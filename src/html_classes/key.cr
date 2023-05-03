module HTMLClasses
  # The key for a html class is a Symbol, with an optional set of variant Symbols
  struct Key
    @key : Symbol
    @variants : Set(Symbol)

    def self.[](*args, **kwargs)
      new(*args, **kwargs)
    end

    def initialize(@key : Symbol, @variants = Set(Symbol).new)
    end

    def initialize(key : Array(Symbol))
      initialize(key[0], Set.new(key[1..]))
    end

    def initialize(*key_and_variants : Symbol, **optional_variants)
      key = key_and_variants.to_a + optional_variants.to_h.select { |_, v| v }.keys
      initialize(key)
    end

    # return array of all possible variants of this key
    def combinations
      variants = @variants.to_a
      (0..(variants.size)).flat_map do |length|
        variants.combinations(length)
      end.map do |combination|
        self.class.new(@key, Set(Symbol).new(combination))
      end
    end

    def inspect(io : IO)
      io << "#{self.class.name}[#{[@key, *@variants.to_a].map(&.inspect).join(", ")}]"
    end
  end
end
