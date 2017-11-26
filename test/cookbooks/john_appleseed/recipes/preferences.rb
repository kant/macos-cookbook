library_helper_method('Inside a recipe.')

plistbuddy 'show hidden files' do
  library_helper_method('Inside a resource > inside a recipe.')
  path '/Users/vagrant/Library/Preferences/com.apple.finder.plist'
  entry 'AppleShowAllFiles'
  value true
  set_by_system 'determined by the state of the system.'
  set_by_resource 'determined by the resource'
end

# plistbuddy 'put the Dock on the left side' do
#   path '/Users/vagrant/Library/Preferences/com.apple.dock.plist'
#   entry 'orientation'
#   value 'left'
# end

# plistbuddy 'disable window animations and Get Info animations' do
#   path '/Users/vagrant/Library/Preferences/com.apple.dock.plist'
#   entry 'DisableAllAnimations'
#   value true
# end
