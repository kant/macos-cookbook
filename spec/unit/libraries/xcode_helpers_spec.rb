require 'spec_helper'
include Macos::XcodeHelpers

describe Macos::XcodeHelpers, '#xcversion_version' do
  context 'When a version is given with three decimal points' do
    it 'One decimal returns just the first integer' do
      expect(xcversion_version('10.0')).to eq '10'
    end
  end
end

#   context 'When app is installed as cask but install path does not exist' do
#     before do
#       allow(File).to receive(:exist?).and_return(false)
#       allow(self).to receive(:app_installed_as_cask?).and_return(true)
#     end

#     it 'needs to be reinstalled' do
#       expect(cask_app_needs_reinstall?('foo-bar', '/Applications/Foo Bar.app')).to be true
#     end
#   end

#   context 'When app is not installed' do
#     before do
#       allow(File).to receive(:exist?).and_return(false)
#       allow(self).to receive(:app_installed_as_cask?).and_return(false)
#     end

#     it 'does not need to be reinstalled' do
#       expect(cask_app_needs_reinstall?('foo-bar', '/Applications/Foo Bar.app')).to be false
#     end
#   end

#   context 'When app is installed as cask and is at install path' do
#     before do
#       allow(File).to receive(:exist?).and_return(true)
#       allow(self).to receive(:app_installed_as_cask?).and_return(true)
#     end

#     it 'does not need to be reinstalled' do
#       expect(cask_app_needs_reinstall?('foo-bar', '/Applications/Foo Bar.app')).to be false
#     end
#   end
