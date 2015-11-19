use strict;
use warnings;
use Path::Class qw( file );

open my $out, '>', 'README.pod';

open my $in, '<', 'thetext.pod';
while(<$in>)
{
  if(/^# include: (.*)$/)
  {
    print $out map { " $_" } file($1)->slurp;
  }
  else
  {
    print $out $_;
  }
}
close $in;
