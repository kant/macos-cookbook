resource_name :plist

property :path, String, name_property: true

property :type, String, equal_to: ['binary', 'us-ascii'], default: 'binary', desired_state: false
property :entry, String, desired_state: true
property :value, [String, TrueClass, FalseClass, Integer, Float, nil], desired_state: true

load_current_value do |desired|
  value_from_system = shell_out('/usr/bin/defaults', 'read', desired.path, desired.entry).stdout.strip
  entry_type_from_system = shell_out('/usr/bin/defaults', 'read-type', desired.path, desired.entry).stdout.split.last

  entry '' if value_from_system.nil?
  value convert_to_data_type_from_string(entry_type_from_system, value_from_system)
  #  type shell_out('/usr/bin/file', '--brief', '--mime-encoding', desired.path).stdout.strip
end

action :set do
  converge_if_changed :entry do
    converge_by "add \"#{new_resource.entry}\" to #{new_resource.value} at #{new_resource.path.split('/').last}" do
      execute plistbuddy_command(:add, new_resource.entry, new_resource.path, new_resource.value)
    end
  end

  converge_if_changed :value do
    converge_by "set \"#{new_resource.entry}\" to #{new_resource.path.split('/').last}" do
      execute plistbuddy_command(:set, new_resource.entry, new_resource.path, new_resource.value)
    end
  end

  execute 'convert to binary plist' do
    command "/usr/bin/plutil -convert #{new_resource.type}1 #{new_resource.path}"
    not_if { shell_out('/usr/bin/file', '--brief', '--mime-encoding', new_resource.path).stdout.strip == new_resource.type }
  end
end
