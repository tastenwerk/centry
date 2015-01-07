module Centry

  module API

    class Users < Grape::API

      include Centry::API::Container
      centry_mountpoint :api
      
      version 'v1', using: :path

      namespace 'users' do

        helpers Centry::ApplicationHelper
        helpers Centry::AuthHelper

        #
        # GET /
        #
        desc "lists all users"
        get do
          authenticate!
          users = User.all
          present users, with: Entities::User
        end

        #
        # GET /current
        #
        desc "return user relation of current token"
        get '/current' do
          authenticate!
          user = User.find( @token.user_id )
          present user, with: Entities::User
        end

        #
        # GET /:id
        #
        desc "returns user with :id"
        get ':id' do
          authenticate!
          error!('InsufficientRights', 403) unless params.id == @token.user_id.to_s || @token.user.is_admin?
          user = User.where(id: params.id, organization_ids: headers['Organization-Id']).first
          error!('NotFound',404) unless user
          present user, with: Entities::User
        end

        #
        # POST /
        #
        desc "create a new user within the new group"
        params do
          requires :user, type: Hash do
            requires :email
            optional :username
            optional :firstname
            optional :lastname
            optional :password
            optional :valid_until
          end
          optional :organization_id
          optional :role, values: ['editor','user','admin'], default: 'user'
        end
        post do
          authenticate!
          require_admin!
          organization_id = headers['Organization-Id'] || params.organization_id
          error!('MissingOrganizationId',409) unless organization_id
          user = User.new( declared( params )[:user] )
          error!({ error: 'SavingFailed', details: user.errors.full_messages}, 422) unless user.save
          if organization_id && organization = Organization.find(organization_id)
            user.organizations << organization
            user.organization_roles.create organization: organization, 
              admin: params.role == 'admin',
              editor: /editor|admin/.match(params.role)
            error!('SavingOrganizationFailed',500) unless user.save
          end
          present user, with: Entities::User
        end

        desc "send the user a link to reset their password"
        params do
          requires :email
        end
        post '/reset_password_request' do
          user = User.find_by( email: params.email )
          error!('EmailAddressUnknown', 404) unless user
          user.gen_confirmation_key!
          return error!('UserMailerError',500) unless UserMailer.reset_password( user, base_url ).deliver_now
          {}
        end

        desc "resets the password for the user"
        params do
          requires :confirmation_key
          requires :password
        end
        post '/:id/reset_password' do
          user = User.find params.id
          error!('UserNotFound',404) unless user
          error!('UserNotFound',404) unless user.confirmation_key == params.confirmation_key
          error!('UserNotFound',404) if user.confirmation_key_expires_at < Time.now
          user.password = params.password
          user.confirmation_key = nil
          user.confirmation_key_expires_at = nil
          user.confirmation_code = nil
          error!({ error: 'SavingUserFailed', details: user.errors.full_messages.inspect},500) unless user.save
          api_key = user.api_keys.create organization_id: user.organizations.first.id.to_s
          present api_key, with: Entities::ApiKey
        end

        #
        # POST /change_password
        #
        desc "changes the password for the current user"
        params do
          requires :old, desc: "the current password"
          requires :new, desc: "the new password"
        end
        post '/change_password' do
          authenticate!
          user = User.find( @token.user_id )
          return error!("WrongPassword",403) unless user.authenticate( params.old )
          user.password = params.new
          return error("failed to save", 422) unless user.save
          user = User.find( @token.user_id )
          present user, with: Entities::User
        end

        #
        # POST /signup
        #
        desc "signs up a new user account (if allowed in config)"
        params do
          requires :email, regexp: /.+@.+/
          requires :password, regexp: /(?=.*[\w0-9])(?=.*[a-z])(?=.*[A-Z]).{6,}/
          optional :organization
          optional :username
        end
        post '/signup', root: false do
          if !params.organization.blank? && Organization.where( name: params.organization ).count > 0
            return error!({ error: 'OrganizationExists', details: params.organization },409)
          end
          if User.where( email: params.email ).count > 0
            return error!('EmailExists',409)
          end
          user = User.create( email: params.email, password: params.password, username: params.username )
          if params.organization.blank?
            user.organizations.create!( name: 'private' )
          else
            user.organizations.create!( name: params.organization )
          end
          return error!(user.errors.full_messages,422) unless user.save
          return error!(UserMailerError,500) unless UserMailer.signup( user, base_url ).deliver_now
          { confirmation_key: user.confirmation_key, id: user.id.to_s }
        end

        #
        # POST /:id/confirm
        #
        desc "checks the code for the given user"
        params do
          requires :confirmation_key
          requires :confirmation_code
        end
        post ':id/confirm' do
          user = User.where( id: params.id, confirmation_key: params.confirmation_key, confirmation_code: params.confirmation_code ).first
          return error!('InvalidKey',409) unless user
          user.update_attributes( confirmation_key: nil, confirmation_code: nil, confirmation_key_expires_at: nil )
          error!({ error: 'SavingFailed', details: user.errors.full_messages},500) if user.errors.size > 0
          status 200
          api_key = user.api_keys.create organization_id: user.organizations.first.id.to_s
          present api_key, with: Entities::ApiKey
        end

        #
        # PUT /:id
        #
        desc "update an existing user"
        params do
          requires :user, type: Hash do
            optional :email
            optional :username
            optional :firstname
            optional :lastname
          end
          optional :role, values: ['user','admin','editor']
          optional :organization_id
        end
        put '/:id' do
          authenticate!
          user = get_user!
          require_admin_or_current_user!
          user.update_attributes( declared(params)[:user] )
          if current_user.is_admin? && params.role
            user_org_role = user.organization_roles.find_or_create_by organization_id: (headers['Organization-Id'] || params.organization_id)
            user_org_role.update_attributes admin: params.role == 'admin',
              editor: /editor|admin/.match(params.role)
          end
          present user.reload, with: Entities::User
        end

        #
        # DELETE /:id
        #
        desc "delete an existing user"
        formatter :json, lambda{ |o,env| "{}" }
        delete '/:id' do
          authenticate!
          user = get_user!
          require_admin_or_current_user!
          error!("DeletionFailed",500) unless user.destroy
        end

      end

    end

  end
end
