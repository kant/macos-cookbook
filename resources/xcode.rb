resource_name :xcode
default_action :install

property :version, String, name_property: true
property :path, String, default: '/Applications/Xcode.app'
property :ios_simulators, Array

action_class do
  def developer_credentials
    data_bag = data_bag_item(:credentials, :apple_id)
    { XCODE_INSTALL_USER:     data_bag[:apple_id],
      XCODE_INSTALL_PASSWORD: data_bag[:password] }
  end
end

load_current_value do
  current_value_does_not_exist! if current_xcode_version.nil?
  version current_xcode_version
end

action :install do
  converge_if_changed :version do
    chef_gem 'xcode-install' do
      options('--no-document')
    end

    execute 'update available Xcode versions' do
      environment developer_credentials
      command [xcversion_command, update]
    end

    execute "install Xcode version #{new_resource.version}" do
      environment developer_credentials
      command [xcversion_command, 'install', xcversion_version(new_resource.version)]
    end
  end
end

# action :install_simulators do
#   if new_resource.ios_simulators
#     new_resource.ios_simulators.each do |major_version|
#       next if major_version.to_i >= included_simulator_major_version
#       version = highest_semantic_simulator_version(major_version, simulator_list)

#       execute "install latest iOS #{major_version} Simulator" do
#         environment DEVELOPER_CREDENTIALS
#         command "#{xcversion_command} simulators --install='#{version}'"
#         not_if { simulator_already_installed?(version) }
#       end
#     end
#   end
# end
