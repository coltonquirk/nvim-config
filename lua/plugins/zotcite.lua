return {
    "jalvesaq/zotcite",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        require("zotcite").setup({
            -- options here (see doc/zotcite.txt)
        })
    end
}
