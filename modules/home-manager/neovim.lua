vim.cmd [[silent! colorscheme catppuccin]]

require("nvim-treesitter.configs").setup {
  highlight = {
    enable = true,
  }
}

local cmp = require("cmp")
local lspkind = require("lspkind")

cmp.setup {
  snippet = {
    expand = function(args)
      require("snippy").expand_snippet(args.body)
    end
  },

  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),

  sources = {
    { name = 'snippy' },
    { name = 'neorg' },
    { name = 'buffer' },
  },

  formatting = {
    format = lspkind.cmp_format({ with_text = false, maxwidth = 50 })
  }
}

require('snippy').setup({
    mappings = {
        is = {
            ['<Tab>'] = 'expand_or_advance',
            ['<S-Tab>'] = 'previous',
        },
        nx = {
            ['<leader>x'] = 'cut_text',
        },
    },
})

require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { }
}

require("neorg").setup {
  load = {
    ["core.defaults"] = {},
    ["core.norg.dirman"] = {
      config = {
        workspaces = {
          work = "~/notes/work",
        }
      }
    },
    ["core.norg.completion"] = {
      config = {
        engine = "nvim-cmp"
      }
    },
  }
}