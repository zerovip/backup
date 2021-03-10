--[[
README:
    To change the order of lines after copy lines and translate lines.
]]

script_name = '中英混排 mix_different_languages'
script_description = 'To change the order of lines after copy lines and translate lines.'
script_author = 'Zero'
script_version = '0.1'

function mix(sub, sel)
    local sub_backup = {}
    for subi, seli in ipairs(sel) do
        sub_backup[seli] = sub[seli]
    end
    local slen = #sel
    for subi, seli in ipairs(sel) do
        if subi % 2 ~= 0 then
            sub[seli] = sub_backup[sel[(subi + 1) / 2]]
        elseif subi % 2 == 0 then
            sub[seli] = sub_backup[sel[(subi + slen) / 2]]
        end
    end
    aegisub.set_undo_point(script_name)
    return sel
end

function mix_validation(sub, sel)
    return #sel % 2 == 0
end

aegisub.register_macro(script_name, script_description, mix, mix_validation)
