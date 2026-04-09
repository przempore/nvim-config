local harpoon_ok, harpoon = pcall(require, "harpoon")
if not harpoon_ok then
  return
end

harpoon.setup({
  global_settings = {
    save_on_toggle = true,
    save_on_change = true,
  },
})

-- OPTIONAL: telescope support
-- local conf = require("telescope.config").values
-- local function toggle_telescope(harpoon_files)
--     local file_paths = {}
--     for _, item in ipairs(harpoon_files.items) do
--         table.insert(file_paths, item.value)
--     end
--
--     require("telescope.pickers").new({}, {
--         prompt_title = "Harpoon",
--         finder = require("telescope.finders").new_table({
--             results = file_paths,
--         }),
--         previewer = conf.file_previewer({}),
--         sorter = conf.generic_sorter({}),
--     }):find()
-- end
-- vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
--     { desc = "Open harpoon window" })

vim.keymap.set("n", "<leader>a", function()
  require("harpoon.mark").add_file()
end)
vim.keymap.set("n", "<leader>e", function()
  require("harpoon.ui").toggle_quick_menu()
end)

vim.keymap.set("n", "<C-h>", function()
  require("harpoon.ui").nav_file(1)
end)
vim.keymap.set("n", "<C-t>", function()
  require("harpoon.ui").nav_file(2)
end)
vim.keymap.set("n", "<C-n>", function()
  require("harpoon.ui").nav_file(3)
end)
vim.keymap.set("n", "<C-s>", function()
  require("harpoon.ui").nav_file(4)
end)
