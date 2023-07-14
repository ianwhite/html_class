require "./spec_helper"

def test_substitute_dictionary
  HTMLClass::Dictionary.new({
    :foo => "foo",
    :bar => "bar",
    Set{:foo, :bar} => "foo-bar",
    :baz => "baz",
    Set{:foo, :baz} => "foo-baz",
    Set{:bar, :baz} => "bar-baz",
    Set{:foo, :bar, :baz} => "foo-bar-baz"
  })
end

module HTMLClass
  describe "Substitute#substitute" do
    it "should return the correct token for a single dictionary key" do
      Substitute.substitute([:foo], test_substitute_dictionary).should eq ["foo"]
      Substitute.substitute([:bar], test_substitute_dictionary).should eq ["bar"]
      Substitute.substitute([:baz], test_substitute_dictionary).should eq ["baz"]
    end

    it "when scanning multiple dictionary keys, results for combination keys are emitted only once, and at the point where the combintaion is first seen" do
      Substitute.substitute([:foo, :bar], test_substitute_dictionary).should eq %w[foo bar foo-bar]
      Substitute.substitute([:bar, :foo], test_substitute_dictionary).should eq %w[bar foo foo-bar]
      Substitute.substitute([:foo, :bar, :baz], test_substitute_dictionary).should eq %w[foo bar foo-bar baz foo-baz bar-baz foo-bar-baz]
      Substitute.substitute([:baz, :foo, :baz], test_substitute_dictionary).should eq %w[baz foo foo-baz baz]
      Substitute.substitute([:bar, :baz, "HELLO", :foo], test_substitute_dictionary).should eq %w[bar baz bar-baz HELLO foo foo-bar foo-baz foo-bar-baz]
    end
  end
end
