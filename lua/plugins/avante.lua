return {
  "yetone/avante.nvim",
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  -- ⚠️ must add this setting! ! !
  build = vim.fn.has("win32") ~= 0
      and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    -- add any opts here
    -- this file can contain specific instructions for your project
    instructions_file = "avante.md",
    -- for example
    provider = "antigravity",
    providers = {
      antigravity = {
        endpoint = "https://daily-cloudcode-pa.sandbox.googleapis.com",
        model = "antigravity-gemini-3-pro",
        timeout = 30000,
        api_key_name = "cmd:echo 'dummy'", 
        
        -- Required by Avante
        is_disable_stream = function(self) return false end,

        parse_curl_args = function(self, code_opts)
          local Gemini = require("avante.providers.gemini")
          local mock_self = setmetatable({}, { __index = Gemini })
          
          -- Prepare the standard Gemini body (contents, systemInstruction, tools, etc.)
          local gemini_body = Gemini.prepare_request_body(mock_self, code_opts, self, {})

          -- Fix: Lua empty tables serialize to [] (list) by default, but the API expects {} (object)
          -- for generationConfig. We force it to be an object by adding a dummy field or ensuring it's nil if empty.
          if gemini_body.generationConfig and next(gemini_body.generationConfig) == nil then
            gemini_body.generationConfig = nil
          end
          
          -- Alternatively, we can set default generation config if needed
          -- gemini_body.generationConfig = { temperature = 0.9 } 
          
          -- Wrap the body for Antigravity v1internal API
          -- We use the fallback project ID "rising-fact-p41fc" which often works for personal accounts
          -- when the managed project returns SUBSCRIPTION_REQUIRED.
          local body = {
            project = "projects/rising-fact-p41fc",
            model = "models/" .. self.model,
            request = gemini_body
          }

          -- Execute the auth script to get the token
          local handle = io.popen("python3 " .. vim.fn.expand("~/.config/nvim/scripts/antigravity_auth.py"))
          local token = handle:read("*a"):gsub("%s+", "")
          handle:close()

          return {
            url = self.endpoint .. "/v1internal:streamGenerateContent?alt=sse",
            proxy = nil,
            insecure = false,
            headers = {
              ["Content-Type"] = "application/json",
              ["Authorization"] = "Bearer " .. token,
              ["X-Goog-Api-Client"] = "google-cloud-sdk vscode_cloudshelleditor/0.1",
              ["Client-Metadata"] = '{"ideType":"IDE_UNSPECIFIED","platform":"PLATFORM_UNSPECIFIED","pluginType":"GEMINI"}'
            },
            body = body
          }
        end,
        parse_response_data = function(data_stream, event_state, opts)
           require("avante.providers.gemini").parse_response(event_state, data_stream, nil, opts)
        end
      },
      gemini = {
        model = "gemini-1.5-pro-latest",
      },
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-sonnet-4-20250514",
        timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
      },
      moonshot = {
        endpoint = "https://api.moonshot.ai/v1",
        model = "kimi-k2-0711-preview",
        timeout = 30000, -- Timeout in milliseconds
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 32768,
        },
      },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-mini/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "stevearc/dressing.nvim", -- for input provider dressing
    "folke/snacks.nvim", -- for input provider snacks
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
