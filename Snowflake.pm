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

  has arm_length => (
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
  
  sub draw_solid_cone {
    my($self, $radius, $height, $slices, $stacks) = @_;
    glutSolidCone($radius, $height, $slices, $stacks);
  }
  
  sub draw_twig {
    my($self, $base, $height, $sides) = @_;

    glPushMatrix();
      glRotated(-90.0, 1.0, 0.0, 0.0);
      glutSolidCone($base, $height, $sides, 5);
    glPopMatrix();
  }
  
  sub draw_arm {
    my($self, $size, $left, $count) = @_;
    
    glPushMatrix();

      glPushMatrix();

        glRotated(30, 0.0, 0.0, 1.0);
        $self->draw_arm($size/1.5, $size, int($count/2)) if $count > 1;
        $self->draw_twig(PINKIE_RADIUS, $size, 6);
        glRotated(-60, 0.0, 0.0, 1.0);
        $self->draw_arm($size/1.5, $size, int($count/2)) if $count > 1;
        $self->draw_twig(PINKIE_RADIUS, $size, 6);
        
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
      
      glEnable(GL_COLOR_MATERIAL);
      glEnable(GL_BLEND);
      glColor4d(0.60, 0.86, 1.0, 0.25);

      for(1..$self->num_twigs) {
        glPushMatrix();
        
          glRotated(360/$self->num_twigs*($_-1), 0.0, 0.0, 1.0);
          $self->draw_arm($self->pinkie_length/1.25, $self->arm_length/1.25, $self->segments);
          $self->draw_twig(ARM_RADIUS, $self->arm_length/1.25, 12);
        
        glPopMatrix();
      }
      
      glPushMatrix();
          
        glRotated(90, 1.0, 0.0, 0.0);
        $self->draw_arm($self->pinkie_length/1.25, $self->arm_length/1.25, $self->segments);
        glRotated(90, 0.0, 1.0, 0.0);
        $self->draw_arm($self->pinkie_length/1.25, $self->arm_length/1.25, $self->segments);
        $self->draw_twig(ARM_RADIUS, $self->arm_length/1.25, 12);
          
        glRotated(-180, 1.0, 0.0, 0.0);
        $self->draw_arm($self->pinkie_length/1.25, $self->arm_length/1.25, $self->segments);
        glRotated(90, 0.0, 1.0, 0.0);
        $self->draw_arm($self->pinkie_length/1.25, $self->arm_length/1.25, $self->segments);
        $self->draw_twig(ARM_RADIUS, $self->arm_length/1.25, 12);
          
      glPopMatrix();

      glDisable(GL_BLEND);
      glDisable(GL_COLOR_MATERIAL);
    
    glPopMatrix();
  }

}

1;
