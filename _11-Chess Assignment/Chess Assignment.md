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

First let's break it down. Successfully completing these mini-tasks will provide the foundational building blocks needed to assemble the final program:

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

---

**Mini-task 1: Validate a chess piece**

```python
# Checks if the given piece is a valid chess piece from the list.
def is_valid_piece(piece: str) -> bool:
    valid_pieces = ["pawn", "knight", "bishop", "rook", "queen", "king"]
    return piece in valid_pieces
```

**Mini-task 2: Validate a position on the chessboard**

```python
# Checks if the given position is valid on a chessboard.
def is_valid_position(position: str) -> bool:
    """
    A valid chess position:
    - Must be exactly two characters long.
    - The first character must be a letter between 'a' and 'h' (inclusive).
    - The second character must be a digit between '1' and '8' (inclusive).
    """
    if len(position) != 2:
        return False
    if position[0] < 'a' or position[0] > 'h':
        return False    
    if position[1] < '1' or position[1] > '8':
        return False
    
    return True
```

**Mini-task 3: Parse user input for a piece and its position**

```python
# Parses the input string for a piece and its position into tuple: fixed size, ordered collection.
def parse_piece_input(input_str: str) -> tuple[str, str] | None:
    parts = input_str.split()
    if len(parts) == 2 and is_valid_piece(parts[0]) and is_valid_position(parts[1]):
        return parts[0], parts[1]
    return None
```

**Mini-task 4: Add a piece to the board**

```python
# Adds a piece to the board if the position is valid and not already occupied.
def add_piece(board: dict[str, str], piece: str, position: str) -> bool:
    if is_valid_position(position) and position not in board:
        board[position] = piece
        return True
    return False
```

**Mini-task 5.1: Capture logic for a pawn**

In this part we have to determine logic for a pawn through this steps:  
- Create an empty list to store potential capture positions.
- Extract the file (position[0]) and rank (position[1]) from the pawn’s current position.
- Convert the file letter ('a' to 'h') to its ASCII number using ord(), and convert it back using chr() — since Python</b>
  doesn’t support character arithmetic directly (e.g., ord('a') returns 97; chr(97) returns 'a').
- Set the direction of pawn movement. For white pawns, this means moving up the board (increasing rank).
- Check the diagonally forward-left and forward-right squares, making sure they stay within the board boundaries.
- Construct those new positions and check if they exist in the board dictionary—if so, append them to the capture list.
</br>

```python
# Determine the pieces a pawn can capture from its current position.
def get_pawn_captures(position: str, board: dict[str, str]) -> list[str]:
    """
    Capture rules for a pawn:
    - A pawn can capture diagonally forward one square.
    - A pawn (white) on e4 is hitting d5 and f5
    - Pawns cannot capture pieces directly in front of them.
    - Only the first piece encountered diagonally can be captured.
    """
    if not is_valid_position(position) or position not in board or board[position] != "pawn":
        return []

    capturable_positions = []
    file = ord(position[0])  # 'a' to 'h' convert to ASCII number
    rank = int(position[1])   # '1' to '8'

    # Determine pawn movement direction
    rank_direction = 1

    # Check Diagonal Left Capture
    if file > ord('a') and 1 <= (rank + rank_direction) <= 8:
        # chr() converts ASCII number to the letter
        left_capture_file = chr(file - 1)
        left_capture_rank = rank + rank_direction
        left_capture_pos = f"{left_capture_file}{left_capture_rank}"
        if left_capture_pos in board:
            capturable_positions.append(left_capture_pos)

    # Check Diagonal Left Capture
    if file < ord('h') and 1 <= (rank + rank_direction) <= 8:
        right_capture_file = chr(file + 1)
        right_capture_rank = rank + rank_direction
        right_capture_pos = f"{right_capture_file}{right_capture_rank}"
        if right_capture_pos in board:
            capturable_positions.append(right_capture_pos)

    return capturable_positions
```

**Mini-task 5.2: Capture logic for a rook**

For the rook logic we need slightly different approach:
- Define movement directions as tuples: ( Up (0, +1), Down (0, -1), Right (+1, 0), Left(-1, 0) )
- For each direction simulate step-by-step movement:
-       At each new square, construct the position string
-       If the square is empty, continue moving
-       If the square contains a piece, add it to capture list and stop in that direction
- Make sure all generated positions stay within board boundaries

```python
# Determines the pieces a rook can capture from its current position.
def get_rook_captures(position: str, board: dict[str, str]) -> list[str]:
    """
    Capture rules for a rook:
    - A rook can capture pieces in a straight line horizontally or vertically.
    - A rook on e4 is hitting e1-e8 and a4-h4 squares
    - The rook can only capture the first piece encountered in any direction.
    - If a piece obstructs the path, further positions in that direction are not reachable.
    """
    if not is_valid_position(position) or position not in board or board[position] != "rook":
        return []

    capturable_positions = []
    file = ord(position[0])  # 'a' to 'h'
    rank = int(position[1])   # '1' to '8'

    directions = [(0, 1), (0, -1), (1, 0), (-1, 0)] # Up, Down, Right, Left

    # Loop all directions
    for d_file, d_rank in directions:
        current_file = file + d_file
        current_rank = rank + d_rank

        # Inside each direction simulate steps until encounter the piece or go off board
        while ord('a') <= current_file <= ord('h') and 1 <= current_rank <= 8:
            # Convert numeric file back into position string
            current_pos = f"{chr(current_file)}{current_rank}"
            if current_pos in board:
                capturable_positions.append(current_pos)
                break  # Stop in this direction after finding the first piece
            current_file += d_file
            current_rank += d_rank

    return capturable_positions
```

**Mini-task 5.3: Capture logic for a knight**

```python
```

**Mini-task 5.4: Capture logic for a bishop**

```python
```

**Mini-task 5.5: Capture logic for a queen**

```python
```

**Mini-task 5.6: Capture logic for a king**

```python
```

**Mini-task 6: Check which black pieces the white piece can capture**

```python
```

**Mini-task 7: Main flow to gather user input and determine capturable pieces**

```python
```


