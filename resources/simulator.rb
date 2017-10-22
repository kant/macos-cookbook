resource_name :simulator

property :type, Integer, name_property: true
property :versions, Array

action :install_simulators do
  if new_resource.ios_simulators
    new_resource.ios_simulators.each do |major_version|
      next if major_version.to_i >= included_simulator_major_version
      version = highest_semantic_simulator_version(major_version, simulator_list)

      execute "install #{version} Simulator" do
        environment DEVELOPER_CREDENTIALS
        command "#{xcversion_command} simulators --install='#{version}'"
        not_if { simulator_already_installed?(version) }
      end
    end
  end
end
