blanket_helper('(2) Inside a recipe.')

blanket 'space' do
  blanket_helper('(3) Inside a resource > inside a recipe.')
  is_unfolded false
  width 48
  height 48
end

blanket 'bedspread' do
  is_unfolded true
  width 60
  height 80
end
