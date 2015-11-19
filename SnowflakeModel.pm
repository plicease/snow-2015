package SnowflakeModel;

use Moose::Role;
  
has num_twigs => (
  is => 'ro', 
  isa => 'Num', 
  default => sub { int(rand 4) + 3 },
);

has pinkie_length => (
  is => 'ro',
  isa => 'Num',
  default => sub { 0.5 + (rand)/2.0 }
);

has branch_length => (
  is => 'ro',
  isa => 'Num',
  default => sub { 1.0 + (rand) },
);
  
has segments => (
  is => 'ro',
  isa => 'Int',
  default => sub { int(rand 4) + 2 },
);
  
has $_ => (is => 'rw', isa => 'Num', default => 0.0 )
  for qw( x y z );
  
has $_ => (is => 'rw', isa => 'Num', default => 0.0 )
  for qw( xspin yspin zspin );

1;
