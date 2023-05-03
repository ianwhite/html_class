require "../spec_helper"
require "html_class_merge/tailwind"

module HTMLClasses
  describe "Registry with Tailwind merge strategy" do
    it "uses Tailwind to merge classes" do
      registry = Registry.new(merge_strategy: HTMLClassMerge::Tailwind)

      registry.register! :button, "rounded bg-blue-500 text-white hover:bg-blue-600"
      registry.register! [:button, :disabled], "opacity-50 cursor-not-allowed"
      registry.register! [:button, :danger], "bg-red-500 hover:bg-red-600"
      registry.register! [:button, :success], "bg-green-200 hover:bg-green-300 text-green-800 hover:text-green-900"
      registry.register! [:button, :danger, :disabled], "opacity-40"

      registry[:button].should eq "rounded bg-blue-500 text-white hover:bg-blue-600"
      registry[:button, disabled: true].should eq "rounded bg-blue-500 text-white hover:bg-blue-600 opacity-50 cursor-not-allowed"
      registry[:button, :danger].should eq "rounded text-white bg-red-500 hover:bg-red-600"
      registry[:button, :disabled, :danger].should eq "rounded text-white cursor-not-allowed bg-red-500 hover:bg-red-600 opacity-40"
      registry[:button, :disabled, :success].should eq "rounded opacity-50 cursor-not-allowed bg-green-200 hover:bg-green-300 text-green-800 hover:text-green-900"
    end
  end
end
