use strict;
use warnings;
use 5.012;

package GL {

  use FFI::Platypus;
  use FFI::CheckLib qw( find_lib_or_die );
  use base qw( Exporter );
  
  use constant {
    GL_SMOOTH              => 0x1D01,
    GL_DEPTH_TEST          => 0x0B71,
    GL_BLEND               => 0x0BE2,
    GL_TRUE                => 0,
    GL_FALSE               => 0,
    GL_LIGHTING            => 0x0B50,
    GL_LIGHT0              => 0x4000,
    GL_DIFFUSE             => 0x1201,
    GL_POSITION            => 0x1203,
    GL_COLOR_BUFFER_BIT    => 0x00004000,
    GL_DEPTH_BUFFER_BIT    => 0x00000100,
    GL_CULL_FACE           => 0x0B44,
    GL_PROJECTION          => 0x1701,
    GL_MODELVIEW           => 0x1700,
    GL_SRC_ALPHA           => 0x0302,
    GL_ONE_MINUS_SRC_ALPHA => 0x0303,
    GL_COLOR_MATERIAL      => 0x0B57,

    #GLU_FILL      => 100012,
    #GLU_OUTSIDE   => 100020,
    #GLU_SMOOTH    => 100000,

    GLUT_RGB      => 0x0000,
    GLUT_DOUBLE   => 0x0002,
    GLUT_DEPTH    => 0x0010,
  };
  
  my $ffi = FFI::Platypus->new(
    lib => [
      $^O eq 'darwin' ? (
        "/System/Library/Frameworks/OpenGL.framework/Libraries/libGL.dylib",
        "/System/Library/Frameworks/OpenGL.framework/Libraries/libGLU.dylib",
        "/System/Library/Frameworks/GLUT.framework/GLUT",
      ) : (
        find_lib_or_die(lib => 'glut'),
        find_lib_or_die(lib => 'GLU'),
        find_lib_or_die(lib => 'GL'),
      )
    ],
  );

  $ffi->load_custom_type('::StringArray' => 'string_array');
  $ffi->type('unsigned int' => 'GLenum');
  $ffi->type('unsigned char' => 'GLboolean');
  $ffi->type('int' => 'GLint');
  $ffi->type('double' => 'GLdouble');
  #$ffi->type('opaque' => 'GLUquadric');
  $ffi->type('float[]' => 'GLfloat_array');
  $ffi->type('unsigned int' => 'GLbitfield');
  $ffi->type('int' => 'GLsizei');

  # GL
  $ffi->attach( glShadeModel => ['GLenum'] => 'void' );
  $ffi->attach( glEnable     => ['GLenum'] => 'void' );
  $ffi->attach( glDisable    => ['GLenum'] => 'void' );
  $ffi->attach( glPushMatrix => [] => 'void' );
  $ffi->attach( glPopMatrix  => [] => 'void' );
  $ffi->attach( glFlush      => [] => 'void' );
  $ffi->attach( glRotated    => [ 'GLdouble', 'GLdouble', 'GLdouble', 'GLdouble' ] => 'void' );
  $ffi->attach( glTranslated => ['GLdouble', 'GLdouble', 'GLdouble' ] => 'void' );
  $ffi->attach( glColor4d    => [ 'GLdouble', 'GLdouble', 'GLdouble', 'GLdouble' ] => 'void' );
  $ffi->attach( glColor3d    => [ 'GLdouble', 'GLdouble', 'GLdouble' ] => 'void' );
  $ffi->attach( glLightfv => [ 'GLenum', 'GLenum', 'GLfloat_array' ] => 'void' );
  $ffi->attach( glClear => [ 'GLbitfield' ] => 'void' );
  $ffi->attach( glLoadIdentity => [] => 'void' );
  $ffi->attach( glScaled => [ 'GLdouble', 'GLdouble', 'GLdouble' ] => 'void' );
  $ffi->attach( glClearColor => ['float', 'float', 'float', 'float' ] => 'void' );
  $ffi->attach( glMatrixMode => [ 'GLenum' ] => 'void' );
  $ffi->attach( glViewport => [ 'GLint', 'GLint', 'GLsizei', 'GLsizei' ] => 'void' );
  $ffi->attach( glBlendFunc => [ 'GLenum', 'GLenum' ] => 'void' );

  # GLU
  #$ffi->attach( gluNewQuadric => [] => 'GLUquadric' );
  #$ffi->attach( gluQuadricDrawStyle => ['GLUquadric','GLenum'] => 'void' );
  #$ffi->attach( gluQuadricOrientation => ['GLUquadric','GLenum'] => 'void' );
  #$ffi->attach( gluQuadricNormals => ['GLUquadric','GLenum'] => 'void' );
  #$ffi->attach( gluQuadricTexture => ['GLUquadric','GLboolean'] => 'void' );
  #$ffi->attach( gluCylinder => ['GLUquadric', 'GLdouble', 'GLdouble', 'GLint', 'GLint'] => 'void' );
  $ffi->attach( gluPerspective => ['GLdouble','GLdouble','GLdouble','GLdouble'] => 'void' );
  
  # GLUT
  $ffi->attach( [ glutInit => '_glutInit' ] => ['int*', 'string_array' ] => 'void' );
  
  sub glutInit {
    my $size = scalar @_;
    _glutInit(\$size, \@_);
  }
  
  $ffi->attach( glutInitDisplayMode => ['unsigned int'] => 'void' );
  $ffi->attach( glutInitWindowSize  => ['int', 'int']   => 'void' );
  $ffi->attach( glutCreateWindow    => ['string']       => 'int'  );
  $ffi->attach( glutMainLoop        => [ ] => 'void' );
  $ffi->attach( glutSwapBuffers     => [] => 'void' );
  $ffi->attach( glutPostRedisplay   => [] => 'void' );
  #$ffi->attach( glutSolidCube       => [ 'GLdouble' ] => 'void' );
  #$ffi->attach( glutSolidCone       => [ 'GLdouble', 'GLdouble', 'GLint', 'GLint' ] => 'void' );
  #$ffi->attach( glutWireCube        => [ 'GLdouble' ] => 'void' );
  $ffi->attach( glutSolidCone        => [ 'GLdouble', 'GLdouble', 'GLint', 'GLint' ] => 'void' );
  
  $ffi->attach( glutDisplayFunc     => [ '()->void' ]        => 'void' => sub {
    my($xsub, $callback) = @_;
    state $closure = $ffi->closure($callback);
    $xsub->($closure);
  });
  $ffi->attach( glutIdleFunc        => [ '()->void' ]        => 'void' => sub {
    my($xsub, $callback) = @_;
    state $closure = $ffi->closure($callback);
    $xsub->($closure);
  });
  $ffi->attach( glutReshapeFunc     => [ '(int,int)->void' ] => 'void' => sub {
    my($xsub, $callback) = @_;
    state $closure = $ffi->closure($callback);
    $xsub->($closure);
  });
  #$ffi->attach( glutMotionFunc      => [ '(int,int)->void' ] => 'void' => sub {
  #  my($xsub, $callback) = @_;
  #  state $closure = $ffi->closure($callback);
  #  $xsub->($closure);
  #});
  
  our @EXPORT = (grep /^gl/i, keys %GL::);
}

1;
