module HTMLClass
  # A dictionary of HTML classes, where keys are symbols or sets of symbols.
  # Contains a reference to a merge strategy, which is used when a key already exists, and
  # the #add OnCollision strategy is set to :merge.
  class Dictionary
    @dict : Hash(Symbol | Set(Symbol), String)

    @merge : HTMLClassMerge::Merge

    delegate :[], :[]?, to: @dict

    def initialize(@dict = Hash(Symbol | Set(Symbol), String).new, @merge = HTMLClass.default_merge)
    end

    def clone(dict = @dict.dup)
      self.class.new dict, @merge
    end

    def to_h
      @dict.dup
    end

    def add(key : Symbol | Enumerable(Symbol), html_class : String, on_collision : OnCollision = :merge) : self
      key = to_key(key)
      clone dict: @dict.merge({ key => handle_collision(key, html_class, on_collision)})
    end

    def add(key : Symbol | Enumerable(Symbol), other_key : Symbol | Enumerable(Symbol), on_collision : OnCollision = :merge) : self
      add key, self[to_key(other_key)], on_collision
    end

    def add(dictionary : Dictionary, on_collision : OnCollision = :merge) : self
      dictionary.to_h.reduce(clone) do |result, (key, html_class)|
        result.add key, html_class, on_collision
      end
    end

    private def to_key(key : Symbol | Enumerable(Symbol))
      key.is_a?(Symbol) ? key : key.to_set
    end

    private def handle_collision(key, html_class, on_collision)
      if on_collision == OnCollision::Merge && (prev_html_class = @dict[key]?)
        @merge.merge [prev_html_class, html_class]
      else
        html_class
      end
    end
  end
end
