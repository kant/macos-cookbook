library_helper_method('(2) Inside a recipe.')

plistbuddy 'show hidden files' do
  library_helper_method('(3) Inside a resource > inside a recipe.')
  path '/Users/vagrant/Library/Preferences/com.apple.finder.plist'
  entry 'AppleShowAllFiles'
  value true
  get_from_system 'determined by the state of the system.'
  set_by_resource 'determined by the resource'
end
