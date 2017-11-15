require 'spec_helper'

describe 'macos::xcode' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  before(:each) do
    stub_data_bag_item('credentials', 'apple_id').and_return(
      apple_id: 'developer@apple.com',
      password: 'apple_id_password'
    )
  end

  context 'Xcode recipe converges successfully' do
    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'When the requested Xcode version is not installed' do
    it 'Xcode is installed' do
      expect(chef_run).to install_xcode_xcode('9.0.1')
      expect(chef_run).to_not install_xcode_xcode('9.0')
    end
  end
end
