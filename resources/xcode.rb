resource_name :xcode

property :ios_simulators, Array
property :version, String, desired_state: false

action_class do
  def developer_credentials
    data_bag = data_bag_item(:credentials, :apple_id)
    { XCODE_INSTALL_USER:     data_bag[:apple_id],
      XCODE_INSTALL_PASSWORD: data_bag[:password] }
  end
end

load_current_value do |desired|
  current_value_does_not_exist! if Xcode.installed_bundle_versions.include?(desired.version)
  version current_xcode_version
end

action :install do
  converge_if_changed :version do
    chef_gem 'xcode-install' do
      options('--no-document')
    end

    execute 'Update cached list of available Xcode versions' do
      environment developer_credentials
      command [XCVersion.command, 'update']
    end

    execute "Install Xcode #{new_resource.version}" do
      environment developer_credentials
      command [XCVersion.command, 'install', XCVersion.version(new_resource.version)]
      not_if { Xcode.installed?(new_resource.version) }
    end
  end
end

action :install_simulators do
  if new_resource.ios_simulators
    new_resource.ios_simulators.each do |major_version|
      next if major_version.to_i >= Simulator.included_major_version
      version = Simulator.highest_semantic_version(major_version)

      execute "install latest iOS #{major_version} Simulator" do
        environment DEVELOPER_CREDENTIALS
        command "#{XCVersion.command} simulators --install='#{version}'"
        not_if { Simulator.installed?(version) }
      end
    end
  end
end
