require "./spec_helper"

def new_test_scanner
  dictionary = HTMLClass::Dictionary.new({
    :foo => "foo",
    :bar => "bar",
    Set{:foo, :bar} => "foo-bar",
    :baz => "baz",
    Set{:foo, :baz} => "foo-baz",
    Set{:bar, :baz} => "bar-baz",
    Set{:foo, :bar, :baz} => "foo-bar-baz"
  })

  merge = HTMLClass::JoinMerge.new

  HTMLClass::Scanner.new(dictionary, merge)
end

module HTMLClass
  describe "Scanner#scan" do
    it "should return the correct class for a single dictionary key" do
      new_test_scanner.scan(:foo).to_s.should eq "foo"
      new_test_scanner.scan(:bar).to_s.should eq "bar"
      new_test_scanner.scan(:baz).to_s.should eq "baz"
    end

    it "when scanning multiple dictionary keys, results for combination keys are emitted only once, and at the point where the combintaion is first seen" do
      new_test_scanner.scan(:foo, :bar).to_s.should eq "foo bar foo-bar"
      new_test_scanner.scan(:bar, :foo).to_s.should eq "bar foo foo-bar"
      new_test_scanner.scan(:foo, :bar, :baz).to_s.should eq "foo bar foo-bar baz foo-baz bar-baz foo-bar-baz"
      new_test_scanner.scan(:baz, :foo, :baz).to_s.should eq "baz foo foo-baz baz"
      new_test_scanner.scan(:bar, :baz, "HELLO", :foo).to_s.should eq "bar baz bar-baz HELLO foo foo-bar foo-baz foo-bar-baz"
      new_test_scanner.scan([:bar], { baz: true }, { "HELLO" => true, :foo => true }).to_s.should eq "bar baz bar-baz HELLO foo foo-bar foo-baz foo-bar-baz"
    end
  end
end
