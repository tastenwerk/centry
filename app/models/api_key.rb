class ApiKey
  include Mongoid::Document
  include Centry::Timestamps
  # include Centry::Serializer

  field :token, type: String
  field :expires_at, type: DateTime
  field :permanent, type: Boolean
  field :name, type: String

  belongs_to :user
  
  before_create :setup_token, :setup_expires_at

  # serialize :id, :token, :expires_at, :permanent, :name, :user_id

  private

  def setup_token
    self.token = SecureRandom.hex(64)
    setup_token if self.class.where( token: self.token ).first
  end

  def setup_expires_at
    self.expires_at = permanent ? 1.year.from_now : 8.hours.from_now
  end

end
