require "html_class_merge/merge"
require "html_class_merge/tokenize"

require "./html_class/scanner"
require "./html_class/config"

module HTMLClass
  VERSION = "0.3.0"

  # What to do when a class is registered with a name that already exists
  enum OnCollision
    Replace
    Merge
  end

  # Dictionary of html classes by symbol keys, useful for utility class frameworks
  alias Dictionary = Hash(Symbol | Set(Symbol), String)

  # Simple merge strategy that just joins tokens with a space
  class JoinMerge
    include HTMLClassMerge::Merge

    def merge(*tokens : String | Enumerable(String)) : String
      HTMLClassMerge::Tokenize.tokenize(*tokens).join(" ")
    end
  end

  class_property default_merge : HTMLClassMerge::Merge = JoinMerge.new

  def html_class(*args, **kwargs) : String
    Scanner.new(self.class.html_class_dictionary, self.class.html_class_merge).scan(*args, **kwargs)
  end

  macro included
    class_property(html_class_merge) { HTMLClass.default_merge }
    class_property(html_class_dictionary) { Dictionary.new }

    private def self.html_class(key, html_class, on_collision : OnCollision = :merge)
      self.html_class_dictionary = Config.new(html_class_dictionary, html_class_merge).add(key, html_class, on_collision)
    end

    private def self.html_class(dictionary : Dictionary, on_collision : OnCollision = :merge)
      self.html_class_dictionary = Config.new(html_class_dictionary, html_class_merge).add(dictionary, on_collision)
    end

    macro inherited
      class_property(html_class_dictionary) { \{{@type.superclass.id}}.html_class_dictionary }
    end
  end
end
