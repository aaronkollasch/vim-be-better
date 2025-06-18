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
    "🔍 Search & Replace",
    "🎨 Visual & Selection",
    "🔢 Numbers & Operations",
    "🏗️ Advanced Features",
    "🎪 Mixed Challenges",
    "📚 Classic Games"
}

local games = {
    navigation = {
        "find-char",
        "word-boundaries",
        "bracket-jump"
    },

    ["text-objects"] = {
        "text-objects-basic",
        "text-objects-advanced",
        "block-edit"
    },

    substitution = {
        "substitute-basic",
        "regex-master",
        "global-replace"
    },

    formatting = {
        "indent-master",
        "case-converter",
        "join-lines"
    },

    ["search-replace"] = {
        "search-replace",
        "pattern-hunter"
    },

    ["visual-selection"] = {
        "visual-precision",
        "visual-block"
    },

    ["numbers-operations"] = {
        "increment-game",
        "number-sequence"
    },

    ["advanced-features"] = {
        "macro-recorder",
        "dot-repeat",
        "fold-master",
        "comment-toggle"
    },

    ["mixed-challenges"] = {
        "vim-golf",
        "speed-editing",
        "refactor-race"
    },

    ["legacy-games"] = {
        "words",
        "ci{",
        "relative",
        "hjkl",
        "whackamole",
        "snake",
        "random",
    }
}

local function getAllGames()
    local allGames = {}
    for category, gameList in pairs(games) do
        for _, game in ipairs(gameList) do
            table.insert(allGames, game)
        end
    end
    table.insert(allGames, "random")
    return allGames
end

local function getGamesByCategory(categoryIndex)
    local categoryKeys = {
        "navigation",
        "text-objects",
        "substitution",
        "formatting",
        "search-replace",
        "visual-selection",
        "numbers-operations",
        "advanced-features",
        "mixed-challenges",
        "legacy-games"
    }

    return games[categoryKeys[categoryIndex]] or {}
end

return {
    difficulty = difficulty,
    categories = categories,
    games = games,
    getAllGames = getAllGames,
    getGamesByCategory = getGamesByCategory
}
