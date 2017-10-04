ard 'activate and configure ard' do
  allow_access_for '-allUsers'
  action [:activate, :configure]
end
