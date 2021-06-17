# frozen_string_literal: true

class RubyStatsPsm
  def uw_httpconns
    execute_command("netstat -an | grep :80 |wc -l").to_i
  end
end
