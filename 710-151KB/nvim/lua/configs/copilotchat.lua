-- ~/.config/nvim/lua/configs/copilotchat.lua

local M = {}

M.setup = function()
  require("CopilotChat").setup {
    -- Basic settings
    debug = true,  -- Enable debug logging for troubleshooting
    proxy = nil,   -- Define a proxy if needed, e.g., "http://myproxy.com:8080"
    allow_insecure = false,  -- Set to true if your proxy or connection is insecure

    -- Model and system prompt configuration
    system_prompt = "You are an AI assistant helping developers.", -- Custom system prompt
    model = 'gpt-4o',  -- GPT model: 'gpt-3.5-turbo', 'gpt-4', or 'gpt-4o'
    temperature = 0.2,  -- Control the randomness of the AI’s response

    -- Headers and formatting
    question_header = '  User ',  -- Header for user input
    answer_header = '  Copilot ',  -- Header for Copilot's response
    error_header = '## Error ',  -- Header for errors
    separator = '───',  -- Separator used in chat

    -- Behavior and display options
    show_folds = true,  -- Display folds for sections in the chat window
    show_help = false,  -- Show help messages when idle
    auto_follow_cursor = true,  -- Follow cursor in chat window
    auto_insert_mode = false,  -- Automatically switch to insert mode in chat
    insert_at_end = true,  -- Move cursor to end when inserting text
    clear_chat_on_new_prompt = false,  -- Keep chat history between prompts
    highlight_selection = true,  -- Highlight selection in source when discussing in chat

    -- History and context
    context = 'buffer',  -- Use buffer-level context
    history_path = vim.fn.stdpath('data') .. '/copilotchat_history',  -- Save history
    callback = nil,  -- Optional: Set callback when response is received

    -- Selection methods for chat prompts
    selection = function(source)
      return require("CopilotChat.select").visual(source) or require("CopilotChat.select").line(source)
    end,

    -- Window layout options
    window = {
      layout = 'float',  -- Use a floating window for chat
      width = 0.5,  -- Set fractional width (or an absolute value if > 1)
      height = 0.5,  -- Set fractional height
      relative = 'editor',  -- Float relative to the whole editor window
      border = 'rounded',  -- Use rounded borders for a cleaner look
      title = 'gpt-4o',  -- Title of the window
      zindex = 50,  -- Set the window z-index for layering
    },

    -- Default prompts
    prompts = {
      Explain = {
        prompt = '/COPILOT_EXPLAIN Write an explanation for the selected code.',
      },
      Review = {
        prompt = '/COPILOT_REVIEW Review the selected code for quality and efficiency.',
      },
      Fix = {
        prompt = '/COPILOT_GENERATE Fix any problems in this code.',
      },
      Optimize = {
        prompt = '/COPILOT_GENERATE Optimize this code for performance.',
      },
      Docs = {
        prompt = '/COPILOT_GENERATE Add documentation for the selected code.',
      },
      Tests = {
        prompt = '/COPILOT_GENERATE Generate tests for the selected code.',
      },
      Commit = {
        prompt = 'Write a commit message following the commitizen convention.',
      },
      AlgorithmImprovement = {
        prompt = '/COPILOT_OPTIMIZE Analyze the selected algorithm and suggest improvements in its time complexity and space complexity.',
      },
    },

    -- Key mappings
    mappings = {
      complete = {
        insert = '<Tab>',  -- Use Tab for completing prompts
      },
      close = {
        normal = 'q',  -- Use 'q' to close the chat window
        insert = '<C-c>',  -- Ctrl-C to close in insert mode
      },
      reset = {
        normal = '<C-l>',  -- Ctrl-L to reset the chat
        insert = '<C-l>',  -- Same for insert mode
      },
      submit_prompt = {
        normal = '<CR>',  -- Enter to submit in normal mode
        insert = '<C-s>',  -- Ctrl-S to submit in insert mode
      },
      accept_diff = {
        normal = '<C-y>',  -- Ctrl-Y to accept changes
        insert = '<C-y>',  -- Same for insert mode
      },
      yank_diff = {
        normal = 'gy',  -- 'gy' to yank (copy) the diff output
      },
      show_diff = {
        normal = 'gd',  -- 'gd' to show code diff
      },
      show_system_prompt = {
        normal = 'gp',  -- 'gp' to show system prompt
      },
      show_user_selection = {
        normal = 'gs',  -- 'gs' to show selected code
      },
    },
  }
end


-- Function to trigger glow.nvim after response
M.preview_with_glow = function()
  vim.cmd('Glow')
end


return M
