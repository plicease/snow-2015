use strict;
use warnings;
use 5.012;
use GL;
use Snowflake;

glutInit(@ARGV);
glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
glutInitWindowSize(1500,500);
glutCreateWindow('snowflake');
glLightfv(GL_LIGHT0, GL_DIFFUSE, [1.0, 1.0, 1.0, 1.0]);
glLightfv(GL_LIGHT0, GL_POSITION, [1.0, 1.0, 1.0, 0.0]);
glEnable(GL_LIGHT0);
glEnable(GL_LIGHTING);
glEnable(GL_CULL_FACE);
glShadeModel(GL_SMOOTH);
glClearColor(1.0, 1.0, 1.0, 0.0);
glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

glEnable(GL_DEPTH_TEST);


my @flakes = (
  Snowflake->new_random( z => -5.0, x => +2.0 ),
  Snowflake->new_random( z => -5.0, x => +0.0 ),
  Snowflake->new_random( z => -5.0, x => -2.0 ),
);

sub display {

  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  glLoadIdentity();

  $_->draw for @flakes;

  glFlush();
  glutSwapBuffers();
}

sub idle {
  $flakes[0]->xspin($flakes[0]->xspin + 0.3);
  $flakes[0]->yspin($flakes[0]->yspin + 0.6);

  $flakes[1]->xspin($flakes[1]->xspin + 0.3);
  $flakes[1]->zspin($flakes[1]->zspin + 0.6);

  $flakes[2]->yspin($flakes[2]->yspin + 0.3);
  $flakes[2]->zspin($flakes[2]->zspin + 0.6);

  glutPostRedisplay();
}

sub reshape {
  my($x, $y) = @_;
  exit if $x == 0 || $y == 0;

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


