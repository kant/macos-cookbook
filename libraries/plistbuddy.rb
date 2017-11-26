require 'colorize'

module MacOS
  module PlistBuddyHelpers
    puts '---> Helpers BEGIN <---'.colorize(:magenta)
    def library_helper_method(message)
      puts '        library_helper_method BEGIN'.colorize(:light_magenta).italic
      puts "          #{message}".colorize(:light_magenta).bold
      puts '        library_helper_method END'.colorize(:light_magenta).italic
    end

    def convert_to_string_from_data_type(value)
      data_type_cases = { Array => "array #{value}",
                          Integer => "integer #{value}",
                          TrueClass => "bool #{value}",
                          FalseClass => "bool #{value}",
                          Hash => "dict #{value}",
                          String => "string #{value}",
                          Float => "float #{value}" }
      data_type_cases[value.class]
    end

    def needs_conversion?(path)
      return true if shell_out('/usr/bin/file', '--brief', '--mime', path).stdout =~ /binary/i
    end

    def convert_to_binary(path)
      shell_out('/usr/bin/plutil', '-convert', 'binary1', path)
    end

    def format_plistbuddy_command(action_property, plist_entry, plist_value = nil)
      plist_entry = "\"#{plist_entry}\"" if plist_entry.include?(' ')
      plist_value = args_formatter(action_property, plist_value)
      "/usr/libexec/PlistBuddy -c \'#{action_property.to_s.capitalize} :#{plist_entry} #{plist_value}\'"
    end

    def method_finder(class_name)
      class_instance_methods = class_name.instance_methods - class_name.superclass.instance_methods
      puts "         ==> #{class_name}".colorize(:green).bold
      class_instance_methods.sort.each do |method|
        puts "        ==> #{method}".colorize(:green)
      end
    end

    private

    def args_formatter(action_property, plist_value)
      if action_property == :add
        convert_to_string_from_data_type plist_value
      else
        plist_value
      end
    end
    puts '---> Helpers END <---'.colorize(:magenta)
  end
end

Chef::Recipe.include(MacOS::PlistBuddyHelpers)
Chef::Resource.include(MacOS::PlistBuddyHelpers)
