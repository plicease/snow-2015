use strict;
use warnings;
use 5.012;

package GLU {

  use base qw( Exporter );
  
  my $ffi = $GL::ffi;

  # GLU
  $ffi->attach( gluPerspective => ['GLdouble','GLdouble','GLdouble','GLdouble'] => 'void' );
  
  our @EXPORT = (grep /^glu/i, keys %GLU::);
}

1;
