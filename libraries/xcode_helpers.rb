module Macos
  module XcodeHelpers
    def developer_credentials
      {
        XCODE_INSTALL_USER: data_bag_item(:credentials, :apple_id)['apple_id'],
        XCODE_INSTALL_PASSWORD: data_bag_item(:credentials, :apple_id)['password'],
      }
    end

    def xcversion_command
      '/opt/chef/embedded/bin/xcversion'.freeze
    end

    def xcode_already_installed?(semantic_version)
      xcversion_output = shell_out("#{xcversion_command} installed").stdout.split
      installed_xcodes = xcversion_output.values_at(*xcversion_output.each_index.select(&:even?))
      installed_xcodes.include?(xcversion_version(semantic_version))
    end

    def xcversion_version(semantic_version)
      split_version = semantic_version.split('.')
      if split_version.length == 2 && split_version.last == '0'
        split_version.first
      elsif split_version.length == 3 && split_version.last(2) == %w(0 0)
        split_version.first
      elsif split_version.length == 3 && split_version.last == '0'
        split_version.first(2).join('.')
      else
        semantic_version
      end
    end

    def requested_xcode_not_at_path
      xcode_version = '/Applications/Xcode.app/Contents/version.plist CFBundleShortVersionString'
      node['macos']['xcode']['version'] != shell_out("defaults read #{xcode_version}").stdout.strip
    end

    def simulator_already_installed?(simulator_type, semantic_version)
      available_simulator_versions.include?("#{simulator_type} #{semantic_version} Simulator (installed)")
    end

    def highest_semantic_simulator_version(major_version, simulators)
      requirement = Gem::Dependency.new('iOS', "~> #{major_version}")
      highest = simulators.select { |name, vers| requirement.match?(name, vers) }.max
      if highest.nil?
        Chef::Application.fatal!("iOS #{major_version} Simulator no longer available from Apple!")
      else
        highest.join(' ')
      end
    end

    def included_simulator_major_version(sdks)
      sdks ||= xcode_build_sdkoutput
      version_matcher    = /\d{1,2}\.\d{0,2}\.?\d{0,3}/
      included_simulator = sdks.match(/Simulator - iOS (?<version>#{version_matcher})/)
      included_simulator[:version].split('.').first.to_i
    end

    def simulator_list
      available_simulator_versions.split(/\n/).map { |version| version.split[0...2] }
    end

    def available_simulator_versions
      sims = shell_out!("#{xcversion_command} simulators").stdout
      mapping = {}
      sims.each do |sim|
        mapping[sim.first] = []
      end

      sims.each do |sim|
        mapping[sim.first].push(sim.last)
      end
      mapping
    end

    def xcode_build_sdkoutput
      shell_out!('/usr/bin/xcodebuild -showsdks').stdout
    end
  end
end

Chef::Recipe.include(Macos::XcodeHelpers)
Chef::Resource.include(Macos::XcodeHelpers)
