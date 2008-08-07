
function! Auto_Tableize()
perl << CTRLD
        sub _is_part_of_table {
            return $_[0] =~ /^\s*[[({].*\S/
                    || ($_[0] =~ /=>/ && $_[0] !~ /{\s*$/)
                    || $_[0] =~ /^\s*$/;
        }

        sub _first_line_in_table {
            my $first_line = ($curwin->Cursor())[0];
            while ($first_line > 0 && _is_part_of_table($curbuf->Get($first_line))) {
                $first_line--;
            }
            return $first_line + 1;
        }

        sub _last_line_in_table {
            my $last_line = ($curwin->Cursor())[0];
            while (_is_part_of_table($curbuf->Get($last_line))) {
                break if $last_line > $curbuf->Count();
                $last_line++;
            }
            return $last_line - 1;
        }


        use IPC::Open2;
        local(*INPUT, *OUTPUT);
        open2(\*INPUT, \*OUTPUT,
            'perl', '-MAppropriateLibrary', '-MRTK::Util::Text::Tableize', '-e', 'print tableize(<>)');
        print OUTPUT join("\n", $curbuf->Get(_first_line_in_table() .. _last_line_in_table())), "\n";
        close OUTPUT;

        chomp(my @formatted = <INPUT>);
        close INPUT;

        $curbuf->Set(_first_line_in_table(), @formatted);
CTRLD
endfunction

map  ,it      :!perl -MRTK::Text::Tableize -e 'print tableize(<>)'<cr>
map! ,it <esc>:!perl -MRTK::Text::Tableize -e 'print tableize(<>)'<cr>i

map  ,a      :call Auto_Tableize()<cr>
map! ,a <esc>:call Auto_Tableize()<cr>i

map  ,wt      :perldo s/\s+$//<cr>
map! ,wt <esc>:perldo s/\s+$//<cr>i

map  ,ial      :w<cr>:r!egrep '\bassert' % \| perl -pe 's/.*\b(assert\w*).*/    $1/' \| sort -u<cr>
map! ,ial <esc>:w<cr>:r!egrep '\bassert' % \| perl -pe 's/.*\b(assert\w*).*/    $1/' \| sort -u<cr>i

vmap ,qwa :Align qw/<cr>gv:Align /;<cr>gv::perldo s/\s+$//<cr>gv::!sort<cr>

vmap ,aas :perldo s/^(\s*)(\w+\.)?(\w+),/$1$2$3 as $3,/<cr>gv:s/ as / ~ /g<cr>gv:Align ~<cr>gv:s/ ~ / as /g<cr>

map ,wp  :perldo s/^(\s*)(\w+)\s*$/$1-$2 => \\my \$$2,/<cr>gv:Align =><cr>
map ,wm  :perldo s/^(\s*)(\w+)\s*$/$1->$2(\$$2)/<cr>gv:Align ( )<cr>gv:perldo s/ +$//<cr>gv:perldo s/( *)\(/($1/<cr>

vmap ,lc          :perldo s/(.*)/lc $1/e<cr>
 map ,lc       viw:perldo s/(.*)/lc $1/e<cr>
map! ,lc  <esc>viw:perldo s/(.*)/lc $1/e<cr>
vmap ,uc          :perldo s/(.*)/uc $1/e<cr>
 map ,uc       viw:perldo s/(.*)/uc $1/e<cr>
map! ,uc  <esc>viw:perldo s/(.*)/uc $1/e<cr>
vmap ,com       :perldo s/^(\s*)(..?)/$1 . $2 eq '# ' ? '' : "# $2"/e<cr>
map  ,com      V:perldo s/^(\s*)(..?)/$1 . $2 eq '# ' ? '' : "# $2"/e<cr>
map! ,com <esc>V:perldo s/^(\s*)(..?)/$1 . $2 eq '# ' ? '' : "# $2"/e<cr>
vmap ,das       :perldo s/^(\s*)(..?.?)/$1 . $2 eq '-- ' ? '' : "-- $2"/e<cr>
map  ,das      V:perldo s/^(\s*)(..?.?)/$1 . $2 eq '-- ' ? '' : "-- $2"/e<cr>
map! ,das <esc>V:perldo s/^(\s*)(..?.?)/$1 . $2 eq '-- ' ? '' : "-- $2"/e<cr>

map ,~w viw~
map ,~l v~

map  ,dt      :perldo s/^(\t+)/'    ' x length $1/e<cr>
map! ,dt <esc>:perldo s/^(\t+)/'    ' x length $1/e<cr>i

map ,tn          VgUVV:s/ /_/g<cr>_4ssub <esc>:s/'//g<cr>
map!,tn     <esc>VgUVV:s/ /_/g<cr>_4ssub <esc>:s/'//g<cr>i
