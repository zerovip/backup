--[[
README:
    To add a tag indicating that this sentence have not been checked.
]]

script_name = '未检查标记 non-check tag'
script_description = 'To add a tag indicating that this sentence have not been checked.'
script_author = 'Zero'
script_version = '0.1'

function strip(sub, sel)
    for _, i in ipairs(sel) do
		local line = sub[i]
		line.text = '【未检查】' .. line.text .. '【未检查】'
		sub[i] = line
	end
    aegisub.set_undo_point(script_name)
    return sel
end

aegisub.register_macro(script_name, script_description, strip)
