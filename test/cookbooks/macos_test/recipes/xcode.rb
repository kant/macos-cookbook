if node['platform_version'].match?(/10\.13/) || node['platform_version'].match?(/10\.12/)
  execute 'Disable Gatekeeper' do
    command 'spctl --master-disable'
  end

  xcode '9.2' do
    ios_simulators lazy { %w(11 10) }
  end

elsif node['platform_version'].match?(/10\.11/)

  xcode '8.2.1' do
    ios_simulators lazy { %w(10 9) }
  end
end
