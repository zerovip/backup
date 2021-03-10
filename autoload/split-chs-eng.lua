--[[
"Line Split" -- An Auto4 LUA script for cleaning up ASS subtitle lines of badly-formed override
blocks and redundant/duplicate tags
* Designed to work for Aegisub 2.0 and above (only pre-release version was available at the time of
writing) @ http://www.malakith.net/aegiwiki
* The changes performed on your subtitles are guaranteed to be undo-able provided that Aegisub's undo
mechanism works. Even so, I am not responsible if it damages your subtitles permanently, so please
back up your subtitle file before applying the cleaning up

Copyright (c) 2015-2020 Syler Zhou<sylerzhou@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial
portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

local tr = aegisub.gettext

script_name = tr"中英拆行 CHS-ENG Line Split"
script_description = tr"split subtitles in different lines, for example, a dual language subtitles(chs-eng) will be split into chs and eng in different lines."
script_author = "Syler Zhou"
script_version = "1.1"
script_modified = "19 April 2015"

alternative_style_name="SecondStyle"

switch_alternative_position=true
remove_alternative_tags=true

states = {}
positions = {}
function parse_text( source )
	for k,v in pairs(states) do
  states[k] = nil
	end
	for k,v in pairs(positions) do
  positions[k] = nil
	end

	local length = string.len(source)

	--[[ state machine to parse the text.
	0: normal text(Chinese), 1: line break state, 2: mark state start(like {font},
	3: mark state end, 4: ascii text char state(English),
	--]]
	local state = 0
	local i=1
	while i<=length do
		local subword = string.sub(source,i,i)
		if subword == " " then
			--ignore white space, make it simpler.
		elseif subword == "\\" then
			if string.sub(source,i,i+1) == "\\N" then
				state = 1
				record_state(state,i)
				-- skip the 'N'
				i=i+1
			else
				if state==2 then
				--ignore it, it is in the mark.
				else
					state = 4
					record_state(state,i)
				end
			end
		elseif subword == "{" then
			state = 2
			record_state(state,i)
		elseif subword == "}" and state == 2 then
			state = 3
			record_state(state,i)
		elseif is_ascii_char(subword) then
			if state==2 then
				--ignore it, it is in the mark.
			else
				state = 4
				record_state(state,i)
			end
		else
			if state==2 then
				--ignore it, it is in the mark.
			else
				state=0
				record_state(state,i)
			end
		end
		i=i+1
	end

	length = table.getn(states)

	-- reset the state and begin new function
	state = nil
	local split_position = nil
	local start_with_chs = nil
	local line_break_count = 0
	for i=1,length do
		if state==nil then
			state=states[i]
			if state==0 then
				start_with_chs=true
			elseif state==4 then
				start_with_chs=false
			end
		elseif states[i]==0 then
			if state==1 then
				if start_with_chs==true then
					-- it's also chs, only just like the chs subs contains \N
					state=states[i]
					if line_break_count>0 then
						split_position=nil
					end
				else
					-- may be this is a eng-chs subtitle
					state=states[i]
				end
			else
				if start_with_chs==nil then
					state=states[i]
					start_with_chs=true
				elseif start_with_chs==false then
					if line_break_count==0 then
						start_with_chs=true
						state=states[i]
					end
				else
					state=states[i]
				end
			end
		elseif states[i]==4 then
			if state==1 then
				if start_with_chs == true then
					--may it's chs-eng
					state=states[i]
				else
					--it's continue with eng
					state=states[i]
					if line_break_count>0 then
						split_position=nil
					end
				end
			else
				if start_with_chs==nil then
					start_with_chs = false
					state=states[i]
				else
					state=states[i]
				end
			end

			if start_with_chs==nil then
				start_with_chs=false
			end
		elseif states[i]==1 then
			state = states[i]
			if start_with_chs~=nil then
				line_break_count = line_break_count + 1
				split_position=i
			end
		end
	end

	if start_with_chs==nil then
		return nil,nil
	end

	if line_break_count==0 or split_position==nil then
		if start_with_chs == true then
			return source,nil
		else
			return nil,source
		end
	end

	local chs=string.sub(source,1,positions[split_position]-1)
	local eng=string.sub(source,positions[split_position]+2)
	if start_with_chs == false then
		local temp = chs
		eng=chs
		chs=temp
	end

	return chs,eng
end

function is_ascii_char(char)
	local ascii = string.byte(char,1)
	if ascii >=32 and ascii <= 127 then
		return true
	end

	return false
end

function record_state(new_state, position)
	local len = table.getn(states)
	if states[len]~=new_state then
		table.insert(states,new_state)
		table.insert(positions,position)
	end
end


function Getconfiguration()
local button,dialog, result_table
	dialog=
	{
		{
			class="label",name="lbltips", x=1,y=0,width=1,height=2,label="Please backup your subtitle file to a safe place first."
		},
	   {
			class="checkbox",name="engTopOverChs", x=1,y=2,width=1,height=1,value=true, label="switch subtitle position", hint="switch the position of the newly splited subtitle, for example, if the original subtitle contains chs & eng, and the chs display on top of the eng version, by check this button, it will make the eng on top of the chs, and vice versa."
	   },
	   {
			class="checkbox",name="remove_alter_style",x=1,y=3,width=1,height=1,value=true,label="remove the tags for this SecondStyle",hint="whether to remove the style tags for the second line."
	   }
	}

	button, result_table = aegisub.dialog.display(dialog,{"Do it", "Give up"},{ok="Do it",cancel="Give up"})

	switch_alternative_position = result_table["engTopOverChs"]
	remove_alternative_tags=result_table["remove_alter_style"]


	if button==false then
		aegisub.cancel()
	end
end

function split_subtitles(sub)
	Getconfiguration()

	local nline = #sub
	local i=1
	local found_alternative_style=false
	local alternative_style_index=1;
	while i<=nline do
		aegisub.progress.set(i * 100 / nline)
		if sub[i].class=="style" then
			alternative_style_index=i
			if sub[i].name==alternative_style_name then
				found_alternative_style=true
			end
		end

		if sub[i].class=="dialogue" and not sub[i].comment and sub[i].text ~= "" then
			local chnline = sub[i]
			local enline= deepcopy(chnline)

			local chstext,engtext=parse_text(chnline.text)
			chstext=chstext~=nil and chstext or ""
			engtext=engtext~=nil and engtext or ""
			chnline.text=chstext

			if string.len(engtext)>0 then
				if remove_alternative_tags then
					enline.text=engtext:gsub("{[^}]+}", "")
				else
					enline.text=engtext
				end
			else
				enline.text=""
			end

			enline.style=alternative_style_name

			--aegisub.log(string.format("%d-> %s\r\n",i,chnline.text ));
			--aegisub.log(string.format("%d-> %s\r\n",i,enline.text ));

			sub.delete(i)
			if switch_alternative_position then
				if string.len(engtext)>0 then
					sub.insert(i,enline)
				end

				if string.len(chstext)>0 then
					sub.insert(i,chnline)
				end
			else
				if string.len(chstext)>0 then
					sub.insert(i,chnline)
				end
				if string.len(engtext)>0 then
					sub.insert(i,enline)
				end
			end

			if string.len(chstext)==0 then
				i=i-1
				nline=nline-1
			end

			if string.len(engtext)>0 then
				i=i+1
				nline=nline+1
			end

			else
				--aegisub.log(string.format("%d ****-> %s\r\n",i,chnlinetext ));
			end


		i=i+1
	end

	if found_alternative_style~=true then
		local alternative_style_line={
			class = "style",
			section = "V4+ Styles",
			name = alternative_style_name,
			fontname = "Segoe UI",
			fontsize = "15",
			color1 = "&H003CF1F3&",
			color2 = "&H001BA818&",
			color3 = "&H00000000&",
			color4 = "&H00000000&",
			bold = false,
			italic = false,
			underline = false,
			strikeout = false,
			scale_x = 100,
			scale_y = 100,
			spacing = 0,
			angle = 0,
			borderstyle = 1,
			outline = 2,
			shadow = 1,
			align = 2,
			margin_l = 0,
			margin_r = 0,
			margin_t = 8,
			margin_b = 0,
			encoding = 1
		}

		sub.insert(alternative_style_index+1,alternative_style_line)
	end
	aegisub.progress.task("Finished!")
	aegisub.progress.set(100)
end

function split_subtitle_macro(subtitles, selected_lines, active_line)
	split_subtitles(subtitles)
	aegisub.set_undo_point(script_name)
end

function split_subtitle_filter(subtitles, config)
	split_subtitles(subtitles)
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

aegisub.register_macro(script_name, script_description, split_subtitle_macro)
aegisub.register_filter(script_name, script_description, 0, split_subtitle_filter)
