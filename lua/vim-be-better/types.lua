local difficulty = {
    "noob",
    "easy",
    "medium",
    "hard",
    "nightmare",
    "tpope",
}

local categories = {
    "🎯 Navigation",
    "✂️ Text Objects",
    "🔄 Substitution",
    "📝 Formatting",
    "🔢 Numbers & Operations",
    "🏗️ Advanced Features",
    "🎪 Mixed Challenges",
    "📚 Classic Games"
}

local gamesByCategory = {
    ["🎯 Navigation"] = {
        "find-char",
        "word-boundaries",
        "bracket-jump",
        "visual-precision",
    },
    ["✂️ Text Objects"] = {
        "text-objects-basic",
        "block-edit"
    },
    ["🔄 Substitution"] = {
        "substitute-basic",
        "regex-master",
        "global-replace"
    },
    ["📝 Formatting"] = {
        "indent-master",
        "case-converter",
        "join-lines"
    },
    ["🔢 Numbers & Operations"] = {
        "increment-game",
        "number-sequence"
    },
    ["🏗️ Advanced Features"] = {
        "macro-recorder",
        "dot-repeat",
        "fold-master",
        "comment-toggle"
    },
    ["🎪 Mixed Challenges"] = {
        "vim-golf",
        "speed-editing",
        "refactor-race"
    },
    ["📚 Classic Games"] = {
        "words",
        "ci{",
        "relative",
        "hjkl",
        "whackamole",
        "snake",
        "random"
    }
}

-- compatibility
local games = {
    "words",
    "ci{",
    "relative",
    "hjkl",
    "whackamole",
    "snake",
    "random",
}

return {
    difficulty = difficulty,
    games = games,
    categories = categories,
    gamesByCategory = gamesByCategory
}
