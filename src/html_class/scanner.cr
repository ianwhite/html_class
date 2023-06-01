module HTMLClass
  # Coerces a variety of arguments into an array of HTML class tokens
  # Hashes and NameTuples are turned into arrays such that the keys are only included if their values are true.
  # Symbols are converted to html classes via @dictionary.
  #
  # #tokens returns the array of tokens.
  #
  # All sets of symbols are also looked up in the @dictionary so any specific behaviour of a *Set* of symbols
  # can be defined.
  class Scanner
    @dictionary : Dictionary

    getter tokens = Array(String).new
    @scanned_keys = Array(Symbol).new
    @scanned_key_sets = Array(Set(Symbol)).new

    def initialize(@dictionary)
    end

    def scan(*args, **kwargs) : self
      scan args
      scan kwargs
    end

    def scan(_nil : Nil) : self
      self
    end

    def scan(optional : Hash) : self
      optional.select { |_, v| v }.keys.each { |arg| scan arg }
      self
    end

    def scan(optional : NamedTuple) : self
      scan optional.to_h
    end

    def scan(args : Enumerable) : self
      args.each { |arg| scan arg }
      self
    end

    def scan(_nil : Nil) : self
      self
    end

    def scan(html_class : String) : self
      @tokens << html_class
      self
    end

    def scan(key : Symbol) : self
      @scanned_keys << key

      possible_key_sets = possible_key_sets(@scanned_keys)
      keys = [key] + possible_key_sets - @scanned_key_sets
      @scanned_key_sets = possible_key_sets

      @tokens.concat keys.compact_map { |k| @dictionary[k]? }
      self
    end

    # return all possible key sets for the given keys
    private def possible_key_sets(keys)
      (2..keys.size).flat_map { |n| keys.combinations(n).map(&.to_set) }
    end
  end
end
