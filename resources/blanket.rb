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
    [is_unfolded, height, width].map { |_property| property_printer(new_resource.property, 'action_class_properties') {} }
    blanket_helper('(6) Inside a method body in action_class.')
  end

  puts '---> ACTION_CLASS [STOP]'.colorize(:blue).bold
end

load_current_value do |desired|
  puts "\n"
  puts '---> LOAD_CURRENT_VALUE [GO]'.colorize(:light_blue).bold
  blanket_helper('(4) Outside a method body inside load_current_value.')

  is_folded 'yes, it is still folded.'

  [is_unfolded, height, width].each do |property|
    property_printer(property, 'load_current_value') {}
    property_printer(desired.property, 'load_current_value') {}
  end

  puts '---> LOAD_CURRENT_VALUE [STOP]'.colorize(:light_blue).bold
end

action :unfold do
  puts '---> ACTION [GO]'.colorize(:red).bold

  action_class_method('(1) Inside an action.')
  blanket_helper('(5) Inside an action.')

  print "^^^^ #{current_value} ^^^^".colorize(:green).bold
  puts "\n"
  [is_unfolded, height, width].map { |_property| property_printer(new_resource.property, 'action') {} }

  converge_if_changed :is_unfolded do
    puts '--> CONVERGE_IF_CHANGED [GO]'.colorize(:yellow).bold

    action_class_helper('(2) Inside converge_if_changed.')
    blanket_helper('(7) Inside converge_if_changed.')

    [is_unfolded, height, width].map { |_property| property_printer(new_resource.property, 'converge_if_changed') {} }

    puts '---> CONVERGE_IF_CHANGED [STOP]'.colorize(:yellow).bold
  end

  puts "\n"

  execute 'echo "execute resource inside an action"' do
    action_class_helper('(3) Inside a resource > inside an action.')
    blanket_helper('(8) Inside a resource > inside an action.')
    live_stream true
  end

  puts '---> ACTION [STOP]'.colorize(:red).bold
end
