resource_name :spotlight
default_action %i(set)

property :volume, String, name_property: true
property :indexed, [true, false], default: true
property :allow_search, [true, false], default: true

action_class do
  def state
    new_resource.indexed ? 'on' : 'off'
  end

  def search
    new_resource.allow_search ? '' : '-d'
  end

  def target_volume
    volume_path(new_resource.volume)
  end

  def volume_path(volume)
    if volume == '/'
      volume
    else
      "/Volumes/#{volume}"
    end
  end

  def mdutil
    ['/usr/bin/mdutil']
  end

  def desired_spotlight_state
    [state, target_volume, search]
  end
end

action :set do
  execute "turn Spotlight indexing #{state} for #{target_volume}" do
    command mdutil + desired_spotlight_state.insert(0, '-i')
    not_if { MetadataUtil.new(target_volume).status == desired_spotlight_state }
  end
end
