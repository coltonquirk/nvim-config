local M = {}

function M.in_math()
	local ok, node = pcall(vim.treesitter.get_node)
	if not ok or not node then return 0 end
	while node do
		if node:type() == "math" then
			return 1
		end
		node = node:parent()
	end
	return 0
end

_G.InTypstMath = M.in_math

vim.cmd([[
	function! InTypstMath()
		return luaeval('InTypstMath()')
	endfunction
]])

return M
