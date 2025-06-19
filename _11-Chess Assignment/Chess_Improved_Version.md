# A Chess Question

### Project Goal

This Python code simulates a simplified chess game, an improved version of [Chess Mini Tasks](https://github.com/monikase/Data-Analytics-Projects/blob/main/_11-Chess%20Assignment/Chess_Mini_Tasks.md), allowing users:

* **Manage Chess Pieces:** Add white and black chess pieces to specific positions in the board
* **Analyze Piece Movements:** Displaying all squares that a selected piece can atack
* **Generate Random Board Setup:** with one white and several `(<17)` black pieces.
* **Visualize the Board:** chosen pieces and highlighted squares
* **Interactive menu:** offers a command-line interface to perform these actions

[Code on Google Colab Notebook](https://colab.research.google.com/drive/1Bs71zqz8-9XDec0BTxFJntxJeJHsZ4sA?usp=sharing)

---

### Building blocks needed to assemble the final program

- 1: Validate a chess piece
- 2: Validate a position on the chessboard
- 3: Parse user input for a piece and its position
- 4: Add a piece to the board
- 5.1: Capture logic for a pawn
- 5.2: Capture logic for rook, bishop, queen
- 5.3: Capture logic for a knight
- 5.4: Capture logic for a king
- 6: Get all squares that piece can move
- 7: Get possible captures
- 8: Establish chess piece symbols
- 9: Print the board
- 10.1: Get random piece
- 10.1: Get random position
- 10.2: Get random board pieces
- 11: Render the menu
- 12: Main function

---

This program will start from the code written for Chess_Mini_Tasks.

---

## 1. Implement a Nice Visualization Function
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

def print_the_board(board: dict[str, tuple[str, str]]) -> None:

    cell_width = 4
    board_grid = [[" " * cell_width for _ in range(8)] for _ in range(8)]
    file_to_col = {chr(ord('a') + i): i for i in range(8)}

    # Placing pieces on the board
    for position, (piece, color) in board.items():
        if is_valid_position(position):
            file = position[0]
            rank = int(position[1])
            col = file_to_col[file]
            row = 8 - rank
            board_grid[row][col] = get_chess_piece_symbol(piece, color).center(cell_width)

    # Build labels 
    file_labels = " ".join(chr(ord('a') + i).center(cell_width))

    separator = "+".join("-" * cell_width for _ in range(8)) # Separators line

    print(f"  +{separator}+  ")
    print(separator)
    for row_index in range(8):
      rank = 8 - row_index
      row_cells = "|".join(board_grid[row_index])
      print(f"{rank} |{row_cells}| {rank}")
      print(separator)
    print(file_labels)
```

Same code printed output:

![image (1)](https://github.com/user-attachments/assets/e6f3272b-a883-427e-abba-a80489393ceb)







