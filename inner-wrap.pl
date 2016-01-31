use strict;
use argola;
use alarmica;

my $prewait;
my $btwinterv;
my $nxbtwinterv;
my $curstat;
my $short_alarm;
my $prepping_chime;
my $volumos;
my $regyet;
my $difran;
my @history_at = ();

my $interstep_prime = 15;
my $interstep_ratio = ( 1 / 6 );
my $presilence_prime = 60;
my $interstep_last;
my $interstep_act;

my $coraction = "x";
my $corarguma;

my $savefile = "recnex.txt";
my $saveloca = 0;

$difran = 0.03;

$volumos = "0.01";

$short_alarm = &alarmica::shlc_svol("0","0.02","0.04","0.08","0.14");
$prepping_chime = &alarmica::shlc_svol("0","0.04","0.08","0.14");


sub acto__f_rev {
  $coraction = "rev";
  $corarguma = &argola::getrg();
}
sub apre__f_rev {
  my $lc_a;
  my $lc_b;
  my $lc_c;
  my $lc_rema;
  my $lc_neos;
  
  $lc_rema = $corarguma;
  if ( $lc_rema eq "" ) { $lc_rema = 1; }
  $lc_neos = $btwinterv;
  
  while ( $lc_rema > 0.5 )
  {
    $lc_a = int($lc_neos * ( 1 - $difran));
    $lc_neos = $lc_a;
    $lc_rema = int($lc_rema - 0.8);
  }
  
  #system("echo $lc_a > recnex.txt");
  &savingit($lc_a);
  
  $lc_b = int(($lc_a * 3) + 0.1);
  $lc_c = &alarmica::parcesec($lc_b);
  system("echo","Scaling Back to: " . $lc_c);
  exit(0);
} &argola::setopt("-rev",\&acto__f_rev);


sub acto__f_adv {
  $coraction = "adv";
  $corarguma = &argola::getrg();
}
sub apre__f_adv {
  my $lc_a;
  my $lc_b;
  my $lc_c;
  my $lc_nx;
  my $lc_rema;
  my $lc_neos;
  
  $lc_rema = $corarguma;
  if ( $lc_rema eq "" ) { $lc_rema = 1; }
  $lc_neos = $btwinterv;
  
  while ( $lc_rema > 0.5 )
  {
    $lc_a = int($lc_neos * 1.01);
    $lc_nx = int($lc_neos + 1.2);
    if ( $lc_a < $lc_nx ) { $lc_a = $lc_nx; }
    $lc_neos = $lc_a;
    $lc_rema = int($lc_rema - 0.8);
  }
  
  #system("echo $lc_a > recnex.txt");
  &savingit($lc_a);
  
  $lc_b = int(($lc_a * 3) + 0.1);
  $lc_c = &alarmica::parcesec($lc_b);
  system("echo","Advanced to: " . $lc_c);
  exit(0);
} &argola::setopt("-adv",\&acto__f_adv);

sub acto__f_chk {
  $coraction = "chk";
}
sub apre__f_chk {
  my $lc_a;
  my $lc_b;
  $lc_a = int(($btwinterv * 3) + 0.2);
  $lc_b = &alarmica::parcesec($lc_a);
  exec("echo","Current Meditation Duration: " . $lc_b);
  exit(0);
} &argola::setopt("-chk",\&acto__f_chk);

sub acto__f_out {
  $coraction = "out";
}
sub apre__f_out {
  exec("echo",$btwinterv);
  exit(0);
} &argola::setopt("-out",\&acto__f_out);

sub acto__f_in {
  $coraction = "in";
  $corarguma = &argola::getrg();
}
sub apre__f_in {
  &savingit($corarguma);
  exit(0);
} &argola::setopt("-in",\&acto__f_in);


sub acto__f_f {
  $savefile = &argola::getrg();
  $saveloca = 10;
} &argola::setopt("-f",\&acto__f_f);


# The -scrn option causes 'meditate-time-me' to run in the mode by
# which the screen is prevented from falling asleep.
sub acto__f_scrn {
  &alarmica::set_caf_screen();
} &argola::setopt("-scrn",\&acto__f_scrn);



sub acto__f_hst {
  @history_at = ( @history_at, &argola::getrg() );
} &argola::setopt("-hst",\&acto__f_hst);


&argola::runopts();




if ( $saveloca < 5 )
{
  die "\nPlease use -f option to specify the save file:\n\n";
}
$btwinterv = 30;
if ( -f $savefile )
{
  my $lc_cm;
  my $lc_cna;
  my @lc_cnb;
  my $lc_remen;
  my $lc_dcreased;
  
  $lc_cm = "cat";
  &argola::wraprg_lst($lc_cm,$savefile);
  $lc_cna = `$lc_cm`; chomp($lc_cna);
  @lc_cnb = split(/:/,$lc_cna);
  
  $btwinterv = $lc_cnb[1];
  #$btwinterv = `cat recnex.txt`; chomp($btwinterv);
  
  # ################################ #
  # ##  BEGIN DECAY PROCESS HERE  ## #
  # ################################ #
  # The decay process is the feature that allows a meditation
  # span to gradually decrease if you go for an extended period
  # of time without using this program. That way, when you
  # return, it won't start out too tough for you.
  
  # Now for the decay process:
  $lc_dcreased = ( 1 > 2 );
  $lc_remen = int((&alarmica::nowo() - $lc_cnb[0]) + 0.2);
  
  #my $lc_dbai;
  #$lc_dbai = 0;
  
  while ( $lc_remen > ( 60 * 60 * 24 ) )
  {
    $btwinterv = ( $btwinterv * .999 );
    $lc_dcreased = ( 2 > 1 );
    
    #$lc_dbai = int($lc_dbai + 1.2);
    #system("echo",$lc_dbai . ": " . $btwinterv . " :");
    
    
    # Originally, the decay-increment after a full day was a full
    # hour - but experience has taught me that it needs to be
    # decreased by a little bit.
    $lc_remen = int( ( $lc_remen - ( 56 * 60 ) ) + 0.2 );
  }
  if ( $lc_dcreased ) { $btwinterv = int($btwinterv); }
  
  
  # ############################## #
  # ##  END DECAY PROCESS HERE  ## #
  # ############################## #
  
  
  $btwinterv = int($btwinterv + 0.3);
  if ( $btwinterv < 30 ) { $btwinterv = 30; }
}




if ( $coraction eq "rev" ) { &apre__f_rev(); }
if ( $coraction eq "adv" ) { &apre__f_adv(); }
if ( $coraction eq "chk" ) { &apre__f_chk(); }
if ( $coraction eq "out" ) { &apre__f_out(); }
if ( $coraction eq "in" ) { &apre__f_in(); }




# Now we get the future to be an increase:
{
  my $lc_aa;
  $lc_aa = int($btwinterv + 1.2);
  $nxbtwinterv = int($btwinterv * (1 + $difran));
  if ( $nxbtwinterv < $lc_aa ) { $nxbtwinterv = $lc_aa; }
}

# Now we set the pre-waiting:
#$prewait = int(27.1 + ( $btwinterv / 8 ));
sub zarin {
  my $lc_tht;
  
  # If it hasn't yet reached the benchmark,
  # quit the function without changing it anything.
  if ( $_[0] < $_[1] ) { return; }
  
  # Okay --- the new result will at *least* be
  # the benchmark.
  $_[0] = $_[1];
  
  $lc_tht = int($btwinterv / $_[2]);
  
  # Now - we don't want to go *below* the benchmark
  # no matter what.
  if ( $lc_tht < $_[1] ) { return; }
  
  $_[0] = $lc_tht;
}
$prewait = $btwinterv;
&zarin($prewait,40,1.2);
&zarin($prewait,50,1.6);
&zarin($prewait,60,2);
&zarin($prewait,70,3);
&zarin($prewait,75,4);
&zarin($prewait,80,5);




$curstat = &alarmica::nowo();

sub stdring ( )
{
  system("echo",": ------------------------------------- :");
  system($short_alarm);
}

sub diferen {
  my $lc_now;
  my $lc_ret;
  
  $lc_now = &alarmica::nowo();
  $lc_ret = int(($curstat - $lc_now) + 0.2);
  return $lc_ret;
}

sub zenny {
}

sub prep_alarm {
  my $lc_current;
  my $lc_primate;
  
  $lc_current = &alarmica::nowo();
  
  $lc_primate = $interstep_prime;
  {
    my $lc2_a;
    $lc2_a = int( ( $curstat - $lc_current ) * $interstep_ratio );
    if ( $lc2_a > $lc_primate ) { $lc_primate = $lc2_a; }
  }
  
  if ( ( $lc_current - $interstep_last ) < $lc_primate ) { return; }
  if ( ( $curstat - $lc_current ) < $presilence_prime ) { return; }
  system($prepping_chime);
  $interstep_last = $lc_current;
}

sub goforward {
  my $lc_xar;
  my $lc_zlp;
  my $lc_visuo;
  $curstat = int($curstat + $_[0] + 0.2);
  while ( ( $lc_xar = &diferen() ) > 0.5 )
  {
    &$interstep_act();
    $lc_zlp = 1;
    if ( $lc_xar > 8 )
    {
      $lc_zlp = 3;
      if ( $lc_xar > 25 ) { $lc_zlp = 10; }
    }
    $lc_visuo = &alarmica::parcesec($lc_xar);
    system("echo",": " . $_[1] . ": " . $lc_visuo);
    &alarmica::do_caf(30);
    sleep($lc_zlp);
  }
}

sub savingit {
  my $lc_cm;
  my $lc_nw;
  
  $lc_nw = `date +%s`; chomp($lc_nw);
  $lc_cm = "echo";
  &argola::wraprg_lst($lc_cm,$lc_nw . ":" . $_[0]);
  $lc_cm .= " >";
  &argola::wraprg_lst($lc_cm,$savefile);
  system($lc_cm);
}

sub dovar {
  my $lc_a;
  $lc_a = $_[0];
  while ( $lc_a > 0.5 )
  {
    &alarmica::do_caf(8);
    system("echo","Ending Bell Volume: " . $volumos);
    &alarmica::fg_invi_vol($volumos);
    sleep(3);
    $volumos = ( $volumos * 1.2);
    if ( $volumos > 1 ) { $volumos = 1; }
    $lc_a = int($lc_a - 0.8);
  }
}


# Announcement Before Meditation:
{
  my $lc_fara;
  my $lc_farb;
  $lc_fara = int(($btwinterv * 3) + 0.2);
  $lc_farb = &alarmica::parcesec($lc_fara);
  system("echo","\nPreparing to meditate for: " . $lc_farb . ":\n");
}




system($prepping_chime);
$interstep_last = &alarmica::nowo();

$interstep_act = \&prep_alarm;
&goforward($prewait,"Prepare for Meditation");
&stdring();
$interstep_act = \&zenny;
&goforward($btwinterv,"Phase 1 of 3");
&stdring();
&goforward($btwinterv,"Phase 2 of 3");
&stdring();
&goforward($btwinterv,"Phase 3 of 3");

&alarmica::do_caf(8);
&alarmica::fg_invi_vol(0);
sleep(3);
$regyet = 0;
while ( 2 > 1 )
{
  my $lc_fara;
  my $lc_farb;
  my $lc_nowrecord;
  
  &dovar(6);
  
  system("echo");
  $lc_nowrecord = 0;
  
  if ( $regyet < 5 )
  {
    #system("echo $nxbtwinterv > recnex.txt");
    &savingit($nxbtwinterv);
    system("echo","REGISTERED INCREMENT TO NEXT TIME: "
        . &alarmica::parcesec(int(($nxbtwinterv * 3) + 0.2))
    );
    $lc_nowrecord = 10;
  }
  
  if ( $regyet > 5 )
  {
    system("echo","Already Registered Next Time to: "
        . &alarmica::parcesec(int(($nxbtwinterv * 3) + 0.2))
    );
  }
  
  $lc_fara = int(($btwinterv * 3) + 0.2);
  $lc_farb = &alarmica::parcesec($lc_fara);
  system("echo","               This time it was: " . $lc_farb);
  system("date");
  
  if ( $lc_nowrecord > 5 )
  {
    my $lc2_date;
    my $lc2_mesg;
    my $lc2_ech;
    my $lc2_cm;
    $lc2_date = `date`; chomp($lc2_date);
    $lc2_mesg = $lc2_date . ": " . $lc_farb;
    foreach $lc2_ech (@history_at)
    {
      $lc2_cm = "echo";
      &argola::wraprg_lst($lc2_cm,$lc2_mesg);
      $lc2_cm .= " >>";
      &argola::wraprg_lst($lc2_cm,$lc2_ech);
      system($lc2_cm);
    }
  }
  
  
  system("echo");
  
  $regyet = 10;
}



