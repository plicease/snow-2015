use strict;
use warnings;
use 5.012;
use GL;
use Snowflake;

glutInit(@ARGV);
glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
#glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);
glutInitWindowSize(500,500);
glutCreateWindow('snowflake');
glLightfv(GL_LIGHT0, GL_DIFFUSE, [1.0, 0.0, 0.0, 1.0]);
glLightfv(GL_LIGHT0, GL_POSITION, [1.0, 1.0, 1.0, 0.0]);
glEnable(GL_LIGHT0);
glEnable(GL_LIGHTING);
glEnable(GL_CULL_FACE);
glShadeModel(GL_SMOOTH);
glClearColor(0.0, 0.0, 0.0, 0.0);
glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

glEnable(GL_DEPTH_TEST);


my $flake = Snowflake->new_random( z => -5.0 );

sub display {
  say "draw";

  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  glLoadIdentity();

  glPushMatrix();
    glTranslated(0.0, 0.0, -10.0);
    #glRotatef($x_rotated, 1.0, 0.0, 0.0);
    #glRotatef($y_rotated, 0.0, 1.0, 0.0);
    #glRotatef($z_rotated, 0.0, 0.0, 1.0);
    glScaled(2.0, 1.0, 1.0);
    #glutSolidCube(1.0);
  glPopMatrix();
  
  $flake->draw;

  glFlush();
  glutSwapBuffers();
}

sub idle {
  $flake->xspin($flake->xspin + 0.3);
  $flake->yspin($flake->xspin + 0.6);
  glutPostRedisplay();
}

sub reshape {
  my($x, $y) = @_;
  exit if $x == 0 || $y == 0;

  say "reshape";
  
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluPerspective(30.0, $x / $y, 0.5, 20.0);
  glMatrixMode(GL_MODELVIEW);
  glViewport(0, 0, $x, $y);
}

glutDisplayFunc(\&display);
glutIdleFunc(\&idle);
glutReshapeFunc(\&reshape);
glutMainLoop();


