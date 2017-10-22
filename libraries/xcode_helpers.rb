module Macos
  module XcodeHelpers
    def xcversion_command
      '/opt/chef/embedded/bin/xcversion'.freeze
    end

    def xcode_already_installed?(semantic_version)
      xcversion_output = shell_out("#{xcversion_command} installed").stdout.split
      installed_xcodes = xcversion_output.values_at(*xcversion_output.each_index.select(&:even?))
      installed_xcodes.include?(semantic_version)
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

    def simulator_already_installed?(semantic_version)
      available_simulator_versions.include?("#{semantic_version} Simulator (installed)")
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

    def included_simulator_major_version
      shell_out!('xcodebuild -version -sdk iphonesimulator').split(': ').last.chomp.chomp
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
  end
end

Chef::Recipe.include(Macos::XcodeHelpers)
Chef::Resource.include(Macos::XcodeHelpers)
