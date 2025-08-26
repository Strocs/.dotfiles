return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- Helper function to check if a file exists
    local function file_exists(path)
      local stat = vim.uv.fs_stat(path)
      return stat and stat.type == "file"
    end

    -- Helper function to check if project uses a tool
    local function project_uses_eslint()
      local root = vim.fn.getcwd()
      local eslint_configs = {
        ".eslintrc",
        ".eslintrc.js",
        ".eslintrc.cjs",
        ".eslintrc.yaml",
        ".eslintrc.yml",
        ".eslintrc.json",
        "eslint.config.js",
        "eslint.config.mjs",
        "eslint.config.cjs",
      }
      
      -- Check for eslint config files
      for _, config in ipairs(eslint_configs) do
        if file_exists(root .. "/" .. config) then
          return true
        end
      end
      
      -- Check package.json for eslint dependency
      local package_json = root .. "/package.json"
      if file_exists(package_json) then
        local ok, content = pcall(vim.fn.readfile, package_json)
        if ok and content then
          local json_str = table.concat(content, "\n")
          if json_str:match('"eslint"') then
            return true
          end
        end
      end
      
      return false
    end

    local function project_uses_tailwind()
      local root = vim.fn.getcwd()
      local tailwind_configs = {
        "tailwind.config.js",
        "tailwind.config.cjs",
        "tailwind.config.mjs",
        "tailwind.config.ts",
        "tailwind.config.json",
      }
      
      -- Check for tailwind config files
      for _, config in ipairs(tailwind_configs) do
        if file_exists(root .. "/" .. config) then
          return true
        end
      end
      
      -- Check package.json for tailwind dependency
      local package_json = root .. "/package.json"
      if file_exists(package_json) then
        local ok, content = pcall(vim.fn.readfile, package_json)
        if ok and content then
          local json_str = table.concat(content, "\n")
          if json_str:match('"tailwindcss"') then
            return true
          end
        end
      end
      
      return false
    end

    -- Initialize servers table
    opts.servers = opts.servers or {}

    -- Disable LazyVim's default TypeScript servers
    opts.servers.tsserver = false
    opts.servers.ts_ls = false
    opts.servers.typescript_language_server = false

    -- Configure vtsls with proper memory limits
    opts.servers.vtsls = {
      cmd = {
        "vtsls",
        "--stdio",
        "--tsserver-max-memory=2048",  -- Increased to reasonable limit
      },
      settings = {
        typescript = {
          workspaceSymbols = {
            scope = "currentProject",
          },
        },
        vtsls = {
          tsserver = {
            maxTsServerMemory = 2048,  -- Ensure this matches the CLI arg
          },
          experimental = {
            completion = {
              enableServerSideFuzzyMatch = false,
            },
          },
        },
      },
    }

    -- Configure ESLint with project-based detection
    if project_uses_eslint() then
      opts.servers.eslint = {
        settings = {
          workingDirectories = { mode = "auto" },
        },
      }
    else
      opts.servers.eslint = false
    end

    -- Configure Tailwind CSS with project-based detection
    if project_uses_tailwind() then
      opts.servers.tailwindcss = {
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                "tw`([^`]*)",
                "tw=\"([^\"]*)",
                "tw={\"([^\"}]*)",
                "tw\\.\\w+`([^`]*)",
                "tw\\(.*?\\)`([^`]*)",
              },
            },
          },
        },
      }
    else
      opts.servers.tailwindcss = false
    end

    opts.inlay_hints = opts.inlay_hints or {}
    opts.inlay_hints.enabled = false

    return opts
  end,
}
