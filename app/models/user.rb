class User
  include Mongoid::Document
  include Centry::Timestamps
  include ActiveModel::SecurePassword
  # include Centry::Serializer
  # include Mongoid::Paperclip

  field :username, type: String
  field :role, type: String, default: 'user'
  field :firstname, type: String
  field :lastname, type: String
  field :email, type: String
  field :phone, type: String
  field :locale, type: String, default: I18n.locale
  field :description, type: String
  field :last_login_at, type: DateTime
  field :last_request_at, type: DateTime
  field :last_login_ip, type: String
  field :valid_until, type: DateTime

  field :password_digest, type: String

  field :confirmation_key, type: String
  field :confirmation_code, type: String
  field :confirmation_code_expires_at, type: DateTime
  field :confirmation_key_expires_at, type: DateTime

  field :public_key, type: String
  field :private_key, type: String

  field :street, type: String
  field :zip, type: String
  field :country, type: String
  field :county, type: String
  field :city, type: String

  field :api_user, type: Boolean
  field :expires_at, type: DateTime

  has_and_belongs_to_many :organizations, inverse_of: :users
  has_many :api_keys
  # embeds_many :user_access_rules

  has_secure_password
  # has_mongoid_attached_file :avatar,
  #   styles: {
  #     original: ['500x500>'],
  #     thumb: ['100x100#']
  #   }

  # validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/jpg', 'image/png']

  validates_presence_of :password, :on => :create  
  validates_presence_of :email, :on => :create
  validates_uniqueness_of :email
  validates_format_of :email, :with => /@/

  before_validation :set_password_if_blank, :set_confirmation_code, on: :create
  before_create :create_membership_for_organization
  # after_create :find_or_create_organization 

  # serialize :id, :username, :password, :email, :firstname, :lastname

  def gen_confirmation_key
    self.confirmation_key = SecureRandom.hex 
    self.confirmation_key_expires_at = 7.days.from_now
    confirmation_key
  end

  def gen_confirmation_key!
    gen_confirmation_key
    save!
  end

  def name
    return self.email unless self.lastname
    return self.lastname unless self.firstname
    return self.firstname + ' ' + self.lastname
  end

  def aquire_api_key
    ApiKey.where( user_id: id ).delete_all
    api_keys.create
  end

  def is_admin?
    role == 'admin'
  end

  def confirmed?
    self.confirmation_code.nil?
  end

  def organization_id=(org_id)
    @organization_id = org_id
  end

  # def use_organization(org_id)
  #   org_id = (org_id.is_a?(String) ? org_id : org.id )
  #   RequestStore.store[:organization_id] = org_id
  # end

  private

  def create_membership_for_organization
    org = nil
    if organization = Organization.where( id: @organization_id ).first
      org = organization
    elsif RequestStore.store[:organization_id] && org_id = RequestStore.store[:organization_id]
      org = Organization.find( org_id )
    end
    self.organizations << org if org && !organizations.find( org.id )
  end

  def avatar_thumb
    avatar.url(:thumb)
  end

  def find_or_create_organization 
    return organizations.first if organizations.where(name: 'private').first
    Organization.create name: 'private', owner_id: id, user_ids: [id]
  end

  def set_password_if_blank
    return unless password_digest.blank? || password.blank?
    self.password = SecureRandom.hex(8).to_s
  end

  def set_confirmation_code
    self.confirmation_code = SecureRandom.random_number(10000).to_s
    self.confirmation_code_expires_at = 10.minutes.from_now
    self.confirmation_key = SecureRandom.hex
  end


end
