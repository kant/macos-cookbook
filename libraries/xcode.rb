module MacOS
  module Xcode
    class << self
      def xcode_bundles
        ::Dir.glob('/Applications/Xcode*.app')
      end

      def linked_xcode_version
        linked = xcode_bundles.select { |bundle| ::File.symlink?(bundle) }
        version_plist = ::File.join linked.first, 'Contents', 'version.plist'
        content = ::Plist.parse_xml version_plist
        content['CFBundleShortVersionString']
      end

      def xcodes
        xcodes = {}
        real_paths = xcode_bundles.reject { |bundle| ::File.symlink?(bundle) }

        real_paths.each do |real_path|
          version_plist = ::File.join real_path, 'Contents', 'version.plist'
          content = Plist.parse_xml version_plist
          version = content['CFBundleShortVersionString']
          xcodes[version] = {}
          xcodes[version][:path] = real_path
        end
        xcodes
      end

      def psuedosemantic_xcode_version(semantic_version)
        split_version = semantic_version.split('.')
        if split_version.length == 2 && split_version.last == '0'
          split_version.first
        else
          semantic_version
        end
      end

      def semantic(version)
        ::Gem::Version.new(version)
      end

      def installed?(semantic_version)
        xcversion_output = shell_out(XCVersion.command, 'installed').stdout
        installed_xcodes = xcversion_output.split.values_at(*xcversion_output.each_index.select(&:even?))
        installed_xcodes.include? semantic_version
      end
    end
  end
end

Chef::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
