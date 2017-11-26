require 'colorize'

resource_name :plistbuddy

property :path, String, desired_state: false
property :entry, String, desired_state: false
property :value, [Hash, String, Array, TrueClass, FalseClass, Integer, Float], desired_state: true

property :desired_true, String, desired_state: true
property :desired_false, String, desired_state: false

property :is_binary, [TrueClass, FalseClass]

default_action :set

action_class do |provider|
  print "\n"
  puts '>>> action_class BEGIN <<<'.colorize(:blue).bold
  # extend MacOS::PlistBuddyHelpers
  # library_helper_method('Outside a method body in action_class.')

  def action_class_method(message)
    print "\n"
    puts ' -> action_class_method BEGIN'.colorize(:cyan).italic
    puts "      #{message}".colorize(:cyan)
    print '        new_resource.desired_true: '.colorize(:light_cyan).bold
    puts new_resource.desired_true.to_s.colorize(:light_cyan)

    print '        new_resource.desired_false: '.colorize(:light_cyan).bold
    puts new_resource.desired_false.to_s.colorize(:light_cyan)
    library_helper_method('Inside a method body in action_class')
    puts ' -> action_class_method END'.colorize(:cyan).italic
  end

  provider_methods = provider.instance_methods.sort - provider.superclass.instance_methods
  puts "+++ provider methods: #{provider_methods}".colorize(:green)

  new_resource_methods = new_resource.instance_methods.sort - new_resource.superclass.instance_methods
  puts "+++ new_resource methods: #{new_resource_methods}".colorize(:green)

  # def plistbuddy(action)
  #   [format_plistbuddy_command(action, new_resource.entry, new_resource.value), new_resource.path].join(' ')
  # end

  # def entry_missing?
  #   return true if shell_out(plistbuddy(:print)).error?
  # end
  puts '>>> action_class END <<<'.colorize(:blue).bold
end

# load_current_value do
#   print "\n"
#   puts '    load_current_value BEGIN'.colorize(:light_blue)
#   library_helper_method('Outside a method body inside load_current_value.')
#   print '        desired_true: '.colorize(:light_cyan).bold
#   puts desired_true.to_s.colorize(:light_cyan)
#   print '        desired_false: '.colorize(:light_cyan).bold
#   puts desired_false.to_s.colorize(:light_cyan)
#   puts '    load_current_value END'.colorize(:light_blue)
# end

load_current_value do |desired|
  print "\n"
  puts '    load_current_value BEGIN'.colorize(:light_blue)

  desired_methods = desired.instance_methods.sort - desired.superclass.instance_methods
  puts "desired methods: #{desired_methods}".colorize(:green)

  library_helper_method('Outside a method body inside load_current_value.')

  print '        desired_true: '.colorize(:light_cyan).bold
  puts desired_true.to_s.colorize(:light_cyan)
  print '        desired_false: '.colorize(:light_cyan).bold
  puts desired_false.to_s.colorize(:light_cyan)

  print '        desired.desired_true: '.colorize(:light_cyan).bold
  puts desired.desired_true.to_s.colorize(:light_cyan)
  print '        desired.desired_false: '.colorize(:light_cyan).bold
  puts desired.desired_false.to_s.colorize(:light_cyan)
  puts '    load_current_value END'.colorize(:light_blue)
end

action :set do
  print "\n"
  puts '>>> :set action BEGIN <<<'.colorize(:red).bold
  library_helper_method('Inside of an action.')
  action_class_method('Inside of an action.')
  print ' -> current_value inside action: '.colorize(:light_blue).bold
  puts " -> #{current_value}".colorize(:light_blue).bold

  print '        new_resource.desired_true: '.colorize(:light_cyan).bold
  puts new_resource.desired_true.to_s.colorize(:light_cyan)

  print '        new_resource.desired_false: '.colorize(:light_cyan).bold
  puts new_resource.desired_false.to_s.colorize(:light_cyan)

  # converge_if_changed :value do
  #   puts "\t\t> converge_if_changed"
  #   puts "\t\t> new_resource.value: #{new_resource.value}"
  #   execute [format_plistbuddy_command(:set, new_resource.entry, new_resource.value), new_resource.path].join(' ')
  # end

  execute 'echo "this is inside of an action"' do
    library_helper_method('Inside an execute resource, inside an action.')
    action_class_method('Inside an execute resource, inside an action.')
    live_stream true
  end

  # execute "add #{new_resource.entry} to #{new_resource.path.split('/').last}" do
  #   command plistbuddy :add
  #   only_if { entry_missing? }
  # end

  puts '>>> :set action END <<<'.colorize(:red).bold
end

# action :delete do
#   execute "delete #{new_resource.entry} from plist" do
#     command plistbuddy :delete
#     not_if { entry_missing? }
#   end
# end
