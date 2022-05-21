-- TODO: 
-- 1. Show LSP server name near the message if option is passed.
-- 2. Regenerate the status message when `LspProgressUpdate` is arrived.

local M = require("lualine.component"):extend()

local default_options = {
   icon = "",
}

function M:init(options)
   M.super.init(self, options)
   self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)
end

function M:update_status()
   local function isempty(value) return value == nil or value == "" end
   local messages = vim.lsp.util.get_progress_messages()

   -- In order to avoid cluttering we're showing only the last message since
   -- the last one probably contains most actual information.
   for i = #messages, 1, -1 do
      local msg = messages[i]

      if msg.progress then
         local status = {}

         if not isempty(msg.title) then
            table.insert(status, msg.title)
         end

         if not isempty(msg.message) then
            table.insert(status, msg.message)
         end

         if not isempty(msg.percentage) then
            table.insert(status, string.format("(%u%%%%)", msg.percentage))
         end

         if not vim.tbl_isempty(status) then
            return vim.trim(table.concat(status, " - "))
         end
      end
   end
end

return M
