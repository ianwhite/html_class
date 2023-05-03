module HTMLClasses
  class JoinMerge
    include MergeStrategy
    include Tokenize

    def merge(*tokens : Tokenizable) : String
      tokenize(*tokens).join(" ")
    end
  end
end
