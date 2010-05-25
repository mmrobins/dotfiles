require 'rubygems'
require 'active_support'
require 'what_methods'
require 'pp'
require 'irb/completion'
#http://icametogetdown.com/post/248931168/irb-console-not-saving-in-ruby-1-8-7
require 'irb/ext/save-history'
ARGV.concat [ "--readline", "--prompt-mode", "simple" ]
IRB.conf[:AUTO_INDENT]=true
IRB.conf[:SAVE_HISTORY] = 10000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"
IRB.conf[:EVAL_HISTORY] = 200
