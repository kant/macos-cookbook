require 'spec_helper'

include MacOS::PlistBuddyHelpers

describe MacOS::PlistBuddyHelpers, '#plistbuddy_command' do
  context 'Adding a value to a plist' do
    it 'the bool arguments contain the data type' do
      expect(plistbuddy_command(:add, 'FooEntry', 'path/to/file.plist', true)).to eq "/usr/libexec/PlistBuddy -c 'Add :FooEntry bool true' path/to/file.plist"
    end

    it 'the int arguments contain the data type' do
      expect(plistbuddy_command(:add, 'QuuxEntry', 'path/to/file.plist', 50)).to eq "/usr/libexec/PlistBuddy -c 'Add :QuuxEntry integer 50' path/to/file.plist"
    end

    it 'the delete command is formatted properly' do
      expect(plistbuddy_command(:delete, 'BarEntry', 'path/to/file.plist')).to eq "/usr/libexec/PlistBuddy -c 'Delete :BarEntry ' path/to/file.plist"
    end

    it 'the set command is formatted properly' do
      expect(plistbuddy_command(:set, 'BazEntry', 'path/to/file.plist', false)).to eq "/usr/libexec/PlistBuddy -c 'Set :BazEntry false' path/to/file.plist"
    end

    it 'the print command is formatted properly' do
      expect(plistbuddy_command(:print, 'QuxEntry', 'path/to/file.plist')).to eq "/usr/libexec/PlistBuddy -c 'Print :QuxEntry ' path/to/file.plist"
    end
  end

  context 'The value provided contains spaces' do
    it 'returns the value properly formatted with double quotes' do
      expect(plistbuddy_command(:print, 'Foo Bar Baz', 'path/to/file.plist')).to eq "/usr/libexec/PlistBuddy -c 'Print :\"Foo Bar Baz\" ' path/to/file.plist"
    end
  end
end

describe MacOS::PlistBuddyHelpers, '#convert_to_data_type_from_string' do
  context 'When the type is boolean and given a 1 or 0' do
    it 'returns true if entry is 1' do
      expect(convert_to_data_type_from_string('boolean', '1')).to eq true
    end

    it 'returns false if entry is 0' do
      expect(convert_to_data_type_from_string('boolean', '0')).to eq false
    end
  end

  context 'When the type is integer and the value is 1' do
    it 'returns the value as an integer' do
      expect(convert_to_data_type_from_string('integer', '1')).to eq 1
    end
  end

  context 'When the type is integer and the value is 0' do
    it 'returns the value as an integer' do
      expect(convert_to_data_type_from_string('integer', '0')).to eq 0
    end
  end

  context 'When the type is integer and the value is 950224' do
    it 'returns the correct value as an integer' do
      expect(convert_to_data_type_from_string('integer', '950224')).to eq 950224
    end
  end

  context 'When the type is string and the value is also a string' do
    it 'returns the correct value still as a string' do
      expect(convert_to_data_type_from_string('string', 'corge')).to eq 'corge'
    end
  end

  context 'When the type is float and the value is 3.14159265359' do
    it 'returns the correct value as a float' do
      expect(convert_to_data_type_from_string('float', '3.14159265359')).to eq 3.14159265359
    end
  end
end

describe MacOS::PlistBuddyHelpers, '#convert_to_string_from_data_type' do
  context 'When given a certain data type' do
    it 'returns the required PlistBuddy boolean entry' do
      expect(convert_to_string_from_data_type(true)).to eq 'bool true'
    end

    # TODO: Skip until proper plist array syntax is implemented (i.e. containers)
    xit 'returns the required PlistBuddy array entry' do
      expect(convert_to_string_from_data_type(%w(foo bar))).to eq 'array foo bar'
    end

    # TODO: Skip until proper plist dict syntax is implemented (i.e. containers)
    xit 'returns the required PlistBuddy dictionary entry' do
      expect(convert_to_string_from_data_type('baz' => 'qux')).to eq 'dict key value'
    end

    it 'returns the required PlistBuddy string entry' do
      expect(convert_to_string_from_data_type('quux')).to eq 'string quux'
    end

    it 'returns the required PlistBuddy int entry' do
      expect(convert_to_string_from_data_type(1)).to eq 'integer 1'
    end

    it 'returns the required PlistBuddy float entry' do
      expect(convert_to_string_from_data_type(1.0)).to eq 'float 1.0'
    end
  end
end
