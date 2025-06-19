# A Chess Question
## 2. Implement Danger Squares Visualization

This Python update enhances the [Chess Mini Tasks](https://github.com/monikase/Data-Analytics-Projects/blob/main/_11-Chess%20Assignment/Chess_Mini_Tasks.md) by highlighting all squares that the white piece can attack, even if the path is blocked by another piece.

---
### NEW: get_all_attackable_squares()

Main function for determining all squares a given piece can attack.
- It redirects to specific helper function depending on the piece type.
- For sliding pieces (rook, bishop, queen), it uses the same function but passes in piece-specific directions.
- Returns a list of board coordinates the piece could theoretically attack.‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍

```python
# Get all squares a piece can attack
def get_all_attackable_squares(piece_type: str, position: str, color: str) -> list[str]:

    if not is_valid_position(position) or not is_valid_piece(piece_type):
        return []

    if piece_type == "pawn":
        return get_pawn_attack_targets(position, color)
    elif piece_type == "rook":
        directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]  # Up, Down, Right, Left
        return get_sliding_attacks(position, directions)
    elif piece_type == "bishop":
        directions = [(-1, -1), (-1, 1), (1, -1), (1, 1)] # Diagonals
        return get_sliding_attacks(position, directions)
    elif piece_type == "queen":
        directions = [(0, 1), (0, -1), (1, 0), (-1, 0), (-1, -1), (-1, 1), (1, -1), (1, 1)] # All 8 directions
        return get_sliding_attacks(position, directions)
    elif piece_type == "knight":
        return get_knight_attack_targets(position)
    elif piece_type == "king":
        return get_king_attack_targets(position)
    else:
        return []
```

### NEW: get_pawn_attack_targets()

- Calculate the two diagonal squares a pawn can attack

```python
def get_pawn_attack_targets(position: str, color: str) -> list[str]:
    """
    Calculates the diagonal squares a pawn attacks, regardless of pieces on them.
    """
    attack_squares = []
    file = ord(position[0])
    rank = int(position[1])
    
    # Determine pawn movement direction based on its color.
    rank_direction = 1 if color == 'white' else -1

    # Check for attacks on left diagonal
    if file > ord('a'):
        left_target_pos = f"{chr(file - 1)}{rank + rank_direction}"
        if is_valid_position(left_target_pos):
            attack_squares.append(left_target_pos)

    # Check for attacks on the right diagonal
    if file < ord('h'):
        right_target_pos = f"{chr(file + 1)}{rank + rank_direction}"
        if is_valid_position(right_target_pos):
            attack_squares.append(right_target_pos)
            
    return attack_squares
```

### NEW: get_sliding_attacks()

- Calculates all squares a sliding piece (rook, bishop, queen) attacks in given directions.

```python
def get_sliding_attacks(position: str, directions: list[tuple[int, int]]) -> list[str]:

    attack_squares = []
    file = ord(position[0])
    rank = int(position[1])

    for d_file, d_rank in directions:
        current_file = file + d_file
        current_rank = rank + d_rank
        while 'a' <= chr(current_file) <= 'h' and 1 <= current_rank <= 8:
            attack_squares.append(f"{chr(current_file)}{current_rank}")
            current_file += d_file
            current_rank += d_rank
    return attack_squares
```

### NEW: get_knight_attack_targets()

- Calculates the 'L'-shaped moves a knight can make.

```python
def get_knight_attack_targets(position: str) -> list[str]:
    """
    Calculates the 'L'-shaped squares a knight attacks.
    """
    attack_squares = []
    file = ord(position[0])
    rank = int(position[1])

    knight_moves = [(-2, -1), (-2, 1), (-1, -2), (-1, 2), (1, -2), (1, 2), (2, -1), (2, 1)]
    for d_file, d_rank in knight_moves:
        target_file = file + d_file
        target_rank = rank + d_rank
        target_pos = f"{chr(target_file)}{target_rank}"
        if is_valid_position(target_pos):
            attack_squares.append(target_pos)
    return attack_squares
```

### NEW: get_king_attack_targets()

- Calculates the single-step squares a king attacks.

```python
def get_king_attack_targets(position: str) -> list[str]:
    """
    Calculates the single-step squares a king attacks.
    """
    attack_squares = []
    file = ord(position[0])
    rank = int(position[1])

    directions = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
    for d_file, d_rank in directions:
        target_file = file + d_file
        target_rank = rank + d_rank
        target_pos = f"{chr(target_file)}{target_rank}"
        if is_valid_position(target_pos):
            attack_squares.append(target_pos)
    return attack_squares
```

### UPDATE: print_the_board()

- Function now accepts an optional highlighted_squares list.
- If provided, it iterates through these positions.
- If a highlighted position is empty on the board, it places an 'X' symbol there.

```python
def print_the_board(board: dict, highlighted_squares: list[str] = None) -> None:  # UPDATE Add highlighted squares, if it's not provided, it defaults to None

    if highlighted_squares is None:                                               # UPDATE Higlighted squares list
        highlighted_squares = []

    cell_width = 4
    board_grid = [[" " * cell_width for _ in range(8)] for _ in range(8)]
    file_to_col = {chr(ord('a') + i): i for i in range(8)}
    
    # Place pieces on the board
    for position, (piece, color) in board.items():
        if is_valid_position(position):
            file, rank = position[0], int(position[1])
            col = file_to_col[file]
            row = 8 - rank
            # Center the symbol inside the cell for proper alignment
            board_grid[row][col] = get_chess_piece_symbol(piece, color).center(cell_width)

    # UPDATE Place highlights
    for h_position in highlighted_squares:
        if is_valid_position(h_position) and h_position not in board:             # Only highlight empty squares
            file, rank = h_position[0], int(h_position[1])
            col = file_to_col[file]
            row = 8 - rank
            board_grid[row][col] = " X ".center(cell_width)

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

### UPDATE: main()

```python
# Mini-task 7: Main function where you reuse all previous functions and assemble working solution
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
            if add_piece(board, white_piece_name, white_position, 'white'):
                print(f"Added white {white_piece_name} at {white_position}.")
                break
            else:
                print(f"Invalid input or position '{white_position}' is already occupied. Please try again.")
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
            # Ensure the black piece is not placed in occupied position
            if not add_piece(board, black_piece_name, black_position, 'black'):    # UPDATE: call add_piece(..) with the color 'black'.
                print(f"Position '{black_position}' is already occupied. Please try again.")
                #print(f"Added black {black_piece_name} at {black_position}.")
        else:
            print("Invalid input format or invalid piece/position. Please use the format 'piece position' (e.g., 'bishop c5').")

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

## Output:

![image](https://github.com/user-attachments/assets/64c70a62-9f43-4a1a-950e-1eb7f7758370)


