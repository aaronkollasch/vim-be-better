local difficultyConfig = {
    noob = {
        challenges = {
            {
                name = "Open specific function",
                startText = {
                    "function getUserData() {",
                    "  const user = database.findById(id);",
                    "  return user;",
                    "}",
                    "",
                    "function processUser() {",
                    "  const user = getCurrentUser();",
                    "  if (!user) return null;",
                    "  const processed = transform(user);",
                    "  return processed;",
                    "}",
                    "",
                    "function validateUser() {",
                    "  return user && user.isValid;",
                    "}",
                    "",
                    "function saveUser() {",
                    "  return database.save(user);",
                    "}"
                },
                foldSetup = {
                    folds = {
                        { start = 1,  ["end"] = 4,  closed = true },
                        { start = 6,  ["end"] = 11, closed = true },
                        { start = 13, ["end"] = 15, closed = true },
                        { start = 17, ["end"] = 19, closed = true }
                    }
                },
                winCondition = {
                    type = "fold_open",
                    targetFold = { start = 6, ["end"] = 11 }
                },
                cursorPos = { line = 6, col = 1 },
                task = "Open the processUser function fold",
                operation = "Navigate to fold and press za or zo",
                hint = "Find the closed processUser fold and press za to open it"
            },
            {
                name = "Close all helper functions",
                startText = {
                    "// Main function",
                    "function main() {",
                    "  executeProcess();",
                    "}",
                    "",
                    "// Helper functions",
                    "function helper1() {",
                    "  return data;",
                    "}",
                    "",
                    "function helper2() {",
                    "  return more;",
                    "}"
                },
                foldSetup = {
                    folds = {
                        { start = 1,  ["end"] = 3,  closed = false },
                        { start = 5,  ["end"] = 8,  closed = false },
                        { start = 10, ["end"] = 12, closed = false }
                    }
                },
                winCondition = {
                    type = "all_closed"
                },
                cursorPos = { line = 5, col = 1 },
                task = "Close all the helper function folds",
                operation = "Navigate to folds and press zc",
                hint = "Use zc to close each helper function fold individually"
            }
        }
    },

    easy = {
        challenges = {
            {
                name = "Navigate with folds",
                startText = {
                    "class UserManager {",
                    "  constructor() {",
                    "    this.users = [];",
                    "  }",
                    "",
                    "  addUser(user) {",
                    "    this.users.push(user);",
                    "    return user;",
                    "  }",
                    "}"
                },
                foldSetup = {
                    folds = {
                        { start = 1, ["end"] = 4,  closed = true },
                        { start = 6, ["end"] = 10, closed = true }
                    }
                },
                winCondition = {
                    type = "fold_open",
                    targetFold = { start = 6, ["end"] = 10 }
                },
                cursorPos = { line = 1, col = 1 },
                task = "Open the addUser method fold",
                operation = "Navigate to method fold and open it",
                hint = "Move to the addUser method fold and press za to open it"
            },
            {
                name = "Selective fold management",
                startText = {
                    "// Configuration",
                    "const config = {",
                    "  api: 'localhost',",
                    "  port: 3000,",
                    "  debug: true",
                    "}",
                    "",
                    "// Main logic",
                    "function init() {",
                    "  setup();",
                    "}"
                },
                foldSetup = {
                    folds = {
                        { start = 2, ["end"] = 5,  closed = false },
                        { start = 7, ["end"] = 10, closed = false }
                    }
                },
                winCondition = {
                    type = "fold_closed",
                    targetFold = { start = 2, ["end"] = 5 }
                },
                cursorPos = { line = 2, col = 1 },
                task = "Close the config object fold",
                operation = "Navigate to config and close the fold",
                hint = "Move to the config object and press zc to close it"
            },
            {
                name = "Open multiple folds",
                startText = {
                    "interface API {",
                    "  get(url: string): Promise<any>;",
                    "  post(url: string, data: any): Promise<any>;",
                    "}",
                    "",
                    "class HttpClient implements API {",
                    "  async get(url: string) {",
                    "    return fetch(url);",
                    "  }",
                    "",
                    "  async post(url: string, data: any) {",
                    "    return fetch(url, { method: 'POST', body: JSON.stringify(data) });",
                    "  }",
                    "}"
                },
                foldSetup = {
                    folds = {
                        { start = 1,  ["end"] = 4,  closed = true },
                        { start = 6,  ["end"] = 9,  closed = true },
                        { start = 11, ["end"] = 13, closed = true }
                    }
                },
                winCondition = {
                    type = "fold_open",
                    targetFold = { start = 1, ["end"] = 4 }
                },
                cursorPos = { line = 1, col = 1 },
                task = "Open the interface definition fold",
                operation = "Navigate to interface and open it",
                hint = "Find the interface API fold and press za to open it"
            },
            {
                name = "Close specific methods",
                startText = {
                    "class Calculator {",
                    "  add(a, b) {",
                    "    return a + b;",
                    "  }",
                    "",
                    "  subtract(a, b) {",
                    "    return a - b;",
                    "  }",
                    "",
                    "  multiply(a, b) {",
                    "    return a * b;",
                    "  }",
                    "}"
                },
                foldSetup = {
                    folds = {
                        { start = 2,  ["end"] = 4,  closed = false },
                        { start = 6,  ["end"] = 8,  closed = false },
                        { start = 10, ["end"] = 12, closed = false }
                    }
                },
                winCondition = {
                    type = "fold_closed",
                    targetFold = { start = 10, ["end"] = 12 }
                },
                cursorPos = { line = 10, col = 1 },
                task = "Close the multiply method fold",
                operation = "Navigate to multiply method and close it",
                hint = "Move to the multiply method and press zc to close it"
            },
            {
                name = "Open constructor",
                startText = {
                    "class Database {",
                    "  constructor(config) {",
                    "    this.host = config.host;",
                    "    this.port = config.port;",
                    "    this.connect();",
                    "  }",
                    "",
                    "  connect() {",
                    "    console.log('Connecting...');",
                    "  }",
                    "}"
                },
                foldSetup = {
                    folds = {
                        { start = 2, ["end"] = 6,  closed = true },
                        { start = 8, ["end"] = 10, closed = false }
                    }
                },
                winCondition = {
                    type = "fold_open",
                    targetFold = { start = 2, ["end"] = 6 }
                },
                cursorPos = { line = 2, col = 1 },
                task = "Open the constructor fold",
                operation = "Navigate to constructor and open it",
                hint = "Find the constructor method and press za to open it"
            }
        }
    },

    medium = {
        challenges = {
            {
                name = "Complex fold states",
                startText = {
                    "function processData() {",
                    "  const data = getData();",
                    "  return data;",
                    "}",
                    "",
                    "function validateData() {",
                    "  const valid = checkData();",
                    "  return valid;",
                    "}",
                    "",
                    "function saveData() {",
                    "  const saved = store();",
                    "  return saved;",
                    "}"
                },
                foldSetup = {
                    folds = {
                        { start = 1,  ["end"] = 4,  closed = false },
                        { start = 6,  ["end"] = 9,  closed = false },
                        { start = 11, ["end"] = 14, closed = false }
                    }
                },
                winCondition = {
                    type = "specific_states",
                    states = {
                        { start = 1,  ["end"] = 4,  shouldBeOpen = false },
                        { start = 6,  ["end"] = 9,  shouldBeOpen = true },
                        { start = 11, ["end"] = 14, shouldBeOpen = false }
                    }
                },
                cursorPos = { line = 1, col = 1 },
                task = "Set specific fold states: close first and third, keep second open",
                operation = "Selective fold management",
                hint = "Close processData and saveData folds, keep validateData open"
            },
            {
                name = "Organize code sections",
                startText = {
                    "// Imports",
                    "import React from 'react';",
                    "import { useState } from 'react';",
                    "",
                    "// Component",
                    "function App() {",
                    "  const [count, setCount] = useState(0);",
                    "  return <div>{count}</div>;",
                    "}",
                    "",
                    "// Exports",
                    "export default App;"
                },
                foldSetup = {
                    folds = {
                        { start = 2,  ["end"] = 3,  closed = false },
                        { start = 5,  ["end"] = 9,  closed = false },
                        { start = 11, ["end"] = 12, closed = false }
                    }
                },
                winCondition = {
                    type = "specific_states",
                    states = {
                        { start = 2,  ["end"] = 3,  shouldBeOpen = false },
                        { start = 5,  ["end"] = 9,  shouldBeOpen = true },
                        { start = 11, ["end"] = 12, shouldBeOpen = false }
                    }
                },
                cursorPos = { line = 2, col = 1 },
                task = "Close imports and exports, keep component open",
                operation = "Organize code by folding imports/exports",
                hint = "Close the imports and exports sections, leave the component visible"
            },
            {
                name = "API methods management",
                startText = {
                    "class ApiService {",
                    "  async getUsers() {",
                    "    return fetch('/api/users');",
                    "  }",
                    "",
                    "  async createUser(data) {",
                    "    return fetch('/api/users', { method: 'POST', body: JSON.stringify(data) });",
                    "  }",
                    "",
                    "  async updateUser(id, data) {",
                    "    return fetch(`/api/users/${id}`, { method: 'PUT', body: JSON.stringify(data) });",
                    "  }",
                    "",
                    "  async deleteUser(id) {",
                    "    return fetch(`/api/users/${id}`, { method: 'DELETE' });",
                    "  }",
                    "}"
                },
                foldSetup = {
                    folds = {
                        { start = 2,  ["end"] = 4,  closed = true },
                        { start = 6,  ["end"] = 8,  closed = false },
                        { start = 10, ["end"] = 12, closed = true },
                        { start = 14, ["end"] = 16, closed = false }
                    }
                },
                winCondition = {
                    type = "specific_states",
                    states = {
                        { start = 2,  ["end"] = 4,  shouldBeOpen = true },
                        { start = 6,  ["end"] = 8,  shouldBeOpen = false },
                        { start = 10, ["end"] = 12, shouldBeOpen = true },
                        { start = 14, ["end"] = 16, shouldBeOpen = false }
                    }
                },
                cursorPos = { line = 2, col = 1 },
                task = "Open GET and UPDATE methods, close CREATE and DELETE",
                operation = "Show only read and update operations",
                hint = "Open getUsers and updateUser, close createUser and deleteUser"
            }
        }
    },

    hard = {
        challenges = {
            {
                name = "Advanced fold navigation",
                startText = {
                    "export class APIClient {",
                    "  constructor(config) {",
                    "    this.config = config;",
                    "  }",
                    "",
                    "  async get(endpoint) {",
                    "    return fetch(endpoint);",
                    "  }",
                    "",
                    "  async post(endpoint, data) {",
                    "    return fetch(endpoint, { method: 'POST', body: data });",
                    "  }",
                    "",
                    "  private handleError(error) {",
                    "    console.error(error);",
                    "  }",
                    "}"
                },
                foldSetup = {
                    folds = {
                        { start = 1,  ["end"] = 4,  closed = false },
                        { start = 6,  ["end"] = 8,  closed = true },
                        { start = 10, ["end"] = 12, closed = true },
                        { start = 14, ["end"] = 16, closed = false }
                    }
                },
                winCondition = {
                    type = "specific_states",
                    states = {
                        { start = 1,  ["end"] = 4,  shouldBeOpen = true },
                        { start = 6,  ["end"] = 8,  shouldBeOpen = true },
                        { start = 10, ["end"] = 12, shouldBeOpen = false },
                        { start = 14, ["end"] = 16, shouldBeOpen = false }
                    }
                },
                cursorPos = { line = 6, col = 1 },
                task = "Open constructor and get method, close post and handleError",
                operation = "Complex fold state management",
                hint = "Open the get method fold, then close the post and handleError folds"
            },
            {
                name = "Complex class organization",
                startText = {
                    "class UserManager {",
                    "  // Private fields",
                    "  #users = [];",
                    "  #cache = new Map();",
                    "",
                    "  // Public methods",
                    "  addUser(user) {",
                    "    this.#users.push(user);",
                    "    this.#cache.set(user.id, user);",
                    "  }",
                    "",
                    "  getUser(id) {",
                    "    return this.#cache.get(id);",
                    "  }",
                    "",
                    "  // Private methods",
                    "  #validateUser(user) {",
                    "    return user && user.id && user.name;",
                    "  }",
                    "}"
                },
                foldSetup = {
                    folds = {
                        { start = 2,  ["end"] = 4,  closed = false },
                        { start = 6,  ["end"] = 10, closed = true },
                        { start = 12, ["end"] = 14, closed = false },
                        { start = 16, ["end"] = 18, closed = true }
                    }
                },
                winCondition = {
                    type = "specific_states",
                    states = {
                        { start = 2,  ["end"] = 4,  shouldBeOpen = false },
                        { start = 6,  ["end"] = 10, shouldBeOpen = true },
                        { start = 12, ["end"] = 14, shouldBeOpen = false },
                        { start = 16, ["end"] = 18, shouldBeOpen = true }
                    }
                },
                cursorPos = { line = 2, col = 1 },
                task = "Hide fields and getUser, show addUser and validation",
                operation = "Focus on modification and validation methods",
                hint = "Close private fields and getUser, open addUser and validateUser"
            },
            {
                name = "Service layer organization",
                startText = {
                    "class DatabaseService {",
                    "  // Connection management",
                    "  connect() {",
                    "    return this.pool.getConnection();",
                    "  }",
                    "",
                    "  disconnect() {",
                    "    return this.pool.end();",
                    "  }",
                    "",
                    "  // CRUD operations",
                    "  async create(table, data) {",
                    "    const query = `INSERT INTO ${table} SET ?`;",
                    "    return this.execute(query, data);",
                    "  }",
                    "",
                    "  async read(table, where) {",
                    "    const query = `SELECT * FROM ${table} WHERE ?`;",
                    "    return this.execute(query, where);",
                    "  }",
                    "",
                    "  // Utility methods",
                    "  execute(query, params) {",
                    "    return this.pool.query(query, params);",
                    "  }",
                    "}"
                },
                foldSetup = {
                    folds = {
                        { start = 2,  ["end"] = 5,  closed = true },
                        { start = 7,  ["end"] = 9,  closed = false },
                        { start = 11, ["end"] = 14, closed = false },
                        { start = 16, ["end"] = 19, closed = true },
                        { start = 21, ["end"] = 24, closed = false }
                    }
                },
                winCondition = {
                    type = "specific_states",
                    states = {
                        { start = 2,  ["end"] = 5,  shouldBeOpen = false },
                        { start = 7,  ["end"] = 9,  shouldBeOpen = false },
                        { start = 11, ["end"] = 14, shouldBeOpen = true },
                        { start = 16, ["end"] = 19, shouldBeOpen = true },
                        { start = 21, ["end"] = 24, shouldBeOpen = false }
                    }
                },
                cursorPos = { line = 11, col = 1 },
                task = "Focus on CRUD operations: show create and read methods only",
                operation = "Hide connection and utility methods, show CRUD",
                hint = "Close connect, disconnect, and execute; open create and read methods"
            }
        }
    },

    nightmare = {
        challenges = {
            {
                name = "Master fold orchestration",
                startText = {
                    "interface UserRepository {",
                    "  findById(id: string): Promise<User>;",
                    "  save(user: User): Promise<void>;",
                    "  delete(id: string): Promise<void>;",
                    "}",
                    "",
                    "class DatabaseUserRepository implements UserRepository {",
                    "  async findById(id: string) {",
                    "    return db.query('SELECT * FROM users WHERE id = ?', [id]);",
                    "  }",
                    "",
                    "  async save(user: User) {",
                    "    return db.query('INSERT INTO users ...', user);",
                    "  }",
                    "",
                    "  async delete(id: string) {",
                    "    return db.query('DELETE FROM users WHERE id = ?', [id]);",
                    "  }",
                    "",
                    "  private validateUser(user: User) {",
                    "    return user && user.email && user.name;",
                    "  }",
                    "}"
                },
                foldSetup = {
                    folds = {
                        { start = 1,  ["end"] = 5,  closed = true },
                        { start = 7,  ["end"] = 10, closed = false },
                        { start = 12, ["end"] = 14, closed = true },
                        { start = 16, ["end"] = 18, closed = false },
                        { start = 20, ["end"] = 22, closed = true }
                    }
                },
                winCondition = {
                    type = "specific_states",
                    states = {
                        { start = 1,  ["end"] = 5,  shouldBeOpen = true },
                        { start = 7,  ["end"] = 10, shouldBeOpen = false },
                        { start = 12, ["end"] = 14, shouldBeOpen = true },
                        { start = 16, ["end"] = 18, shouldBeOpen = false },
                        { start = 20, ["end"] = 22, shouldBeOpen = true }
                    }
                },
                cursorPos = { line = 1, col = 1 },
                task = "Open interface, save, and validateUser; close findById and delete",
                operation = "Master-level fold orchestration",
                hint = "Complex fold state: open interface, close findById, open save, close delete, open validateUser"
            },
            {
                name = "Enterprise architecture view",
                startText = {
                    "// Domain Models",
                    "interface User {",
                    "  id: string;",
                    "  email: string;",
                    "  name: string;",
                    "}",
                    "",
                    "// Repository Layer",
                    "abstract class BaseRepository<T> {",
                    "  protected abstract tableName: string;",
                    "  async findAll(): Promise<T[]> { /* implementation */ }",
                    "}",
                    "",
                    "// Service Layer",
                    "class UserService {",
                    "  constructor(private userRepo: UserRepository) {}",
                    "  async getUsers() { return this.userRepo.findAll(); }",
                    "}",
                    "",
                    "// Controller Layer",
                    "class UserController {",
                    "  constructor(private userService: UserService) {}",
                    "  async getUsers(req, res) { /* implementation */ }",
                    "}",
                    "",
                    "// Application Entry",
                    "const app = express();",
                    "app.use('/users', userController);"
                },
                foldSetup = {
                    folds = {
                        { start = 2,  ["end"] = 6,  closed = false },
                        { start = 8,  ["end"] = 12, closed = true },
                        { start = 14, ["end"] = 17, closed = false },
                        { start = 19, ["end"] = 22, closed = true },
                        { start = 24, ["end"] = 26, closed = false }
                    }
                },
                winCondition = {
                    type = "specific_states",
                    states = {
                        { start = 2,  ["end"] = 6,  shouldBeOpen = true },
                        { start = 8,  ["end"] = 12, shouldBeOpen = false },
                        { start = 14, ["end"] = 17, shouldBeOpen = true },
                        { start = 19, ["end"] = 22, shouldBeOpen = false },
                        { start = 24, ["end"] = 26, shouldBeOpen = true }
                    }
                },
                cursorPos = { line = 2, col = 1 },
                task = "Show domain, service and app layers; hide repository and controller",
                operation = "Architectural layer focus",
                hint = "Open User interface, UserService, and app entry; close BaseRepository and UserController"
            }
        }
    },

    tpope = {
        challenges = {
            {
                name = "tpope's fold mastery",
                startText = {
                    "\" Vim configuration sections",
                    "\" Basic settings",
                    "set number",
                    "set relativenumber",
                    "set tabstop=4",
                    "",
                    "\" Key mappings",
                    "nnoremap <leader>w :w<CR>",
                    "nnoremap <leader>q :q<CR>",
                    "",
                    "\" Plugin settings",
                    "let g:netrw_banner = 0",
                    "let g:netrw_liststyle = 3",
                    "",
                    "\" Custom functions",
                    "function! ToggleQuickfix()",
                    "  \" implementation",
                    "endfunction"
                },
                foldSetup = {
                    folds = {
                        { start = 2,  ["end"] = 5,  closed = true },
                        { start = 7,  ["end"] = 9,  closed = false },
                        { start = 11, ["end"] = 13, closed = true },
                        { start = 15, ["end"] = 18, closed = false }
                    }
                },
                winCondition = {
                    type = "all_closed"
                },
                cursorPos = { line = 7, col = 1 },
                task = "Close all configuration sections",
                operation = "Close all folds for clean config overview",
                hint = "Use zM to close all folds at once, or manually close each section"
            },
            {
                name = "Vim plugin configuration",
                startText = {
                    "\" Plugin manager setup",
                    "call plug#begin('~/.vim/plugged')",
                    "Plug 'tpope/vim-surround'",
                    "Plug 'tpope/vim-commentary'",
                    "call plug#end()",
                    "",
                    "\" Surround configuration",
                    "let g:surround_{char2nr('c')} = \"\\1command: \\1\\r\\1\\1\"",
                    "",
                    "\" Commentary configuration",
                    "autocmd FileType javascript setlocal commentstring=//\\ %s",
                    "",
                    "\" Custom mappings",
                    "nmap <leader>gc gc",
                    "vmap <leader>gc gc"
                },
                foldSetup = {
                    folds = {
                        { start = 2,  ["end"] = 5,  closed = false },
                        { start = 7,  ["end"] = 8,  closed = true },
                        { start = 10, ["end"] = 11, closed = false },
                        { start = 13, ["end"] = 14, closed = true }
                    }
                },
                winCondition = {
                    type = "specific_states",
                    states = {
                        { start = 2,  ["end"] = 5,  shouldBeOpen = true },
                        { start = 7,  ["end"] = 8,  shouldBeOpen = false },
                        { start = 10, ["end"] = 11, shouldBeOpen = true },
                        { start = 13, ["end"] = 14, shouldBeOpen = false }
                    }
                },
                cursorPos = { line = 2, col = 1 },
                task = "Show plugin manager and commentary, hide surround and mappings",
                operation = "Focus on core plugin setup",
                hint = "Keep plugin manager and commentary visible, fold surround config and mappings"
            }
        }
    }
}

return difficultyConfig
