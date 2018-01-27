spotlight
===

Use the **spotlight** resource to manage the metadata indexing state for disk volumes. This
will primarily affect the ability to search volume contents with the macOS Spotlight feature.
Under the hood, a **spotlight** resource executes the `mdutil` command in the `metadata_util`
library.

[Learn more about Spotlight](https://support.apple.com/en-us/HT204014).

[Learn more about the `mdutil` command](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/mdutil.1.html).

Syntax
------

The most basic usage of a **spotlight** resource block declares a disk volume as the name property
to **enable** metadata indexing:

```ruby
spotlight '/'
```

The full syntax for all of the properties available to the **spotlight** resource is:

```ruby
spotlight 'volume name' do
  volume                      String # defaults to 'volume name' if not specified
  indexed                     TrueClass, FalseClass # defaults to TrueClass if not specified
  searchable                  TrueClass, FalseClass # defaults to TrueClass if not specified
end
```

Actions
-------

This resource has the following actions:

`:set`

<dl>
  <dd><b>Ruby Type: </b><code>String</code></dd>
  <dd>Set the metadata indexing state declared by the `indexed` property. This
  is the only, and default, action.</dd>
</dl>

Properties
----------

`volume`

<dl>
  <dd><b>Ruby Type: </b><code>String</code></dd>
  <dd>The name of the disk volume to manage.</dd>
</dl>

`indexed`

<dl>
  <dd><b>Ruby Type: </b><code>TrueClass, FalseClass</code></dd>
  <dd>Whether or not the desired state of the named disk volume is to be
  indexed. Default value: <code>true</code></dd>
</dl>

`searchable`

<dl>
  <dd><b>Ruby Type: </b><code>TrueClass, FalseClass</code></dd>
  <dd>The name of the disk volume to manage. Disables Spotlight searching if the
  index has already been created for the <code>volume</code>. Only applicable if
  the indexed property is set to false. Default value: <code>true</code></dd>
</dl>

Examples
----------

```ruby
spotlight '/' # enables indexing on the boot volume

spotlight 'test_disk1' do # disables indexing on 'test_disk1'
  indexed false
end

spotlight 'enable indexing on TDD2' do
  volume 'TDD2'
  indexed true
end

spotlight 'disable indexing and prevent searching index on TDD-ROM' do
  volume 'TDD-ROM'
  indexed false
  searchable false
end
```
