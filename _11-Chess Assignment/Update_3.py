import random

# Mini-task 1: Validate a chess piece
def is_valid_piece(piece: str) -> bool:

    valid_pieces = ["pawn", "knight", "bishop", "rook", "queen", "king"]
    return piece in valid_pieces

# Mini-task 2: Validate a position on the chessboard
def is_valid_position(position: str) -> bool:

    if len(position) != 2:
        return False

    if position[0] < 'a' or position[0] > 'h':
        return False

    if position[1] < '1' or position[1] > '8':
        return False

    return True

# Mini-task 3: Parse user input for a piece and its position
def parse_piece_input(input_str: str) -> tuple[str, str] | None:

    parts = input_str.split()
    if len(parts) == 2 and is_valid_piece(parts[0]) and is_valid_position(parts[1]):
        return parts[0], parts[1]
    return None

# Mini-task 4: Add a piece to the board
def add_piece(board: dict, piece: str, position: str, color: str) -> bool:    # UPDATE: Receiving 4 arguments

    if is_valid_position(position) and position not in board:
        board[position] = (piece, color)  # UPDATE: Added color
        return True
    return False

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

def get_sliding_attacks(position: str, directions: list[tuple[int, int]]) -> list[str]:
    """
    Calculates all squares a sliding piece (rook, bishop, queen) attacks
    in given directions.
    """
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

"""Optional Task 2 - Main function for Implement Danger Squares Visualization"""

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

# Mini-task 5.2: Capture logic for a rook
def get_rook_captures(position: str, board: dict[str, str]) -> list[str]:

    if not is_valid_position(position) or position not in board or board[position][0] != "rook":
        return []

    capturable_positions = []
    file = ord(position[0])
    rank = int(position[1])
    color = board[position][1]      # UPDATE: Get color

    directions = [(0, 1), (0, -1), (1, 0), (-1, 0)] # Up, Down, Right, Left

    for d_file, d_rank in directions:
        current_file = file + d_file
        current_rank = rank + d_rank

        while 'a' <= chr(current_file) <= 'h' and 1 <= current_rank <= 8:
            current_pos = f"{chr(current_file)}{current_rank}"
            if current_pos in board:
                if board[current_pos][1] != color:              # UPDATE color
                    capturable_positions.append(current_pos)
                break
            current_file += d_file
            current_rank += d_rank

    return capturable_positions

# Mini-task 5.3 (optional): Capture logic for a knight
def get_knight_captures(position: str, board: dict[str, str]) -> list[str]:

    if not is_valid_position(position) or position not in board or board[position][0] != "knight":
        return []

    capturable_positions = []
    file = ord(position[0])
    rank = int(position[1])
    color = board[position][1]

    knight_moves = [
        (-2, -1), (-2, 1), (-1, -2), (-1, 2),
        ( 1, -2), ( 1, 2), ( 2, -1), ( 2, 1)
    ]
    for d_file, d_rank in knight_moves:
        current_file = file + d_file
        current_rank = rank + d_rank
        if 'a' <= chr(current_file) <= 'h' and 1 <= current_rank <= 8:
            current_pos = f"{chr(current_file)}{current_rank}"
            if current_pos in board and board[current_pos][1] != color:
                capturable_positions.append(current_pos)

    return capturable_positions

# Mini-task 5.4 (optional): Capture logic for a bishop
def get_bishop_captures(position: str, board: dict[str, str]) -> list[str]:

    if not is_valid_position(position) or position not in board or board[position][0] != "bishop":
        return []

    capturable_positions = []
    file = ord(position[0])  # 'a' to 'h'
    rank = int(position[1])   # '1' to '8'
    color = board[position][1]
    directions = [
        (-1, -1), (-1, 1), (1, -1), (1, 1)
    ]

    for d_file, d_rank in directions:
        current_file = file + d_file
        current_rank = rank + d_rank
        while 'a' <= chr(current_file) <= 'h' and 1 <= current_rank <= 8:
            current_pos = f"{chr(current_file)}{current_rank}"
            if current_pos in board:
                if board[current_pos][1] != color:
                    capturable_positions.append(current_pos)
                break
            current_file += d_file
            current_rank += d_rank

    return capturable_positions

# Mini-task 5.5 (optional): Capture logic for a queen
def get_queen_captures(position: str, board: dict[str, str]) -> list[str]:

    if not is_valid_position(position) or position not in board or board[position][0] != "queen":
        return []

    capturable_positions = []
    file = ord(position[0])
    rank = int(position[1])
    color = board[position][1]

    directions = [
        (0, 1), (0, -1), (1, 0), (-1, 0),  # Vertical and horizontal
        (-1, -1), (-1, 1), (1, -1), (1, 1)  # Diagonal
    ]

    for d_file, d_rank in directions:
        current_file = file + d_file
        current_rank = rank + d_rank

        while 'a' <= chr(current_file) <= 'h' and 1 <= current_rank <= 8:
            current_pos = f"{chr(current_file)}{current_rank}"
            if current_pos in board:
                if board[current_pos][1] != color:
                    capturable_positions.append(current_pos)
                break
            current_file += d_file
            current_rank += d_rank

    return capturable_positions

# Mini-task 5.6 (optional): Capture logic for a king
def get_king_captures(position: str, board: dict[str, str]) -> list[str]:

    if not is_valid_position(position) or position not in board or board[position][0] != "king":
        return []
    capturable_positions = []
    file = ord(position[0])  # 'a' to 'h'
    rank = int(position[1])   # '1' to '8'
    color = board[position][1]

    directions = [
        (-1, -1), (-1, 0), (-1, 1),
        ( 0, -1),          ( 0, 1),
        ( 1, -1), ( 1, 0), ( 1, 1)
    ]

    for d_file, d_rank in directions:
        current_file = file + d_file
        current_rank = rank + d_rank
        if 'a' <= chr(current_file) <= 'h' and 1 <= current_rank <= 8:
            current_pos = f"{chr(current_file)}{current_rank}"
            if current_pos in board and board[current_pos][1] != color:
                capturable_positions.append(current_pos)

    return capturable_positions

# Mini-task 6: Check which black pieces the white piece can capture
def get_capturable_pieces(board: dict, white_piece: str, white_position: str) -> list[str]:

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

def print_the_board(board: dict, highlighted_squares: list[str] = None) -> None:  #UPDATE

    if highlighted_squares is None:       # UPDATE Higlighted squares
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
        if is_valid_position(h_position) and h_position not in board:  # Only highlight empty squares
            file, rank = h_position[0], int(h_position[1])
            col = file_to_col[file]
            row = 8 - rank
            board_grid[row][col] = " X ".center(cell_width)


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


def get_random_position() -> str:
    """Generates a random valid chessboard position."""
    file = chr(random.randint(ord('a'), ord('h')))
    rank = random.randint(1, 8)
    return f"{file}{rank}"

def get_random_piece_type() -> str:
    """Returns a random valid chess piece type."""
    valid_pieces = ["pawn", "knight", "bishop", "rook", "queen", "king"]
    return random.choice(valid_pieces)

def generate_random_board(board: dict) -> tuple[str, str]:
    """
    Generates a random board state with one white piece and sixteen black pieces.
    Returns the white piece name and its position.
    """
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
          # Random board generation
          white_piece_name, white_position = generate_random_board(board)
          break
        else:
          print("Invalid choice. Please enter 1 or 2.")

    print("\n--- Current Board State ---")
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

main()
