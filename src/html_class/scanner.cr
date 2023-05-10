module HTMLClass
  # Coerces a variety of arguments into a String of html classes
  # Hashes and NameTuples are turned into arrays such that the keys are only included if the value is true.
  # Symbols are converted to to html classes via @dictionary
  # all sets of symbols are also looked up in the @dictionary so any specific combinations of symbols can be defined
  class Scanner
    alias Argument = String | Symbol | Enumerable(Symbol | String)

    @dictionary : Dictionary
    @merge : HTMLClassMerge::Merge
    @scanned_keys = Array(Symbol).new
    @emitted_combination_keys = Array(Set(Symbol)).new

    def initialize(@dictionary, @merge)
    end

    def scan(*args : Argument | Hash(Argument, Bool) | NamedTuple) : String
      @merge.merge args.flat_map { |arg| scan arg }
    end

    def scan(*args, **kwargs : Bool) : String
      scan(*args, kwargs.to_h)
    end

    def scan(args : Hash(Argument, Bool)) : String
      @merge.merge args.select { |_, v| v }.keys.flat_map { |arg| scan arg }
    end

    def scan(args : NamedTuple) : String
      @merge.merge args.to_h.select { |_, v| v }.keys.flat_map { |arg| scan arg }
    end

    def scan(args : Enumerable(Symbol | String)) : String
      @merge.merge args.flat_map { |arg| scan arg }
    end

    def scan(arg : String) : String
      arg
    end

    def scan(key : Symbol) : String
      @scanned_keys << key

      html_classes = combinations_from_dictionary
      html_classes.unshift(@dictionary[key]) if @dictionary.has_key?(key)

      @merge.merge html_classes
    end

    private def combinations_from_dictionary
      (combination_keys - @emitted_combination_keys).compact_map do |key|
        if @dictionary.has_key?(key)
          @emitted_combination_keys << key
          @dictionary[key]
        end
      end
    end

    private def combination_keys
      (2..@scanned_keys.size).flat_map { |n| @scanned_keys.combinations(n).map(&.to_set) }
    end
  end
end
