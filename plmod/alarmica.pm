package alarmica;
use strict;
use randomica;
use argola;

my $resdir;
my $soundfl;
my $wait_rate = 3;
my $hme;
my $cbkdr;
my $dbkfl;
my $ringfun;

my $permitay = 0;
my $destinay;

$ringfun = \&ringtalert;

$hme = $ENV{"HOME"};
$cbkdr = $hme . "/.chobakwrap/plmr-randomica";
$dbkfl = $cbkdr . "/message.txt";


$resdir = &argola::srcd;
$soundfl = $resdir . "/sounds/42095__fauxpress__bell-meditation.mp3";


sub ringtalert {
  my $lc_code;
  my $lc_ref;
  my $lc_vol;
  
  $lc_ref = $_[0];
  $lc_code = &randomica::ranstrg(8);
  $lc_vol = 0.05;
  while ( !(findmsg($lc_code)) )
  {
    &outptex("\n\nRINGING AFTER TASK:\n    " . $$lc_ref{"mesg"});
    &outptex("  " . $lc_code . " -- Vol=" . $lc_vol);
    fg_invi_vol($lc_vol);
    $lc_vol = ( $lc_vol * 1.02 );
    if ( $lc_vol > 1 ) { $lc_vol = 1; }
    sleep(2);
  }
}



sub parcesec {
  my $lc_src;
  my $lc_sec;
  my $lc_min;
  
  $lc_src = $_[0];
  &wean($lc_src,60,$lc_sec);
  &dgits(2,$lc_sec);
  &wean($lc_src,60,$lc_min);
  &dgits(2,$lc_min);
  
  return ( $lc_src . ":" . $lc_min . ":" . $lc_sec );
}

sub wean {
  my $lc_hollow;
  $_[2] = $_[0] % $_[1];
  $lc_hollow = int(($_[0] - $_[2]) + 0.2);
  $_[0] = int(($lc_hollow / $_[1]) + 0.2);
}

sub dgits {
  my $lc_src;
  my $lc_tgo;
  my $lc_ret;
  
  $lc_src = $_[1];
  $lc_tgo = $_[0];
  $lc_ret = "";
  while ( $lc_tgo > 0.5 )
  {
    $lc_src = "00" . $lc_src;
    $lc_ret = chop($lc_src) . $lc_ret;
    $lc_tgo = int($lc_tgo - 0.8);
  }
  
  $_[1] = $lc_ret;
}


sub setlabel {
  my $lc_lf;
  $lc_lf = $_[0];
  $$lc_lf{"mesg"} = $_[1];
}

sub howremain {
  my $lc_now;
  $lc_now = &nowo;
  if ( $lc_now >= $_[0] ) { return ( 1 > 2 ); }
  
  $_[1] = int(($_[0] - $lc_now) + 0.2);
  return ( 2 > 1 );
}

sub justbesure {
  my $lc_hammer;
  my $lc_code;
  my $lc_left;
  
  &findmsg("no");
  $lc_code = &randomica::ranstrg(8);
  
  $lc_hammer = int(&nowo + 70.2);
  
  while ( &howremain($lc_hammer,$lc_left) )
  {
    &outptex("\n\n"
      . "JUST TO BE SURE YOU WANT TO INTERRUPT THE WHOLE PROCESS:\n"
      . "  You have " . &parcesec($lc_left) . " to enter: " . $lc_code . "\n"
      . "  (Or just \"no\" to cancel)"
    );
    if ( &findmsg($lc_code) )
    {
      &outptex("\nOKAY --- THE PROCESS IS OVER WITH:");
      exit(0);
    }
    if ( &findmsg("no") )
    {
      return;
    }
    sleep(1);
  }
}

sub wait {
  my $lc_code;
  my $lc_prwcode;
  my $lc_ref;
  my $lc_start;
  my $lc_projend;
  my $lc_mesg;
  my $lc_endure;
  
  $lc_ref = $_[0];
  $lc_start = $$lc_ref{"at"};
  $lc_mesg = $$lc_ref{"mesg"};
  $lc_projend = int($lc_start + ( $_[1] * 60 ) + $_[2] + 0.2);
  $$lc_ref{"at"} = $lc_projend;
  $lc_code = &randomica::ranstrg(8);
  $lc_prwcode = &randomica::ranstrg(8);
  while ( &howremain($lc_projend,$lc_endure) )
  {
    if ( &findmsg($lc_code) )
    {
      $$lc_ref{"at"} = &nowo;
      &outptex("\n\nTASK ENDED EARLY: (Ringing part will be skipped.)");
      return;
    }
    if ( &findmsg($lc_prwcode) )
    {
      &justbesure;
    }
    &outptex("\n\nTASK: " . $lc_mesg . ":\n" . $lc_code . " -- " . &parcesec($lc_endure));
    &outptex("(Process-wide interrupt: " . $lc_prwcode . ")");
    if ( $lc_endure > 15 )
    {
      &do_caf(40);
      sleep(5);
      if ( &findmsg($lc_code) )
      {
        $$lc_ref{"at"} = &nowo;
        &outptex("\n\nTASK ENDED EARLY: (Ringing part will be skipped.)");
        return;
      }
      sleep(4);
    }
    sleep(1);
  }
  
  &$ringfun($lc_ref);
  
}



sub regmsg {
  my $lc_cm;
  $lc_cm = "echo";
  &argola::wraprg_lst($lc_cm,(&nowo . ":" . $_[0]));
  $lc_cm .= " >> ";
  &argola::wraprg_lst($lc_cm,$dbkfl);
  system("mkdir","-p",$cbkdr);
  system($lc_cm);
}

sub findmsg {
  my $lc_cm;
  my $lc_rs;
  my $lc_er;
  my @lc_al;
  my $lc_each;
  my $lc_found;
  my $lc_when;
  my $lc_what;
  
  $lc_found = 0;
  
  $lc_er = int((&nowo - ( 60 * 60 )) + 0.2);
  $lc_cm = "cat";
  &argola::wraprg_lst($lc_cm,$dbkfl);
  $lc_cm .= " 2> /dev/null";
  $lc_rs = `$lc_cm`;
  system("rm","-rf",$dbkfl);
  @lc_al = split(/\n/,$lc_rs);
  foreach $lc_each (@lc_al)
  {
    ($lc_when,$lc_what) = split(/:/,$lc_each,2);
    if ( $lc_what eq $_[0] )
    {
      $lc_found = 10;
    } else {
      if ( $lc_when > $lc_er )
      {
        $lc_cm = "echo";
        &argola::wraprg_lst($lc_cm,$lc_each);
        $lc_cm .= " >> ";
        &argola::wraprg_lst($lc_cm,$dbkfl);
        system("mkdir","-p",$cbkdr);
        system($lc_cm);
      }
    }
  }
  
  return ( $lc_found > 5 );
}

sub shlc_caf {
  my $lc_ret;
  
  $lc_ret = "( ( caffeinate -i -t";
  &argola::wraprg_lst($lc_ret,$_[0]);
  $lc_ret .= " &bg ) 2> /dev/null )";
}

sub do_caf {
  system(&shlc_caf($_[0]));
}

sub nowo {
  my $lc_ret;
  $lc_ret = `date +%s`;
  chomp($lc_ret);
  return $lc_ret;
}

sub new_res {
  my $lc_ret;
  
  $lc_ret = { "at" => &nowo };
  return $lc_ret;
}



sub shlc_vol {
  my $lc_ret;
  $lc_ret = "( ( afplay -v";
  &argola::wraprg_lst($lc_ret,$_[0],$soundfl);
  $lc_ret .= " &bg ) || true )";
}

sub shlc_svol {
  my $lc_ret;
  my $lc_frst;
  my $lc_ech;
  $lc_frst = 10;
  $lc_ret = "( ";
  foreach $lc_ech (@_)
  {
    if ( $lc_frst < 5 )
    {
      $lc_ret .= " && sleep ";
      &argola::wraprg_lst($lc_ret,$wait_rate);
      $lc_ret .= " && ";
    }
    $lc_frst = 0;
    $lc_ret .= &shlc_vol($lc_ech);
  }
  $lc_ret .= " ) &bg";
  $lc_ret = "( " . $lc_ret . " ) 2> /dev/null";
  return $lc_ret;
}

sub shlc_isvol {
  my $lc_ret;
  my $lc_frst;
  my $lc_ech;
  $lc_frst = 10;
  $lc_ret = "( ";
  foreach $lc_ech (@_)
  {
    if ( $lc_frst < 5 )
    {
      $lc_ret .= " && sleep ";
      &argola::wraprg_lst($lc_ret,$wait_rate);
      $lc_ret .= " && ";
    }
    $lc_frst = 0;
    $lc_ret .= &shlc_vol($lc_ech);
  }
  $lc_ret .= " ) 2> /dev/null";
  return $lc_ret;
}

sub fg_invi_vol {
  system(&shlc_isvol(@_));
}

sub advance_by_s {
  my $lc_at;
  my $lc_ref;
  my $lc_to;
  my $lc_lft;
  $lc_ref = $_[0];
  $lc_at = $$lc_ref{"at"};
  
  $lc_to = int($lc_at + $_[1] + 0.2);
  $$lc_ref{"at"} = $lc_to;
  
  &outptex($lc_at . " : " . $lc_to);
  
  &do_caf(30);
  
  $lc_lft = int(($lc_to - &nowo) + 0.2);
  while ( $lc_lft > 0.5 )
  {
    &outptex(": " . $lc_lft);
    if ( $lc_lft > 10.5 )
    {
      sleep(8);
      do_caf(30);
    }
    sleep(1);
    $lc_lft = int(($lc_to - &nowo) + 0.2);
  }
}

sub outptex {
  my $lc_rg;
  my $lc_cm;
  if ( $permitay < 5 )
  {
    foreach $lc_rg (@_)
    {
      system("echo",$lc_rg);
    }
    return;
  }
  foreach $lc_rg (@_)
  {
    $lc_cm = "echo";
    &argola::wraprg_lst($lc_cm,$lc_rg);
    $lc_cm .= " >>";
    &argola::wraprg_lst($lc_cm,$destinay);
    system($lc_cm);
  }
}

sub setout {
  $permitay = 10;
  $destinay = $_[0];
}



1;
