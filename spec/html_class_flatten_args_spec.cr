require "./spec_helper"

module HTMLClass
  describe "FlattenArgs.flatten_args" do
    FlattenArgs.flatten_args(:foo).should eq [:foo] of String | Symbol
    FlattenArgs.flatten_args(:foo, :bar).should eq [:foo, :bar] of String | Symbol
    FlattenArgs.flatten_args([:foo, ["bar", :baz]]).should eq [:foo, "bar", :baz] of String | Symbol
    FlattenArgs.flatten_args(:foo, nil, bar: true, baz: false).should eq [:foo, :bar] of String | Symbol
    FlattenArgs.flatten_args(:foo, [:bar, nil, "baz"], { boom: true, booze: false }).should eq [:foo, :bar, "baz", :boom] of String | Symbol
    FlattenArgs.flatten_args([:foo, [[[ { :bar => true, nil => true, ["baz", { "BOOZE" => false }] => true, "BAZ" => false } ], :boom]]]).should eq [:foo, :bar, "baz", :boom] of String | Symbol
  end
end
