module Centry

  module API

    class Users < Grape::API

      version 'v1', using: :path

      namespace 'users' do

        helpers Centry::ApplicationHelper
        helpers Centry::AuthHelper
        helpers Centry::UsersHelper

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
            optional :role, values: ['user','admin'], default: 'user'
          end
          optional :organization_id
        end
        post do
          authenticate!
          require_admin!
          user = User.new( declared( params )[:user] )
          user.organization_id = params.organization_id if current_user.is_admin?
          error!({ error: 'SavingFailed', details: user.errors.full_messages}, 422) unless user.save
          present user, with: Entities::User
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
          params.organization = 'private' if params.organization.blank?
          if params.organization != 'private' && Organization.where( name: params.organization ).count > 0
            return error!({ error: 'OrganizationExists', details: params.organization },409)
          end
          if User.where( email: params.email ).count > 0
            return error!('EmailExists',409)
          end
          user = User.create( email: params.email, password: params.password, username: params.username )
          organization = Organization.create( name: params.organization, users: [ user ], owner: user )
          return error!(user.errors.full_messages,422) unless user
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
          user = user.reload
          status 200
          api_key = user.aquire_api_key
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
            optional :role, values: ['user','admin'], default: 'user'
          end
          optional :organization_id
        end
        put '/:id' do
          authenticate!
          user = get_user!
          require_admin_or_current_user!
          user.update_attributes( declared(params)[:user] )
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
