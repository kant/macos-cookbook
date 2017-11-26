plistbuddy 'show hidden files' do
  library_helper_method('Inside of a recipe.')
  path '/Users/vagrant/Library/Preferences/com.apple.finder.plist'
  entry 'AppleShowAllFiles'
  value true
  desired_true 'this is desired_state: true'
  desired_false 'this is desired_state: false'
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
