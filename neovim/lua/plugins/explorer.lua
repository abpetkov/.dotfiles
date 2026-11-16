return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          -- Dotfiles are hidden unless this is on. Gitignored files stay hidden.
          files = { hidden = true },
          grep = { hidden = true },
          grep_word = { hidden = true },
          explorer = {
            hidden = true,
            on_show = function(picker)
              local override = {
                Normal = "SnacksExplorer",
                NormalNC = "SnacksExplorer",
                NormalFloat = "SnacksExplorer",
                FloatBorder = "SnacksExplorerBorder",
                FloatTitle = "SnacksExplorerTitle",
                FloatFooter = "SnacksExplorer",
              }

              local function patch_opts(opts)
                if not opts then
                  return
                end
                opts.wo = opts.wo or {}
                opts.wo.winhighlight = Snacks.util.winhl(opts.wo.winhighlight, override)
              end

              local function paint(win)
                if not win then
                  return
                end
                patch_opts(win.opts)
                if win.win and vim.api.nvim_win_is_valid(win.win) and win.update then
                  win:update()
                end
              end

              local function paint_all()
                paint(picker.list and picker.list.win)
                paint(picker.input and picker.input.win)
                local saved = picker.layout and picker.layout.win_opts
                if saved then
                  patch_opts(saved.list)
                  patch_opts(saved.input)
                end
                for _, win in pairs((picker.layout and picker.layout.box_wins) or {}) do
                  paint(win)
                end
              end

              -- Layout refreshes rewrite the list window from a saved copy, which
              -- puts the dark float background back. Patch that copy too.
              paint_all()
              vim.schedule(paint_all)
            end,
          },
        },
      },
    },
  },
}
