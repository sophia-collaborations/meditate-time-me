package alarmica;
use strict;
use randomica;
use argola;

my $resdir;
my $soundfl;
my $wait_rate = 3;


$resdir = &argola::srcd;
$soundfl = $resdir . "/sounds/42095__fauxpress__bell-meditation.mp3";

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
  
  system("echo",$lc_at . " : " . $lc_to);
  
  &do_caf(30);
  
  $lc_lft = int(($lc_to - &nowo) + 0.2);
  while ( $lc_lft > 0.5 )
  {
    system("echo",": " . $lc_lft);
    if ( $lc_lft > 10.5 )
    {
      sleep(8);
      do_caf(30);
    }
    sleep(1);
    $lc_lft = int(($lc_to - &nowo) + 0.2);
  }
}

1;
