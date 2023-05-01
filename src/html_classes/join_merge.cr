require "html_class_merge/merge"
require "html_class_merge/tokenize"

module HtmlClasses
  class JoinMerge
    include HtmlClassMerge::Merge
    include HtmlClassMerge::Tokenize

    def merge(*tokens : HtmlClassMerge::Tokenizable) : String
      tokenize(*tokens).join(" ")
    end
  end
end
