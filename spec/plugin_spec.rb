require 'spec_helper'

describe Centry::Plugin do

  let(:path){ File::dirname(__FILE__)+'/support' }

  describe "registration" do

    it "registers a plugin path" do
      Centry::Plugin.register_path path
      expect( Centry::Plugin.paths ).to include( path )
    end

    it "registration fails with invalid path" do
      path = "invalid/path"
      expect{ Centry::Plugin.register_path path }.to raise_error("invalid path #{path}")
    end

  end

  describe "loads itself as plugin" do

    let(:path){ Pathname.new(File::dirname(__FILE__)+'/../app').realpath.to_s }

    it { expect(Centry::Plugin.paths ).to include( path ) }

  end

end