# vim-be-better

A comprehensive vim training plugin featuring game-based exercises to improve your vim skills through structured practice and challenges.
It was created on top of the fork of [vim-be-good plugin](https://github.com/ThePrimeagen/vim-be-good)

## Features

- **25+ Different Games** across 8 categories
- **Progressive difficulty system** (noob → easy → medium → hard → nightmare → tpope)
- **Comprehensive vim motion coverage** from basic navigation to advanced text objects

## Installation

### Requirements
- Neovim 0.8.0+

### Plugin Managers

#### lazy.nvim
```lua
{
  'szymonwilczek/vim-be-better',
  config = function()
    -- Optional: Enable logging for debugging
    vim.g.vim_be_better_log_file = 1
  end
}
```

#### vim-plug
```vim
Plug 'szymonwilczek/vim-be-better'
```

#### packer.nvim
```lua
use 'szymonwilczek/vim-be-better'
```

## Quick Start

1. Open Neovim in an empty buffer
2. Run `:VimBeBetter` to open the game menu
3. Select a category and difficulty level (using 'x' - not 'dd' like in original plugin)
4. Complete the challenges to improve your vim skills

## Game Categories

### 🎯 Navigation
Master vim's movement commands and navigation techniques.

#### find-char
Practice using `f`, `F`, `t`, `T` motions to quickly navigate to specific characters.

```
Challenge: Find the character marked with '^'
Text: The quick brown fox jumps over the lazy dog
      ^
Use: f, F, t, T motions
```

#### word-boundaries
Learn efficient word-based navigation with `w`, `b`, `e`, `ge`.

```
Challenge: Navigate to specific word boundaries
function validateEmail(email) { return email.includes('@'); }
         ^              ^
Target positions marked with ^
```

#### bracket-jump
Master bracket matching with `%` and related motions.

```
Challenge: Jump between matching brackets
if (condition && (nested || check)) {
^                 ^      ^       ^
Navigate efficiently between all bracket pairs
```

#### visual-precision
Practice precise text selection using visual mode operations.

```
Challenge: Select specific text ranges
const userConfig = { name: 'John', age: 25 };
      ^^^^^^^^^^^    Select this exact range
Use: Visual mode + motions
```

### ✂️ Text Objects
Learn to manipulate text efficiently using vim's text objects.

#### text-objects-basic
Practice fundamental text objects like `iw`, `aw`, `is`, `ip`.

```
Challenge: Delete inner word
function processData(input) {
         ^^^^^^^^^^^
Use: diw to delete 'processData'
```

#### block-edit
Master block operations and complex text object combinations.

```
Challenge: Change content inside braces across multiple lines
const config = {
  api: { url: 'test', timeout: 5000 },
  db: { host: 'localhost', port: 3306 }
};
Use: ci{ and related commands
```

### 🔄 Substitution
Master vim's powerful search and replace capabilities.

#### substitute-basic
Learn fundamental substitution patterns with `:s` command.

```
Challenge: Replace all occurrences of 'var' with 'let'
var userName = 'john';
var userAge = 25;
Expected: let userName = 'john';
```

#### regex-master
Practice advanced regular expressions in vim substitutions.

```
Challenge: Extract email domains
Email: john.doe@example.com
Expected: example.com
Use: Advanced regex patterns
```

#### global-replace
Master global search and replace across multiple lines and patterns.

```
Challenge: Convert snake_case to camelCase
user_name → userName
user_email → userEmail
Use: Global substitution commands
```

### 📝 Formatting
Learn vim's formatting and indentation commands.

#### indent-master
Practice indentation commands like `>>`, `<<`, `=`.

```
Challenge: Fix indentation
function test() {
local x = 1
return x
end

Expected:
function test() {
    local x = 1
    return x
end
```

#### case-converter
Master case conversion with `~`, `gu`, `gU`, `g~`.

```
Challenge: Convert to uppercase
hello world → HELLO WORLD
Use: gUiw or similar commands
```

#### join-lines
Practice line joining with `J` and `gJ`.

```
Challenge: Join lines appropriately
const message = 'Hello' +
               'World';
Expected: const message = 'Hello' + 'World';
```

### 🔢 Numbers & Operations
Practice numeric operations and calculations in vim.

#### increment-game
Master number increment/decrement with `<C-a>` and `<C-x>`.

```
Challenge: Increment all numbers by 1
version = 1.2.3
Expected: version = 2.3.4
Use: <C-a> on each number
```

#### number-sequence
Learn to work with number sequences and patterns.

```
Challenge: Create sequence
1
2
3
Expected: 1, 2, 3, 4, 5
Use: Various vim techniques
```

### 🏗️ Advanced Features
Master vim's most powerful features.

#### macro-recorder
Learn to record and execute macros for repetitive tasks.

```
Challenge: Add quotes to each word
apple
banana
cherry

Expected:
"apple"
"banana"
"cherry"

Solution: qa I" <Esc> A" <Esc> j q, then @a for repetition
```

#### dot-repeat
Master the `.` command for efficient repetition.

```
Challenge: Replace all 'x' with correct letters
vim xs awesome
practxce makes perfect

Expected:
vim is awesome
practice makes perfect

Use: Replace first 'x', then navigate and use '.' to repeat
```

#### fold-master
Practice code folding techniques with `zf`, `zo`, `zc`.

```
Challenge: Fold function definitions
function longFunction() {
    // many lines of code
    return result;
}
Use: zf motions to create folds
```

#### comment-toggle
Learn efficient code commenting techniques.

```
Challenge: Toggle comments on selected lines
function test() {
    console.log('debug');
    return true;
}

Use: gcc for line comments, gc with motions
```

### 🎪 Mixed Challenges
Combine multiple vim skills in complex scenarios.

#### speed-editing
Complete editing tasks as quickly as possible with time limits.

```
Challenge: Add semicolons to 3 lines (Target: 8 seconds)
let x = 1
let y = 2
let z = 3

Expected:
let x = 1;
let y = 2;
let z = 3;

Scoring: 🥇 Gold ≤8s, 🥈 Silver ≤10.4s, 🥉 Bronze ≤12s
```

#### refactor-race
Apply real-world refactoring techniques quickly and accurately.

```
Challenge: Extract magic number (Target: 12 seconds)
function validateAge(age) {
  return age >= 18;
}

Expected:
const MIN_AGE = 18;

function validateAge(age) {
  return age >= MIN_AGE;
}
```

#### vim-golf
Complete tasks with minimum keystrokes - like golf, lower score wins.

```
Challenge: Add semicolon (Par: 2 keystrokes)
console.log('hello')

Expected:
console.log('hello');

Optimal Solution: A; (2 keystrokes)
Scoring: 🏆 Hole-in-one (2), 🥇 Eagle (<2), 🥈 Birdie (2), 🥉 Par (≤5)
```

### 📚 Classic Games
Traditional vim training games with modern enhancements.

#### words
Practice word navigation and manipulation.

#### hjkl
Master basic directional movement.

#### relative
Learn relative line jumping with numbers.

#### whackamole
Quick character location and case manipulation.

#### ci{
Practice "change inside" operations with various delimiters.

#### snake
A vim-controlled snake game for fun practice.

## Difficulty Levels

- **noob**: Basic operations with hints and guidance
- **easy**: Simple challenges with some assistance
- **medium**: Intermediate complexity without hints
- **hard**: Advanced challenges requiring efficiency
- **nightmare**: Expert-level operations
- **tpope**: Master-level challenges (named after Tim Pope)

## Commands

- `:VimBeBetter` - Open the main game menu

## Configuration

```lua
-- Enable logging for debugging
vim.g.vim_be_better_log_file = 1

-- Custom difficulty preferences (optional)
vim.g.vim_be_better_default_difficulty = "easy"
```

## Contributing

We welcome contributions! Here's how to get started:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

### Development Setup

```bash
# Clone your fork
git clone https://github.com/szymonwilczek/vim-be-better.git
cd vim-be-better

# For local development, add to your neovim config:
# ~/.config/nvim/init.lua
vim.opt.rtp:prepend('/path/to/vim-be-better')

# or add it directly to your plugin configuration by appending the path
```

### Adding New Games

To add a new game, create a new file in the appropriate category directory:
- `lua/vim-be-better/games/[category]/[game-name].lua`
- Follow the existing game structure and patterns
- Update `lua/vim-be-better/types.lua` to include your game

## Issues and Support

If you encounter any issues:

1. Enable logging: `vim.g.vim_be_better_log_file = 1`
2. Reproduce the issue
3. Check the log file: `:echo stdpath("data") . "/vim-be-better.log"`
4. Create an issue with the log contents

## Acknowledgments
[ThePrimeagen](https://github.com/ThePrimeagen) - [vim-be-good](https://github.com/ThePrimeagen/vim-be-good)
