require "../spec_helper"

module HtmlClasses
  describe Registry do
    it "#register returns a new registry" do
      registry = Registry.new
      registry.register(:foo, "bar").should_not eq registry
      registry[:foo].should eq ""
    end

    it "#register! mutates the registry" do
      registry = Registry.new
      registry.register!(:foo, "bar")
      registry[:foo].should eq "bar"
    end

    it "can #register and retrieve with #[]" do
      registry = HTMLClasses::Registry.new
      registry = registry.register :button, "rounded border"
      registry = registry.register [:button, :disabled], "bg-gray"
      registry = registry.register HTMLClasses::Key[:button, :large], "text-lg"

      registry2 = registry.register :button, "square", :replace

      registry[:button].should eq "rounded border"
      registry[:button, :success].should eq "rounded border"
      registry[:button, :disabled].should eq "rounded border bg-gray"
      registry[:button, :large].should eq "rounded border text-lg"
      registry[:button, :disabled, :large].should eq "rounded border bg-gray text-lg"

      registry2[:button, :disabled, :large].should eq "square bg-gray text-lg"
    end

    it "can be initialized with a hash" do
      registry = Registry.new({:button           => "rounded border",
                               [:button, :large] => "text-lg"})

      registry[:button].should eq "rounded border"
      registry[:button, :large].should eq "rounded border text-lg"
    end

    it "can register another registry to combine registries" do
      registry = Registry.new({:button           => "rounded border",
                               [:button, :large] => "text-lg"})

      registry2 = Registry.new({:button              => "square",
                                [:button, :disabled] => "bg-gray"})

      registry3 = registry.register registry2

      registry3[:button].should eq "rounded border square"
      registry3[:button, :large].should eq "rounded border square text-lg"
      registry3[:button, :disabled].should eq "rounded border square bg-gray"
      registry3[:button, :disabled, :large].should eq "rounded border square bg-gray text-lg"
    end

    it "can register hash to register many at once" do
      registry = Registry.new({:button           => "rounded border",
                               [:button, :large] => "text-lg"})

      registry2 = registry.register({:button              => "square",
                                     [:button, :disabled] => "bg-gray"})

      registry2[:button].should eq "rounded border square"
      registry2[:button, :large].should eq "rounded border square text-lg"
      registry2[:button, :disabled].should eq "rounded border square bg-gray"
      registry2[:button, :disabled, :large].should eq "rounded border square bg-gray text-lg"
    end
  end
end
