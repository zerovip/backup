--[[
README:
    To change the order of lines back to chinese-english seperated.
]]

script_name = '中英分开 seperate_different_languages'
script_description = 'To change the order of lines back to chinese-english seperated.'
script_author = 'Zero'
script_version = '0.1'

function seperate(sub, sel)
    local sub_backup = {}
    for subi, seli in ipairs(sel) do
        sub_backup[seli] = sub[seli]
    end
    local slen = #sel
    for subi, seli in ipairs(sel) do
        if subi <= slen / 2 then
            sub[seli] = sub_backup[sel[subi * 2 - 1]]
        elseif subi > slen / 2 then
            sub[seli] = sub_backup[sel[subi * 2 - slen]]
        end
    end
    aegisub.set_undo_point(script_name)
    return sel
end

function seperate_validation(sub, sel)
    return #sel % 2 == 0
end

aegisub.register_macro(script_name, script_description, seperate, seperate_validation)
