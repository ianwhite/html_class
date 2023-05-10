# html_classes

TODO: Write a description here

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     html_class:
       github: ianwhite/html_class
   ```

2. Run `shards install`

## Usage

```crystal
require "html_class/tailwind"

class MyView
  include HTMLClass::Tailwind

  html_class :h1, "text-xl"
  html_class :button, "rounded p-3 bg-gray-50 border-black text-black"
  html_class :success, "bg-green-50 border-green-900 text-green"
end

view = MyView.new
view.html_class(:h1)                     # => "text-xl"
view.html_class(:button)                 # => "rounded p-3 bg-gray-50 border-black text-black"
view.html_class(:button, "rounded-none") # => "p-3 bg-gray-50 border-black text-black rounded-none"
view.html_class(:button, :success)       # => "rounded p-3 bg-green-50 border-green-900 text-green"

# you can inherit html_classes, and merge or replace them
class SubView < MyView
  html_class :h1, "font-bold", :merge   # default is :merge
  html_class :button, "", :replace      # but you can also :replace
end

sub_view = SubView.new
sub_view.html_class(:h1)     # => "text-xl font-bold"
sub_view.html_class(:button) # => ""


# you can also import multiple html class dictionaries at will (NB this class does not inherit form the above)
class LargeView
  include HTMLClass::Tailwind

  html_class MyView.html_class_dictionary # import from another view
  html_class :h1, "text-2xl"
  html_class :button, "p-5 text-lg"
end

large_view = LargeView.new
large_view.html_class(:h1)     # => "text-2xl"
large_view.html_class(:button) # => "rounded bg-gray-50 border-black text-black p-5 text-lg"
```

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/your-github-user/html_classes/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Ian White](https://github.com/your-github-user) - creator and maintainer
