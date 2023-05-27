require "./spec_helper"

require "yaml"

module HTMLClass
  class TestIncludeHTMLClass
    include HTMLClass

    html_class :success, "text-green"
    html_class :failure, "text-red"
    html_class :card, "border rounded p-5"
    html_class %i[card failure], "border-red"
    html_class %i[card success], "border-green"
    html_class :big, "text-2xl"
  end

  describe HTMLClass do
    it "version should match shard.yml" do
      yaml = File.open("shard.yml") do |file|
        YAML.parse(file)
      end

      HTMLClass::VERSION.should eq yaml["version"]
    end

    it ".default_merge defaults to a JoinMerge" do
      HTMLClass.default_merge.should be_a HTMLClass::JoinMerge
    end

    describe TestIncludeHTMLClass do
      it "html_class(String | Enumerable(String)) merges using default merge strategy" do
        TestIncludeHTMLClass.new.html_class("foo", "bar").should eq "foo bar"
        TestIncludeHTMLClass.new.html_class("foo bar", ["baz"]).should eq "foo bar baz"
      end

      it "html_class(Hash(String, Bool)) merges keys whose values are true" do
        TestIncludeHTMLClass.new.html_class({"foo bar" => true, "baz" => false, ["biz"] => true}).should eq "foo bar biz"
      end

      it "html_class(String, Hash(String, Bool), Hash(String, Bool), Array(String)) merges as expected" do
        TestIncludeHTMLClass.new.html_class("foo", {"bar" => true}, {"baz" => false}, ["biz"]).should eq "foo bar biz"
      end

      it "html_class(Symbol | String) looks up classes in the dictionary" do
        obj = TestIncludeHTMLClass.new
        obj.html_class(:success).should eq "text-green"
        obj.html_class(:card, "big").should eq "border rounded p-5 big"
        obj.html_class(:success, :card).should eq "text-green border rounded p-5 border-green"
      end

      it "html_class(**kwargs : Bool) or (NamedTuple) merges keys whose value are true" do
        obj = TestIncludeHTMLClass.new
        obj.html_class(:card, success: false, failure: false).should eq "border rounded p-5"
        obj.html_class(:card, success: true, failure: false).should eq "border rounded p-5 text-green border-green"
        obj.html_class(:card, {success: false, failure: true}).should eq "border rounded p-5 text-red border-red"
      end

      it "html_class(Symbol, Hash(String, Bool), Hash(Symbol, Bool), NamedTuple, Array(String|Symbol), **kwargs) merges as expected" do
        obj = TestIncludeHTMLClass.new
        obj.html_class(:card, {"bg-gray" => true}, {success: false}, ["biz", :failure], big: true).should eq "border rounded p-5 bg-gray biz text-red border-red text-2xl"
      end

      it "html_class( Array of HTMLClass::Arg )" do
        obj = TestIncludeHTMLClass.new
        args = [:card, ["foo"], [:card, ["foo"], {success: true, failure: false}]]
        obj.html_class(args).should eq "border rounded p-5 foo border rounded p-5 foo text-green border-green border-green border-green"

        args = [[{ card: true }, ["a", ["b", "c", [{ ["d", [["e"]]] => true, "g" => false }]]]]]
        obj.html_class(args).should eq "border rounded p-5 a b c d e"
      end

      it "html_class ignores nil" do
        obj = TestIncludeHTMLClass.new
        obj.html_class(nil).should eq ""
        obj.html_class(["a", nil], { nil => true}, [[["b", nil]]]).should eq "a b"
      end
    end
  end
end
