use strict;
use warnings;
use 5.012;

package SnowflakeDraw {

  use Moose::Role;
  use GL;
  use GLUT;
  
  requires qw( 
    num_twigs pinkie_length branch_length segments
    x y z xspin yspin zspin
  );
  
  sub draw_twig {
    my($self, $base, $height, $sides) = @_;

    glPushMatrix();
      glRotated(-90.0, 1.0, 0.0, 0.0);
      glutSolidCone($base, $height, $sides, 5);
    glPopMatrix();
  }
  
  sub draw_branch {
    my($self, $size, $left, $segments) = @_;

    $segments //= $self->segments;
    
    glPushMatrix();

      glPushMatrix();

        glRotated(30, 0.0, 0.0, 1.0);
        $self->draw_branch($size/1.5, $size, int($segments/2)) if $segments > 1;
        $self->draw_twig(0.025, $size, 6);
        glRotated(-60, 0.0, 0.0, 1.0);
        $self->draw_branch($size/1.5, $size, int($segments/2)) if $segments > 1;
        $self->draw_twig(0.025, $size, 6);
        
      glPopMatrix();
      
      glTranslated(0.0, $left/($segments*.75), 0.0);

      $self->draw_branch(
        $size / 1.5,
        $left-$left/($segments*.75), 
        int($segments-1)
      ) if $segments > 1;

    glPopMatrix();
  }

  sub draw {
    my($self) = @_;
    
    glPushMatrix();
    
      glTranslated($self->x, $self->y, $self->z);
      glRotated($self->xspin, 1.0, 0.0, 0.0);
      glRotated($self->yspin, 0.0, 1.0, 0.0);
      glRotated($self->zspin, 0.0, 0.0, 1.0);
      
      glEnable(GL_COLOR_MATERIAL);
      glEnable(GL_BLEND);
      glColor4d(0.60, 0.86, 1.0, 0.35);

      for(1..$self->num_twigs) {
        glPushMatrix();
        
          glRotated(360/$self->num_twigs*($_-1), 0.0, 0.0, 1.0);
          $self->draw_branch($self->pinkie_length/1.25, $self->branch_length/1.25);
          $self->draw_twig(0.05, $self->branch_length/1.25, 12);
        
        glPopMatrix();
      }
      
      glPushMatrix();
          
        glRotated(90, 1.0, 0.0, 0.0);
        $self->draw_branch($self->pinkie_length/1.25, $self->branch_length/1.25);
        glRotated(90, 0.0, 1.0, 0.0);
        $self->draw_branch($self->pinkie_length/1.25, $self->branch_length/1.25);
        $self->draw_twig(0.05, $self->branch_length/1.25, 12);
          
        glRotated(-180, 1.0, 0.0, 0.0);
        $self->draw_branch($self->pinkie_length/1.25, $self->branch_length/1.25);
        glRotated(90, 0.0, 1.0, 0.0);
        $self->draw_branch($self->pinkie_length/1.25, $self->branch_length/1.25);
        $self->draw_twig(0.05, $self->branch_length/1.25, 12);
          
      glPopMatrix();

      glDisable(GL_BLEND);
      glDisable(GL_COLOR_MATERIAL);
    
    glPopMatrix();
  }

}

1;
