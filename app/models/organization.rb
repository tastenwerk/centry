class Organization

  include Mongoid::Document
  # include Mongoid::Userstamp
  # include Mongoid::Timestamps

  field :name, type: String
  field :fqdn, type: String
  field :settings, type: Object
  field :suspended, type: Boolean, default: false
  
  has_and_belongs_to_many :users, inverse_of: :organizations
  belongs_to :owner, class_name: 'User'
  # has_and_belongs_to_many :app_plans

  # embeds_many :access_rules

  # after_save :check_owner_has_full_access
  before_create :setup_fqdn

  def access_for_user( user )
    return unless users.find(user.id)
    access_rules.where(user: user).first
  end

  def apps
    app_plans.map(&:app)
  end

  private

  def setup_fqdn
    return unless fqdn.blank?
    self.fqdn = "#{name.gsub(' ','_').underscore}.camin.io"
  end

  def check_owner_has_full_access
    return unless owner = users.first
    app_plans.each do |plan|
      access_rules.find_or_create_by( user: owner, can_write: true, can_share: true, can_delete: true, app: plan.app )
    end
  end

end
