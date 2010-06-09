# -*- mode: ruby; ruby-indent-level: 2 -*- vim:set ft=ruby et sw=2 sts=2 sta:

ENV['HOME'] ||= ENV['USERPROFILE']
unless IRB.conf[:LOAD_MODULES].respond_to?(:to_ary)
  IRB.conf[:LOAD_MODULES] = []
end
IRB.conf[:AUTO_INDENT]   = true
IRB.conf[:USE_READLINE]  = true
IRB.conf[:LOAD_MODULES] |= %w(irb/completion stringio enumerator)
IRB.conf[:HISTORY_FILE]  = File.expand_path('~/.irb_history.rb') rescue nil
IRB.conf[:SAVE_HISTORY]  = 50000
IRB.conf[:EVAL_HISTORY]  = 300

$LOAD_PATH.unshift(File.expand_path('~/.ruby/lib'),File.expand_path('~/.ruby'))
$LOAD_PATH.uniq!

def desire(lib)
  require lib
  true
rescue LoadError
  false
end

desire 'rubygems'
desire 'ap'
desire 'drx'

def IRB.rails_root
  conf[:LOAD_MODULES].to_ary.include?('console_app') &&
    conf[:LOAD_MODULES].
    detect {|x| break $1 if x =~ %r{(.*)/config/environment$}}
end

if IRB.rails_root
  # Rails
  IRB.conf[:HISTORY_FILE] = File.join(IRB.rails_root,'tmp','irb_history.rb')
  desire 'rails_ext'
else
  desire 'active_support'
end
desire File.expand_path('~/.irb_local.rb')

$KCODE = 'UTF8' if RUBY_VERSION =~ /^1\.8/ && (RUBY_PLATFORM =~ /mswin32/ || ENV['LANG'].to_s =~ /UTF/i)

# def pp(*args)
  # require 'pp'
  # PrettyPrint.send(:pp, *args)
# end

module Enumerable
  def count_by(&block)
    group_by(&block).inject({}) {|h,(k,v)| h[k] = v.size; h}
  end
end

class IRB::Irb
  def output_value
    if @context.inspect_mode.kind_of?(Symbol)
      value = @context.last_value.send(@context.inspect_mode).to_s.dup
      if value.chomp!
        value[0,0] = "\n"
      end
      printf @context.return_format, value
    elsif @context.inspect?
      printf @context.return_format, @context.last_value.inspect
    else
      printf @context.return_format, @context.last_value
    end
  end
end

class Class
  def inspect_filter(method = :inspect)
    alias_method "unfiltered_#{method}", method unless method_defined?("unfiltered_#{method}")
    define_method(method) do
      filtered_caller = caller.reject {|t| t =~ /`\w*inspect\w*'/}
      if filtered_caller.first(5).any? {|t| t =~ /\birb\.?r[bc]:\d+:in `output_value'$/}
        $caller = filtered_caller
        if ENV['TERM'] && ENV['TERM'] != 'dumb'
          return yield(send("unfiltered_#{method}"))
        end
      end
      send "unfiltered_#{method}"
    end
  end
end

if RUBY_VERSION =~ /^1\.8/
  [String, Numeric, TrueClass, FalseClass].each do |klass|
    klass.inspect_filter {|text| "\e[1;35m#{text}\e[0m"}
  end
  Array.inspect_filter do |text|
    text[0] == ?% ?  "\e[1;35m#{text}\e[0m" : text
  end
  NilClass.inspect_filter {|text| "\e[1;30m#{text}\e[0m"}
  Symbol.inspect_filter {|text| "\e[1;36m#{text}\e[0m"}
  Module.inspect_filter {|text| "\e[1;32m#{text}\e[0m"}
  Object.inspect_filter do |text|
    text.gsub(/#<([A-Z]\w*(?:::\w+)*)/,"#<\e[1;32m\\1\e[0m")
  end
end

begin
  class Gem::GemPathSearcher
    def inspect
      "#<#{self.class.inspect}:#{object_id}>"
    end
  end
rescue NameError
end

