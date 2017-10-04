require 'plist'

resource_name :ard

property :restart_options, Array, default: ['-agent', '-console', '-menu'], desired_state: false

property :users, Array, desired_state: false
property :privs, Array, default: ['-all'], desired_state: false
property :access, Array, default: ['-on'], desired_state: false
property :allow_access_for, [String, Array, nil], default: '-allUsers'
property :computerinfo, Array, desired_state: false
property :clientopts, Array, desired_state: false

load_current_value do
  # privs get_all_privs
  allow_access_for all_users_allowed?
end

def remote_management_plist_contents
  plist = '/Library/Preferences/com.apple.RemoteManagement.plist'
  shell_out!("/usr/bin/plutil -convert xml1 #{plist}")
  Plist.parse_xml(plist)
end

def all_users_allowed?
  return true if remote_management_plist_contents['ARD_AllLocalUsers'] == 1
end

action_class do
  def kickstart(cmd_params)
    ard_cmd =
      '/System/Library/CoreServices/RemoteManagement/' +
      'ARDAgent.app/Contents/Resources/kickstart'.freeze
    execute "#{ard_cmd} #{cmd_params}"
  end

  def all_user_privs
    remote_management_plist_contents['ARD_AllLocalUsersPrivs']
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
  converge_if_changed do
    configure_options = []
    %w(users privs access).each do |k|
      next unless new_resource.send(k)
      configure_options << "-#{k} #{new_resource.send(k).join(',')}"
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
end
