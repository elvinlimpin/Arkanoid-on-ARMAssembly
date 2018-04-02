#### CPSC 359 – Winter 2018
#### Assignment 4 Raspberry Pi Video Game
70 points (Weight: 14%)
Due March 30th @11:59 PM

##### Objective
The objective of this assignment is to expose you to video programming
using ARM assembly on Raspberry Pi 3.
###### Game Objective
To implement a video game that requires a paddle at the bottom of
the screen move left and right preventing a ball from falling off the playing ground. If the
ball hits a brick, the brick disappears. It will bounce off if it hits a wall, a brick or a
paddle. To win, all bricks must disappear.

####

#### Game Logic
The game environment is a finite 2D n x m grid.

- A game map is an instance of the game environment (for a value of n & m > 20)
- Specifies the score of the player.
- Specifies number of lives left (starting with a minimum of 3 lives).
- Each cell of the grid is either a brick tile, wall tile, or a floor tile.
- The cells on the right, left and the upper edge of the map are filled with wall tiles.
- Use at least 10 of each brick type.
- A game state is a representation of the game as it is being played, and contains: Score: 0, Lives: 3, Bricks, Value-Pack, Paddle, End Wall Tiles, Paddle, Inside Floor Tiles, Ball
- An instance of a game map.
- Paddle’s position on the game map (initialized to a starting position).
- Ball’s position, angle & direction on the game map, with initial position on top middle of the paddle, initial 45º angle and initial right/upward direction.
- The score collected by the player (initialized to zero).
- Number of lives left.
- A win condition flag.
- A lose condition flag.

#### Bricks
- 3 types of bricks must be present in the game. Types are differentiated in
hardness of breaking.

#### Value-Packs
- Value-packs are hidden under brick tiles. Breaking the brick tile will reveal them.
- You must implement at least two types of value-packs that adds some feature to
the game. Choose two from:
§ Speed down the ball.
§ Catch the ball and shoot when you want to.
§ Expand the paddle.
- You may get extra marks for additional creative value-packs.
- You are required to implement only 1 of each type.

### The game transitions into a new state when
- Ball moves on the screen (the position of the ball will change periodically
according to angle & direction).
- Ball Bouncing: the ball changes direction upon collision
- Ball will only reverse direction if in contact with wall or brick tiles (horizontally or vertically).

#### If in contact with a paddle
- If striking left/right end, it bounces upwards and left/right at ~45º angle.
- If striking inside left/right, it bounces in the same horizontal direction at
~60º angle (you don’t need to get exact angle, only need to approximate).
- The player collects points when the ball contact bricks objects. Initial score is
zero.
- If the Ball fell off the screen, player will lose an available life or set the lose flag.
- Paddle/Ball cannot pass through walls/bricks.
- When revealed, a value-pack must travel from top to bottom.

#### Action:
- Move in one of two cardinal directions (left, right) if action is valid. The move
results in the paddle’s position being set to the position of the destination cell.
- Moving paddle into a floor tile marked as value-pack will result in:
§ The overall score being incremented.
§ The removal of the value-pack marking on the destination floor tile.
§ Application of the feature effect. (The effect of a value-pack might be
permanent till end of the game).

#### Game ends when
- The user breaks all brick tiles (win).
- The user lives = zero (lose).
- The user decides to quit.
The game is over when either the win or lose condition flags is set in the game state

### Game Interface
#### Main Menu Screen
- The Main Menu interface is drawn to the screen
- Game title is drawn somewhere on the screen
- Creator name(s) drawn somewhere on the screen
- Menu options labeled “Start Game” and “Quit Game”
- A visual indicator of which option is currently selected
- The player uses the SNES controller to interact with the menu
- Select between options using Up and Down on the D-Pad
- Activate a menu item using the A button
- Activating Start Game will transition to the Game Screen
- Activating Quit Game will clear the screen and exit the game

#### Game Screen
- The current game state is drawn to the screen
- Represented as a 2D grid of cells
- All cells in the current game state are drawn to the screen
- Each cell is at least 32x32 pixels
- Each different tile type is drawn with a different visual representation ie: Paddle, brick, wall, floor, ball, etc. Minimally in color and shape.
- Bricks & value-packs of different types must be of different visual
representation. Minimally in color.
- Score and lives left are drawn on the screen

#### A label followed by the value for each field.
- If the “Win Condition” flag is set, display a “Game Won” message
- If the “Lose Condition” flag is set, display a “Game Lost” message
- Both messages should be prominent (ie: large, middle of game screen)

#### The player uses the SNES controller to interact with the game
- Pressing left or right on the D-Pad will attempt a move action
- Pressing B button will release the ball from initial position.
- Holding A button will increase the speed of the paddle.
- Performing a valid action will require the game state to be redrawn
- Pressing the Start button will open a 

#### Game Menu
- Two menu items: Restart Game and Quit
- Visually display menu option labels and a selector
- Menu drawn on a filled box with a border in the center of the game screen
- Normal game controls not processed when Game Menu is open
- Pressing Start button will close the Game Menu
- Press up and down on D-Pad to select between menu options
- Pressing the A button activates a menu option
- Activating Restart Game will reset the game to its original state
- Activating Quit will transition to the Main Menu screen
- If the win condition or lose condition flags are set
- Pressing any button will return to the Main Menu screen.
