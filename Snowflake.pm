use strict;
use warnings;
use 5.012;

package Snowflake {

  use Moose;

  with 'SnowflakeModel';
  with 'SnowflakeDraw';

  sub spin {
    my($self, $xdelta, $ydelta, $zdelta) = @_;
    $self->xspin($self->xspin+$xdelta);
    $self->yspin($self->yspin+$ydelta);
    $self->zspin($self->zspin+$zdelta);
  }
  
}

1;
