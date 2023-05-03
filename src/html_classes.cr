require "habitat"
require "html_class_merge/merge"
require "html_class_merge/tokenize"

module HTMLClasses
  VERSION = "0.2.0"

  alias Tokenize = HTMLClassMerge::Tokenize
  alias Tokenizable = HTMLClassMerge::Tokenizable
  alias MergeStrategy = HTMLClassMerge::Merge

  # What to do when a class is registered with a name that already exists
  enum OnCollision
    Replace
    Merge
  end
end

require "./html_classes/join_merge"
require "./html_classes/registry"

module HTMLClasses
  Habitat.create do
    setting merge_strategy : MergeStrategy = JoinMerge.new
  end
end
