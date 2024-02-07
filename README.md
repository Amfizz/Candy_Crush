# Candy_Crush
The most popular and addictive game Candy Crush. I am sure we all have played it once or at least heard about it. In this repository you can find everyone's favorite game coded  in Assembly Language. Take a deep look into how your colorful candies are made and destroyed.

Game Initialization:
The game starts with a set of predefined messages, including a welcome message, instructions, and a press-any-key prompt.
The game board is initialized with a rectangular grid of characters ('A', 'B', 'C', 'D') and corresponding colors.
The score is initialized to zero.
Game Board Representation:
The game board is represented as a grid on the console screen, and the characters are displayed using ASCII art.
The grid consists of horizontal and vertical lines to create a visual representation of the game board.
The initial pattern on the board is a sequence of characters.

Gameplay Mechanics:

Swapping Characters:The player interacts with the game by clicking on two positions on the grid to swap characters.
The Coorswap function is responsible for swapping characters at the clicked positions.
After each swap, the game checks for patterns (matches) and updates the score accordingly.

Matching Patterns: Patterns can be formed horizontally, vertically, or diagonally by having at least two adjacent identical characters.
The game checks for patterns after each character swap using the pattern function.
If a pattern is detected, the corresponding characters are removed, and the score is updated.
The bombsub function handles special cases when a bomb pattern ('X') is formed.

Bombs: Bombs are created when a pattern of five or more characters is formed.
When a bomb is created, it can be swapped with any character to remove all instances of that character from the board.

Scoring: The updateScore function is responsible for updating the player's score.
Points are awarded for each successful character swap and pattern matching.
The objective is to achieve a score of 80 or higher to win the game.

Winning Condition: The game checks if the player's score has reached or exceeded 80.
If the condition is met, the winning screen is displayed, congratulating the player.

Additional Features: The game includes mouse input for player interaction.
The code attempts to generate a random number using the system time for various functionalities.
There is a function (noMouseClick) to wait for mouse clicks and another function (waitForButtonRelease) to wait for button releases.

User Interface: The game displays the current score, the game board, and relevant messages on the console.
The screen is updated dynamically based on user input and game events.

Termination: The game can be terminated by reaching the winning condition or by pressing a key to exit.
Summary:
In summary, the game is a simplified version of Candy Crush, involving character swapping, pattern matching, scoring, and the use of bombs for strategic gameplay. The assembly code combines game logic, UI rendering, and input handling to create an interactive console game experience.
