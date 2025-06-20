# A Chess Question
## 4. Implement a Game Menu System

This Python code builds upon the previous Chess Task (Update_3.py) by replacing the linear input system with an interactive menu that allows flexible commands.  

**Menu Commands:**

```
  - white_input <piece> <location>    (e.g., knight a5)
  - black_input <piece> <location>    (e.g., bishop d6)
  - print_board                       (displays the current board)
  - check_captures                    (lists capturable black pieces)
  - exit                              (quits the program)
```
In this Task we redesign the **main()** function. Now it has to run in a continuous loop accepting commands from the user.

### UPDATE: main()

- Display the Menu with a list of available commands
  - white_input : This command allows you to place a white piece. If a white piece already exists on the board, it will be removed before the new one is placed
  - black_input : This command lets you place black pieces one by one.
  - print_board : Displays the current state of the chessboard.
  - check_captures : This command now performs two actions:
    - It lists the black pieces that the currently placed white piece can actually capture.
    - It then displays the board again, highlighting all squares the white piece can attack (even if blocked) with an 'X'. It will prompt you if no white piece has been placed yet.
  - exit : Terminates the program.

```python
def main() -> None:
    """
    Main function to handle user input, manage the board, and output capturable pieces
    using an interactive menu system.
    """
    board = {}
    white_piece_name = None  # Stores the name of the active white piece
    white_position = None    # Stores the position of the active white piece

    print("Welcome to the Chess Piece Analyzer!")
    print("\n--- Available Commands ---")
    print("  - white_input <piece> <location> : Place or move the white piece (e.g., 'knight a5')")
    print("  - black_input <piece> <location> : Place a black piece (e.g., 'bishop d6')")
    print("  - print_board                      : Display the current board state")
    print("  - check_captures                   : List capturable black pieces and highlight all attackable squares for the white piece")
    print("  - exit                             : Quit the program")
    print("--------------------------")

    while True:
        user_command = input("\nEnter command: ").lower().strip()
        parts = user_command.split()

        if not parts:
            print("No command entered. Please try again.")
            continue

        command = parts[0]

        if command == "exit":
            print("Exiting program. Goodbye!")
            break
        elif command == "white_input":
            if len(parts) == 3:
                piece = parts[1]
                position = parts[2]
                if is_valid_piece(piece) and is_valid_position(position):
                    # Remove existing white piece if any, to ensure only one white piece is tracked
                    existing_white_pos_on_board = None
                    for pos_on_board, (p_type, p_color) in list(board.items()):
                        if p_color == 'white':
                            existing_white_pos_on_board = pos_on_board
                            break
                    if existing_white_pos_on_board:
                        del board[existing_white_pos_on_board]
                        print(f"Removed previous white piece at {existing_white_pos_on_board}.")

                    if add_piece(board, piece, position, 'white'):
                        white_piece_name = piece
                        white_position = position
                        print(f"Added white {white_piece_name} at {white_position}.")
                    else:
                        print(f"Position '{position}' is already occupied. Please choose another position.")
                else:
                    print("Invalid piece or position. Usage: white_input <piece> <location>")
            else:
                print("Invalid command format. Usage: white_input <piece> <location>")
        elif command == "black_input":
            if len(parts) == 3:
                piece = parts[1]
                position = parts[2]
                if is_valid_piece(piece) and is_valid_position(position):
                    if add_piece(board, piece, position, 'black'):
                        print(f"Added black {piece} at {position}.")
                    else:
                        print(f"Position '{position}' is already occupied. Please choose another position.")
                else:
                    print("Invalid piece or position. Usage: black_input <piece> <location>")
            else:
                print("Invalid command format. Usage: black_input <piece> <location>")
        elif command == "print_board":
            print("\n--- Current Board State ---")
            print_the_board(board)
        elif command == "check_captures":
            if white_piece_name and white_position:
                # Actual capturable pieces
                capturable_positions = get_capturable_pieces(board, white_piece_name, white_position)
                print(f"\nWhite {white_piece_name} at {white_position} can capture black pieces at the following positions:")
                if capturable_positions:
                    for pos in capturable_positions:
                        captured_piece_name = board[pos][0]
                        print(f"- Black {captured_piece_name} at {pos}")
                else:
                    print("No capturable pieces found.")

                # All attackable squares (even if blocked)
                attackable_squares = get_all_attackable_squares(white_piece_name, white_position, 'white')
                print("\n--- Board with All Attackable Squares (marked with X) ---")
                # Filter out the white piece's current position from highlighted squares to avoid overwriting its symbol
                filtered_attackable_squares = [sq for sq in attackable_squares if sq != white_position]
                print_the_board(board, highlighted_squares=filtered_attackable_squares)
            else:
                print("No white piece has been placed yet. Please use 'white_input' first to place a white piece.")
        else:
            print(f"Unknown command: '{command}'. Please use one of the available commands.")
```

---

## Output:

![image](https://github.com/user-attachments/assets/fe2b005c-1a7b-48db-998b-049b8c9c49ce)

