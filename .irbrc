require 'rubygems'
require 'activesupport'
require 'what_methods'
require 'pp'
IRB.conf[:AUTO_INDENT]=true
require 'irb/completion'
require 'irb/ext/save-history'
ARGV.concat [ "--readline", "--prompt-mode", "simple" ]
IRB.conf[:SAVE_HISTORY] = 10000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"
