def main() -> None:
    board = {}
    white_piece_name = None
    white_position = None

    black_pieces_count = {"pawn": 0, "knight": 0, "bishop": 0, "rook": 0, "queen": 0, "king": 0}

    welcome_message()

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
            white_piece_name, white_position = handle_white_input(parts, board, white_piece_name, white_position, black_pieces_count)
        elif command == "black_input":
            handle_black_input(parts, board, black_pieces_count)
        elif command == "print_board":
            print("\n--- Current Board State ---")
            print()
            print_the_board(board)
        elif command == "check_captures":
            handle_check_captures(board, white_piece_name, white_position)
        else:
            print(f"Unknown command: '{command}'. Please use one of the available commands.")

def welcome_message() -> None:
    """Displays the welcome message and available commands."""
    print("Welcome to the Chess Piece Analyzer!")
    print("\n--- Available Commands ---")
    print("  - white_input <piece> <location>   : Place or move the white piece (e.g., 'knight a5')")
    print("  - black_input <piece> <location>   : Place a black piece (e.g., 'bishop d6')")
    print("  - print_board                      : Display the current board state")
    print("  - check_captures                   : List capturable black pieces and highlight all attackable squares for the white piece")
    print("  - exit                             : Quit the program")
    print("--------------------------")

def handle_white_input(parts: list, board: dict, white_piece_name: str, white_position: str, black_pieces_count: dict) -> tuple[str | None, str | None]:
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

            if add_piece(board, piece, position, 'white', black_pieces_count):
                print(f"Added white {piece} at {position}.")
                return piece, position
            else:
                print(f"Position '{position}' is already occupied. Please choose another position.")
        else:
            print("Invalid piece or position. Use: white_input <piece> <location>")
    else:
        print("Invalid command format. Use: white_input <piece> <location>")
    return white_piece_name, white_position

def handle_black_input(parts: list, board: dict, black_pieces_count:dict) -> None:
    if len(parts) == 3:
        piece = parts[1]
        position = parts[2]
        if is_valid_piece(piece) and is_valid_position(position):
            if add_piece(board, piece, position, 'black', black_pieces_count):
                print(f"Added black {piece} at {position}.")
            else:
                print(f"Position '{position}' is already occupied. Please choose another position.")
        else:
            print("Invalid piece or position. Use: black_input <piece> <location>")
    else:
        print("Invalid command format. Use: black_input <piece> <location>")

def handle_check_captures(board: dict, white_piece_name: str | None, white_position: str | None) -> None:
    if white_piece_name and white_position:

        capturable_positions = get_capturable_pieces(board, white_piece_name, white_position)
        print(f"\nWhite {white_piece_name} at {white_position} can capture black pieces at the following positions:")
        if capturable_positions:
            for pos in capturable_positions:
                captured_piece_name = board[pos][0]
                print(f"- Black {captured_piece_name} at {pos}")
        else:
            print("No capturable pieces found.")

        attackable_squares = get_all_attackable_squares(white_piece_name, white_position, 'white')
        print("\n--- Board with All Attackable Squares (marked with X) ---")
        print()
        filtered_attackable_squares = [sq for sq in attackable_squares if sq != white_position]
        print_the_board(board, highlighted_squares=filtered_attackable_squares)
    else:
        print("No white piece has been placed yet. Please use 'white_input' first to place a white piece.")

# Validate a chess piece
def is_valid_piece(piece: str) -> bool:
    valid_pieces = ["pawn", "knight", "bishop", "rook", "queen", "king"]
    return piece in valid_pieces

# Validate a position on the chessboard
def is_valid_position(position: str) -> bool:
    if len(position) != 2:
        return False
    if position[0] < "a" or position[0] > "h":
        return False
    if position[1] < "1" or position[1] > "8":
        return False

    return True

# Parse user input for a piece and its position
def parse_piece_input(input_str: str) -> tuple[str, str] | None:
    parts = input_str.split()
    if len(parts) == 2 and is_valid_piece(parts[0]) and is_valid_position(parts[1]):
        return parts[0], parts[1]
    return None

# Add a piece to the board
def add_piece(board: dict, piece: str, position: str, color: str, black_pieces_count: dict) -> bool:
    
    max_pieces_black = {
        "pawn": 8,
        "knight": 2,
        "bishop": 2,
        "rook": 2,
        "queen": 1,
        "king": 1
    }

    if is_valid_position(position):
        if position in board:
            print(f"Position '{position}' is already occupied. Please choose another position.")
            return False
        
        if color == "black":
            if black_pieces_count[piece] >= max_pieces_black[piece]:
                print(f"Cannot add more than {max_pieces_black[piece]} black {piece}s.")
                return False
            board[position] = (piece, color)
            black_pieces_count[piece] += 1
            return True
        elif color == "white":
            board[position] = (piece,color)
            return True
    return False

# Check which black pieces the white piece can capture
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

def get_pawn_attack_targets(position: str, color: str) -> list[str]:
    attack_squares = []
    file = ord(position[0])
    rank = int(position[1])
    rank_direction = 1 if color == "white" else -1

    # Check for attacks on left and right diagonal
    if file > ord("a"):
        left_target_pos = f"{chr(file - 1)}{rank + rank_direction}"
        if is_valid_position(left_target_pos):
            attack_squares.append(left_target_pos)
    if file < ord("h"):
        right_target_pos = f"{chr(file + 1)}{rank + rank_direction}"
        if is_valid_position(right_target_pos):
            attack_squares.append(right_target_pos)

    return attack_squares

def get_sliding_attacks(position: str, directions: list[tuple[int, int]]) -> list[str]:
    attack_squares = []
    file = ord(position[0])
    rank = int(position[1])

    for d_file, d_rank in directions:
        current_file = file + d_file
        current_rank = rank + d_rank
        while "a" <= chr(current_file) <= "h" and 1 <= current_rank <= 8:
            attack_squares.append(f"{chr(current_file)}{current_rank}")
            current_file += d_file
            current_rank += d_rank
    return attack_squares

def get_knight_attack_targets(position: str) -> list[str]:
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

    if not is_valid_position(position) or position not in board or board[position][0] != "pawn":
        return []

    capturable_positions = []
    file = ord(position[0]) 
    rank = int(position[1])
    color = board[position][1]
    rank_direction = 1 if color == "white" else -1

    # Check for captures on the left and right diagonal
    if file > ord("a"):
        left_capture_pos = f"{chr(file - 1)}{rank + rank_direction}"
        if left_capture_pos in board and board[left_capture_pos][1] != color:
            capturable_positions.append(left_capture_pos)
    if file < ord("h"):
        right_capture_pos = f"{chr(file + 1)}{rank + rank_direction}"
        if right_capture_pos in board and board[right_capture_pos][1] != color:
            capturable_positions.append(right_capture_pos)
    return capturable_positions

# Mini-task 5.2: Capture logic for a rook
def get_rook_captures(position: str, board: dict[str, str]) -> list[str]:
    if not is_valid_position(position) or position not in board or board[position][0] != "rook":
        return []

    capturable_positions = []
    file = ord(position[0])
    rank = int(position[1])
    color = board[position][1]
    directions = [(0, 1), (0, -1), (1, 0), (-1, 0)] # Up, Down, Right, Left

    for d_file, d_rank in directions:
        current_file = file + d_file
        current_rank = rank + d_rank

        while "a" <= chr(current_file) <= "h" and 1 <= current_rank <= 8:
            current_pos = f"{chr(current_file)}{current_rank}"
            if current_pos in board:
                if board[current_pos][1] != color:
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
        if "a" <= chr(current_file) <= "h" and 1 <= current_rank <= 8:
            current_pos = f"{chr(current_file)}{current_rank}"
            if current_pos in board and board[current_pos][1] != color:
                capturable_positions.append(current_pos)

    return capturable_positions

# Mini-task 5.4 (optional): Capture logic for a bishop
def get_bishop_captures(position: str, board: dict[str, str]) -> list[str]:
    if not is_valid_position(position) or position not in board or board[position][0] != "bishop":
        return []

    capturable_positions = []
    file = ord(position[0])
    rank = int(position[1])
    color = board[position][1]
    directions = [(-1, -1), (-1, 1), (1, -1), (1, 1)]

    for d_file, d_rank in directions:
        current_file = file + d_file
        current_rank = rank + d_rank
        while "a" <= chr(current_file) <= "h" and 1 <= current_rank <= 8:
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
    directions = [(0, 1), (0, -1), (1, 0), (-1, 0), (-1, -1), (-1, 1), (1, -1), (1, 1)]

    for d_file, d_rank in directions:
        current_file = file + d_file
        current_rank = rank + d_rank

        while "a" <= chr(current_file) <= "h" and 1 <= current_rank <= 8:
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
    file = ord(position[0]) 
    rank = int(position[1])
    color = board[position][1]
    directions = [(-1, -1), (-1, 0), (-1, 1), ( 0, -1), ( 0, 1), ( 1, -1), ( 1, 0), ( 1, 1)]

    for d_file, d_rank in directions:
        current_file = file + d_file
        current_rank = rank + d_rank
        if "a" <= chr(current_file) <= "h" and 1 <= current_rank <= 8:
            current_pos = f"{chr(current_file)}{current_rank}"
            if current_pos in board and board[current_pos][1] != color:
                capturable_positions.append(current_pos)

    return capturable_positions


# Chess pieces symbols.
def get_chess_piece_symbol(piece: str, color: str) -> str:
    
    symbols = {
        "king": {"white": " ♔ ", "black": " ♚ "},
        "queen": {"white": " ♕ ", "black": " ♛ "},
        "rook": {"white": " ♖ ", "black": " ♜ "},
        "bishop": {"white": " ♗ ", "black": " ♝ "},
        "knight": {"white": " ♘ ", "black": " ♞ "},
        "pawn": {"white": " ♙ ", "black": " ♟ "},
    }

    if piece not in symbols:
        raise ValueError(f"Invalid piece name: {piece}. Valid options are: {', '.join(symbols.keys())}.")
    if color not in symbols[piece]:
        raise ValueError(f"Invalid color: {color}. Valid options are: 'white' or 'black'.")

    return symbols[piece][color]

def print_the_board(board: dict, highlighted_squares: list[str] = None) -> None:

    if highlighted_squares is None:
        highlighted_squares = []

    cell_width = 4
    board_grid = [[" " * cell_width for _ in range(8)] for _ in range(8)]
    file_to_col = {chr(ord("a") + i): i for i in range(8)}

    for position, (piece, color) in board.items():
        if is_valid_position(position):
            file, rank = position[0], int(position[1])
            col = file_to_col[file]
            row = 8 - rank
            board_grid[row][col] = get_chess_piece_symbol(piece, color).center(cell_width)

    for h_position in highlighted_squares:
        if is_valid_position(h_position) and h_position not in board:
            file, rank = h_position[0], int(h_position[1])
            col = file_to_col[file]
            row = 8 - rank
            board_grid[row][col] = " X ".center(cell_width)

    file_labels_str = " ".join(chr(ord("a") + i).center(cell_width) for i in range(8))
    separator_str = "+".join("-" * cell_width for _ in range(8))

    print(f"   {file_labels_str}   ")
    print(f"  +{separator_str}+  ")

    for row_index in range(8):
        rank = 8 - row_index
        row_cells_str = "|".join(board_grid[row_index])
        print(f"{rank} |{row_cells_str}| {rank}")
        print(f"  +{separator_str}+  ")
    print(f"   {file_labels_str}   ")

main()
