require "../spec_helper"

module HtmlClasses
  describe Key do
    it "can be a single name" do
      Key.new(:foo).should eq Key[:foo]
    end

    it "can be a single name, with variants" do
      Key.new(:foo, :large, :red).should eq Key.new(:foo, Set{:large, :red})
    end

    it "variant order does not matter for equality" do
      Key[:foo, :large, :red].should eq Key[:foo, :red, :large]
    end

    it "can have variants optionally added via keyword arguments" do
      Key[:button, danger: true, disabled: false].should eq Key[:button, :danger]
      Key.new(:button, danger: false, disabled: true).should eq Key[:button, :disabled]
    end

    it "#combinations returns array of all combinations from least to most specific" do
      Key[:foo, :large, :red].combinations.should eq [
        Key[:foo],
        Key[:foo, :large],
        Key[:foo, :red],
        Key[:foo, :large, :red],
      ]
    end

    it "#inspect returns a self-similar string representation" do
      Key[:foo].inspect.should eq "HtmlClasses::Key[:foo]"
      Key[:foo, :large, :red].inspect.should eq "HtmlClasses::Key[:foo, :large, :red]"
    end
  end
end
