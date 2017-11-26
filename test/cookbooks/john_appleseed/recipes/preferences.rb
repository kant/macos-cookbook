library_helper_method('In the raw recipe body.')

plistbuddy 'show hidden files' do
  library_helper_method('Inside of a recipe.')
  path '/Users/vagrant/Library/Preferences/com.apple.finder.plist'
  entry 'AppleShowAllFiles'
  value true
  desired_true 'determined by the state of the system.'
  desired_false 'determined by the values defined by the recipe or custom resource.'
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
