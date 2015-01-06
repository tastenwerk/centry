require 'spec_helper'

describe User do

  describe "create" do
  
    let!(:user){ create(:user) }

    it { expect(user).to be_a(User) }
    it { expect(user.username).to eq('johndoe') }
    it { expect(User.where( username: 'johndoe' ).first ).not_to be(nil) }
    it { expect(User.where( username: 'johndoe' ).first ).to be_a(User) }

  end

  describe "organizations" do

    let!(:user){ create(:user) }

    it { expect(user).to respond_to(:organizations) }

    it { expect(user.organizations.size).to eq(1) }

  end

  describe "update" do

    let!(:user) do
      user = create(:user, username: 'test-update')
      user.update( username: 'test2' )
      user
    end

    it { expect(User.find_by( username: 'test2' )).not_to be(nil) }
    it { expect(User.find_by( username: 'test-update' )).to be(nil) }

  end

  describe "delete" do

    let!(:user) do
      user = create(:user, username: 'test-delete')
      user.destroy
    end

    it { expect(User.find_by( username: 'test-delete')).to be(nil) }

  end

  describe "api_key" do

    let!(:user){ create(:user) }

    describe "creates a new api key" do
      
      let!(:api_key){ user.api_keys.create }

      it { expect( api_key ).to be_a(ApiKey) }

      it { expect( api_key.token.size ).to eq(32) }

      it { expect( api_key.expires_at ).to be >= (8*60-1).minutes.from_now }

      it { expect( api_key.expires_at ).to be <= (8*60+1).minutes.from_now }

    end

    describe "aquires an api key" do

      let!(:user){ create(:user) }

      let!(:api_key){ user.aquire_api_key }

      it{ expect( api_key ).to be_a(ApiKey) }

      it{ expect( api_key.token.size ).to eq 32 }

      it{ expect( api_key.token ).to match(/[\w\d]{32}/) }

    end


  end

  describe "roles" do

    let!(:user){ create(:user) }

    describe "defaults to user" do
    
      it{ expect( user.role ).to eq('user') }

    end

    describe "is_admin?" do

      let!(:admin){ create(:user, role: 'admin') }

      it{ expect( user.is_admin? ).to be false }

      it{ expect( admin.is_admin? ).to be true }

    end

  end

  describe "locale" do

    let!(:user){ create(:user) }
    it{ expect( user.locale ).to eq I18n.default_locale.to_s }

  end

  describe "confirmation code" do

    let!(:user){ create(:user) }
    it{ expect( user.confirmation_code.size ).to eq 4 }
    it{ expect( user.confirmation_code ).to match(/\d{4}/) }

  end

  describe "confirmation key" do

    let!(:user){ create(:user) }
    it{ expect( user.confirmation_key.size ).to eq 32 }
    it{ expect( user.confirmation_key ).to match(/[\w\d]{32}/) }

  end

end
