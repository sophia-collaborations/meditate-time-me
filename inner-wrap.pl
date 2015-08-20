use strict;
use argola;
use alarmica;

my $short_alarm;
my $nex_alarm;


$short_alarm = &alarmica::shlc_svol("0","0.02","0.04","0.08","0.14");

#system(&alarmica::shlc_vol("0.2"));
#system(&alarmica::shlc_svol("0.1","0.2","0.3","0.4","0.5","0.6","0.7","0.8","0.9","1"));
#system(&alarmica::shlc_caf(3));

my $bandia;
$bandia = &alarmica::new_res;
#system("echo",$$bandia{"at"});

#&alarmica::advance_by_s($bandia,60);

#while ( &argola::yet )
#{
#  &alarmica::advance_by_s($bandia,&argola::getrg);
#  if ( &argola::yet ) { system($short_alarm); }
#}

$nex_alarm = "echo > /dev/null";

sub opto__f_s {
  system($nex_alarm);
  $nex_alarm = $short_alarm;
  &alarmica::advance_by_s($bandia,&argola::getrg);
} &argola::setopt("-s",\&opto__f_s);

sub opto__f_ms {
  my $lc_min;
  my $lc_sec;
  my $lc_tsec;
  
  system($nex_alarm);
  $nex_alarm = $short_alarm;
  
  $lc_min = &argola::getrg;
  $lc_sec = &argola::getrg;
  $lc_tsec = int(($lc_min * 60) + $lc_sec + 0.2);
  
  &alarmica::advance_by_s($bandia,$lc_tsec);
} &argola::setopt("-ms",\&opto__f_ms);


&argola::runopts;


system("echo","TIMING COMPLETE:");
{
  my $lc_vol;
  &alarmica::fg_invi_vol(0);
  sleep(3);
  $lc_vol = 0.01;
  while ( 2 > 1 )
  {
    &alarmica::do_caf(8);
    &alarmica::fg_invi_vol($lc_vol);
    sleep(3);
    $lc_vol = ( $lc_vol * 1.2 );
    if ( $lc_vol > 1 ) { $lc_vol = 1; }
  }
}



