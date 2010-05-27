use strict;
use warnings FATAL => 'all';
use Test::More;

use HTML::Zoom;


my $tmpl = <<END;
<body>
  <div class="main">
    <span prop='moo' class="hilight name">Bob</span>
    <span class="career">Builder</span>
    <hr />
  </div>
</body>
END

ok( ! check_select( '[x=y]' ), 'False select fail' );
ok( check_select( '[prop=moo]'), 'Select by arbitary property' );
ok( check_select( '[class=career]' ), 'Select by class using property' );
ok( check_select( 'span[class=career]' ), 'Select using chained selector' );
ok( ! check_select( 'div[class=carreer]' ), 'False chain test where first clause is wrong' );
ok( ! check_select( 'span[class=monkey]' ), 'False chain test where second clause is wrong' );
is( check_select('span[class=career],[prop=moo]'), 2, 'Multiple chained selectors');

done_testing;

sub check_select{
    # less crude?:
    my $output = HTML::Zoom
    ->from_html($tmpl)
    ->select(shift)->replace("the monkey")->to_html;
    my $count = 0;
    while ( $output =~ /\G?.*the monkey/gc ){
        $count++;
    }
    return $count;
}
