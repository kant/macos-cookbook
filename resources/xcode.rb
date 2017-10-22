include Macos::XcodeHelpers

resource_name :xcode

property :version, String, name_property: true, regex: [/\d{1,2}(\.\d{0,2})?(\.\d{0,3})?/]
property :path, String, default: '/Applications/Xcode.app'

property :ios_simulators, Array, regex: [/\d{1,2}\.\d{0,2}(\.\d{0,3})?/]
property :tvos_simulators, Array, regex: [/\d{1,2}\.\d{0,2}(\.\d{0,3})?/]
property :watchos_simulators, Array, regex: [/\d{1,2}\.\d{0,2}(\.\d{0,3})?/]

default_action :install

action_class do
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
    version = version.match?(/\d{1,2}\.0/) ? version.split('.').first : version

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
    execute "install #{type} #{version} Simulator" do
      environment developer_credentials
      command "#{xcversion_command} simulators --install='#{type} #{version}'"
      not_if { simulator_already_installed?(type, version) }
    end
  end
end

action :install do
  install_xcode_install_gem
  update_xcode_versions
  install_xcode(new_resource.version) unless xcode_already_installed?(new_resource.version)
  accept_license

  if property_is_set?(:ios_simulators)
    install_simulator('iOS', ios_simulators)
  end

  if property_is_set?(:tvos_simulators)
    install_simulator('tvOS', tvos_simulators)
  end

  if property_is_set?(:watchos_simulators)
    install_simulator('watchOS', watchos_simulators)
  end
end
