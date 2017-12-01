control 'xcode' do
  desc 'Xcode 9.0.1 exists and Developer mode is enabled'

  describe file('/Applications/Xcode.app') do
    it { should exist }
    it { should be_symlink }
  end

  describe directory('/Applications/Xcode-9.0.1.app') do
    it { should exist }
    it { should be_directory }
  end

  describe command('/usr/bin/defaults read /Applications/Xcode.app/Contents/version.plist CFBundleShortVersionString') do
    it { should match '9.0.1' }
  end

  describe command('/usr/local/bin/xcversion simulators'), :skip do
    its('stdout') { should match(/iOS 10\.3\.1 Simulator \(installed\)/) }
  end
end
