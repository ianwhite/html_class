module HTMLClass
  # Coerces a variety of arguments into a String of html classes
  # Hashes and NameTuples are turned into arrays such that the keys are only included if the value is true.
  # Symbols are converted to to html classes via @dictionary.
  # All sets of symbols are also looked up in the @dictionary so any specific behaviour of a set of symbols
  # can be defined.
  class Scanner
    @dictionary : Dictionary

    @merge : HTMLClassMerge::Merge

    @seen_keys = Array(Symbol).new

    @seen_key_sets = Array(Set(Symbol)).new

    def initialize(@dictionary, @merge)
    end

    def scan(*args : HTMLClass::Arg | NamedTuple) : String
      @merge.merge args.flat_map { |arg| scan arg }
    end

    def scan(*args : HTMLClass::Arg | NamedTuple, **kwargs) : String
      scan(args.to_a + [kwargs.to_h])
    end

    def scan(optional : Hash) : String
      @merge.merge optional.select { |_, v| v }.keys.flat_map { |arg| scan arg }
    end

    def scan(optional : NamedTuple) : String
      scan optional.to_h
    end

    def scan(args : Array) : String
      @merge.merge args.flat_map { |arg| scan arg }
    end

    def scan(html_class : String) : String
      html_class
    end

    def scan(key : Symbol) : String
      @seen_keys << key

      possible_key_sets = possible_key_sets(@seen_keys)
      keys = [key] + possible_key_sets - @seen_key_sets
      @seen_key_sets = possible_key_sets

      @merge.merge keys.compact_map { |k| @dictionary[k]? }
    end

    # return all possible key sets for the given keys
    private def possible_key_sets(keys)
      (2..keys.size).flat_map { |n| keys.combinations(n).map(&.to_set) }
    end
  end
end
