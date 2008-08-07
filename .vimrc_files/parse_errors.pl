#!/usr/bin/perl -w
use strict;

sub preprocess
{
    my $line = shift @_;
    $line =~ s/\x1b.*?m//g;
    $line =~ s/\^J//g;
    chomp $line;
    return $line;
}

sub printforvim
{
    my ($message, $file, $lineno, $rest) = @_;
    $message .= $rest if (defined($rest) and $rest =~ s/^,//);
    if ($file) {
        print(join('^^', $file, $lineno, $message)) if $file;
    } else {
        print("eval, no file - $message");
    }
    print("\n");
}

undef $/;
my $text  = <STDIN>;
my @lines = map { preprocess($_) } (split("\n", $text));

my $warning_multiline_state = 0;
#my $blank_line_previous_state = 0;

for my $line (@lines) {
    if ($warning_multiline_state && ($line =~ m/ -> (.*) at (.*) line (\d+)\./)) { # "warning caused by" on previous line
        printforvim($1, $2, $3);
    } elsif ($warning_multiline_state && ($line =~ m/(.*) at ([^\s]+\.pm) line (\d+)\./)) { # warning without "->"
        printforvim($1, $2, $3);
    } elsif ($line =~ m/warning caused by/) { # oarned
        $warning_multiline_state = 1;
    } elsif ($line =~ m/^\s*-- (.*)\sat\s(.*\.pm)\sline\s(\d+)(.*)$/) { # died
        printforvim($1, $2, $3, $4)
    } elsif ($line =~ m/-- Test failed: (.*) (?:on|at) ([^\s]+\.pm), line (\d+)/) { # test failure
        printforvim($1, $2, $3);
    } elsif ($line =~ m/-- Test failed: ([^\s]+\.pm), line (\d+)/) { # test failure, no message
        printforvim("[no message]", $1, $2);
    } elsif ($line =~ m/Failed loading package [a-zA-Z:]+:\s+(.*) at ([^\s]+\.pm) line (\d+)/) {
        printforvim($1, $2, $3);
    } elsif ($line =~ m/(.*) called at ([^\s]+\.pm) line (\d+)/) {
        printforvim($1, $2, $3);
    } elsif ($line =~ m/(?:on|at) ([^\s]+\.pm),? line (\d+)/) {
        printforvim("[multiline message]", $1, $2);
    }
#    next if ($blank_line_previous_state && $line =~ /^\s*$/);
#    $blank_line_previous_state = $line =~ /^\s*$/ ? 1 : 0;
}
