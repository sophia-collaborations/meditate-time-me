package chobak_hook;
use strict;
# Each hook-point is a hash-ref
# Each hook is an array referenced from the therein-referenced hash
#
# Syntax for declaring a modules hook:
#   my $hooks = {};
#
# Syntax for adding to hook "foo" in module "bar":
#   &chobak_hook::addhk($foo::hooks,"bar",\&bar_handler);
#
# A hook is simply an array of functions that should be called one
# after another in a given situation. How (if at all) the functions
# within a hook relate to each other should be determined by the
# module in which the hook is contained --- and any module that
# adds functions to a hook should add only functions designed to
# be used in a manner appropriate to that specific hook.
#   I would like to somehow enforce that with this module -- but
# that would take lots of code if it were possible at all. Instead,
# I must simply appeal to the good behavior of those who use this
# module.

sub addhk {
  my @lc_arrayo;
  my $lc_aryref;
  my $lc_count;
  
  if ( ref($_[0]) ne "HASH" ) { return -1; }
  @lc_arrayo = ();
  if ( ref($_[0]->{$_[1]}) ne "ARRAY" )
  {
    $_[0]->{$_[1]} = \(@lc_arrayo,@lc_arrayo);
  }
  
  $lc_aryref = $_[0]->{$_[1]};
  $lc_count = @$lc_aryref;
  
  @$lc_aryref = (@$lc_aryref,$_[2]);
  
  return $lc_count;
}

sub fsquen {
  my @lc_rgl;
  my $lc_cnt;
  my $lc_hooks;
  my $lc_hookid;
  my $lc_kval;
  my $lc_hookref;
  my $lc_item;
  
  @lc_rgl = @_;
  $lc_cnt = @lc_rgl;
  if ( $lc_cnt < 2.5 ) { return ( 1 > 2 ); }
  $lc_hooks = shift(@lc_rgl);
  $lc_hookid = shift(@lc_rgl);
  $lc_kval = shift(@lc_rgl);
  if ( ref($lc_hooks) ne "HASH" ) { return ( 1 > 2 ); }
  
  $lc_hookref = $lc_hooks->{$lc_hookid};
  if ( ref($lc_hookref) ne "ARRAY" ) { return $lc_kval; }
  
  foreach $lc_item (@$lc_hookref)
  {
    if ( ref($lc_item) eq "CODE" )
    {
      $lc_kval = &$lc_item($lc_kval,@lc_rgl);
    }
  }
  return $lc_kval;
}


1;
