module HTMLClass
  module Substitute
    # given an array of tokens, and dictionary, substitute any keys in the dictionary with their corresponding values.
    # also look up combinations of keys, and add those to the list of tokens.
    def self.substitute(tokens : Array(Symbol | String), dictionary : Dictionary) : Array(String)
      seen_keys     = [] of Symbol
      seen_key_sets = [] of Set(Symbol)

      tokens.flat_map do |token|
        if token.is_a?(Symbol)
          seen_keys << token
          key_sets = possible_key_sets(seen_keys)
          keys = [token] + key_sets - seen_key_sets
          seen_key_sets = key_sets

          keys.compact_map { |k| dictionary[k]? }
        else
          token
        end
      end
    end

    # return all possible key sets for the given keys
    def self.possible_key_sets(keys : Array(Symbol)) : Array(Set(Symbol))
      (2..keys.size).flat_map { |n| keys.combinations(n).map(&.to_set) }
    end
  end
end
