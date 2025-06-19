# A Chess Question
## 3. Implement Starting Position Generation

This Python code builds upon the previous Chess Question Code Task (Update_2.py) by introducing an interactive setup. At the start, the program prompts the user to choose between two options: manually input piece positions or generate them randomly. If random generation is selected, the program automatically places one white piece and sixteen black pieces at random, ensuring a realistic starting scenario.

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

- Fills a board dictionary with one random white piece and 16 random black pieces.
- Returns the white piece name and its position.

```python
def generate_random_board(board: dict) -> tuple[str, str]:

    # Place one random white piece
    white_piece_name = get_random_piece_type()
    white_position = get_random_position()
    while not add_piece(board, white_piece_name, white_position, 'white'):
        white_position = get_random_position()                                   # Try a new position if occupied
    print(f"Randomly placed white {white_piece_name} at {white_position}.")

    # Place sixteen random black pieces
    for i in range(16):
        black_piece_name = get_random_piece_type()
        black_position = get_random_position()

        # Ensure black pieces are not placed on already occupied squares
        while not add_piece(board, black_piece_name, black_position, 'black'):
            black_position = get_random_position()                               # Try a new position if occupied
        print(f"Randomly placed black {black_piece_name} at {black_position}.")
    
    return white_piece_name, white_position
```

### UPDATE: main()

- We ask for user preference: Play Manually '1' or Randomly '2'
- Based on the user's choice:
  - Manual Mode works as before
  - Random Mode directs us to **generate_random_board()**

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
        choice = input("Would you like to (1) Enter pieces manually or (2) Generate randomly? Enter 1 or 2: ").strip()      # UPDATE: Ask user preference
        if choice == "1":
          # Manual input 
          while True:
            white_input = input("Enter the white piece and its position (e.g., 'pawn e4'): ").lower()
            parsed_white_input = parse_piece_input(white_input)
            if parsed_white_input:
                white_piece_name, white_position = parsed_white_input
                if add_piece(board, white_piece_name, white_position, 'white'):
                    print(f"Added white {white_piece_name} at {white_position}.")
                    break
                else:
                    print(f"Invalid input or position '{white_position}' is already occupied. Please try again.")
            else:
                print("Invalid input format or invalid piece/position. Please use the format 'piece position' (e.g., 'pawn e4').")

          # Manual input for black pieces
          for i in range(16):
              black_input = input(f"Enter black piece {i+1} and its position (e.g., 'bishop c5') or 'done': ").lower()
              if black_input == "done":
                  break
              parsed_black_input = parse_piece_input(black_input)
              if parsed_black_input:
                  black_piece_name, black_position = parsed_black_input
                  # Ensure the black piece is not placed in occupied position
                  if not add_piece(board, black_piece_name, black_position, 'black'):    # UPDATE: call add_piece(..) with the color 'black'.
                      print(f"Position '{black_position}' is already occupied. Please try again.")
                      #print(f"Added black {black_piece_name} at {black_position}.")
              else:
                  print("Invalid input format or invalid piece/position. Please use the format 'piece position' (e.g., 'bishop c5').")
          break # Exit choice loop
        elif choice == "2":

          # UPDATE Random board generation
          white_piece_name, white_position = generate_random_board(board)
          break
        else:
          print("Invalid choice. Please enter 1 or 2.")

    print_the_board(board)

    # 3. Calculate and print capturable pieces
    capturable_positions = get_capturable_pieces(board, white_piece_name, white_position)
    print(f"\nWhite {white_piece_name} at {white_position} can capture black pieces at the following positions:")
    if capturable_positions:
        for pos in capturable_positions:
            captured_piece_name = board[pos][0]
            print(f"- {board[pos][0]} at {pos}")
    else:
        print("\nNo capturable pieces found.")

    # UPDATE 4. Calculate and highlight all attackable squares (even if blocked)
    attackable_squares = get_all_attackable_squares(white_piece_name, white_position, 'white')
    print("\n--- Board with All Attackable Squares (marked with X) ---")
    print_the_board(board, highlighted_squares=attackable_squares)
```

---

## Output:

![image (2)](https://github.com/user-attachments/assets/e36562aa-22e5-4d17-a644-a5deb2d9fb67)









