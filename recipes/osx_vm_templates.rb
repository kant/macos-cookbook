include_recipe 'macos::keep_awake'

launchd 'add network interface detection' do
  program_arguments ['/usr/sbin/networksetup', '-detectnewhardware']
  run_at_load true
  label 'com.github.timsutton.osx-vm-templates.detectnewhardware'
  path '/Library/LaunchDaemons/com.github.timsutton.osx-vm-templates.detectnewhardware.plist'
  mode 0o644
  owner 'root'
  group 'wheel'
end

macos_user 'vagrant' do
  autologin true
  password 'vagrant'
end

execute 'system update' do
  command ['softwareupdate', '--install', '--all']
  not_if { shell_out('softwareupdate', '--list', '--all').stderr.chomp.match?('No new software available.') }
end

# os_vers = node['platform_version'].split('.')[1].to_i
#
# if os_vers >= 9
# elsif os_vers == 7
# elsif os_vers == 8
# else
# end
