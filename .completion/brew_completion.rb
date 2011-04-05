#!/usr/bin/env ruby

args = ENV["COMP_LINE"].split /\s+/

# "brew"
args.shift

subcommand = args.shift || ''
arg = args.last || ''

case subcommand
when *%w{audit deps edit home info install log opts uses}
  choices = `brew search`.split("\n")
  search_pattern = arg
when *%w{--cache --prefix cleanup link uninstall unlink}
  choices = `brew list`.split("\n")
  search_pattern = arg
when *%w{--config --version create doctor missing outdated prune search update}
else
  choices = %w{--cache --config --prefix --version audit cleanup create deps doctor edit home info install link log missing opts outdated prune search uninstall unlink update uses}
  search_pattern = subcommand
end

puts `compgen -W '#{choices.join(" ")}' -- '#{search_pattern}'` if search_pattern

exit 0
