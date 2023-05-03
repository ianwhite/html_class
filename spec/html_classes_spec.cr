require "./spec_helper"
require "yaml"

describe HTMLClasses do
  it "version should match shard.yml" do
    yaml = File.open("shard.yml") do |file|
      YAML.parse(file)
    end

    HTMLClasses::VERSION.should eq yaml["version"]
  end

  it "settings.merge_strategy defaults to a JoinMerge" do
    HTMLClasses.settings.merge_strategy.should be_a HTMLClasses::JoinMerge
  end
end
