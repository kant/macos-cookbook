require 'spec_helper'
include Macos::XcodeHelpers

describe Macos::XcodeHelpers, '#xcversion_version?' do
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
end
