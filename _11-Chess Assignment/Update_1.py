# Mini-task 1: Validate a chess piece
def is_valid_piece(piece: str) -> bool:
    """Checks if the given piece name is valid."""
    valid_pieces = ["pawn", "knight", "bishop", "rook", "queen", "king"]
    return piece in valid_pieces

# Mini-task 2: Validate a position on the chessboard
def is_valid_position(position: str) -> bool:
    """
    Checks if the given position is valid on a chessboard.
    """
    if len(position) != 2:
        return False
    
    file = position[0]
    rank = position[1]

    if not ('a' <= file <= 'h'):
        return False
    
    if not ('1' <= rank <= '8'):
        return False
    
    return True

# Mini-task 3: Parse user input for a piece and its position
def parse_piece_input(input_str: str) -> tuple[str, str] | None:
    """
    Parses the input string for a piece and its position.
    """
    parts = input_str.split()
    if len(parts) == 2 and is_valid_piece(parts[0]) and is_valid_position(parts[1]):
        return parts[0], parts[1]
    return None

# Mini-task 4: Add a piece to the board
# def add_piece(board: dict[str, str], piece: str, position: str) -> bool: 
def add_piece(board: dict, piece: str, position: str, color: str) -> bool:    # UPDATE: Receiving 4 arguments

    if is_valid_position(position) and position not in board:
        board[position] = (piece, color)  # UPDATE: Added color   
        return True
    return False

# Mini-task 5.1: Capture logic for a pawn
def get_pawn_captures(position: str, board: dict) -> list[str]:
    """
    Determines the pieces a pawn can capture.
    """
    # Check piece name from tuple and get its color.
    if not is_valid_position(position) or position not in board or board[position][0] != "pawn":
        return []

    capturable_positions = []
    file = ord(position[0])
    rank = int(position[1])
    our_color = board[position][1]

    # Determine pawn movement direction based on its color.
    rank_direction = 1 if our_color == 'white' else -1

    # Check for captures on left diagonal
    if file > ord('a'):
        left_capture_pos = f"{chr(file - 1)}{rank + rank_direction}"
        # FIX: Check if the target piece is of the opposite color.
        if left_capture_pos in board and board[left_capture_pos][1] != our_color:
            capturable_positions.append(left_capture_pos)

    # Check for captures on the right diagonal
    if file < ord('h'):
        right_capture_pos = f"{chr(file + 1)}{rank + rank_direction}"
        # FIX: Check if the target piece is of the opposite color.
        if right_capture_pos in board and board[right_capture_pos][1] != our_color:
            capturable_positions.append(right_capture_pos)

    return capturable_positions

# Mini-task 5.2: Capture logic for a rook
def get_rook_captures(position: str, board: dict) -> list[str]:
    """
    Determines the pieces a rook can capture.
    """
    if not is_valid_position(position) or position not in board or board[position][0] != "rook":
        return []
      
    capturable_positions = []
    file = ord(position[0])
    rank = int(position[1])
    color = board[position][1]

    directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]  # Up, Down, Right, Left

    for d_file, d_rank in directions:
        current_file = file + d_file
        current_rank = rank + d_rank

        while 'a' <= chr(current_file) <= 'h' and 1 <= current_rank <= 8:
            current_pos = f"{chr(current_file)}{current_rank}"
            if current_pos in board:
                if board[current_pos][1] != color:                # UPDATE
                    capturable_positions.append(current_pos)
                break  # Stop in this direction after finding the first piece
            current_file += d_file
            current_rank += d_rank

    return capturable_positions

# Mini-task 5.3: Capture logic for a knight
def get_knight_captures(position: str, board: dict) -> list[str]:

    if not is_valid_position(position) or position not in board or board[position][0] != "knight":
        return []

    capturable_positions = []
    file = ord(position[0])
    rank = int(position[1])
    color = board[position][1]

    knight_moves = [(-2, -1), (-2, 1), (-1, -2), (-1, 2), (1, -2), (1, 2), (2, -1), (2, 1)]
    for d_file, d_rank in knight_moves:
        current_file = file + d_file
        current_rank = rank + d_rank
        if 'a' <= chr(current_file) <= 'h' and 1 <= current_rank <= 8:
            current_pos = f"{chr(current_file)}{current_rank}"
            if current_pos in board and board[current_pos][1] != color:
                capturable_positions.append(current_pos)

    return capturable_positions

# Mini-task 5.4: Capture logic for a bishop
def get_bishop_captures(position: str, board: dict) -> list[str]:
    """
    Determines the pieces a bishop can capture.
    """
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
        while 'a' <= chr(current_file) <= 'h' and 1 <= current_rank <= 8:
            current_pos = f"{chr(current_file)}{current_rank}"
            if current_pos in board:
                if board[current_pos][1] != color:
                    capturable_positions.append(current_pos)
                break
            current_file += d_file
            current_rank += d_rank

    return capturable_positions

# Mini-task 5.5: Capture logic for a queen
def get_queen_captures(position: str, board: dict) -> list[str]:
    """
    Determines the pieces a queen can capture.
    """
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

        while 'a' <= chr(current_file) <= 'h' and 1 <= current_rank <= 8:
            current_pos = f"{chr(current_file)}{current_rank}"
            if current_pos in board:
                if board[current_pos][1] != color:
                    capturable_positions.append(current_pos)
                break
            current_file += d_file
            current_rank += d_rank

    return capturable_positions

# Mini-task 5.6: Capture logic for a king
def get_king_captures(position: str, board: dict) -> list[str]:
    """
    Determines the pieces a king can capture.
    """
    if not is_valid_position(position) or position not in board or board[position][0] != "king":
        return []
        
    capturable_positions = []
    file = ord(position[0])
    rank = int(position[1])
    our_color = board[position][1]

    directions = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]

    for d_file, d_rank in directions:
        current_file = file + d_file
        current_rank = rank + d_rank
        if 'a' <= chr(current_file) <= 'h' and 1 <= current_rank <= 8:
            current_pos = f"{chr(current_file)}{current_rank}"
            if current_pos in board and board[current_pos][1] != our_color:
                capturable_positions.append(current_pos)

    return capturable_positions

# Mini-task 6: Check which pieces the specified piece can capture
def get_capturable_pieces(board: dict, white_piece: str, white_position: str) -> list[str]:
    """
    Determines which black pieces the white piece can capture.
    """
    if white_piece == "pawn":
        return get_pawn_captures(white_position, board)
    elif white_piece == "rook":
        return get_rook_captures(white_position, board)
    elif white_piece == "bishop":
        return get_bishop_captures(white_position, board)
    elif white_piece == "knight":
        return get_knight_captures(white_position, board)
    elif white_piece == "queen":
        return get_queen_captures(white_position, board)
    elif white_piece == "king":
        return get_king_captures(white_position, board)
    else:
        return []

def get_chess_piece_symbol(piece: str, color: str) -> str:
    """
    Returns the UTF-8 symbol for the specified chess piece.
    """
    symbols = {
        "king": {"white": " ♔ ", "black": " ♚ "},
        "queen": {"white": " ♕ ", "black": " ♛ "},
        "rook": {"white": " ♖ ", "black": " ♜ "},
        "bishop": {"white": " ♗ ", "black": " ♝ "},
        "knight": {"white": " ♘ ", "black": " ♞ "},
        "pawn": {"white": " ♙ ", "black": " ♟ "},
    }
    return symbols.get(piece, {}).get(color, " ? ")

def print_the_board(board: dict) -> None:
    """Prints the current state of the chessboard with adjusted spacing."""
    cell_width = 4
    board_grid = [[" " * cell_width for _ in range(8)] for _ in range(8)]
    file_to_col = {chr(ord('a') + i): i for i in range(8)}
    
    # FIX: Unpacking (piece, color) now works because add_piece stores a tuple.
    for position, (piece, color) in board.items():
        if is_valid_position(position):
            file, rank = position[0], int(position[1])
            col = file_to_col[file]
            row = 8 - rank
            # Center the symbol inside the cell for proper alignment
            board_grid[row][col] = get_chess_piece_symbol(piece, color).center(cell_width)

    # Labels for files ('a' through 'h')
    file_labels_str = " ".join(chr(ord('a') + i).center(cell_width) for i in range(8))
    
    # Separator line between ranks
    separator_str = "+".join("-" * cell_width for _ in range(8))

    # Print the top file labels
    print(f"   {file_labels_str}   ")
    # Print the top border
    print(f"  +{separator_str}+  ")

    # Print each rank with its pieces and side labels
    for row_index in range(8):
        rank = 8 - row_index
        row_cells_str = "|".join(board_grid[row_index])
        print(f"{rank} |{row_cells_str}| {rank}")
        print(f"  +{separator_str}+  ")

    # Print the bottom file labels
    print(f"   {file_labels_str}   ")

# Mini-task 7: Main function
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
            if add_piece(board, white_piece_name, white_position, 'white'):
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

if __name__ == "__main__":
    main()
