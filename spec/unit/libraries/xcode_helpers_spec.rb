require 'spec_helper'
include Macos::XcodeHelpers

describe Macos::XcodeHelpers, '#cask_app_needs_reinstall?' do
  context 'When the version is three digits long and both the MINOR and MATCH versions end in zero' do
    it 'One decimal returns just the first integery' do
      expect(xcversion_version('10.0.0')).to eq '10'
    end
  end

  context 'When the version is three digits long and only the PATCH version ends in zero' do
    it 'One decimal returns just the first integery' do
      expect(xcversion_version('10.0.1')).to eq '10.0.1'
    end
  end

  context 'When the version is three digits long and only the MINOR version ends in zero' do
    it 'One decimal returns just the first integery' do
      expect(xcversion_version('10.3.0')).to eq '10.3'
    end
  end

  context 'When the version is three digits long and neither the MINOR or PATCH versions end in zero' do
    it 'One decimal returns just the first integery' do
      expect(xcversion_version('10.3.1')).to eq '10.3.1'
    end
  end

  context 'When the version is two digits long and the MINOR version ends in zero' do
    it 'One decimal returns just the first integery' do
      expect(xcversion_version('10.0')).to eq '10'
    end
  end

  context 'When the version is two digits long and the MINOR version does not end in zero' do
    it 'One decimal returns just the first integery' do
      expect(xcversion_version('10.6')).to eq '10.6'
    end
  end

  context 'When output is given' do
    it 'the correct iOS simulator version' do
      output = <<-HEREDOC
      iOS SDKs:
      iOS 11.0                      	-sdk iphoneos11.0

    iOS Simulator SDKs:
      Simulator - iOS 11.0          	-sdk iphonesimulator11.0

    macOS SDKs:
      macOS 10.13                   	-sdk macosx10.13

    tvOS SDKs:
      tvOS 11.0                     	-sdk appletvos11.0

    tvOS Simulator SDKs:
      Simulator - tvOS 11.0         	-sdk appletvsimulator11.0

    watchOS SDKs:
      watchOS 4.0                   	-sdk watchos4.0

    watchOS Simulator SDKs:
      Simulator - watchOS 4.0       	-sdk watchsimulator4.0
    HEREDOC
      expect(included_simulator_major_version(output)).to eq 11
    end
  end
end
