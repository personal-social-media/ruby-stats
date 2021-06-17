# frozen_string_literal: true

require "singleton"
require_relative "./rubystats_psm/version"

class RubyStatsPsm
  include Singleton
  text = "OS is not supported in this version."

  if OS.include? "linux"
    require "usagewatch/linux"
    require_relative "./rubystats_psm/linux"
    require_relative "./rubystats_psm/skcript_linux"
  elsif OS.match?(/cygwin|mswin|mingw|bccwin|wince|emx/)
    puts "Windows" + text
  elsif Os.include? "darwin"
    puts "Darwin" + text
  else
    puts "This" + text
  end

  private def method_missing(symbol, *args)
    if Usagewatch.respond_to?(symbol)
      Usagewatch.send(symbol, *args)
    end
    super
  end

  def execute_command(cmd)
    `#{cmd}`
  end

  class << self
    private def method_missing(symbol, *args)
      instance.send(symbol, *args)
    end
  end
end
