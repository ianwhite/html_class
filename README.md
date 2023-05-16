# html_class

Provide a mechanism for

1. Joining arbitrary HTML classes together, using a merge strategy (such as Tailwind)
2. Specifying groups of HTML classes by a symbol key (or Set of keys)

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     html_class:
       github: ianwhite/html_class
   ```

2. Run `shards install`

## Usage

Example of defining some groups of html classes, based on Tailwind's rules for merging classes, then using those
groups, along with arbitrary HTML classes to construct a `class` HTML attribute

```crystal
require "html_class/tailwind"

class MyView
  include HTMLClass::Tailwind

  # define some styles
  html_class :h1, "text-xl"
  html_class :button, "rounded p-3 bg-gray-50 border-black text-black"
  html_class :success, "bg-green-50 border-green-900 text-green"
end

view = MyView.new
view.html_class(:h1)                     # => "text-xl"
view.html_class(:button, success: false) # => "rounded p-3 bg-gray-50 border-black text-black"
view.html_class(:button, "rounded-none") # => "p-3 bg-gray-50 border-black text-black rounded-none"
view.html_class(:button, success: true)  # => "rounded p-3 bg-green-50 border-green-900 text-green"

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

## Contributors

- [Ian White](https://github.com/ianwhite) - creator and maintainer
