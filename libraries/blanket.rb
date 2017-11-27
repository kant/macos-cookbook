require 'colorize'

module MacOS
  module BlanketHelpers
    def property_printer(label, property, location)
      print "#{label} from [#{location}]: ".colorize(:light_cyan)
      puts property.to_s.colorize(:light_cyan).italic
    end

    def blanket_helper(message)
      method_identifier('blanket_helper', message)
    end

    def indenter(level, char = nil)
      char = if char
               char + ' '
             else
               '  '
             end

      levels = '  ' * level
      levels + char
    end

    def method_identifier(label, message)
      puts "#{indenter(2, '-')}#{label}".colorize(:light_magenta).bold
      puts "#{indenter(3)}#{message}".colorize(:light_magenta).italic
      puts "#{indenter(2, '-')}#{label}".colorize(:light_magenta).bold
    end

    def instance_method_finder(class_name)
      class_instance_methods = class_name.instance_methods - class_name.superclass.instance_methods
      puts "#{indenter(1, '-')}#{class_name}:".colorize(:green).bold
      class_instance_methods.sort.each do |method|
        puts "#{indenter(3)}#{method}".colorize(:green)
      end
    end

    def instance_variable_finder(class_name)
      class_instance_variables = class_name.instance_variables - class_name.superclass.instance_variables
      puts(indenter(1, '*'), class_name).to_s.colorize(:red).bold
      class_instance_variables.sort.each do |variable|
        puts(indenter(3), variable).to_s.colorize(:red)
      end
    end
  end
end

Chef::Recipe.include(MacOS::BlanketHelpers)
Chef::Resource.include(MacOS::BlanketHelpers)
