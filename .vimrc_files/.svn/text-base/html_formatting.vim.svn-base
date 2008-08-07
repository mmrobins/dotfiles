" email link... put an email address on a line by itself and then type comma l e to turn it into a spambot-proof link
map ,le <esc>V:perldo $_="mailto:$_";s/(.)/($1 eq"@"or$1 ne":")?"&#@{[ord$1]};":$1/ge;$_=qq{<a href="$_">$_</a>};s/">.+?:/">/<CR>

" nothing else of interest here yet
