require "./spec_helper"
require "../src/html_class/tailwind"

class MyView
  include HTMLClass::Tailwind

  html_class :h1, "text-xl"
  html_class :button, "rounded p-3 bg-gray-50 border-black text-black"
  html_class :success, "bg-green-50 border-green-900 text-green-900"
end

class SubView < MyView
  html_class :h1, "font-bold", :merge   # default is :merge
  html_class :button, "", :replace      # but you can also :replace
end

class LargeView
  include HTMLClass::Tailwind

  # import from another view
  html_class MyView.html_class_dictionary
  html_class :h1, "text-2xl"
  html_class :button, "p-5 text-lg"
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
  end

  it "LargeView example" do
    large_view = LargeView.new
    large_view.html_class(:h1).should eq "text-2xl"
    large_view.html_class(:button).should eq "rounded bg-gray-50 border-black text-black p-5 text-lg"
  end
end
