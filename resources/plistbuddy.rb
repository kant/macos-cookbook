require 'colorize'

resource_name :plistbuddy

property :path, String, desired_state: false
property :entry, String, desired_state: false
property :value, [Hash, String, Array, TrueClass, FalseClass, Integer, Float], desired_state: true

property :desired_true, String, desired_state: true
property :desired_false, String, desired_state: false

property :is_binary, [TrueClass, FalseClass]

default_action :set

action_class do
  print "\n"
  puts '---> ACTION_CLASS [GO]'.colorize(:blue).bold

  extend MacOS::PlistBuddyHelpers

  library_helper_method('Outside a method body in action_class.')

  def action_class_method(message)
    print "\n"
    puts '   + action_class_method'.colorize(:cyan).bold
    puts "     #{message}".colorize(:cyan).italic

    print '       new_resource.desired_true: '.colorize(:light_cyan)
    puts new_resource.desired_true.to_s.colorize(:light_cyan).italic

    print '       new_resource.desired_false: '.colorize(:light_cyan)
    puts new_resource.desired_false.to_s.colorize(:light_cyan).italic

    library_helper_method('Inside a method body in action_class.')
    # instance_method_finder(new_resource.class)
    # instance_variable_finder(new_resource.class)

    puts '   - action_class_method'.colorize(:cyan).italic
  end

  # instance_method_finder(provider)
  # instance_variable_finder(provider)

  # def plistbuddy(action)
  #   [format_plistbuddy_command(action, new_resource.entry, new_resource.value), new_resource.path].join(' ')
  # end

  # def entry_missing?
  #   return true if shell_out(plistbuddy(:print)).error?
  # end
  puts '---> ACTION_CLASS [STOP]'.colorize(:blue).bold
end

load_current_value do |desired|
  puts '---> LOAD_CURRENT_VALUE [GO]'.colorize(:light_blue).bold

  # instance_method_finder(desired.class)
  # instance_variable_finder(desired.class)

  library_helper_method('Outside a method body inside load_current_value.')

  print '       desired_true: '.colorize(:light_cyan).bold
  puts desired_true.to_s.colorize(:light_cyan)
  print '       desired_false: '.colorize(:light_cyan).bold
  puts desired_false.to_s.colorize(:light_cyan)

  print '       desired.desired_true: '.colorize(:light_cyan).bold
  puts desired.desired_true.to_s.colorize(:light_cyan)
  print '       desired.desired_false: '.colorize(:light_cyan).bold
  puts desired.desired_false.to_s.colorize(:light_cyan)
  puts '---> LOAD_CURRENT_VALUE [STOP]'.colorize(:light_blue).bold
end

action :set do
  print "\n"
  puts '--> ACTION [GO]'.colorize(:red).bold
  library_helper_method('Inside an action.')
  action_class_method('Inside an action.')
  print ' * current_value inside action: '.colorize(:light_blue).bold
  puts " - #{current_value}".colorize(:light_blue).bold

  print '       new_resource.desired_true: '.colorize(:light_cyan)
  puts new_resource.desired_true.to_s.colorize(:light_cyan).italic

  print '       new_resource.desired_false: '.colorize(:light_cyan)
  puts new_resource.desired_false.to_s.colorize(:light_cyan).italic

  converge_if_changed do
    puts '--> CONVERGE_IF_CHANGED [GO]'.colorize(:yellow).bold
    library_helper_method('Inside converge_if_changed.')
    action_class_method('Inside converge_if_changed.')
    print '       new_resource.desired_true: '.colorize(:light_cyan)
    puts new_resource.desired_true.to_s.colorize(:light_cyan).italic

    print '       new_resource.desired_false: '.colorize(:light_cyan)
    puts new_resource.desired_false.to_s.colorize(:light_cyan).italic
    puts '---> CONVERGE_IF_CHANGED [STOP]'.colorize(:yellow).bold
  end

  puts "\n"

  execute 'echo "execute resource inside an action"' do
    library_helper_method('Inside a resource > inside an action.')
    action_class_method('Inside a resource > inside an action.')
    live_stream true
  end

  # execute "add #{new_resource.entry} to #{new_resource.path.split('/').last}" do
  #   command plistbuddy :add
  #   only_if { entry_missing? }
  # end

  puts '---> ACTION [STOP]'.colorize(:red).bold
end

# action :delete do
#   execute "delete #{new_resource.entry} from plist" do
#     command plistbuddy :delete
#     not_if { entry_missing? }
#   end
# end
