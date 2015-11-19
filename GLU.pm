package GLU;

use strict;
use warnings;
use base qw( Exporter );
  
my $ffi = $GL::ffi;

$ffi->attach( gluPerspective => ['GLdouble','GLdouble','GLdouble','GLdouble'] => 'void' );
  
our @EXPORT = (grep /^glu/i, keys %GLU::);

1;
