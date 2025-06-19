# A Chess Question
## 3. Implement Starting Position Generation

This Python enhances previous Update_1.py the program now will ask you your preference in the beginning: 
- Would you like to enter the figures manually or generate them randomly?
  - If the user selects random generation, implement functions that would place one white figure and sixteen random black ones.

---

We start from adding **import random** Python statement which contains functions for generating random numbers and making random selections.

```python
import random
```

### NEW: get_random_position()

Create random, valid chessboard coordinates like "b6" or "e2".

- **random.randint()** picks a random ASCII code between 'a' and 'h' and a random row (rank) number between 1 and 8.
- Joins the two into a chessboard coordinate string (e.g., 'd5').

```python
def get_random_position() -> str:
    file = chr(random.randint(ord('a'), ord('h')))
    rank = random.randint(1, 8)
    return f"{file}{rank}"
```

### NEW: def get_random_piece_type()

- Randomly selects a valid type of chess piece.
- Uses **random.choice()** to return one at random from that list.

```python
def get_random_piece_type() -> str:
    valid_pieces = ["pawn", "knight", "bishop", "rook", "queen", "king"]
    return random.choice(valid_pieces)
```

### NEW: def generate_random_board()

- Generates a random board state with one white piece and sixteen black pieces.
- Returns the white piece name and its position.

```python
def generate_random_board(board: dict) -> tuple[str, str]:

    # Place one random white piece
    white_piece_name = get_random_piece_type()
    white_position = get_random_position()
    while not add_piece(board, white_piece_name, white_position, 'white'):
        white_position = get_random_position() # Try a new position if occupied
    print(f"Randomly placed white {white_piece_name} at {white_position}.")

    # Place sixteen random black pieces
    for i in range(16):
        black_piece_name = get_random_piece_type()
        black_position = get_random_position()
        # Ensure black pieces are not placed on already occupied squares
        while not add_piece(board, black_piece_name, black_position, 'black'):
            black_position = get_random_position() # Try a new position if occupied
        print(f"Randomly placed black {black_piece_name} at {black_position}.")
    
    return white_piece_name, white_position
```




