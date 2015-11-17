use strict;
use warnings;
use 5.012;

package Snowflake {

  use Moose;
  use GL;
  
  use constant {
    ARM_RADIUS    => 0.05,
    PINKIE_RADIUS => 0.025,
  };
  
  has num_twigs     => (is => 'ro', isa => 'Num', required => 1 );
  has pinkie_length => (is => 'ro', isa => 'Num', required => 1  );
  has arm_length    => (is => 'ro', isa => 'Num', required => 1  );
  has segments      => (is => 'ro', isa => 'Int', required => 1  );
  has is_3d         => (is => 'ro', isa => 'Int', required => 1  );
  
  has $_ => (is => 'rw', isa => 'Num', default => 0.0 ) for qw( x y z );
  has $_ => (is => 'rw', isa => 'Num', default => 0.0 ) for qw( xspin yspin zspin );
  
  sub new_random {
    my($class, %other) = @_;
    $class->new(
      num_twigs     => int(rand 4) + 3,
      arm_length    => 1.0 + (rand),
      pinkie_length => 0.5 + (rand)/2.0,
      segments      => int(rand 4)+2,
      is_3d         => int(rand 3)+2,
      %other,
    );
  }
  
  sub draw_solid_cone {
    my($self, $radius, $height, $slices, $stacks) = @_;

    #state $q;
    #unless($q)
    #{
    #  $q = gluNewQuadric();
    #  gluQuadricDrawStyle($q, GLU_FILL);
    #  gluQuadricOrientation($q, GLU_OUTSIDE);
    #  gluQuadricNormals($q, GLU_SMOOTH);
    #  gluQuadricTexture($q, GL_FALSE);
    #}
    #
    #say "gluCylinder($q, $radius, 0.0, $height, $slices, $stacks);";
    #gluCylinder($q, $radius, 0.0, $height, $slices, $stacks);
    #glutSolidCone($radius, $height, $slices, $stacks);
    glEnable(GL_COLOR_MATERIAL);
    glutSolidCone($radius, $height, $slices, $stacks);
  }
  
  sub draw_twig {
    my($self, $height, $width, $sides) = @_;

    glPushMatrix();
      glRotated(-90.0, 1.0, 0.0, 0.0);
      $self->draw_solid_cone($width, $height, $sides, 5);
    glPopMatrix();
  }
  
  sub draw_arm {
    my($self, $size, $left, $count) = @_;
    
    glPushMatrix();

      glPushMatrix();

        glRotated(30, 0.0, 0.0, 1.0);
        $self->draw_arm($size/1.5, $size, int($count/2)) if $count > 1;
        $self->draw_twig($size, PINKIE_RADIUS, 6);
        glRotated(-60, 0.0, 0.0, 1.0);
        $self->draw_arm($size/1.5, $size, int($count/2)) if $count > 1;
        $self->draw_twig($size, PINKIE_RADIUS, 6);
        
      glPopMatrix();
      
      glTranslated(0.0, $left/($count*.75), 0.0);
      $self->draw_arm($size / 1.5, $left-$left/($count*.75), int($count-1)) if $count > 1;

    glPopMatrix();
  }

  sub draw {
    my($self) = @_;
    
    glPushMatrix();
    
      glTranslated($self->x, $self->y, $self->z);
      glRotated($self->xspin, 1.0, 0.0, 0.0);
      glRotated($self->yspin, 0.0, 1.0, 0.0);
      glRotated($self->zspin, 0.0, 0.0, 1.0);
      
      glColor4d(0.60, 0.86, 1.0, 0.25);
      glEnable(GL_BLEND);

      for(1..$self->num_twigs) {
        glPushMatrix();
        
          glRotated(360/$self->num_twigs*($_-1), 0.0, 0.0, 1.0);
          $self->draw_arm($self->pinkie_length/1.25, $self->arm_length/1.25, $self->segments);
          $self->draw_twig($self->arm_length/1.25, ARM_RADIUS, 12);
        
        glPopMatrix();
      }
      
      if($self->is_3d) {
        glPushMatrix();
          
          glRotated(90, 1.0, 0.0, 0.0);
          $self->draw_arm($self->pinkie_length/1.25, $self->arm_length/1.25, $self->segments);
          glRotated(90, 0.0, 1.0, 0.0);
          $self->draw_arm($self->pinkie_length/1.25, $self->arm_length/1.25, $self->segments);
          $self->draw_twig($self->arm_length/1.25, ARM_RADIUS, 12);
          
          glRotated(-180, 1.0, 0.0, 0.0);
          $self->draw_arm($self->pinkie_length/1.25, $self->arm_length/1.25, $self->segments);
          glRotated(90, 0.0, 1.0, 0.0);
          $self->draw_arm($self->pinkie_length/1.25, $self->arm_length/1.25, $self->segments);
          $self->draw_twig($self->arm_length/1.25, ARM_RADIUS, 12);
          
        glPopMatrix();
      }
      
      glDisable(GL_BLEND);
    
    glPopMatrix();
  }

}

1;
