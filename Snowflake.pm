use strict;
use warnings;
use 5.012;

package Snowflake {

  use Moose;

  with 'SnowflakeModel';
  with 'SnowflakeDraw';
  
}

1;
