require "./spec_helper"
require "yaml"

describe HtmlClasses do
  it "version should match shard.yml" do
    yaml = File.open("shard.yml") do |file|
      YAML.parse(file)
    end

    HtmlClasses::VERSION.should eq yaml["version"]
  end

  it "settings.merge_strategy defaults to a JoinMerge" do
    HtmlClasses.settings.merge_strategy.should be_a HtmlClasses::JoinMerge
  end
end
