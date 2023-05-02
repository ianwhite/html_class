require "./key"

module HtmlClasses
  # A registry of html classes, such as:
  #
  # ```
  # require "html_class_merge/tailwind"
  # registry = HtmlClasses::Registry.new(merge_strategy: HtmlClassMerge::Tailwind)
  #
  # registry.register! :button, "rounded bg-blue-500 text-white hover:bg-blue-600"
  # registry.register! [:button, :disabled], "opacity-50 cursor-not-allowed"
  # registry.register! [:button, :danger], "bg-red-500 hover:bg-red-600"
  #
  # registry[:button]                 # => "rounded bg-blue-500 text-white hover:bg-blue-600"
  # registry[:button, disabled: true] # => "rounded bg-blue-500 text-white hover:bg-blue-600 opacity-50 cursor-not-allowed"
  #
  # # the following depends on having a merge strategy (such as Tailwind) that knows what classes override others
  # registry[:button, :danger] # => "rounded text-white bg-red-500 hover:bg-red-600"
  # ```
  #
  class Registry
    @registry : Hash(Key, String)

    # The strategy to use when merging classes
    @merge_strategy : HtmlClassMerge::Merge

    # What to do when a class is registered with a name that already exists
    enum OnCollision
      Replace
      Merge
    end

    def initialize(@registry = {} of Key => String, @merge_strategy = HtmlClasses.settings.merge_strategy)
    end

    def initialize(registry : Hash(Symbol | Array(Symbol), String), *args)
      initialize(registry.transform_keys { |k| Key.new(k) }, *args)
    end

    def clone(registry = @registry)
      self.class.new registry.dup, @merge_strategy
    end

    def register!(key : Key, html_class : String, on_collision : OnCollision = OnCollision::Merge) : self
      @registry[key] = handle_collision(key, html_class, on_collision)
      self
    end

    def register!(key : Symbol | Array(Symbol), html_class : String, on_collision : OnCollision = OnCollision::Merge) : self
      register! Key.new(key), html_class, on_collision
    end

    def register!(registry : Registry, on_collision : OnCollision = OnCollision::Merge) : self
      registry.to_h.reduce(self) do |registry, (key, html_class)|
        register! key, html_class, on_collision
      end
    end

    def register!(hash : Hash(Symbol | Array(Symbol), String), on_collision : OnCollision = OnCollision::Merge) : self
      register! clone(hash), on_collision
    end

    def register(key, html_class, on_collision : OnCollision = OnCollision::Merge) : Registry
      clone.register! key, html_class, on_collision
    end

    def register(registry, on_collision : OnCollision = OnCollision::Merge) : Registry
      clone.register! registry, on_collision
    end

    def [](key : Key) : String
      @merge_strategy.merge key.combinations.compact_map { |n| @registry[n]? }
    end

    def [](*args, **kwargs) : String
      self[Key.new(*args, **kwargs)]
    end

    def to_h
      @registry.dup
    end

    private def handle_collision(key : Key, html_class : String, on_collision : OnCollision)
      if on_collision == OnCollision::Merge && @registry.has_key?(key)
        @merge_strategy.merge [@registry[key], html_class]
      else
        html_class
      end
    end
  end
end
