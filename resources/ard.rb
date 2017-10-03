resource_name :ard

property :install_package, String
property :uninstall_options, Array, default: ['-files', '-settings', '-prefs']
property :restart_options, Array, default: ['-agent', '-console', '-menu']

property :users, Array
property :privs, Array, default: ['-all']
property :access, String, default: '-on'
property :allow_access_for, String, default: '-allUsers'
property :computerinfo, Array
property :clientopts, Array

action_class do
  def kickstart(cmd_params)
    ard_cmd = 
      '/System/Library/CoreServices/RemoteManagement/' +
      'ARDAgent.app/Contents/Resources/kickstart'.freeze
    execute "kickstart:#{cmd_params}" do
      command "#{ard_cmd} #{cmd_params}"
    end
  end
end

action :activate do
  kickstart('-activate')
end

action :deactivate do
 kickstart('-deactivate')
end

action :restart do
  kickstart("-restart #{new_resource.restart_options.join(' ')}")  
end

action :configure do
  configure_options = []
  [users, privs, access].each do |k|
    next unless new_resource.send(kickstart)
    configure_options << "-#{k} #{new_resource.send(k).join(',')}")
  end
  if new_resource.allow_access_for
    configure_options.insert(0, "-allowAccessFor #{new_resource.allow_access_for}")
  end
  if new_resource.computerinfo
    configure_options.insert(0, "-computerinfo #{new_resource.computerinfo.join(' ')}")
  end
  if new_resource.clientopts
    configure_options.insert(0, "-clientopts #{new_resource.clientopts.join(' ')}")
  end
  kickstart("-configure #{configure_options.join(' ')}")
end
