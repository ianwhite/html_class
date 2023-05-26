require "./spec_helper"
require "../src/html_class/tailwind"

class MyView
  include HTMLClass::Tailwind

  html_class :h1, "text-xl"
  html_class :button, "rounded p-3 bg-gray-50 border-black text-black"
  html_class :success, "bg-green-50 border-green-900 text-green-900"
end

class SubView < MyView
  html_class :tiny_button, :button                  # you can copy a definition by name
  html_class :tiny_button, "rounded-sm text-xs p-1" # and :merge new html classes

  html_class :h1, "font-bold", :merge   # the default collision strategy is :merge
  html_class :button, "", :replace      # but you can also :replace
end

class LargeView
  include HTMLClass::Tailwind

  html_class MyView.html_class_dictionary # import from another view
  html_class :h1, "text-2xl"
  html_class :button, "p-5 text-lg"
end

class SubLargeView < LargeView
  # testing that the dictionary is inherited, and that the dictionary is not copied
  # also testing overriding the merge strategy
  self.html_class_merge = HTMLClass::JoinMerge.new
end

class SubSubLargeView < SubLargeView
  # testing inheritance of merge strategy
end

describe "README examples" do
  it "MyView example" do
    view = MyView.new
    view.html_class(:h1).should eq "text-xl"
    view.html_class(:button).should eq "rounded p-3 bg-gray-50 border-black text-black"
    view.html_class(:button, "rounded-none").should eq "p-3 bg-gray-50 border-black text-black rounded-none"
    view.html_class(:button, :success).should eq "rounded p-3 bg-green-50 border-green-900 text-green-900"
  end

  it "SubView example" do
    sub_view = SubView.new
    sub_view.html_class(:success).should eq "bg-green-50 border-green-900 text-green-900"
    sub_view.html_class(:h1).should eq "text-xl font-bold"
    sub_view.html_class(:button).should eq ""
    sub_view.html_class(:tiny_button).should eq "bg-gray-50 border-black text-black rounded-sm text-xs p-1"
  end

  it "LargeView example" do
    large_view = LargeView.new
    large_view.html_class(:h1).should eq "text-2xl"
    large_view.html_class(:button).should eq "rounded bg-gray-50 border-black text-black p-5 text-lg"
  end

  it "testing inheritance" do
    MyView.html_class_dictionary.object_id.should_not eq SubView.html_class_dictionary.object_id
    MyView.html_class_merge.object_id.should eq HTMLClassMerge::Tailwind.object_id

    LargeView.html_class_dictionary.object_id.should eq SubLargeView.html_class_dictionary.object_id
    LargeView.html_class_merge.object_id.should eq HTMLClassMerge::Tailwind.object_id

    SubLargeView.html_class_merge.should be_a HTMLClass::JoinMerge

    SubSubLargeView.html_class_merge.object_id.should eq SubLargeView.html_class_merge.object_id
  end
end
