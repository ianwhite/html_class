require "../html_class"
require "html_class_merge/tailwind"

module HTMLClass
  module Tailwind
    macro included
      include HTMLClass

      self.html_class_merge = HTMLClassMerge::Tailwind
    end
  end
end
