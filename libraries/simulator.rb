module MacOS
  module Simulator
    class << self
      def installed?(semantic_version)
        available_versions.include?("#{semantic_version} Simulator (installed)")
      end

      def highest_semantic_version(major_version)
        requirement = ::Gem::Dependency.new('iOS', "~> #{major_version}")
        highest = available_list.select { |name, vers| requirement.match?(name, vers) }
        if highest.max.nil?
          Chef::Application.fatal!("iOS #{major_version} Simulator no longer available from Apple!")
        else
          highest.join(' ')
        end
      end

      def included_major_version
        semantic_version_pattern = /\d{1,2}\.\d{0,2}\.?\d{0,3}/
        sdks_output = shell_out!('/usr/bin/xcodebuild', '-showsdks').stdout
        included_simulator = sdks_output.match(/Simulator - iOS (?<version>#{semantic_version_pattern})/)
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
