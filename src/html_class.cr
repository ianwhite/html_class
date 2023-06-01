require "html_class_merge/merge"
require "html_class_merge/tokenize"

require "./html_class/dictionary"
require "./html_class/scanner"

module HTMLClass
  VERSION = "0.4.2"

  # What to do when a HTML class is added with a name that already exists
  enum OnCollision
    Replace
    Merge
  end

  # Simple merge strategy that just joins tokens with a space
  class JoinMerge
    include HTMLClassMerge::Merge

    def merge(*tokens : String | Enumerable(String)) : String
      HTMLClassMerge::Tokenize.tokenize(*tokens).join(" ")
    end
  end

  class_property default_merge : HTMLClassMerge::Merge = JoinMerge.new

  def html_class(*args, **kwargs) : String
    self.class.html_class_merge.merge Scanner.new(self.class.html_class_dictionary)
                                             .scan(*args, **kwargs)
                                             .tokens
  end

  macro included
    class_property(html_class_merge) { HTMLClass.default_merge }

    class_property(html_class_dictionary) { Dictionary.new(merge: html_class_merge) }

    macro inherited
      class_property(html_class_merge) { \{{ @type.superclass.id }}.html_class_merge }

      class_property(html_class_dictionary) { \{{ @type.superclass.id }}.html_class_dictionary }
    end

    private def self.html_class(key, html_class, on_collision : OnCollision = :merge)
      self.html_class_dictionary = html_class_dictionary.add(key, html_class, on_collision)
    end

    private def self.html_class(dictionary, on_collision : OnCollision = :merge)
      self.html_class_dictionary = html_class_dictionary.add(dictionary, on_collision)
    end
  end
end
