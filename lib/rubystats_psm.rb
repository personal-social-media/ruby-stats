# frozen_string_literal: true

require_relative "./rubystats_psm/version"

class RubyStatsPsm
  text = "OS is not supported in this version."

  if OS.include? "darwin"
    require "usagewatch_ext/mac"
    # puts "Mac version is under development"
  elsif OS.include? "linux"
    require "usagewatch/linux"
    require_relative "./rubystats_psm/linux"
    require_relative "./rubystats_psm/skcript_linux"
  elsif OS.match?(/cygwin|mswin|mingw|bccwin|wince|emx/)
    puts "Windows" + text
  else
    puts "This" + text
  end
end
