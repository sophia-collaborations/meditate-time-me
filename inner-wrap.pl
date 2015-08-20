use strict;
use argola;
use alarmica;

my $short_alarm;
my $end_alarm;

{
  my @lc_a;
  my @lc_b;
  
  @lc_a = ("0","0.02","0.04","0.06","0.08","0.1");
  @lc_a = (@lc_a,"0.13","0.16","0.2","0.25","0.3");
  @lc_a = (@lc_a,"0.35","0.4","0.5","0.6","0.7","0.8","0.9");
  
  @lc_b = ("1");
  @lc_b = (@lc_b,@lc_b,@lc_b);
  @lc_b = (@lc_b,@lc_b,@lc_b);
  @lc_b = (@lc_b,@lc_b,@lc_b);
  @lc_b = (@lc_b,@lc_b,@lc_b);
  
  @lc_a = (@lc_a,@lc_b);
  $end_alarm = &alarmica::shlc_isvol(@lc_a);
}

$short_alarm = &alarmica::shlc_svol("0","0.02","0.04","0.08","0.14");

#system(&alarmica::shlc_vol("0.2"));
#system(&alarmica::shlc_svol("0.1","0.2","0.3","0.4","0.5","0.6","0.7","0.8","0.9","1"));
#system(&alarmica::shlc_caf(3));

my $bandia;
$bandia = &alarmica::new_res;
#system("echo",$$bandia{"at"});

#&alarmica::advance_by_s($bandia,60);

while ( &argola::yet )
{
  &alarmica::advance_by_s($bandia,&argola::getrg);
  if ( &argola::yet ) { system($short_alarm); }
}

system($end_alarm);



