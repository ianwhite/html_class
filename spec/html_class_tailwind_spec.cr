require "./spec_helper"
require "../src/html_class/tailwind"

module HTMLClass
  class TestTailwindIncludeHTMLClass
    include HTMLClass::Tailwind

    html_class :button, "rounded bg-blue-500 text-white hover:bg-blue-600"
    html_class [:disabled], "opacity-50"
    html_class [:button, :disabled], "cursor-not-allowed"
    html_class :danger, "bg-red-500 hover:bg-red-600"
    html_class :success, "bg-green-200 hover:bg-green-300 text-green-800 hover:text-green-900"
    html_class [:button, :danger, :disabled], "opacity-40"
  end

  class TestIncludeHTMLClassSubclass < TestTailwindIncludeHTMLClass
    html_class :big_button, :button
    html_class :big_button, "text-2xl rounded-lg"
  end

  describe "with Tailwind merge strategy" do
    it "uses Tailwind to merge classes" do
      obj = TestTailwindIncludeHTMLClass.new

      obj.html_class(:button).should eq "rounded bg-blue-500 text-white hover:bg-blue-600"
      obj.html_class(:button, disabled: true).should eq "rounded bg-blue-500 text-white hover:bg-blue-600 opacity-50 cursor-not-allowed"
      obj.html_class(:button, :danger).should eq "rounded text-white bg-red-500 hover:bg-red-600"
      obj.html_class(:button, {danger: true, success: false}, disabled: true).should eq "rounded text-white bg-red-500 hover:bg-red-600 cursor-not-allowed opacity-40"
      obj.html_class(:button, :disabled, :success, "rounded-none").should eq "opacity-50 cursor-not-allowed bg-green-200 hover:bg-green-300 text-green-800 hover:text-green-900 rounded-none"
    end

    it "merges array arguments correctly" do
      obj = TestTailwindIncludeHTMLClass.new
      obj.html_class(["text-2xl text-sm", ["text-3xl"], { "text-4xl" => true }]).should eq "text-4xl"
      obj.html_class([:button, :disabled]).should eq "rounded bg-blue-500 text-white hover:bg-blue-600 opacity-50 cursor-not-allowed"
    end
  end

  describe "testing inheritance" do
    it "inherits the merge strategy" do
      obj = TestIncludeHTMLClassSubclass.new
      obj.class.html_class_merge.object_id.should eq HTMLClassMerge::Tailwind.object_id
    end

    it "allows inheriting keys piecemeal, and augmenting" do
      obj = TestIncludeHTMLClassSubclass.new
      obj.html_class(:big_button).should eq "bg-blue-500 text-white hover:bg-blue-600 text-2xl rounded-lg"
    end
  end
end
