class ApiKey
  include Mongoid::Document
  include Centry::Timestamps

  field :token, type: String
  field :expires_at, type: DateTime
  field :permanent, type: Boolean
  field :name, type: String
  field :organization_id, type: String

  belongs_to :user
  
  before_create :setup_token, :setup_expires_at, :setup_organization

  private

  def setup_organization
    self.organization_id = RequestStore.store['organization_id']
  end

  def setup_token
    self.token = SecureRandom.hex(64)
    setup_token if self.class.where( token: self.token ).first
  end

  def setup_expires_at
    self.expires_at = permanent ? 1.year.from_now : 8.hours.from_now
  end

end
