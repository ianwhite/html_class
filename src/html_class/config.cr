module HTMLClass
  class Config
    getter dictionary : Dictionary

    @merge : HTMLClassMerge::Merge

    def initialize(@dictionary, @merge)
    end

    def add(key : Array(Symbol), html_class, on_collision : OnCollision = :merge) : Dictionary
      add(key.to_set, html_class, on_collision)
    end

    def add(key : Symbol | Set(Symbol), html_class : String, on_collision : OnCollision = :merge) : Dictionary
      @dictionary.merge({key => handle_collision(key, html_class, on_collision)})
    end

    def add(dictionary : Dictionary, on_collision : OnCollision = :merge) : Dictionary
      result = @dictionary.clone
      dictionary.each do |key, html_class|
        result[key] = handle_collision(key, html_class, on_collision)
      end
      result
    end

    def handle_collision(key : Symbol | Set(Symbol), html_class : String, on_collision : OnCollision) : String
      if on_collision == OnCollision::Merge && @dictionary.has_key?(key)
        @merge.merge [dictionary[key], html_class]
      else
        html_class
      end
    end
  end
end
