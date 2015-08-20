package argola;
use strict;

my @argbuft;
my @argbufp;
my $versono;
my $resorco;
my %opthash = {};
my @optlist = ();

@argbuft = @ARGV;
$versono = &getrg;
$resorco = &getrg;
@argbufp = @argbuft;


sub getrg {
  my $lc_a;
  my $lc_ret;
  $lc_a = @argbuft;
  $lc_ret = "";
  if ( $lc_a > 0.5 ) { $lc_ret = shift(@argbuft); }
  return $lc_ret;
}

sub remrg {
  return @argbuft;
}

sub setopt {
  @optlist = ( @optlist, $_[0] );
  $opthash{$_[0]} = $_[1];
}

sub runopts {
  my $lc_crg;
  my $lc_ech;
  my $lc_found;
  my $lc_mth;
  while ( &yet )
  {
    $lc_crg = &getrg;
    $lc_found = 0;
    foreach $lc_ech (@optlist)
    {
      if ( $lc_ech eq $lc_crg )
      {
        $lc_mth = $opthash{$lc_ech};
        $lc_found = 10;
      }
    }
    if ( $lc_found < 5 )
    {
      die "\n" . $_[0] . ": FATAL ERROR:\nUnknown Option: " . $lc_crg . ":\n\n";
    }
    &$lc_mth;
  }
}

sub rset {
  @argbuft = @argbufp;
}

sub vrsn {
  return $versono;
}

sub srcd {
  return $resorco;
}

sub yet {
  my $lc_a;
  $lc_a = @argbuft;
  return ( $lc_a > 0.5 );
}

sub remo {
  my @lc_tua;
  @lc_tua = @argbuft;
  @argbuft = ();
  return @lc_tua;
}

sub wrparg_bsc {
  my $lc_ret;
  my $lc_src;
  my $lc_chr;
  $lc_src = scalar reverse $_[0];
  $lc_ret = "\'";
  while ( $lc_src ne "" )
  {
    $lc_chr = chop($lc_src);
    if ( $lc_chr eq "\'" ) { $lc_chr = "\'\"\'\"\'"; }
    $lc_ret .= $lc_chr;
  }
  $lc_ret .= "\'";
  return $lc_ret;
}

sub wraprg_lst {
  my $lc_ret;
  my $lc_rem;
  my @lc_ray;
  @lc_ray = @_;
  $lc_rem = @lc_ray;
  if ( $lc_rem < 0.5 ) { return; }
  $lc_ret = shift(@lc_ray); $lc_rem = @lc_ray;
  while ( $lc_rem > 0.5 )
  {
    $lc_ret .= " " . &wrparg_bsc(shift(@lc_ray));
    $lc_rem = @lc_ray;
  }
  $_[0] = $lc_ret;
}



1;
