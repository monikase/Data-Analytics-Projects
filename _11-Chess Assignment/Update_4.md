# A Chess Question
## 4. Implement a Game Menu System

This Python code builds upon the previous Chess Task (Update_3.py) by replacing the linear input system with an interactive menu that allows flexible commands.  

Menu Commands:

```
  - white_input <piece> <location>    (e.g., knight a5)
  - black_input <piece> <location>    (e.g., bishop d6)
  - print_board                       (displays the current board)
  - check_captures                    (lists capturable black pieces)
  - exit                              (quits the program)
```

---



```python
import random
```

### NEW: get_random_position()
