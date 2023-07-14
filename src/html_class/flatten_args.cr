module HTMLClass
  # #flatten_args flattens a wide variety of arguments, such as Hash, NamedTuple, String, and Symbol, and Enumerable
  # of these into a single Array of String | Symbol
  # NamedTuple and Hash are flattened by selecting only the keys with truthy values, and then flattening the keys
  module FlattenArgs
    extend self

    def flatten_args(*args, **nargs) : Array(String | Symbol)
      flatten_args(args) + flatten_args(nargs)
    end

    def flatten_args(enumerable : Enumerable) : Array(String | Symbol)
      enumerable.flat_map { |arg| flatten_args arg }
    end

    def flatten_args(optional : NamedTuple) : Array(String | Symbol)
      flatten_args optional.to_h
    end

    def flatten_args(optional : Hash) : Array(String | Symbol)
      optional.select { |_, v| v }.keys.flat_map { |arg| flatten_args arg }
    end

    def flatten_args(arg : Nil) : Array(String | Symbol)
      [] of String | Symbol
    end

    def flatten_args(arg : String | Symbol)
      [arg] of String | Symbol
    end
  end
end
