return {
  {
    "rebelot/kanagawa.nvim",
    opts = {
      theme = "wave",
      colors = {
        theme = {
          wave = {
            ui = {
              bg = "#2D2A2E",
              bg_gutter = "#2D2A2E",
            },
          },
        },
      },
      overrides = function(colors)
        local bg = colors.theme.ui.bg
        return {
          SnacksExplorer = { fg = colors.theme.ui.fg, bg = bg },
          SnacksExplorerBorder = { fg = colors.theme.ui.nontext, bg = bg },
          SnacksExplorerTitle = { fg = colors.theme.ui.special, bg = bg, bold = true },
          -- Indent guides in the file tree. Linked to LineNr by default, which paints a stripe.
          SnacksPickerTree = { fg = colors.theme.ui.nontext, bg = bg },
        }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "kanagawa-wave" },
  },
}
