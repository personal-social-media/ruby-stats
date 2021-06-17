# frozen_string_literal: true

class RubyStatsPsm
  # Show the amount of total disk used in Gigabytes
  def uw_diskused
    df = execute_command("df")
    parts = df.split(" ").map { |s| s.to_i }
    sum = 0
    (9..parts.size - 1).step(6).each { |i|
      sum += parts[i]
    }
    round = sum.round(2)
    ((round / 1024) / 1024).round(2)
  end

  def uw_diskavailable
    df = execute_command("df -kl")
    sum = 0.00
    df.each_line.with_index do |line, line_index|
      next if line_index.eql? 0
      line = line.split(" ")
      next if /localhost/.match?(line[0])  # ignore backup filesystem
      sum += ((line[3].to_f) / 1024) / 1024
    end
    sum.round(2)
  end

  def uw_diskused_perc
    execute_command("df --output=pcent / | tr -dc '0-9'").to_i
  end

  def uw_cpuused
    execute_command("grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage }'").to_f
  end

  def self.uw_cputop
    ps = `ps aux | awk '{print $11, $3}' | sort -k2nr  | head -n 10`
    array = []
    ps.each_line do |line|
      line = line.chomp.split(" ")
      array << [line.first.gsub(/[\[\]]/, ""), line.last]
    end
    array
  end

  # Show the number of TCP connections used
  def self.uw_tcpused
    if File.exist?("/proc/net/sockstat")
      File.open("/proc/net/sockstat", "r") do |ipv4|
        @sockstat = ipv4.read
      end

      @tcp4data = @sockstat.split
      @tcp4count = @tcp4data[5]
    end

    if  File.exist?("/proc/net/sockstat6")
      File.open("/proc/net/sockstat6", "r") do |ipv6|
        @sockstat6 = ipv6.read
      end

      @tcp6data = @sockstat6.split
      @tcp6count = @tcp6data[2]
    end

    @totaltcpused = @tcp4count.to_i + @tcp6count.to_i
  end

  # Show the number of UDP connections used
  def self.uw_udpused
    if File.exist?("/proc/net/sockstat")
      File.open("/proc/net/sockstat", "r") do |ipv4|
        @sockstat = ipv4.read
      end

      @udp4data = @sockstat.split
      @udp4count = @udp4data[16]
    end

    if File.exist?("/proc/net/sockstat6")
      File.open("/proc/net/sockstat6", "r") do |ipv6|
        @sockstat6 = ipv6.read
      end

      @udp6data = @sockstat6.split
      @udp6count = @udp6data[5]
    end

    @totaludpused = @udp4count.to_i + @udp6count.to_i
  end

  # Show the percentage of Active Memory used
  def self.uw_memused
    if File.exist?("/proc/meminfo")
      File.open("/proc/meminfo", "r") do |file|
        @result = file.read
      end
    end

    @memstat = @result.split("\n").collect { |x| x.strip }
    @memtotal = @memstat[0].gsub(/[^0-9]/, "")
    @memactive = @memstat[5].gsub(/[^0-9]/, "")
    @memactivecalc = (@memactive.to_f * 100) / @memtotal.to_f
    @memusagepercentage = @memactivecalc.round
  end

  # return hash of top ten proccesses by mem consumption
  # example [["apache2", 12.0], ["passenger", 13.2]]
  def self.uw_memtop
    ps = execute_command("ps aux | awk '{print $11, $4}' | sort -k2nr  | head -n 10")
    array = []
    ps.each_line do |line|
      line = line.chomp.split(" ")
      array << [line.first.gsub(/[\[\]]/, ""), line.last]
    end
    array
  end

  # Show the average system load of the past minute
  def self.uw_load
    if File.exist?("/proc/loadavg")
      File.open("/proc/loadavg", "r") do |file|
        @loaddata = file.read
      end

      @load = @loaddata.split(/ /).first.to_f
    end
  end

  # Bandwidth Received Method
  def self.bandrx
    if File.exist?("/proc/net/dev")
      File.open("/proc/net/dev", "r") do |file|
        @result = file.read
      end
    end

    @arrRows = @result.split("\n")

    @arrEthLoRows = @arrRows.grep(/eth|lo/)

    rowcount = (@arrEthLoRows.count - 1)

    for i in (0..rowcount)
      @arrEthLoRows[i] = @arrEthLoRows[i].gsub(/\s+/m, " ").strip.split(" ")
    end

    @arrColumns = Array.new
    for l in (0..rowcount)
      @temp = Array.new
      @temp[0] = @arrEthLoRows[l][1]
      @temp[1] = @arrEthLoRows[l][9]
      @arrColumns << @temp
    end

    columncount = (@arrColumns[0].count - 1)

    @arrTotal = Array.new
    for p in (0..columncount)
      @arrTotal[p] = 0
    end

    for j in (0..columncount)
      for k in (0..rowcount)
        @arrTotal[j] = @arrColumns[k][j].to_i + @arrTotal[j]
      end
    end

    @bandrxtx = @arrTotal
  end

  # Current Bandwidth Received Calculation in Mbit/s
  def self.uw_bandrx
    @new0 = self.bandrx
    sleep 1
    @new1 = self.bandrx

    @bytesreceived = @new1[0].to_i - @new0[0].to_i
    @bitsreceived = (@bytesreceived * 8)
    @megabitsreceived = (@bitsreceived.to_f / 1024 / 1024).round(3)
  end

  # Bandwidth Transmitted Method
  def self.bandtx
    if File.exist?("/proc/net/dev")
      File.open("/proc/net/dev", "r") do |file|
        @result = file.read
      end
    end

    @arrRows = @result.split("\n")

    @arrEthLoRows = @arrRows.grep(/eth|lo/)

    rowcount = (@arrEthLoRows.count - 1)

    for i in (0..rowcount)
      @arrEthLoRows[i] = @arrEthLoRows[i].gsub(/\s+/m, " ").strip.split(" ")
    end

    @arrColumns = Array.new
    for l in (0..rowcount)
      @temp = Array.new
      @temp[0] = @arrEthLoRows[l][1]
      @temp[1] = @arrEthLoRows[l][9]
      @arrColumns << @temp
    end

    columncount = (@arrColumns[0].count - 1)

    @arrTotal = Array.new
    for p in (0..columncount)
      @arrTotal[p] = 0
    end

    for j in (0..columncount)
      for k in (0..rowcount)
        @arrTotal[j] = @arrColumns[k][j].to_i + @arrTotal[j]
      end
    end

    @bandrxtx = @arrTotal
  end

  # Current Bandwidth Transmitted in Mbit/s
  def self.uw_bandtx
    @new0 = self.bandtx
    sleep 1
    @new1 = self.bandtx

    @bytestransmitted = @new1[1].to_i - @new0[1].to_i
    @bitstransmitted = (@bytestransmitted * 8)
    @megabitstransmitted = (@bitstransmitted.to_f / 1024 / 1024).round(3)
  end

  # Disk Usage Method
  def self.diskio
    if File.exist?("/proc/diskstats")
      File.open("/proc/diskstats", "r") do |file|
        @result = file.read
      end
    end

    @arrRows = @result.split("\n")

    rowcount = (@arrRows.count - 1)

    for i in (0..rowcount)
      @arrRows[i] = @arrRows[i].gsub(/\s+/m, " ").strip.split(" ")
    end

    @arrColumns = Array.new
    for l in (0..rowcount)
      @temp = Array.new
      @temp[0] = @arrRows[l][3]
      @temp[1] = @arrRows[l][7]
      @arrColumns << @temp
    end

    columncount = (@arrColumns[0].count - 1)

    @arrTotal = Array.new
    for p in (0..columncount)
      @arrTotal[p] = 0
    end

    for j in (0..columncount)
      for k in (0..rowcount)
        @arrTotal[j] = @arrColumns[k][j].to_i + @arrTotal[j]
      end
    end

    @diskiorw = @arrTotal
  end

  # Current Disk Reads Completed
  def self.uw_diskioreads
    @new0 = self.diskio
    sleep 1
    @new1 = self.diskio

    @diskreads = @new1[0].to_i - @new0[0].to_i
  end

  # Current Disk Writes Completed
  def self.uw_diskiowrites
    @new0 = self.diskio
    sleep 1
    @new1 = self.diskio

    @diskwrites = @new1[1].to_i - @new0[1].to_i
  end
end
