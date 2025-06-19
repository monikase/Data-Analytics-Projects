# A Chess Question
## 1. Implement a Nice Visualization Function

This Python code updates [Chess Mini Tasks](https://github.com/monikase/Data-Analytics-Projects/blob/main/_11-Chess%20Assignment/Chess_Mini_Tasks.md)

---

### NEW: get_chess_piece_symbol()
  - Create a function to print the chessboard using Unicode chess symbols to represent each piece accurately.
  - Ensure proper alignment of pieces in an 8x8 grid, with row and column labels.

```python
# Helper function to help with printing pretty chess pieces.
def get_chess_piece_symbol(piece: str, color: str) -> str:
    """
    Returns the UTF-8 symbol for the specified chess piece based on its name and color.

    Args:
        piece (str): The name of the chess piece (e.g., 'king', 'queen', 'rook', 'bishop', 'knight', 'pawn').
        color (str): The color of the piece ('white' or 'black').
    """
    # Define a dictionary mapping piece names to their white and black UTF-8 symbols
    symbols = {
        "king": {"white": " ♔ ", "black": " ♚ "},
        "queen": {"white": " ♕ ", "black": " ♛ "},
        "rook": {"white": " ♖ ", "black": " ♜ "},
        "bishop": {"white": " ♗ ", "black": " ♝ "},
        "knight": {"white": " ♘ ", "black": " ♞ "},
        "pawn": {"white": " ♙ ", "black": " ♟ "},
    }

    # Validate the piece and color inputs
    if piece not in symbols:
        raise ValueError(f"Invalid piece name: {piece}. Valid options are: {', '.join(symbols.keys())}.")
    if color not in symbols[piece]:
        raise ValueError(f"Invalid color: {color}. Valid options are: 'white' or 'black'.")

    # Return the corresponding symbol
    return symbols[piece][color]
```

### NEW: print_the_board():
- Set width of each board cell, and build 8x8 board grid 
- Map file letters ('a' to 'h') to column indices: {'a': 0, 'b': 1, ..., 'h': 7}
- Loop through board dictionary, which maps positions to tuples of piece type and **color** 
- Slice position e.g. "e4" to **file = "e"**, **rank = "4"** and convert it to column and row 
- Get symbol from **get_chess_piece_symbol(..)** function and place it in the cell
- Define labels, visual board elements
- Loop through each row of the grid, printing the cells with vertical bars and showing rank numbers on both sides.

```python
def print_the_board(board: dict) -> None:

    cell_width = 4
    board_grid = [[" " * cell_width for _ in range(8)] for _ in range(8)]
    file_to_col = {chr(ord('a') + i): i for i in range(8)}
    
    for position, (piece, color) in board.items():
        if is_valid_position(position):
            file, rank = position[0], int(position[1])
            col = file_to_col[file]
            row = 8 - rank
            # Center the symbol inside the cell for proper alignment
            board_grid[row][col] = get_chess_piece_symbol(piece, color).center(cell_width)

    # Labels for files ('a' through 'h')
    file_labels_str = " ".join(chr(ord('a') + i).center(cell_width) for i in range(8))

    separator_str = "+".join("-" * cell_width for _ in range(8))

    # Print the top file labels and border
    print(f"   {file_labels_str}   ")
    print(f"  +{separator_str}+  ")

    # Print each rank with its pieces and side labels
    for row_index in range(8):
        rank = 8 - row_index
        row_cells_str = "|".join(board_grid[row_index])
        print(f"{rank} |{row_cells_str}| {rank}")
        print(f"  +{separator_str}+  ")
    print(f"   {file_labels_str}   ")
```

### UPDATE: main():

We need to update our main function adding variable for the piece color

```python
def main() -> None:
    """
    Main function to handle user input, manage the board, and output capturable pieces.
    """
    board = {}
    white_piece_name = ""
    white_position = ""
    # 1. Get white piece input from the console
    while True:
        white_input = input("Enter the white piece and its position (e.g., 'pawn e4'): ").lower()
        parsed_white_input = parse_piece_input(white_input)
        if parsed_white_input:
            white_piece_name, white_position = parsed_white_input
            # FIX: Call add_piece with the color 'white'.
            if add_piece(board, white_piece_name, white_position, 'white'):     # UPDATE: Call add_piece with the color 'white'.
                print(f"Added white {white_piece_name} at {white_position}.")
                break
            else:
                print(f"Position '{white_position}' is already occupied. Please try again.")
        else:
            print("Invalid input format or invalid piece/position. Please use the format 'piece position' (e.g., 'pawn e4').")

    # 2. Get up to 16 black pieces from console
    for i in range(16):
        black_input = input(f"Enter black piece {i+1} and its position (e.g., 'bishop c5') or 'done': ").lower()
        if black_input == "done":
            break
        parsed_black_input = parse_piece_input(black_input)
        if parsed_black_input:
            black_piece_name, black_position = parsed_black_input
            
            if not add_piece(board, black_piece_name, black_position, 'black'):   # UPDATE: Call add_piece with the color 'black'.
                print(f"Position '{black_position}' is already occupied. Please try again.")
        else:
            print("Invalid input. Use format 'piece position' (e.g., 'bishop c5').")

    print_the_board(board)

    capturable_positions = get_capturable_pieces(board, white_piece_name, white_position)
    
    print(f"\nWhite {white_piece_name} at {white_position} can capture black pieces at the following positions:")
    if capturable_positions:
        for pos in capturable_positions:
            
            captured_piece_name = board[pos][0]                  # UPDATE: Access the piece name from the tuple for printing.
            print(f"- Black {captured_piece_name} at {pos}")
    else:
        print("No capturable pieces found.")
```

### UPDATE: add_piece():

Now calling add_piece function takes 3 positional arguments but 4 were given, so we need an update:

```python
# Mini-task 4: Add a piece to the board
# def add_piece(board: dict[str, str], piece: str, position: str) -> bool: 
def add_piece(board: dict, piece: str, position: str, color: str) -> bool:    # UPDATE: Receiving 4 arguments

    if is_valid_position(position) and position not in board:
        board[position] = (piece, color)                                      # UPDATE: Added color   
        return True
    return False
```

### UPDATE: get_pawn_captures():

Implementing color aware logic
- Direction Based on Color
- Capture conditions

```python
# Mini-task 5.1: Capture logic for a pawn
def get_pawn_captures(position: str, board: dict[str, str]) -> list[str]:
    
    # Check piece name from tuple and get its color.
    if not is_valid_position(position) or position not in board or board[position][0] != "pawn":
        return []

    capturable_positions = []
    file = ord(position[0])  # 'a' to 'h'
    rank = int(position[1])   # '1' to '8'
    color = board[position][1]                                        # UPDATE: Get the color

    # Determine pawn movement direction BASED ON ITS COLOR 
    rank_direction = 1 if color == "white" else -1                    # UPDATE: Change direction if it is not white

    # Check for captures on the left diagonal
    if file > ord('a'):
        left_capture_pos = f"{chr(file - 1)}{rank + rank_direction}"
        if left_capture_pos in board and board[left_capture_pos][1] != color:   # UPDATE: Check if the target piece is of the opposite color.
            capturable_positions.append(left_capture_pos)

    # Check for captures on the right diagonal
    if file < ord('h'):
        right_capture_pos = f"{chr(file + 1)}{rank + rank_direction}"
        if right_capture_pos in board and board[right_capture_pos][1] != color: # UPDATE: Check if the target piece is of the opposite color.
            capturable_positions.append(right_capture_pos)

    return capturable_positions
```

Similarly we have to adjust all other pieces. 

## Output:

![image](https://github.com/user-attachments/assets/3d28d1f0-ffb6-4148-b38c-3d3d10c1e4d1)

</br>

⚠️ **Note: The visual layout of the chessboard may appear differently depending on the terminal or editor you're using. In particular, character alignment may vary between platforms like Google Colab and VS Code.**



![image](https://github.com/user-attachments/assets/182bf905-441d-4d3c-9b94-f4c7e2e8e894)








