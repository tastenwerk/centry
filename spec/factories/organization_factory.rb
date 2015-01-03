FactoryGirl.define do
  factory :organization, class: 'Organization' do
    name "test org"

    to_create { |instance| instance.save }

  end
end
