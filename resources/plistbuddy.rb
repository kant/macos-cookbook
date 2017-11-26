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
  puts '>>> action_class BEGIN <<<'.colorize(:blue).bold
  extend MacOS::PlistBuddyHelpers
  library_helper_method('Outside a method body.')

  def action_class_method
    print "\n"
    puts '    action_class_method BEGIN'.colorize(:cyan).italic
    print '        new_resource.desired_true: '.colorize(:light_cyan)
    puts new_resource.desired_true.to_s.colorize(:light_cyan).bold

    print '        new_resource.desired_false: '.colorize(:light_cyan)
    puts new_resource.desired_false.to_s.colorize(:light_cyan).bold
    library_helper_method('Inside a method body.')
    puts '    action_class_method END'.colorize(:cyan).italic
  end

  def plistbuddy(action)
    [format_plistbuddy_command(action, new_resource.entry, new_resource.value), new_resource.path].join(' ')
  end

  def entry_missing?
    return true if shell_out(plistbuddy(:print)).error?
  end
  puts '>>>> action_class END <<<<'.colorize(:blue).bold
end

load_current_value do
  print "\n"
  puts '==> load_current_value BEGIN'.colorize(:light_blue).bold
  library_helper_method('Inside load_current_value')
  puts '==> load_current_value END'.colorize(:light_blue).bold
  print "\n"
end

action :set do
  puts '>>> action :set BEGIN <<<'.colorize(:red).bold
  puts "    current_value: #{current_value}".colorize(:red)

  library_helper_method('Inside an action')
  action_class_method

  # converge_if_changed :value do
  #   puts "\t\t> converge_if_changed"
  #   puts "\t\t> new_resource.value: #{new_resource.value}"
  #   execute [format_plistbuddy_command(:set, new_resource.entry, new_resource.value), new_resource.path].join(' ')
  # end

  execute "add #{new_resource.entry} to #{new_resource.path.split('/').last}" do
    command plistbuddy :add
    only_if { entry_missing? }
  end
  puts '>>> action :set END <<<'.colorize(:red).bold
end

action :delete do
  execute "delete #{new_resource.entry} from plist" do
    command plistbuddy :delete
    not_if { entry_missing? }
  end
end
