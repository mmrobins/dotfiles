#!/usr/local/bin/perl
############## consider trying to relax length() req in handle_via_merge (diffnum lines)
############## avoid treating new 4-line subroutine as 4 changed lines
use strict;
use warnings;

use Term::ANSIColor qw/ color /;
#use Algorithm::Diff; # for the real traverse_balanced()
    # until module installed everywhere I'll want it to be,
    # I've in-lined the releavant code (or a streamlined
    # version thereof) in a BEGIN block at end of the script.

$| = 1;

# user may override defaults by fiddling with the indicated ENV variables...
sub new_line               { $ENV{'DIFF_COLOR_NEW'}              || 'green'   }
sub old_line               { $ENV{'DIFF_COLOR_OLD'}              || 'red'     }
sub line_no                { $ENV{'DIFF_COLOR_LINE_NO'}          || 'yellow'  }
sub question_mk            { $ENV{'DIFF_COLOR_QUESTIONS'}        || 'yellow'  }
sub misc                   { $ENV{'DIFF_COLOR_MISC'}             || 'blue'    }
sub hilight                { $ENV{'DIFF_COLOR_HILIGHT'}          || 'reverse' }
sub both_ways              { $ENV{'DIFF_COLOR_BOTH_WAYS'}        || 'magenta' }
sub do_horizontal_diffing  { $ENV{'DIFF_COLOR_DO_HORIZONTAL'}    || 1         } # 0 or 1
sub max_chars_line_cleanup { $ENV{'DIFF_COLOR_MAX_LINE_CLEANUP'} || 3         } # <+int>
sub max_merged_line_noise  { $ENV{'DIFF_COLOR_MAX_MERGE_NOISE'}  || 5         } # <+int>

my( $ADDITION, $SUBTRACTION, $CONTEXT, $OTHER, @lines ) = qw/ a s c o /;
my @ASC_TYPE_CODES = ( $ADDITION, $SUBTRACTION, $CONTEXT );
process_input();
exit();

sub process_input {
    my $lines_summary;
    while (<>) {
        push @lines, processed_current_line();
        $lines_summary = join '', map { $_->{'type'} } @lines;
        if ( ! do_horizontal_diffing() ) {
            flush_all_lines();
        } elsif ( $lines_summary =~ /^[^$SUBTRACTION$ADDITION]($SUBTRACTION+)($ADDITION+)[^$SUBTRACTION$ADDITION]\z/ ) {
            handle_via_merge() || flush_all_lines_but_the_last_one();
        } elsif ( $lines_summary =~ /^[^$SUBTRACTION$ADDITION](?:$SUBTRACTION+$ADDITION*)?\z/ ) {
            # do nothing in the hopes of building up to the above mergable pattern
        } elsif ( $lines_summary =~ /[^$SUBTRACTION$ADDITION]\z/ ) {
            flush_all_lines_but_the_last_one();
        } else {
            flush_all_lines();
        }
    }
    if ( $lines_summary||'' =~ /^[^$SUBTRACTION$ADDITION]($SUBTRACTION+)($ADDITION+)\z/ ) {
        handle_via_merge() || flush_all_lines();
    } else {
        flush_all_lines();
    }
}
sub handle_via_merge {
    return unless $1;
    return unless $2;
    return unless ( length($1) == length($2) );
    flush_merged_lines();
    return 1;
}
sub flush_all_lines {
    print map { $_->{'colored_line'} } @lines;
    @lines = ();
}
sub flush_all_lines_but_the_last_one {
    my $last_line = pop @lines;
    flush_all_lines();
    @lines = $last_line;
}
sub flush_merged_lines {
    my $first_line = shift @lines;
    print $first_line->{'colored_line'} || '';
    my @last_line = (@lines && ($lines[-1]->{'type'} eq $ADDITION)) ? () : pop @lines;
    my @minus_lines = grep { $_->{'type'} eq $SUBTRACTION } @lines;
    my @plus_lines  = grep { $_->{'type'} eq $ADDITION    } @lines;
    my @unmerged_lines;
    while ( @minus_lines ) { # same count as @plus_lines in current code
        my @result_lines = merge_lines(
            shift( @minus_lines ),
            shift( @plus_lines )
        );
        if ( @result_lines > 1 ) { # failed merge
            push @unmerged_lines, @result_lines;
        } else { # merge worked
            print map { $_->{'colored_line'} } (
                ( grep { $_->{'type'} eq $SUBTRACTION } @unmerged_lines ),
                ( grep { $_->{'type'} eq $ADDITION    } @unmerged_lines ),
                ( @result_lines ),
            );
            @unmerged_lines = ();
        }
    }
    print map { $_->{'colored_line'} } (
        ( grep { $_->{'type'} eq $SUBTRACTION } @unmerged_lines ),
        ( grep { $_->{'type'} eq $ADDITION    } @unmerged_lines ),
    );
    @lines = @last_line;
}
sub merge_lines {
    my( $minus_line, $plus_line ) = @_;
    my @old = split '', $minus_line->{'original_line'};
    my @new = split '', $plus_line->{'original_line'};
    shift(@$_), pop(@$_) for \@old, \@new; # strip plus/minus mark and newline

    my @diffs;
    Algorithm::Diff::traverse_balanced( \@old, \@new, {
        MATCH     => sub {   push(  @diffs,  [$CONTEXT,     $old[ $_[0] ]]  )   },
        DISCARD_A => sub {   push(  @diffs,  [$SUBTRACTION, $old[ $_[0] ]]  )   },
        DISCARD_B => sub {   push(  @diffs,  [$ADDITION,    $new[ $_[1] ]]  )   },
        CHANGE    => sub {   push(  @diffs,  [$SUBTRACTION, $old[ $_[0] ]],
                                             [$ADDITION,    $new[ $_[1] ]]  )   },
    });
    try_to_cleanup_line_noise( \@diffs );

    my %count = counts_by_diff_type( @diffs );
    if ( $count{$CONTEXT} <= max_merged_line_noise() ) {
        return {
            'colored_line' => get_merged_diff_as_one_line( \%count, \@diffs ),
        };
    } else {
        return( $minus_line, $plus_line );
    }
}
sub counts_by_diff_type {
    return map {
        my $type = $_;
        ( $type => scalar grep {$_->[0] eq $type} @_ );
    } @ASC_TYPE_CODES;
}
sub try_to_cleanup_line_noise {
    my $diffs = shift;
    my $should_continue = 1; # first one is free
    while ( $should_continue ) {
        $should_continue = 0; # unless we find something to clean up
        my $cursor = 0;
        # print STDERR get_merged_diff_as_one_line({},$diffs,'debug' => 1);
        while ( $cursor < $#{$diffs} - 2 ) {
            my $lookahead = join '', map {$_ ? $_->[0] : ''} @{$diffs}[ $cursor .. $cursor + 3 ];
            # print STDERR "$lookahead @ $cursor = " . join( '+', map {$_->[1] } @$diffs). "\n";
            if ( $lookahead =~ m/^(.*)(.)\2/ ) {
                my $offset = $1 ? length($1) : 0;
                my( $any1, $any2 ) = @{$diffs}[ $cursor + $offset .. $cursor + $offset+1 ];
                splice( @$diffs, $cursor + $offset, 2, (
                    [ $any1->[0], $any1->[1] . $any2->[1] ],
                ));
                $cursor--; # see if the next clump is more of the same
                $should_continue = 1;
            } elsif ( $lookahead =~ m/^(?:$SUBTRACTION$ADDITION$SUBTRACTION|$ADDITION$SUBTRACTION$ADDITION)/ ) {
                my( $sa1, $as, $sa2 ) = @{$diffs}[ $cursor .. $cursor + 2 ];
                splice( @$diffs, $cursor, 3, (
                    [ $sa1->[0] => $sa1->[1] . $sa2->[1] ],
                    [ $as->[0]  => $as->[1] ],
                ));
                $should_continue = 1;
            } elsif ( $lookahead =~ m/^((?:$SUBTRACTION|$ADDITION)$CONTEXT)\1/ ) {
                ##
                # If we're cleaning up context noise of 1 character in length
                # and we have the following input, then we should find work to do...
                ##
                # [ c   =>  "sub line_no                { $ENV{'DIFF_" ],
                # [ s1  =>  "CO" ],
                # [ c1  =>  "L" ],
                # [ s2  =>  "OR_L" ],
                # [ c2  =>  "INE_NO'}          || '" ],
                # [ s   =>  "yellow" ],
                # [ a   =>  "YELLOW" ],
                # [ c   =>  "'  }" ],
                ##
                # (above is an 's' example, but same applies to 'a' examples)
                # salient features:
                #   cursor looking at types s1,c1,s2,c2
                #   the c1 is num_chars long
                #   the c1 text appears at the end of the s2 text
                # actions:
                #   s2 gets c1 removed from end of text
                #   c2 gets c1 added to the start of text
                #   s1 .= c1 . s2
                #   c1 and s2 get removed from the diff list
                # result as below (note that two diff entries are removed)
                ##
                # [ c   =>  "sub line_no                { $ENV{'DIFF_" ],
                # [ s1  =>  "COLOR_" ],
                # rm c1
                # rm s2
                # [ c2 =>  "LINE_NO'}          || '" ],
                # [ s  =>  "yellow" ],
                # [ a  =>  "YELLOW" ],
                # [ c  =>  "'  }" ],
                ##
                # cursor is sitting at scsc or acac:
                my( $sa1, $c1, $sa2, $c2 ) = @{$diffs}[ $cursor .. $cursor + 3 ];
                my $len = length $c1->[1];
                next unless $len <= max_chars_line_cleanup();
                next unless substr($sa2->[1], -$len) eq $c1->[1];
                # looks like noise. Clean it up:
                substr($sa2->[1], -$len) = '';
                $c2->[1] = $c1->[1] . $c2->[1];
                $sa1->[1] .= $c1->[1] . $sa2->[1];
                splice @$diffs, $cursor + 1, 2;
                $should_continue = 1;
            } elsif ( $lookahead =~ m/^$SUBTRACTION$ADDITION$CONTEXT$SUBTRACTION/ )  {
                # Here's another case:
                # cursor on sacs; len(c) == cnl;
                ##
                # [ s  =>  "Pr" ],
                # [ a  =>  "Netw" ],
                # [ c  =>  "o" ],
                # [ s  =>  "v" ],
                # [ a  =>  "rk" ],
                ##
                # which we might like to turn into
                # [ s1  =>  "Prov" ],
                # [ a1  =>  "Netwo" ],
                # rm c1
                # rm s2
                # [ a  =>  "rk" ],
                ##
                # and even better, put that last bit on the s1 or a1 as needed
                my( $s1, $a1, $c1, $s2 ) = @{$diffs}[ $cursor .. $cursor + 3 ];
                next unless length $c1->[1] <= max_chars_line_cleanup();
                $s1->[1] .= $c1->[1] . $s2->[1];
                $a1->[1] .= $c1->[1];
                splice @$diffs, $cursor + 2, 2;
                unless (  $#{$diffs} > $cursor + 1  ){
                    if ( $diffs->[$cursor +2][0] eq $SUBTRACTION ) {
                        $s1->[1] .= $diffs->[$cursor +2][0];
                        splice @$diffs, $cursor + 2, 1;
                    } elsif ( $diffs->[$cursor +2][0] eq $ADDITION ) {
                        $a1->[1] .= $diffs->[$cursor +2][0];
                        splice @$diffs, $cursor + 2, 1;
                    }
                }
                $should_continue = 1;
            } elsif ( $lookahead =~ m/^$SUBTRACTION$CONTEXT$ADDITION/ ) {
                my( $s, $c, $a ) = @{$diffs}[ $cursor .. $cursor + 2 ];
                next unless length $c->[1] <= max_chars_line_cleanup();
                my $sub = $s->[1] . $c->[1];
                my $add = $c->[1] . $a->[1];
                splice( @$diffs, $cursor, 3, (
                    [ $SUBTRACTION => $sub ],
                    [ $ADDITION    => $add ],
                ));
                $should_continue = 1;
            } elsif ( $lookahead =~ m/^$SUBTRACTION$ADDITION$CONTEXT/ ) {
                my( $s, $a, $c ) = @{$diffs}[ $cursor .. $cursor + 2 ];
                next unless length $c->[1] <= max_chars_line_cleanup();
                my $sub = $s->[1] . $c->[1];
                my $add = $a->[1] . $c->[1];
                splice( @$diffs, $cursor, 3, (
                    [ $SUBTRACTION => $sub ],
                    [ $ADDITION    => $add ],
                ));
                $should_continue = 1;
            } elsif ( $lookahead =~ m/^$ADDITION$CONTEXT$SUBTRACTION/ ) {
                my( $a, $c, $s ) = @{$diffs}[ $cursor .. $cursor + 2 ];
                next unless length $c->[1] <= max_chars_line_cleanup();
                my $add = $a->[1] . $c->[1];
                my $sub = $c->[1] . $s->[1];
                splice( @$diffs, $cursor, 3, (
                    [ $SUBTRACTION => $sub ],
                    [ $ADDITION    => $add ],
                ));
                $should_continue = 1;
            } elsif ( $lookahead =~ m/^$CONTEXT$ADDITION$SUBTRACTION/ ) {
                my( $c, $a, $s ) = @{$diffs}[ $cursor .. $cursor + 2 ];
                next unless length $c->[1] <= max_chars_line_cleanup();
                my $add = $c->[1] . $a->[1];
                my $sub = $c->[1] . $s->[1];
                splice( @$diffs, $cursor, 3, (
                    [ $SUBTRACTION => $sub ],
                    [ $ADDITION    => $add ],
                ));
                $should_continue = 1;
            } elsif ( $lookahead =~ m/^.$SUBTRACTION$ADDITION$CONTEXT/ ) {
                my( $s, $a, $c ) = @{$diffs}[ $cursor + 1 .. $cursor + 3 ];
                next unless length $c->[1] <= max_chars_line_cleanup();
                my $add = $a->[1] . $c->[1];
                my $sub = $s->[1] . $c->[1];
                splice( @$diffs, $cursor + 1, 3, (
                    [ $SUBTRACTION => $sub ],
                    [ $ADDITION    => $add ],
                ));
                $should_continue = 1;
            } elsif ( $lookahead =~ m/^$CONTEXT$SUBTRACTION$ADDITION/ ) {
                my( $c, $s, $a ) = @{$diffs}[ $cursor .. $cursor + 2 ];
                next unless length $c->[1] <= max_chars_line_cleanup();
                my $add = $c->[1] . $a->[1];
                my $sub = $c->[1] . $s->[1];
                splice( @$diffs, $cursor, 3, (
                    [ $SUBTRACTION => $sub ],
                    [ $ADDITION    => $add ],
                ));
                $should_continue = 1;
            } elsif ( $lookahead =~ m/^$SUBTRACTION$CONTEXT$SUBTRACTION$ADDITION/ ) {
                my( $s1, $c, $s2, $a ) = @{$diffs}[ $cursor .. $cursor + 3 ];
                next unless length $c->[1] <= max_chars_line_cleanup();
                $s1->[1] .= $c->[1] . $s2->[1];
                $a->[1] = $c->[1] . $a->[1];
                splice( @$diffs, $cursor + 1, 3, (
                    $a,
                ));
                $should_continue = 1;
            }
        } continue { $cursor++ }
    }
}
sub get_merged_diff_as_one_line {
    my( $count, $diffs, %options ) = @_;
    my( $start, $stop ) = $options{'debug'} ? (map {clr('yellow',$_)} '[',']') : ('','');
    return join '', line_marker_for_diff_type_counts( $count ), (  map {
        my( $type, $text ) = @$_;
        my @hilight = $text =~ /\S/ ? () : hilight();
        $type eq $SUBTRACTION ? $start . clr( @hilight, old_line(), $text ) . $stop:
        $type eq $ADDITION    ? $start . clr( @hilight, new_line(), $text ) . $stop:
        $type eq $CONTEXT     ? $start .                            $text   . $stop: ();
    } @$diffs  ), "\n";
}
sub line_marker_for_diff_type_counts {
    my $count = shift;
    return(  ( $count->{$ADDITION} && $count->{$SUBTRACTION} )
        ? clr( hilight(), both_ways(), '*' )
        : $count->{$ADDITION}
            ? clr( hilight(), new_line(),  '+' )
            : clr( hilight(), old_line(),  '-' )
    );
}
sub processed_current_line {
    my $painter =
        /^\s/                       ? \&context_line      :
        /^\?/                       ? \&question_line     :
        /^!/                        ? \&context_diff_line :
        /^\+\+\+ /                  ? \&modified_version  :
        /^[+>]/                     ? \&addition          :
        /^\@\@/                     ? \&at_line           :
        /^\@\@/                     ? \&at_line           :
        /^\d/                       ? \&old_style_at_line :
        /^--- \d+,\d+ ----$/        ? \&old_style_at_line :
        /^\*\*\* \d+,\d+ \*\*\*\*$/ ? \&old_style_at_line :
        /^---$/                     ? \&old_style_divider :
        /^--- /                     ? \&original_version  :
        /^\*\*\* /                  ? \&modified_version  :
        /^[-<]/                     ? \&subtraction       :
        /^\S/                       ? \&header_line       :
        die "unexpected input at line $.:\n$_";
    my $original_line = $_;
    $painter->();
    my $colored_line = $_;
    my $line_type =
        $painter eq \&addition     ? $ADDITION    :
        $painter eq \&subtraction  ? $SUBTRACTION :
        $painter eq \&context_line ? $CONTEXT     :
        $OTHER;
    return {
        'original_line' => $original_line,
        'colored_line'  => $colored_line,
        'type'          => $line_type,
    };
}

sub context_line      {}
sub question_line     { s/^(.*)/          clr( hilight(), question_mk(), $1 )                          /e }
sub context_diff_line { s/^(.*)/          clr(            both_ways(),   $1 )                          /e }
sub modified_version  { s/^(... \S+)(.*)/ clr( hilight(), new_line(),    $1 ) . clr( misc(), $2 )      /e }
sub addition          { s/^([+>])(.*)/    clr( hilight(), new_line(),    $1 ) . clr( new_line(),  $2 ) /e }
sub at_line           { s/^(\@\@.+?\@\@)/ clr(            line_no(),     $1 )                          /e }
sub old_style_at_line { s/^(.+)/          clr(            line_no(),     $1 )                          /e }
sub old_style_divider { s/^(---)/         clr(            misc(),        $1 )                          /e }
sub original_version  { s/^(--- \S+)(.*)/ clr( hilight(), old_line(),    $1 ) . clr( misc(), $2 )      /e }
sub subtraction       { s/^([-<])(.*)/    clr( hilight(), old_line(),    $1 ) . clr( old_line(),  $2 ) /e }
sub header_line       { s/^(.*)/          clr(            misc(),        $1 )                          /e }

sub clr {
    my $string = pop;
    return join( '',  ( map { color($_) } @_ ), $string, color('reset') );
}

1;


# once Algorithm::Diff is installed, this can go and a use line can go above
BEGIN { # code stolen and streamlined from Algorithm::Diff $VERSION = 1.19_01;
    package Algorithm::Diff;
    use strict;
    use integer;
    sub _withPositionsOfInInterval {
        my( $aCollection, $start, $end, %d, $index ) = @_;
        for ( $index = $start ; $index <= $end ; $index++ ) {
            if ( exists $d{ $aCollection->[$index] } ) {
                unshift @{  $d{ $aCollection->[$index] }  }, $index;
            } else {
                $d{ $aCollection->[$index] } = [$index];
            }
        }
        return wantarray ? %d : \%d;
    }
    sub _replaceNextLargerWith {
        my ( $array, $aValue, $high ) = @_;
        $high ||= $#$array;
        if ( $high == -1 || $aValue > $array->[-1] ) {
            push ( @$array, $aValue );
            return $high + 1;
        }
        my( $low, $index, $found ) = ( 0 );
        while ( $low <= $high ) {
            $index = ( $high + $low ) / 2;
            $found = $array->[$index];
            if ( $aValue == $found ) {
                return undef;
            } elsif ( $aValue > $found ) {
                $low = $index + 1;
            } else {
                $high = $index - 1;
            }
        }
        $array->[$low] = $aValue;
        return $low;
    }
    sub _longestCommonSubsequence {
        my( $a, $b ) = @_;
        my $compare = sub { my ( $a, $b ) = @_; $a eq $b };
        my ( $aStart, $aFinish, $matchVector ) = ( 0, $#$a, [] );
        my ( $prunedCount, $bMatches, $bStart, $bFinish ) = ( 0, {}, 0, $#$b );
        while ( $aStart <= $aFinish
            and $bStart <= $bFinish
            and &$compare( $a->[$aStart], $b->[$bStart] )
        ) {
            $matchVector->[ $aStart++ ] = $bStart++;
            $prunedCount++;
        }
        while ( $aStart <= $aFinish
            and $bStart <= $bFinish
            and &$compare( $a->[$aFinish], $b->[$bFinish] )
        ) {
            $matchVector->[ $aFinish-- ] = $bFinish--;
            $prunedCount++;
        }
        $bMatches = _withPositionsOfInInterval( $b, $bStart, $bFinish );
        my( $thresh, $links, $i, $ai, $j, $k ) = ( [], [] );
        for ( $i = $aStart ; $i <= $aFinish ; $i++ ) {
            $ai = $a->[$i];
            if ( exists( $bMatches->{$ai} ) ) {
                $k = 0;
                for $j ( @{ $bMatches->{$ai} } ) {
                    if ( $k and $thresh->[$k] > $j and $thresh->[ $k - 1 ] < $j ) {
                        $thresh->[$k] = $j;
                    } else {
                        $k = _replaceNextLargerWith( $thresh, $j, $k );
                    }
                    if ( defined($k) ) {
                        $links->[$k] = [ ( $k ? $links->[ $k - 1 ] : undef ), $i, $j ];
                    }
                }
            }
        }
        if (@$thresh) {
            for ( my $link = $links->[$#$thresh] ; $link ; $link = $link->[0] ) {
                $matchVector->[ $link->[1] ] = $link->[2];
            }
        }
        return $matchVector;
    }
    sub traverse_balanced {
        my( $a, $b, $callbacks ) = @_;
        my $matchVector = _longestCommonSubsequence( $a, $b );
        my( $lastA, $lastB, $bi, $ai, $ma, $mb ) = ( $#$a, $#$b, 0, 0, -1 );
        while (1) {
            do { $ma++ } while(
                    $ma <= $#$matchVector
                &&  !defined $matchVector->[$ma]
            );
            last if $ma > $#$matchVector;
            $mb = $matchVector->[$ma];
            while ( $ai < $ma || $bi < $mb ) {
                if ( $ai < $ma && $bi < $mb ) {
                    $callbacks->{'CHANGE'}->( $ai++, $bi++, @_ );
                } elsif ( $ai < $ma ) {
                    $callbacks->{'DISCARD_A'}->( $ai++, $bi, @_ );
                } else {
                    $callbacks->{'DISCARD_B'}->( $ai, $bi++, @_ );
                }
            }
            $callbacks->{'MATCH'}->( $ai++, $bi++, @_ );
        }
        while ( $ai <= $lastA || $bi <= $lastB ) {
            if ( $ai <= $lastA && $bi <= $lastB ) {
                $callbacks->{'CHANGE'}->( $ai++, $bi++, @_ );
            } elsif ( $ai <= $lastA ) {
                $callbacks->{'DISCARD_A'}->( $ai++, $bi, @_ );
            } else {
                $callbacks->{'DISCARD_B'}->( $ai, $bi++, @_ );
            }
        }
    }
    1;
}
