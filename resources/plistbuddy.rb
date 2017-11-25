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
  puts "\t\t> begin action_class"
  extend MacOS::PlistBuddyHelpers

  def plistbuddy(action)
    puts "\n"
    puts "\t\t\t=> inside plistbuddy..."
    puts "\t\t\t=> new_resource.foo: #{new_resource.foo}"
    [format_plistbuddy_command(action, new_resource.entry, new_resource.value), new_resource.path].join(' ')
  end

  def entry_missing?
    puts "\n"
    puts "\t\t\t=> inside entry_missing?..."
    puts "\t\t\t=> new_resource.bar: #{new_resource.bar}"
    return true if shell_out(plistbuddy(:print)).error?
  end
  puts "\t\t> end action_class"
  puts "\n"
end

# load_current_value do |desired|
#   puts "\n\n"
#   puts "\t\t> desired.value: #{desired.value}"
#   puts "\t\t> desired.entry: #{desired.entry}"
#   puts "\t\t> desired.path: #{desired.path}"
#   puts "\n"

#   full_command = [format_plistbuddy_command(:print, desired.entry), desired.path].join(' ')
#   result = shell_out(full_command)

#   puts "\t\t> full_command: #{full_command}"
#   puts "\n"
#   puts "\t\t> result: #{result}"
#   puts "\t\t> result.stdout: #{result.stdout}"
#   puts "\t\t> result.stdout.chomp: #{result.stdout.chomp}"
#   puts "\n"
#   puts "\t\t> result.stdout.chomp != desired.value: #{result.stdout.chomp != desired.value}"
#   puts "\n"
#   puts "\t\t> entry (before): #{entry}"
#   puts "\t\t> path (before): #{path}"
#   puts "\t\t> value (before): #{value}"
#   value desired.value if result.stdout.chomp != desired.value.to_s
#   puts "\t\t> value (after): #{value}"
# end

load_current_value do |desired|
  puts "\n"
  puts "\t\t> begin load_current_value"
  # puts "\t\t> desired.value: #{desired.value}"
  # puts "\t\t> desired.entry: #{desired.entry}"
  # puts "\t\t> desired.path: #{desired.path}"
  # puts "\n"

  # full_command = [format_plistbuddy_command(:print, desired.entry), desired.path].join(' ')
  # result = shell_out(full_command)

  # puts "\t\t> full_command: #{full_command}"
  # puts "\n"
  # puts "\t\t> result: #{result}"
  # puts "\t\t> result.stdout: #{result.stdout}"
  # puts "\t\t> result.stdout.chomp: #{result.stdout.chomp}"
  # puts "\n"
  # puts "\t\t> result.stdout.chomp != desired.value: #{result.stdout.chomp != desired.value}"
  # puts "\n"

  puts "\t\t\t-> entry: #{entry}"
  puts "\t\t\t-> path: #{path}"
  puts "\t\t\t-> value: #{value}"

  puts "\t\t\t-> foo: #{foo}"
  puts "\t\t\t-> bar: #{bar}"
  puts "\t\t\t-> baz: #{baz}"

  puts "\t\t\t-> desired.entry: #{desired.entry}"
  puts "\t\t\t-> desired.path: #{desired.path}"
  puts "\t\t\t-> desired.value: #{desired.value}"

  puts "\t\t\t-> desired.foo: #{desired.foo}"
  puts "\t\t\t-> desired.bar: #{desired.bar}"
  puts "\t\t\t-> desired.baz: #{desired.baz}"

  # puts "\t\t> entry: #{new_resource.entry}"
  # puts "\t\t> path: #{new_resource.path}"
  # puts "\t\t> value: #{new_resource.value}"
  # value desired.value if result.stdout.chomp != desired.value.to_s
  # puts "\t\t> value (after): #{value}"
  puts "\t\t> end load_current_value"
  puts "\n"
end

# load_current_value do
#   puts "\n"
#   puts "\t\t>>> begin load_current_value"
#   # puts "\t\t> desired.value: #{desired.value}"
#   # puts "\t\t> desired.entry: #{desired.entry}"
#   # puts "\t\t> desired.path: #{desired.path}"
#   # puts "\n"

#   # full_command = [format_plistbuddy_command(:print, desired.entry), desired.path].join(' ')
#   # result = shell_out(full_command)

#   # puts "\t\t> full_command: #{full_command}"
#   # puts "\n"
#   # puts "\t\t> result: #{result}"
#   # puts "\t\t> result.stdout: #{result.stdout}"
#   # puts "\t\t> result.stdout.chomp: #{result.stdout.chomp}"
#   # puts "\n"
#   # puts "\t\t> result.stdout.chomp != desired.value: #{result.stdout.chomp != desired.value}"
#   # puts "\n"

#   puts "\t\t\t-> entry: #{entry}"
#   puts "\t\t\t-> path: #{path}"
#   puts "\t\t\t-> value: #{value}"

#   puts "\t\t\t-> foo: #{foo}"
#   puts "\t\t\t-> bar: #{bar}"
#   puts "\t\t\t-> baz: #{baz}"

#   # puts "\t\t> entry: #{new_resource.entry}"
#   # puts "\t\t> path: #{new_resource.path}"
#   # puts "\t\t> value: #{new_resource.value}"
#   # value desired.value if result.stdout.chomp != desired.value.to_s
#   # puts "\t\t> value (after): #{value}"
#   puts "\t\t>>> end load_current_value"
#   puts "\n"
# end

action :set do
  puts "\n"
  puts "\t\t>>> begin action :set"
  puts "\t\t> current_value: #{current_value}"
  # puts "current_value.class: #{current_value.class}"
  # puts "current_value.ancestors: #{current_value.ancestors}"

  # converge_if_changed :value do
  #   puts "\t\t> converge_if_changed"
  #   puts "\t\t> new_resource.value: #{new_resource.value}"
  #   execute [format_plistbuddy_command(:set, new_resource.entry, new_resource.value), new_resource.path].join(' ')
  # end

  execute "add #{new_resource.entry} to #{new_resource.path.split('/').last}" do
    command plistbuddy :add
    only_if { entry_missing? }
  end

  puts "\t\t>>> end action :set"
  puts "\n"
end

action :delete do
  execute "delete #{new_resource.entry} from plist" do
    command plistbuddy :delete
    not_if { entry_missing? }
  end
end
