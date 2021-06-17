# frozen_string_literal: true

require "rspec"
require "spec_helper"

describe "Version" do
  xit "should be the version number" do
    a = RubyStatsPsm::VERSION
    a.class.should be(String)
    a.should_not be_nil
  end
end

describe "OSVersion" do
  xit "should be the OS version" do
    a = RubyStatsPsm::OS
    a.class.should be(String)
    a.should_not be_nil
  end
end

if OS.include? "linux"
  describe "Version" do
    xit "should be the version number of usagewatch" do
      a = Usagewatch::VERSION
      a.class.should be(String)
      a.should_not be_nil
    end
  end
end
