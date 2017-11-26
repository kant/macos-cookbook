require 'colorize'

resource_name :plistbuddy

property :path, String, desired_state: true
property :entry, String, desired_state: true
property :value, [Hash, String, Array, TrueClass, FalseClass, Integer, Float], desired_state: true

property :foo, String, desired_state: false, default: 'foo'
property :bar, String, desired_state: false, default: 'bar'
property :baz, String, desired_state: false, default: 'baz'

property :is_binary, [TrueClass, FalseClass]

default_action :set

action_class do
  puts "\n"
  puts '---> begin action_class'.colorize(:light_blue).bold
  extend MacOS::PlistBuddyHelpers

  def plistbuddy(action)
    puts "\n"
    puts "\t---> inside plistbuddy...".colorize(mode: :italic)
    print "\t     new_resource.foo: ".colorize(mode: :italic)
    puts new_resource.foo.to_s.colorize(:green).bold
    [format_plistbuddy_command(action, new_resource.entry, new_resource.value), new_resource.path].join(' ')
  end

  def entry_missing?
    puts "\n"
    puts "\t---> inside entry_missing?...".colorize(mode: :italic)
    print "\t     new_resource.bar: ".colorize(mode: :italic)
    puts new_resource.bar.to_s.colorize(:green).bold
    return true if shell_out(plistbuddy(:print)).error?
  end
  puts '---> end action_class'.colorize(:light_blue).bold
end

load_current_value do |desired|
  puts "\n"
  puts "\t\t---> begin load_current_value".colorize(:red).bold
  puts "\t\t     entry: #{entry}"
  puts "\t\t     path: #{path}"
  puts "\t\t     value: #{value}"
  puts "\t\t     foo: #{foo}"
  puts "\t\t     bar: #{bar}"
  puts "\t\t     baz: #{baz}"
  puts "\t\t     desired.entry: #{desired.entry}"
  puts "\t\t     desired.path: #{desired.path}"
  puts "\t\t     desired.value: #{desired.value}"
  puts "\t\t     desired.foo: #{desired.foo}"
  puts "\t\t     desired.bar: #{desired.bar}"
  puts "\t\t     desired.baz: #{desired.baz}"
  puts "\t\t---> end load_current_value".colorize(:red).bold
end

action :set do
  puts "\n"
  puts "\t>>> begin action :set".colorize(:magenta).bold
  puts "\t---> current_value: #{current_value}".colorize(:cyan).bold

  # converge_if_changed :value do
  #   puts "\t\t> converge_if_changed"
  #   puts "\t\t> new_resource.value: #{new_resource.value}"
  #   execute [format_plistbuddy_command(:set, new_resource.entry, new_resource.value), new_resource.path].join(' ')
  # end

  execute "add #{new_resource.entry} to #{new_resource.path.split('/').last}" do
    command plistbuddy :add
    only_if { entry_missing? }
  end
  puts "\t>>> end action :set".colorize(:magenta).bold
end

action :delete do
  execute "delete #{new_resource.entry} from plist" do
    command plistbuddy :delete
    not_if { entry_missing? }
  end
end
