current_os = semantic(node[:platform_version])
el_capitan = semantic('10.11.6')

if current_os <= el_capitan
  xcode 'install Xcode 8.2.1' do
    version '8.2.1'
  end
else
  xcode 'install Xcode 9.0.1' do
    version '9.0.1'
  end
end
