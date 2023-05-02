require "../spec_helper"

module HtmlClasses
  describe JoinMerge do
    it "implements the merge protocol by joining all the tokens" do
      JoinMerge.new.merge(["a", "b", "c"], "a", "   b    c", [] of String).should eq "a b c a b c"
    end
  end
end
