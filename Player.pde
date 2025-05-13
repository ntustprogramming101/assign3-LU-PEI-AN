// Player Class: Represents the player in the game
class Player {
  float x, y, w = 30, h = 60, xSpeed = 5, ySpeed = 0, gravity = 0.4; // Position, size, speed, and physics
  int health = PLAYER_HEALTH; // Player's health
  int moveDir = 0; // Movement direction, 0=idle, 1=right, -1=left
  int spriteIndex = 0; // sprite index: 0=idle, 1=left, 2=right
  int animatedFrameIndex = 0; // animated frame index for the sprite
  boolean invincible = true, damaged = false; // Flags for invincibility and damage states
  int invincibilityTimer = INVINCIBILITY_DURATION, damageTimer = 0; // Timers for invincibility and damage
  float feetOffset = 5; // Offset for feet collision detection

  Player() {
    x = width / 2; // Start the player in the middle of the screen
    y = 0; // Start the player at the top of the screen
  }

  void update() {
    if (health <= 0) return; // Stop updating if the player is dead
    
    if (moveDir != 0) {
      x += moveDir * xSpeed; // Move the player horizontally
      x = constrain(x, 0, width - w); // Keep the player within the screen bounds
    }
    ySpeed += gravity; // Apply gravity to the player's ySpeed
    y += ySpeed; // Update the player's vertical position

    handlePlatformCollision(); // Check for collisions with platforms
    handleCeilingBottomCollision(); // Check for collisions with the ceiling and bottom of the screen
    handleInvincibleAndDamage(); // Handle invincibility and damage states
    updateAnimation(); // Update the player's animation
  }

  // Stage 2-2: Check for collisions with platforms
  void handlePlatformCollision() {
    for (Platform p : platforms) {
        if (x + w > p.x && x < p.x + p.w && y + h - feetOffset >= p.y && y + h <= p.y + p.h && ySpeed >= 0) { 
             y = p.y - h + feetOffset;
              ySpeed = 0; 
               y += p.speed;
           }
    }
}

  // End of stage 2-2

  boolean AABB(float ax, float ay, float aw, float ah, float bx, float by, float bw, float bh) {
    // Axis-Aligned Bounding Box (AABB) collision detection
    return (ax < bx + bw && ax + aw > bx && ay < by + bh && ay + ah > by);
  }

  // Stage 2-3: handle ceiling and bottom collisions
  void handleCeilingBottomCollision() {
   
    if (y <= 0) {
    y = 0; 
    if (!invincible && !damaged) {
      health -= 1; 
      damaged =true;
      damageTimer = DAMAGE_BLINK_DURATION;
    }
  }

 
  if (y > height) {
    y = 0;
   
    if (!invincible && !damaged) {
      health -= 1;
       damaged =true;
      damageTimer = DAMAGE_BLINK_DURATION;
      damaged =true;
      damageTimer = DAMAGE_BLINK_DURATION;
    }

  }

    // Stage 3-2: 
    // This block checks if the player is not invincible and not already in a damaged state:
    // - If both conditions are true, the player's health is reduced by 1.
    // - The player is then marked as damaged, and the damage timer is set to the predefined
    //   DAMAGE_BLINK_DURATION. This ensures the player enters a temporary "damaged" state
    //   with visual feedback (e.g., blinking effect) and avoids taking consecutive damage
    //   immediately.
    
    // End of stage 3-2
  }
  // End of stage 2-3

  // Stage 3-1: handle invincibility and damage states
  void handleInvincibleAndDamage() {
    // This block handles the player's invincibility and damage states:
    // - If the player is invincible, the invincibility timer decreases each frame.
    //   Once the timer reaches 0, the player is no longer invincible.
    // - If the player is in a damaged state, the damage timer decreases each frame.
     //   Once the timer reaches 0, the damaged state is cleared.
     // These timers ensure that the player has temporary protection after taking damage
    // and provides visual feedback (e.g., blinking effect) during these states.

    if (invincible){
      damaged = false;
      invincibilityTimer--;
      tint(255,126); 
  
    if (invincibilityTimer <= 0) {
            invincible = false;  
              noTint(); 
    }
    } else {
      if (damaged) {
      damageTimer--;
        tint(255, 0, 0); 
 if (damageTimer <= 0) {
        damaged = false; 
        damageTimer = DAMAGE_BLINK_DURATION; 
        }
    } else {
      noTint(); 
    }
    }
  }
  // End of stage 3-1

  // Stage 3-3: Cycle through animation frames based on timer
  void updateAnimation() {
   if (moveDir == 0) {
    
    spriteIndex = 0;
    animatedFrameIndex = 0;
  } else if (moveDir == -1) {
   
    spriteIndex = 1;
    animatedFrameIndex = (frameCount / 10) % 2; 
  } else if (moveDir == 1) {
   
    spriteIndex = 2;
    animatedFrameIndex = (frameCount / 10) % 2; 
      }    
  }
  // End of stage 3-3

  void display() {
    PImage currentImage = playerSprites[spriteIndex][animatedFrameIndex];
    if (invincible && frameCount % 20 < 10) {
      tint(255, 126);
    } else if (damaged && frameCount % 10 < 5) {
      tint(255, 0, 0);
    } else {
      noTint();
    }
    image(currentImage, x, y, w, h);
    noTint();
  }

  void setMovement(int dir) {
    // Set the movement direction
    moveDir = dir;
    // Update the sprite index based on direction
    spriteIndex = (moveDir < 0) ? 1 : (moveDir > 0) ? 2 : 0;
  }

  void forceDropToBottom() {
    ySpeed += gravity; // Apply gravity to the player's velocity
    y += ySpeed; // Update the player's vertical position
    if (y > height) {
      y = height;
    }
  }

}
