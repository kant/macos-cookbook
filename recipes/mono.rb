package = 'MonoFramework-MDK-4.4.2.11.macos10.xamarin.universal.pkg'
version = '4.4.2'
checksum = 'd8bfbee7ae4d0d1facaf0ddfb70c0de4b1a3d94bb1b4c38e8fa4884539f54e23'

remote_file "#{Chef::Config[:file_cache_path]}/#{package}" do
  source "https://download.mono-project.com/archive/#{version}/macos-10-universal/#{package}"
  checksum checksum
  not_if 'pkgutil --pkgs=com.xamarin.mono-MDK.pkg'
end

execute 'install-mono' do
  command "installer -pkg #{Chef::Config[:file_cache_path]}/#{package} -target /"
  not_if 'pkgutil --pkgs=com.xamarin.mono-MDK.pkg'
end
