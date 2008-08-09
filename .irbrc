  HISTFILE = "~/.irb.hist"
  MAXHISTSIZE = 100
   
  begin
    if defined? Readline::HISTORY
      histfile = File::expand_path( HISTFILE )
      if File::exists?( histfile )
        lines = IO::readlines( histfile ).collect {|line| line.chomp}
        puts "Read %d saved history commands from %s." %
          [ lines.nitems, histfile ] if $DEBUG || $VERBOSE
        Readline::HISTORY.push( *lines )
      else
        puts "History file '%s' was empty or non-existant." %
          histfile if $DEBUG || $VERBOSE
      end
  
      Kernel::at_exit {
        lines = Readline::HISTORY.to_a.reverse.uniq.reverse
        lines = lines[ -MAXHISTSIZE, MAXHISTSIZE ] if lines.nitems > MAXHISTSIZE
        $stderr.puts "Saving %d history lines to %s." %

          [ lines.length, histfile ] if $VERBOSE || $DEBUG
        File::open( histfile, File::WRONLY|File::CREAT|File::TRUNC ) {|ofh|
          lines.each {|line| ofh.puts line }
        }
      }
    end
  end

