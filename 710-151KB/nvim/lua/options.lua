-- First, require the default NvChad options to ensure you inherit all the default settings
require "nvchad.options"

-- Then you can customize your vim options
local o = vim.o

-- Enable cursor line and set its options
o.cursorline = true      -- Enable cursorline
o.cursorlineopt = 'both' -- 'both' option highlights both the line and the number on the cursor line

-- Add any other options below
-- Example: Set the number of lines to keep above and below the cursor
o.scrolloff = 8

-- Example: Set the number of screen lines to keep to the left and right of the cursor if 'nowrap' is set
o.sidescrolloff = 8



-- Example: Show the absolute line number in the current line and relative numbers in all other lines

-- Example: Set the tab width
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true  -- Converts tabs to spaces

-- Remember to return any module if it's structured that way
return o
