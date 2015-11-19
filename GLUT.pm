package GLUT;

use strict;
use warnings;
use 5.010;
use GL ();
use base qw( Exporter );
  
use constant {
  GLUT_RGB      => 0x0000,
  GLUT_DOUBLE   => 0x0002,
  GLUT_DEPTH    => 0x0010,
};

my $ffi = $GL::ffi;
  
$ffi->load_custom_type('FFI::Platypus::Type::StringArray' => 'string_array');

$ffi->attach( glutInit => ['int*', 'string_array' ] => 'void' => sub {
  my($xsub, @args) = @_;
  my $size = scalar @args;
  $xsub->(\$size, \@args);
});
  
$ffi->attach( glutInitDisplayMode => ['unsigned int'] => 'void' );
$ffi->attach( glutInitWindowSize  => ['int', 'int']   => 'void' );
$ffi->attach( glutCreateWindow    => ['string']       => 'int'  );
$ffi->attach( glutMainLoop        => [ ] => 'void' );
$ffi->attach( glutSwapBuffers     => [] => 'void' );
$ffi->attach( glutPostRedisplay   => [] => 'void' );
$ffi->attach( glutSolidCone        => [ 'GLdouble', 'GLdouble', 
                                        'GLint', 'GLint' ] => 'void' );
  
$ffi->attach( glutDisplayFunc => [ '()->void' ] => 'void' => sub {
  my($xsub, $callback) = @_;
  state $closure = $ffi->closure($callback);
  $xsub->($closure);
});

$ffi->attach( glutIdleFunc => [ '()->void' ] => 'void' => sub {
  my($xsub, $callback) = @_;
  state $closure = $ffi->closure($callback);
  $xsub->($closure);
});

$ffi->attach( glutReshapeFunc => [ '(int,int)->void' ] => 'void' => sub {
  my($xsub, $callback) = @_;
  state $closure = $ffi->closure($callback);
  $xsub->($closure);
});
  
our @EXPORT = (grep /^(GLUT_|glut)/i, keys %GLUT::);

1;
