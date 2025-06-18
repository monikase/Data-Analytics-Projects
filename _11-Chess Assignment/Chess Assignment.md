# A Chess Question

### Project Goal

Implement a Python program that will answer a simple question – given a board state that the user enters, with 1 white figure and up to 16 black figures, which black figures can the white figure take?

---

### Primary Requirements

**1. User Input for White Piece**  
- Prompt the user to input a white piece and its position on the board.  
- User must choose between two predefined piece types (e.g., pawn and rook).  
- The input format must be: (e.g., knight a5).  
- The program must confirm a successful addition or display an error message if the input is invalid.  
   
**2. User Input for Black Pieces** 
- After the white piece is set, the user must input the black pieces one by one.  
- Each black piece must follow the same format (e.g., bishop d6).   
- The user must add at least one and at most sixteen black pieces.  
- The user can enter "done" to stop adding black pieces only after at least one black piece has been added.  
- The program must confirm a successful addition or display an error message if the input is invalid.  
   
**3. Input Validation**  
- The program must ensure that input coordinates follow the correct format (where the letter is a-h and the digit is 1-8, e.g., a1, d4, h8).  
- The program must handle edge cases, such as:
   -    Attempting to enter "done" before adding at least one black piece.
   -    Providing invalid chess piece names.
   -    Entering out-of-bounds coordinates.  

**4. Output a Gameplay Logic**
- After all pieces are added, the program must display a list of black pieces that the white piece can capture based on valid chess moves.  
- If no black pieces are captured, the program should indicate this clearly.  

---

### Mini Tasks

First let's break it down. Successfully completing these mini-tasks will provide the foundational building blocks needed to assemble the final program. The minitasks are these:

- Mini-task 1: Validate a chess piece
- Mini-task 2: Validate a position on the chessboard
- Mini-task 3: Parse user input for a piece and its position
- Mini-task 4: Add a piece to the board
- Mini-task 5.1: Capture logic for a pawn
- Mini-task 5.2: Capture logic for a rook
- Mini-task 5.3: Capture logic for a knight
- Mini-task 5.4: Capture logic for a bishop
- Mini-task 5.5: Capture logic for a queen
- Mini-task 5.6: Capture logic for a king
- Mini-task 6: Check which black pieces the white piece can capture
- Mini-task 7: Main flow to gather user input and determine capturable pieces
