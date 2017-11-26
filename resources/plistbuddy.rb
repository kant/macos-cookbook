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
  puts '---> begin action_class'.colorize(:light_blue).bold
  extend MacOS::PlistBuddyHelpers
  library_helper_method

  def action_class_method
    print "\n"
    puts "---> inside \"action_class_method\"".colorize(mode: :italic)
    puts "     new_resource.desired_true: ".colorize(mode: :italic)
    puts "     new_resource.desired_false: ".colorize(mode: :italic)
    puts new_resource.desired_true.to_s.colorize(:green).bold
  end

  def plistbuddy(action)
    [format_plistbuddy_command(action, new_resource.entry, new_resource.value), new_resource.path].join(' ')
  end

  def entry_missing?
    return true if shell_out(plistbuddy(:print)).error?
  end
  puts '---> end action_class'.colorize(:light_blue).bold
end

load_current_value do
  print "\n"
  puts "---> begin load_current_value".colorize(:red).bold
  # action_class_method
  library_helper_method
  puts "---> end load_current_value".colorize(:red).bold
  print "\n"
end

action :set do
  puts ">>> begin action :set".colorize(:light_magenta).bold
  puts "---> current_value: #{current_value}".colorize(:cyan).bold

  library_helper_method
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
  puts ">>> end action :set".colorize(:light_magenta).bold
end

action :delete do
  execute "delete #{new_resource.entry} from plist" do
    command plistbuddy :delete
    not_if { entry_missing? }
  end
end
