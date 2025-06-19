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
   - At each new square, construct the position string
   - If the square is empty, continue moving
   - If the square contains a piece, add it to capture list and stop in that direction
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
                break                 # Stop in this direction after finding the first piece
            current_file += d_file    # If not, continue on that same direction
            current_rank += d_rank

    return capturable_positions
```

**Mini-task 5.3: Capture logic for a knight**

A knight moves in an "L" shape: two squares in one direction and one square perpendicular.
- Create a list of tuples, where each tuple represents one of the knight’s eight possible moves (as offsets in file and rank).
- Iterate through each move, applying offset to the knight's current position.
- If the constructed position is valid and contains a piece, treat it as a potential capture.

```python
# Determines the pieces a knight can capture from its current position.
def get_knight_captures(position: str, board: dict[str, str]) -> list[str]:
    """
    Capture rules for a knight:
    - A knight moves in an "L" shape.
    - Knights can jump over other pieces and are not obstructed.
    - Can capture any piece at its landing position.
    """
    if not is_valid_position(position) or position not in board or board[position] != "knight":
        return []

    capturable_positions = []
    file = ord(position[0])  # 'a' to 'h'
    rank = int(position[1])   # '1' to '8'

    knight_moves = [
        (-2, -1), (-2, 1), (-1, -2), (-1, 2),
        ( 1, -2), ( 1, 2), ( 2, -1), ( 2, 1)
    ]
    for d_file, d_rank in knight_moves:
        current_file = file + d_file
        current_rank = rank + d_rank
        if ord('a') <= current_file <= ord('h') and 1 <= current_rank <= 8:
            current_pos = f"{chr(current_file)}{current_rank}"
            if current_pos in board:
                capturable_positions.append(current_pos)

    return capturable_positions
```

**Mini-task 5.4: Capture logic for a bishop**

A bishop moves diagonally in any direction:
- Define movement directions using a list of tuples: up-left, up-right, down-left, down-right
- Iterate through each direction
   - If a piece is encountered, record its position as capturable and stop.
   - If no piece is found, continue stepping in that direction until reaching the edge of the board.

```python
# Determines the pieces a bishop can capture from its current position.
def get_bishop_captures(position: str, board: dict[str, str]) -> list[str]:
    """
    Capture rules for a bishop:
    - A bishop moves diagonally in any direction.
    - The bishop can only capture the first piece encountered in any diagonal direction.
    - If a piece obstructs the path, further positions in that direction are not reachable.
    """
    if not is_valid_position(position) or position not in board or board[position] != "bishop":
        return []

    capturable_positions = []
    file = ord(position[0])  # 'a' to 'h'
    rank = int(position[1])   # '1' to '8'
    directions = [
        (-1, -1), (-1, 1), (1, -1), (1, 1)
    ]

    for d_file, d_rank in directions:
        current_file = file + d_file
        current_rank = rank + d_rank
        while ord('a') <= current_file <= ord('h') and 1 <= current_rank <= 8:
            current_pos = f"{chr(current_file)}{current_rank}"
            if current_pos in board:
                capturable_positions.append(current_pos)
                break  # Stop in this direction after finding the first piece
            current_file += d_file
            current_rank += d_rank

    return capturable_positions
```

**Mini-task 5.5: Capture logic for a queen**

The queen combines the movement logic of both **rook** and **bishop**:
- Combine all these movement directions in a list of tuples
- Iterate through each direction with the same approach as used for the rook and bishop 

```python
#Determines the pieces a queen can capture from its current position.
def get_queen_captures(position: str, board: dict[str, str]) -> list[str]:
    """
    Capture rules for a queen:
    - A queen can move horizontally, vertically, or diagonally.
    - The queen can only capture the first piece encountered in any direction.
    - If a piece obstructs the path, further positions in that direction are not reachable.
    """
    if not is_valid_position(position) or position not in board or board[position] != "queen":
        return []

    capturable_positions = []
    file = ord(position[0])  # 'a' to 'h'
    rank = int(position[1])   # '1' to '8'

    directions = [
        (0, 1), (0, -1), (1, 0), (-1, 0),  # Vertical and horizontal
        (-1, -1), (-1, 1), (1, -1), (1, 1)  # Diagonal
    ]

    for d_file, d_rank in directions:
        current_file = file + d_file
        current_rank = rank + d_rank

        while ord('a') <= current_file <= ord('h') and 1 <= current_rank <= 8:
            current_pos = f"{chr(current_file)}{current_rank}"
            if current_pos in board:
                capturable_positions.append(current_pos)
                break  # Stop in this direction after finding the first piece
            current_file += d_file
            current_rank += d_rank

    return capturable_positions
```

**Mini-task 5.6: Capture logic for a king**

The king moves one square in any direction.
- Create a list of 8 possible one-step directions (diagonals, vertical, horizontal).
- For each direction:
   - Calculate the new position
   - If that square contains a piece, add it to the capture list.

```python
# Determines the pieces a king can capture from its current position.
def get_king_captures(position: str, board: dict[str, str]) -> list[str]:
    """
    Capture rules for a king:
    - A king can move one square in any direction.
    - The king can capture any piece on a square within one move.
    """
    if not is_valid_position(position) or position not in board or board[position] != "king":
        return []
    capturable_positions = []
    file = ord(position[0])  # 'a' to 'h'
    rank = int(position[1])   # '1' to '8'
    directions = [
        (-1, -1), (-1, 0), (-1, 1),
        ( 0, -1),          ( 0, 1),
        ( 1, -1), ( 1, 0), ( 1, 1)
    ]

    for d_file, d_rank in directions:
        current_file = file + d_file
        current_rank = rank + d_rank
        if ord('a') <= current_file <= ord('h') and 1 <= current_rank <= 8:
            current_pos = f"{chr(current_file)}{current_rank}"
            if current_pos in board:
                capturable_positions.append(current_pos)

    return capturable_positions
```

**Mini-task 6: Check which black pieces the white piece can capture**

Logic Summary:
- Given a white piece’s type and position, determine which black pieces it can capture based on its movement rules.
- Check the type of white piece using conditional statements.
- Depending on the piece type, call the corresponding capture function to calculate possible capture positions.
- Each of these helper functions returns a list of black-piece positions that are within capturing range.
- If the piece type isn’t recognized, return an empty list.

```python
# Determines which black pieces the white piece can capture.
def get_capturable_pieces(board: dict[str, str], white_piece: str, white_position: str) -> list[str]:

    capturable_positions = []
    if white_piece == "pawn":
        capturable_positions = get_pawn_captures(white_position, board)
    elif white_piece == "rook":
        capturable_positions = get_rook_captures(white_position, board)
    elif white_piece == "bishop":
        capturable_positions = get_bishop_captures(white_position, board)
    elif white_piece == "knight":
        capturable_positions = get_knight_captures(white_position, board)
    elif white_piece == "queen":
        capturable_positions = get_queen_captures(white_position, board)
    elif white_piece == "king":
        capturable_positions = get_king_captures(white_position, board)
    else:
        return []

    return capturable_positions
```

**Mini-task 7: Main flow to gather user input and determine capturable pieces**

Main function where you reuse all previous functions and assemble working solution
First initialize the game board as empty dictionary

**1. Get white piece input from the console:**
   - Begin a loop that asks the user to enter a white piece and its starting position (e.g., "pawn e4").
   - Use **parse_piece_input()** to split and validate the user input:
      - If parsing succeeds, extract the piece name and position.
      - If parsing fails, display error message and restart the loop.
   - Attempt to add the white piece to the board:
      - If the position is already occupied or invalid, inform the user and restart the loop.
      - If successful, print confirmation and exit the loop.
  
**2. Get up to 16 black pieces from console:**
   - Prompt user to enter a black piece and its position.
   - If the user enters "done", exit the loop.
   - Otherwise, parse the input using **parse_piece_input()**.
   - If the input is valid:
      - Extract the piece name and position.
      - Check that the position is not the same as the white piece's.
         - If it is, notify the user and skip to the next input.
      - Try to add the piece to the board using **add_piece()**.
         - If successful, confirm the piece was added.
         - If the position is already occupied, alert the user.
   - If the input format is invalid:
      - Show a message explaining the correct input format.
    
**3. Calculate capturable pieces**

**4. Print results**



```python
def main() -> None:
    """
    Main function to handle user input, manage the board, and output capturable pieces.
    """
    board = {}
    # 1. Get white piece input from the console
    white_piece_name = ""
    white_position = ""
    while True:
        white_input = input("Enter the white piece and its position (e.g., 'pawn e4'): ").lower()

        parsed_white_input = parse_piece_input(white_input)
        if parsed_white_input:
            white_piece_name, white_position = parsed_white_input
            if add_piece(board, white_piece_name, white_position):
                print(f"Added white {white_piece_name} at {white_position}.")
                break
            else:
                print(f"Invalid input or position '{white_position}' is already occupied. Please try again.")
        else:
            print("Invalid input format or invalid piece/position. Please use the format 'piece position' (e.g., 'pawn e4').")

    # 2. Get up to 16 black pieces from console
    for i in range(16):
        black_input = input(f"Enter black piece {i+1} and its position (e.g., 'bishop c5') or 'done': ")
        if black_input.lower() == "done":
            break
        parsed_black_input = parse_piece_input(black_input)
        if parsed_black_input:
            # Unpack piece name and position
            black_piece_name, black_position = parsed_black_input
            # Ensure the black piece is not placed on the white piece's position
            if black_position == white_position:
                print(f"Cannot place a black piece on the white piece's position '{white_position}'.")
            elif add_piece(board, black_piece_name, black_position):
                print(f"Added black {black_piece_name} at {black_position}.")
            else:
                print(f"Invalid input or position '{black_position}' is already occupied. Please try again.")
        else:
            print("Invalid input format or invalid piece/position. \
            Please use the format 'piece position' (e.g., 'bishop c5').")
        
    # 3. Calculate capturable pieces
    capturable_positions = get_capturable_pieces(board, white_piece_name, white_position)
    
    # 4. Print results
    print(f"\nWhite {white_piece_name} at {white_position} can capture black pieces at the following positions:")
    if capturable_positions:
        for pos in capturable_positions:
            print(f"- {board[pos]} at {pos}")
    else:
        print("\nNo capturable pieces found.")
```


