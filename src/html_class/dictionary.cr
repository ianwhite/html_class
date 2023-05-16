module HTMLClass
  # A dictionary of HTML classes, where keys are symbols or sets of symbols.
  # Contains a reference to a merge strategy, which is used when a key already exists, and
  # the #add collision strategy is set to :merge.
  class Dictionary
    alias K = Symbol | Set(Symbol)
    alias V = String

    @hash : Hash(K, V)
    @merge : HTMLClassMerge::Merge

    include Enumerable({K, V})
    include Iterable({K, V})

    delegate :each, :[], :[]?, to: @hash

    def initialize(@hash = Hash(K, V).new, @merge = HTMLClass.default_merge)
    end

    def initialize(other : Dictionary)
      @hash = other.to_h
      @merge = other.merge
    end

    def to_h
      @hash.dup
    end

    def dup
      self.class.new(@hash.dup, @merge)
    end

    def add(key : K, html_class : V, on_collision : OnCollision = :merge) : self
      self.class.new(@hash.merge({key => handle_collision(key, html_class, on_collision)}), @merge)
    end

    def add(key : Array(Symbol), html_class : V, on_collision : OnCollision = :merge) : self
      add key.to_set, html_class, on_collision
    end

    def add(dictionary : Dictionary, on_collision : OnCollision = :merge) : self
      dictionary.reduce(self.dup) do |result, (key, html_class)|
        result.add key, html_class, on_collision
      end
    end

    private def handle_collision(key, html_class, on_collision) : V
      if on_collision == OnCollision::Merge && @hash.has_key?(key)
        @merge.merge [@hash[key], html_class]
      else
        html_class
      end
    end
  end
end
