# frozen_string_literal: true

require "spec_helper"

RSpec.describe "General usage" do
  it "should include the library" do
    expect(Usagewatch).to be_a(Module)
  end

  describe "uw_diskused" do
    subject { RubyStatsPsm.uw_diskused }

    it "should be the GB of disk used" do
      expect(subject).to be_a(Integer)
      expect(subject).to be > 0
    end
  end

  describe "uw_diskavailable" do
    subject { RubyStatsPsm.uw_diskavailable }

    it "should be the GB of disk available" do
      expect(subject).to be_a(Float)
      expect(subject).to be > 0
    end
  end

  describe "uw_cpuused" do
    subject { RubyStatsPsm.uw_cpuused }

    it "should be the percentage of cpu used" do
      expect(subject).to be_a(Float)
      expect(subject).to be > 0
    end
  end

  describe "uw_diskused_perc" do
    subject { RubyStatsPsm.uw_diskused_perc }

    it "should be the percentage of GB of disk used" do
      expect(subject).to be_a(Integer)
      expect(subject).to be_between(0, 100)
    end
  end

  describe "uw_load" do
    subject { RubyStatsPsm.uw_load }

    it "should be the average load of the past minute" do
      expect(subject).to be_a(Float)
      expect(subject).to be_between(0, 4)
    end
  end

  describe "uw_cputop" do
    subject { RubyStatsPsm.uw_cputop }

    it "should be the average load of the past minute" do
      expect(subject).to be_a(Array)
      expect(subject[0][0]).to be_a(String)
      expect(subject[0][1]).to be_a(String)
      expect(subject.size).to eq(10)
    end
  end

  describe "uw_cputop" do
    subject { RubyStatsPsm.uw_memtop }

    it "should be an array of top mem consumption processes " do
      expect(subject).to be_a(Array)
      expect(subject[0][0]).to be_a(String)
      expect(subject[0][1]).to be_a(String)
      expect(subject.size).to eq(10)
    end
  end

  describe "uw_httpconns" do
    subject { RubyStatsPsm.uw_httpconns }

    it "should be the number of current apache connections" do
      expect(subject).to be_a(Integer)
      expect(subject).to be >= 0
    end
  end

  describe "uw_tcpused" do
    subject { RubyStatsPsm.uw_tcpused }

    it "should TCP Connections Used" do
      expect(subject).to be_a(Integer)
      expect(subject).to be >= 0
    end
  end

  describe "uw_udpused" do
    subject { RubyStatsPsm.uw_udpused }

    it "should UDP Connections Used" do
      expect(subject).to be_a(Integer)
      expect(subject).to be >= 0
    end
  end

  describe "uw_bandrx" do
    subject { RubyStatsPsm.uw_bandrx }

    it "should be current received" do
      expect(subject).to be_a(Float)
      expect(subject).to be >= 0
    end
  end

  describe "uw_bandtx" do
    subject { RubyStatsPsm.uw_bandtx }

    it "should be current sent" do
      expect(subject).to be_a(Float)
      expect(subject).to be >= 0
    end
  end
end
