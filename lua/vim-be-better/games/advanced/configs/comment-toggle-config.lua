local difficultyConfig = {
    noob = {
        challenges = {
            {
                name = "Toggle single line comments",
                fileType = "javascript",
                startText = {
                    "function hello() {",
                    "    console.log('Hello World');",
                    "    return true;",
                    "}"
                },
                targetText = {
                    "function hello() {",
                    "    // console.log('Hello World');",
                    "    return true;",
                    "}"
                },
                cursorPos = { line = 2, col = 5 },
                task = "Comment out the console.log line",
                operation = "gcc to toggle line comment",
                hint = "Position cursor on line 2 and press 'gcc'"
            },
            {
                name = "Uncomment single line",
                fileType = "python",
                startText = {
                    "def greet(name):",
                    "    # print(f'Hello {name}')",
                    "    return f'Hi {name}'"
                },
                targetText = {
                    "def greet(name):",
                    "    print(f'Hello {name}')",
                    "    return f'Hi {name}'"
                },
                cursorPos = { line = 2, col = 5 },
                task = "Uncomment the print statement",
                operation = "gcc to toggle line comment",
                hint = "Position cursor on commented line and press 'gcc'"
            }
        }
    },

    easy = {
        challenges = {
            {
                name = "Comment multiple lines with motion",
                fileType = "lua",
                startText = {
                    "local function process(data)",
                    "    local result = {}",
                    "    for i, item in ipairs(data) do",
                    "        result[i] = item * 2",
                    "    end",
                    "    return result",
                    "end"
                },
                targetText = {
                    "local function process(data)",
                    "    local result = {}",
                    "    -- for i, item in ipairs(data) do",
                    "    --     result[i] = item * 2",
                    "    -- end",
                    "    return result",
                    "end"
                },
                cursorPos = { line = 3, col = 5 },
                task = "Comment out the for loop block (3 lines)",
                operation = "gc3j or gc2j (motion-based commenting)",
                hint = "Position cursor on 'for' line and use 'gc3j' or select visually and 'gc'"
            },
            {
                name = "Mixed comment/uncomment",
                fileType = "javascript",
                startText = {
                    "const config = {",
                    "    // api_url: 'https://api.example.com',",
                    "    timeout: 5000,",
                    "    // retries: 3,",
                    "    debug: false",
                    "};"
                },
                targetText = {
                    "const config = {",
                    "    api_url: 'https://api.example.com',",
                    "    // timeout: 5000,",
                    "    retries: 3,",
                    "    debug: false",
                    "};"
                },
                cursorPos = { line = 2, col = 5 },
                task = "Uncomment api_url and retries, comment timeout",
                operation = "Multiple gcc operations",
                hint = "Toggle comments on lines 2, 3, and 4 using gcc"
            }
        }
    },

    medium = {
        challenges = {
            {
                name = "Visual mode block commenting",
                fileType = "python",
                startText = {
                    "class DataProcessor:",
                    "    def __init__(self, data):",
                    "        self.data = data",
                    "        self.processed = False",
                    "    ",
                    "    def process(self):",
                    "        if not self.processed:",
                    "            self.data = [x * 2 for x in self.data]",
                    "            self.processed = True",
                    "        return self.data"
                },
                targetText = {
                    "class DataProcessor:",
                    "    def __init__(self, data):",
                    "        self.data = data",
                    "        self.processed = False",
                    "    ",
                    "    # def process(self):",
                    "    #     if not self.processed:",
                    "    #         self.data = [x * 2 for x in self.data]",
                    "    #         self.processed = True",
                    "    #     return self.data"
                },
                cursorPos = { line = 6, col = 5 },
                task = "Comment out the entire process method",
                operation = "Visual selection + gc",
                hint = "Select the process method using V4j then press gc"
            },
            {
                name = "HTML comment style",
                fileType = "html",
                startText = {
                    "<div class=\"container\">",
                    "    <h1>Welcome</h1>",
                    "    <p>This is a test page</p>",
                    "    <button>Click me</button>",
                    "</div>"
                },
                targetText = {
                    "<div class=\"container\">",
                    "    <h1>Welcome</h1>",
                    "    <!-- <p>This is a test page</p> -->",
                    "    <button>Click me</button>",
                    "</div>"
                },
                cursorPos = { line = 3, col = 5 },
                task = "Comment out the paragraph element",
                operation = "gcc (HTML comment style)",
                hint = "Position cursor on the <p> line and press gcc"
            }
        }
    },

    hard = {
        challenges = {
            {
                name = "Complex nested commenting",
                fileType = "javascript",
                startText = {
                    "function complexLogic(arr) {",
                    "    const filtered = arr.filter(x => x > 0);",
                    "    // const doubled = filtered.map(x => x * 2);",
                    "    const reduced = filtered.reduce((a, b) => a + b, 0);",
                    "    ",
                    "    if (reduced > 100) {",
                    "        console.log('Large sum detected');",
                    "        return reduced;",
                    "    }",
                    "    ",
                    "    return filtered;",
                    "}"
                },
                targetText = {
                    "function complexLogic(arr) {",
                    "    // const filtered = arr.filter(x => x > 0);",
                    "    const doubled = filtered.map(x => x * 2);",
                    "    // const reduced = filtered.reduce((a, b) => a + b, 0);",
                    "    ",
                    "    // if (reduced > 100) {",
                    "    //     console.log('Large sum detected');",
                    "    //     return reduced;",
                    "    // }",
                    "    ",
                    "    return filtered;",
                    "}"
                },
                cursorPos = { line = 2, col = 5 },
                task = "Toggle comments strategically: enable doubled, disable filtered and reduced, comment if-block",
                operation = "Multiple gcc and motion-based commenting",
                hint = "gcc on line 2, 3, 4, then gc3j on line 6"
            }
        }
    },

    nightmare = {
        challenges = {
            {
                name = "Multi-language comment mastery",
                fileType = "vue",
                startText = {
                    "<template>",
                    "  <div>",
                    "    <!-- <h1>{{ title }}</h1> -->",
                    "    <p>{{ description }}</p>",
                    "  </div>",
                    "</template>",
                    "",
                    "<script>",
                    "export default {",
                    "  data() {",
                    "    return {",
                    "      // title: 'My App',",
                    "      description: 'A Vue app'",
                    "    }",
                    "  }",
                    "}",
                    "</script>"
                },
                targetText = {
                    "<template>",
                    "  <div>",
                    "    <h1>{{ title }}</h1>",
                    "    <!-- <p>{{ description }}</p> -->",
                    "  </div>",
                    "</template>",
                    "",
                    "<script>",
                    "export default {",
                    "  data() {",
                    "    return {",
                    "      title: 'My App',",
                    "      // description: 'A Vue app'",
                    "    }",
                    "  }",
                    "}",
                    "</script>"
                },
                cursorPos = { line = 3, col = 5 },
                task = "Toggle comments in both HTML and JavaScript sections",
                operation = "Mixed HTML and JS commenting",
                hint = "Uncomment h1, comment p, uncomment title, comment description"
            }
        }
    },

    tpope = {
        challenges = {
            {
                name = "Lightning fast comment surgery",
                fileType = "javascript",
                startText = {
                    "// Configuration object for the application",
                    "const appConfig = {",
                    "  // Server settings",
                    "  server: {",
                    "    port: 3000,",
                    "    // host: 'localhost',",
                    "    ssl: false",
                    "  },",
                    "  // Database configuration",
                    "  database: {",
                    "    // type: 'postgresql',",
                    "    host: 'db.example.com',",
                    "    port: 5432,",
                    "    // ssl: true",
                    "  },",
                    "  // Feature flags",
                    "  features: {",
                    "    newUI: true,",
                    "    // analytics: false,",
                    "    experimental: false",
                    "  }",
                    "};"
                },
                targetText = {
                    "// Configuration object for the application",
                    "const appConfig = {",
                    "  // Server settings",
                    "  server: {",
                    "    // port: 3000,",
                    "    host: 'localhost',",
                    "    // ssl: false",
                    "  },",
                    "  // Database configuration",
                    "  database: {",
                    "    type: 'postgresql',",
                    "    // host: 'db.example.com',",
                    "    // port: 5432,",
                    "    ssl: true",
                    "  },",
                    "  // Feature flags",
                    "  features: {",
                    "    // newUI: true,",
                    "    analytics: false,",
                    "    // experimental: false",
                    "  }",
                    "};"
                },
                cursorPos = { line = 5, col = 5 },
                task = "Perform precise comment surgery across the entire config",
                operation = "Rapid precise commenting with minimal keystrokes",
                hint = "Master level: Toggle 9 specific lines efficiently"
            }
        }
    }
}

return difficultyConfig
