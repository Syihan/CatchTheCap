import ddf.minim.*;

/* VARIABLES */

// Control the game's settings
int gameScreen = 0;  //0: Initial Screen; 1: Game;
int score = 0;
int highscore = score;

// Control the game's aesthetics and music
PImage TITLE_SCREEN;
PImage BACKGROUND;
AudioPlayer PLAYER;
Minim MINIM;

// Control the cap's characteristics
PImage CAP_IMAGE;
int CAP_WIDTH = 150;
int CAP_HEIGHT = 172;
int capX, capY;

// Control the cap's movements
float GRAVITY = 0.25;
float AIR_RESISTANCE = 0.001;
float cap_yspeed = random (0, 5) * randomDirection();
float cap_xspeed = random(1, 10);

// These variables control the racket's characteristics
PImage HAND_IMAGE;
float HAND_DIMENSIONS = 150;

/* SETUP */

// This method sets up the screen
void setup() {
  size(1280, 720);
  capX = width / 4;
  capY = height / 5;
  MINIM = new Minim(this);
  PLAYER = MINIM.loadFile("Pomp and Circumstance.wav", 2048);
  TITLE_SCREEN = loadImage("Title Screen.png");
  BACKGROUND = loadImage("Background.png");
  HAND_IMAGE = loadImage("Hand.png");
  CAP_IMAGE = loadImage("Cap.png");
}


/* DRAW */

// This moment is continuously used to draw and update the screen
void draw() {
  // Display the contents of the current screen
  if (gameScreen == 0) {
    initScreen();
  } else if (gameScreen == 1) {
    gameScreen();
  }
  loopSong();
}


/* SCREENS */

// This sets up the initial screen
void initScreen() {
  image(TITLE_SCREEN, 0, 0);
}

// This sets up the game
void gameScreen() {
  image(BACKGROUND, 0, 0);
  drawCap();
  setGravity();
  setXSpeed();
  setBoundaries();
  drawHand();
  hitHand();
  drawScore();
}


/* INPUTS */

// Controls the mouse button input
public void mousePressed() {
  // Start the game when the mouse is pressed
  if (gameScreen==0) {
    startGame();
  }
}


/* GAME METHODS */

// Sets the necessery variables to start the game  
void startGame() {
  gameScreen=1;
}

// Draws the cap
void drawCap() {
  image(CAP_IMAGE, capX - (CAP_WIDTH/2), capY - (CAP_HEIGHT/2), 150, 172);
}

// Applies gravity
void setGravity() {
  cap_yspeed += GRAVITY;
  capY += cap_yspeed;
  // cap_yspeed -= (cap_yspeed * AIR_RESISTANCE);
}

// Resets the cap to the top if it falls
void resetCap(int surface) {
  capY = surface-(CAP_HEIGHT/2);
  cap_yspeed*=-1;
  score++;
  if (highscore < score) highscore = score;
}

// Tells the cap what to do when it hits the screen boundaries
void setBoundaries() {
  // Cap misses the racket
  if (capY-(CAP_HEIGHT/2) > height) { 
    // Resets the cap to begin at the top of the screen and randomizes its speed
    capY = 0;
    capX = (int)random (0, width);
    cap_yspeed = random (0, 5);
    cap_xspeed = random (1, 10) * randomDirection();
    // Diminishes 5 points every time the ball misses the racket
    if (highscore < score) highscore = score;
    score = 0;
  }
  // Cap hits ceiling
  if (capY-(CAP_HEIGHT/2) < 0) {
    topBounce(0);
  }
  // Cap hits the left wall
  if (capX-(CAP_WIDTH/2) < 0){
    leftBounce(0);
  }
  // Ball hits the right wall
  if (capX+(CAP_WIDTH/2) > width){
    rightBounce(width);
  }
}

// Draws the hand
void drawHand() {
  image(HAND_IMAGE, mouseX - (HAND_DIMENSIONS/2), height - 150, HAND_DIMENSIONS, HAND_DIMENSIONS);
}

// Causes cap to bounce off of hand
void hitHand() {
  //If the ball is in the same area as the racket
  if ((capX+(CAP_WIDTH/2) > mouseX-(HAND_DIMENSIONS/2)) && (capX-(CAP_WIDTH/2) < mouseX+(HAND_DIMENSIONS/2))) {
    //If the ball is above the racket
    if (capY >= height - 100) {
      //Make the ball bounce on top of the racket
      resetCap(height - 100);
    }
  }
}

// Sets the horizontal speed
void setXSpeed() {
  capX += cap_xspeed;
  //cap_xspeed -= cap_xspeed;
}

// Chooses between left and right movement
int randomDirection() {
  int direction = 1;
  int choice = round(random(0, 1));
  if (choice == 0) direction = -1;
  else direction = 1;
  return direction;
}

// Bounces the cap if it hits the top
void topBounce(int surface) {
  capY = surface+(CAP_HEIGHT/2);
  cap_yspeed*=-1;
}

// Bounces the cap if it hits the left wall
void leftBounce(int surface){
  capX = surface+(CAP_WIDTH/2);
  cap_xspeed*=-1;
}

// Bounces the cap if it hits the right wall
void rightBounce(int surface){
  capX = surface-(CAP_WIDTH/2);
  cap_xspeed*=-1;
}

// Updates the score and high score on the screen
void drawScore() {
  fill(255, 255, 255);
  textSize(50);
  textAlign(RIGHT);
  text("High Score: " + highscore, width - 50, 60);
  text("Current Score: " + score, width - 50, 120);
}

// Constantly loops the song
void loopSong() {
  if (!PLAYER.isPlaying()) {
    PLAYER.rewind();
    PLAYER.play();
  }
}