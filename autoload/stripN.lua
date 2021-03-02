--[[
README:
    To strip all `\N`s in every line.
]]

script_name = 'strip \\N'
script_description = 'To strip all `\\N`s in every line.'
script_author = 'Zero'
script_version = '0.1'

function strip(sub, sel)
    for _, i in ipairs(sel) do
		local line = sub[i]
		line.text = string.gsub(line.text, '\\N', ' ')
		sub[i] = line
	end
    aegisub.set_undo_point(script_name)
    return sel
end

aegisub.register_macro(script_name, script_description, strip)
