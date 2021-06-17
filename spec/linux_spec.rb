# frozen_string_literal: true

require "rspec"
require "spec_helper"

if OS.include? "linux"
  describe "TCPConnectios" do
    xit "should TCP Connections Used" do
      a = Usagewatch.uw_tcpused
      a.class.should be Fixnum
      a.should_not be_nil
      a.should be >= 0
    end
  end

  describe "UDPConections" do
    xit "should UDP Connections Used " do
      a = Usagewatch.uw_udpused
      a.class.should be Fixnum
      a.should_not be_nil
      a.should be >= 0
    end
  end

  describe "DiskREADS" do
    xit "should be current disk reads  " do
      a = Usagewatch.uw_diskioreads
      a.class.should be Fixnum
      a.should_not be_nil
      a.should be >= 0
    end
  end

  describe "DiskWrites" do
    xit "should be current disk writes  " do
      a = Usagewatch.uw_diskiowrites
      a.class.should be Fixnum
      a.should_not be_nil
      a.should be >= 0
    end
  end

  describe "Bandwidth" do
    xit "should be current received  " do
      a = Usagewatch.uw_bandrx
      a.class.should be Float
      a.should_not be_nil
      a.should be >= 0
    end
  end

  describe "Bandwidth" do
    xit "should be current received  " do
      a = Usagewatch.uw_bandtx
      a.class.should be Float
      a.should_not be_nil
      a.should be >= 0
    end
  end
end
