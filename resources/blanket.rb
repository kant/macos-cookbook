require 'colorize'

resource_name :blanket

property :is_unfolded, [TrueClass, FalseClass], desired_state: true
property :height, Integer, desired_state: false
property :width, Integer, desired_state: false

default_action :unfold

action_class do
  puts '---> ACTION_CLASS [GO]'.colorize(:blue).bold

  extend MacOS::BlanketHelpers

  blanket_helper('(1) Outside a method body in action_class.')

  def action_class_helper(message)
    method_identifier('action_class_helper', message)
  end

  def action_class_properties
    property_printer('new_resource.is_unfolded', new_resource.is_unfolded, 'action_class_properties')
    property_printer('new_resource.height', new_resource.height, 'action_class_properties')
    property_printer('new_resource.width',new_resourcedesired.width, 'action_class_properties')
    blanket_helper('(6) Inside a method body in action_class.')
  end

  puts '---> ACTION_CLASS [STOP]'.colorize(:blue).bold
end

load_current_value do |desired|
  puts "\n"
  puts '---> LOAD_CURRENT_VALUE [GO]'.colorize(:light_blue).bold
  blanket_helper('(4) Outside a method body inside load_current_value.')

  property_printer('desired.is_unfolded', desired.is_unfolded, '[pre-setter] load_current_value')
  property_printer('desired.height', desired.height, '[pre-setter] load_current_value')
  property_printer('desired.width', desired.width, '[pre-setter] load_current_value')

  is_unfolded true

  property_printer('desired.is_unfolded', desired.is_unfolded, '[post-setter] load_current_value')
  property_printer('desired.height', desired.height, '[post-setter] load_current_value')
  property_printer('desired.width', desired.width, '[post-setter] load_current_value')

  puts '---> LOAD_CURRENT_VALUE [STOP]'.colorize(:light_blue).bold
end

action :unfold do
  puts '---> ACTION [GO]'.colorize(:red).bold

  action_class_helper('(5) Inside an action.')
  blanket_helper('(6) Inside an action.')

  print "^^^^ #{current_value} ^^^^".colorize(:green).bold
  puts "\n"
  property_printer('new_resource.is_unfolded', new_resource.is_unfolded, 'action')
  property_printer('new_resource.height', new_resource.height, 'action')
  property_printer('new_resource.width', new_resource.width, 'action')

  converge_if_changed do
    puts '--> CONVERGE_IF_CHANGED [GO]'.colorize(:yellow).bold

    action_class_helper('(7) Inside converge_if_changed.')
    blanket_helper('(8) Inside converge_if_changed.')
    property_printer('--> new_resource.is_unfolded', new_resource.is_unfolded, 'converge_if_changed')
    property_printer('new_resource.height', new_resource.height, 'converge_if_changed')
    property_printer('new_resource.width', new_resource.width, 'converge_if_changed')
    puts '---> CONVERGE_IF_CHANGED [STOP]'.colorize(:yellow).bold
  end

  puts "\n"

  execute 'echo "execute resource inside an action"' do
    action_class_helper('(9) Inside a resource > inside an action.')
    blanket_helper('(10) Inside a resource > inside an action.')
    live_stream true
  end

  puts '---> ACTION [STOP]'.colorize(:red).bold
end
