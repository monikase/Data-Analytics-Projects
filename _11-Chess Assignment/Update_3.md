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

### NEW: get_all_attackable_squares()

