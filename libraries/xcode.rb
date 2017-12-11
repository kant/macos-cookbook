module MacOS
  module Xcode
    class << self
      def xcversion_command
        '/opt/chef/embedded/bin/xcversion'.freeze
      end

      def xcode_bundles
        ::Dir.glob('/Applications/Xcode*.app')
      end

      def current_xcode_version
        linked = xcode_bundles.select { |bundle| ::File.symlink?(bundle_path) }
        version_plist = ::File.join linked.first, 'Contents', 'version.plist'
        content = Plist.parse_xml(version_plist)
        content['CFBundleShortVersionString']
      end

      def requested_xcode_already_installed?(semantic_version = nil)
        version = semantic_version || node['macos']['xcode']['version']
        xcversion_output = shell_out(XCVersion.command, 'installed').stdout
        installed_xcodes = xcversion_output.split.values_at(*xcversion_output.each_index.select(&:even?))
        installed_xcodes.include?(version)
      end

      def xcodes
        xcodes = {}
        bundle_paths = ::Dir.glob('/Applications/Xcode*.app')
        bundle_paths = bundle_paths.reject { |bundle_path| ::File.symlink?(bundle_path) }

        bundle_paths.each do |bundle_path|
          version_plist = ::File.join(bundle_path, 'Contents', 'version.plist')
          content = Plist.parse_xml(version_plist)
          version = content['CFBundleShortVersionString']
          xcodes[version] = {}
          xcodes[version][:path] = bundle_path
        end
        xcodes
      end

      def xcversion_version(semantic_version)
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

      def simulator_already_installed?(semantic_version); end

      def highest_semantic_simulator_version(major_version, simulators)
        requirement = Gem::Dependency.new('iOS', "~> #{major_version}")
        highest = simulators.select { |name, vers| requirement.match?(name, vers) }.max
        if highest.nil?
          Chef::Application.fatal!("iOS #{major_version} Simulator no longer available from Apple!")
        else
          highest.join(' ')
        end
      end

      def installed?(semantic_version)
        xcversion_output = shell_out("#{XCVersion.command} installed").stdout.split
        installed_xcodes = xcversion_output.values_at(*xcversion_output.each_index.select(&:even?))
        installed_xcodes.include?(semantic_version)
      end
    end
  end

  module Simulator
    class << self
      def installed?(semantic_version)
        available_versions.include?("#{semantic_version} Simulator (installed)")
      end

      def highest_semantic_version(major_version)
        requirement = Gem::Dependency.new('iOS', "~> #{major_version}")
        highest = available_list.select { |name, vers| requirement.match?(name, vers) }.max
        if highest.nil?
          Chef::Application.fatal!("iOS #{major_version} Simulator no longer available from Apple!")
        else
          highest.join(' ')
        end
      end

      def included_major_version
        version_matcher    = /\d{1,2}\.\d{0,2}\.?\d{0,3}/
        sdks               = shell_out!('/usr/bin/xcodebuild -showsdks').stdout
        included_simulator = sdks.match(/Simulator - iOS (?<version>#{version_matcher})/)
        included_simulator[:version].split('.').first.to_i
      end

      def available_list
        available_versions.split(/\n/).map { |version| version.split[0...2] }
      end

      def available_versions
        shell_out!("#{XCVersion.command} simulators").stdout
      end
    end
  end
end

Chef::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
