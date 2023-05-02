require "habitat"
require "./html_classes/join_merge"
require "./html_classes/registry"

module HtmlClasses
  VERSION = "0.1.1"

  Habitat.create do
    setting merge_strategy : HtmlClassMerge::Merge = JoinMerge.new
  end
end

alias HTMLClasses = HtmlClasses
