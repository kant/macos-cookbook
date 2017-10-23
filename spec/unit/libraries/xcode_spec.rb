require 'spec_helper'
include Xcode::Helper

describe Xcode::Helper, '#xcversion_version?' do
  context 'When the version is three digits long and both the MINOR and MATCH versions end in zero' do
    it 'returns only the major version' do
      expect(xcversion_version('10.0.0')).to eq '10'
    end
  end

  context 'When the version is three digits long and only the PATCH version ends in zero' do
    it 'One decimal returns just the first integery' do
      expect(xcversion_version('10.0.1')).to eq '10.0.1'
    end
  end

  context 'When the version is three digits long and only the MINOR version ends in zero' do
    it 'returns the major and minor versions' do
      expect(xcversion_version('10.3.0')).to eq '10.3'
    end
  end

  context 'When the version is three digits long and neither the MINOR or PATCH versions end in zero' do
    it 'the entire semantic version' do
      expect(xcversion_version('10.3.1')).to eq '10.3.1'
    end
  end

  context 'When the version is two digits long and the MINOR version ends in zero' do
    it 'returns only the major version' do
      expect(xcversion_version('10.0')).to eq '10'
    end
  end

  context 'When the version is two digits long and the MINOR version does not end in zero' do
    it 'returns the major and minor versions' do
      expect(xcversion_version('10.6')).to eq '10.6'
    end
  end

  context 'When the working with the list of available simulators' do
    sdk_output = "iOS SDKs:
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
    Simulator - watchOS 4.0       	-sdk watchsimulator4.0"

    simulators = [['Xcode', '9.0'],
                  ['iOS', '8.1'],
                  ['iOS', '8.2'],
                  ['iOS', '8.3'],
                  ['iOS', '8.4'],
                  ['iOS', '9.0'],
                  ['iOS', '9.1'],
                  ['iOS', '9.2'],
                  ['iOS', '9.3'],
                  ['iOS', '10.0'],
                  ['iOS', '10.1'],
                  ['tvOS', '9.0'],
                  ['tvOS', '9.1'],
                  ['tvOS', '9.2'],
                  ['tvOS', '10.0'],
                  ['watchOS', '2.0'],
                  ['watchOS', '2.1'],
                  ['watchOS', '2.2'],
                  ['tvOS', '10.1'],
                  ['iOS', '10.2'],
                  ['watchOS', '3.1'],
                  ['iOS', '10.3.1'],
                  ['watchOS', '3.2'],
                  ['tvOS', '10.2'],
                  ['Xcode', '9.0.1'],
                  ['iOS', '8.1'],
                  ['iOS', '8.2'],
                  ['iOS', '8.3'],
                  ['iOS', '8.4'],
                  ['iOS', '9.0'],
                  ['iOS', '9.1'],
                  ['iOS', '9.2'],
                  ['iOS', '9.3'],
                  ['iOS', '10.0'],
                  ['iOS', '10.1'],
                  ['tvOS', '9.0'],
                  ['tvOS', '9.1'],
                  ['tvOS', '9.2'],
                  ['tvOS', '10.0'],
                  ['watchOS', '2.0'],
                  ['watchOS', '2.1'],
                  ['watchOS', '2.2'],
                  ['tvOS', '10.1'],
                  ['iOS', '10.2'],
                  ['watchOS', '3.1'],
                  ['iOS', '10.3.1'],
                  ['watchOS', '3.2'],
                  ['tvOS', '10.2']]

    it 'returns the full iOS version' do
      major_version = '10'
      expect(highest_semantic_simulator_version(major_version, simulators)).to eq 'iOS 10.3.1'
    end

    it 'returns true if the simulator is already installed' do
      version = 10
      expect(simulator_already_installed?(version)).to be true
    end

    it 'finds the already-installed simulator version' do
      expect(included_simulator_major_version(sdk_output)).to eq '11'
    end
  end
end
