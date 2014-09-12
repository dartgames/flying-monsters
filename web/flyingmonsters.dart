import 'dart:html';
import 'dart:async';
import 'dart:math';

const int PLAYER_WIDTH = 64;
const int PLAYER_HEIGHT = 64;
const String PLAYER_RIGHT = "images/player_right.png";
const String PLAYER_LEFT = "images/player_left.png";

int playerX;
int playerY;
int score = 0;
int speed;

CanvasElement canvas;
ImageElement playerImage;

void update(Timer t) {
    playerX += speed; // update player's location
  
    // get a new player when the last one gone off screen
    if (playerX < (-PLAYER_WIDTH) || playerX > canvas.width) {
        newRandomPlayer();
    }

    draw();
}

void draw() {
    CanvasRenderingContext2D canvasContext = canvas.context2D;
  
    // draw background
    canvasContext.setFillColorRgb(0, 0, 255);
    canvasContext.fillRect(0, 0, 500, 500);
  
    // draw score in black at the top right of the screen
    String scoreText = "Score: $score";
    canvasContext.setFillColorRgb(0, 0, 0);
    canvasContext.fillText(scoreText, canvas.width - 100, 30);
  
    // draw player
    canvasContext.drawImageScaled(playerImage, playerX, playerY, PLAYER_WIDTH, PLAYER_HEIGHT);
}

void newRandomPlayer() {
    // if it's 1 it will go right, otherwise, left
    Random random = new Random();
  
    speed = random.nextInt(10) + 5; // random speed 5-14 pixels/frame
  
    playerY = random.nextInt(canvas.height - PLAYER_HEIGHT); // random y axis
  
    int leftOrRight = random.nextInt(2);
  
    if (leftOrRight == 1) {
        playerX = 0;
        playerImage.src = PLAYER_RIGHT;
    } else {
        playerX = canvas.width - PLAYER_WIDTH;
        playerImage.src = PLAYER_LEFT;
        speed = -speed; // move left, not right
    }
}

// when the canvas is clicked, check if the user hit a player
void clickHappened(MouseEvent me) {
    // check if click was within player space    
    int clickX = me.offset.x;
    int clickY = me.offset.y;
    
    if (clickX > playerX && clickY < playerX + PLAYER_WIDTH && clickY > playerY && clickY  < playerY + PLAYER_HEIGHT) {
        // we have a hit!
        score++;
        newRandomPlayer();
    }
}

void main() {
    canvas = querySelector("#myCanvas");
    canvas.onClick.listen(clickHappened);
    
    playerImage = new ImageElement();
    
    newRandomPlayer();

    // this timer will call update() approx. 60 times a second
    Timer t = new Timer.periodic(const Duration(milliseconds: 17), update);
}
