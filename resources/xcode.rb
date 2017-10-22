include Macos::XcodeHelpers

resource_name :xcode
default_action %i(setup install_xcode)

property :version, String, name_property: true, regex: [/\d{1,2}(\.\d{0,2})?(\.\d{0,3})?/]
property :path, String, default: '/Applications/Xcode.app'

property :ios_simulators, Array
property :tvos_simulators, Array
property :watchos_simulators, Array

action_class do
  def developer_credentials
    data_bag_item(:credentials, :apple_id)
    {
      XCODE_INSTALL_USER:     data_bag_item['apple_id'],
      XCODE_INSTALL_PASSWORD: data_bag_item['password'],
    }
  end

  def install_xcode_install_gem
    chef_gem 'xcode-install' do
      options('--no-document')
    end
  end

  def update_xcode_versions
    execute 'update available Xcode versions' do
      environment developer_credentials
      command "#{xcversion_command} update"
    end
  end

  def install_xcode(version)
    execute "install Xcode #{version}" do
      environment developer_credentials
      command "#{xcversion_command} install '#{xcversion_version(version)}'"
      not_if { xcode_already_installed?(version) }
    end
  end

  def accept_license
    execute 'accept license' do
      command '/usr/bin/xcodebuild -license accept'
    end
  end

  def install_simulator(type, version)
    execute "install #{version} Simulator" do
      environment DEVELOPER_CREDENTIALS
      command "#{xcversion_command} simulators --install='#{type} #{version}'"
      not_if { simulator_already_installed?(type, version) }
    end
  end
end

action :install do
  install_xcode_install_gem
  update_xcode_versions
  install_xcode(new_resource.version)
  accept_license

  if property_is_set?(:ios_simulators)
    new_resource.ios_simulators each do |simulator|
      install_simulator('iOS', simulator)
    end
  end

  if property_is_set?(:tvos_simulators)
    new_resource.tvos_simulators each do |simulator|
      install_simulator('tvOS', simulator)
    end
  end

  if property_is_set?(:watchos_simulators)
    new_resource.watchos_simulators each do |simulator|
      install_simulator('watchOS', simulator)
    end
  end
end
