script_name("Better Trinity")
script_authors("perkinson", "brown", "etc.")
script_description("Многофункциональный скрипт для Trinity RP")
script_version("1.1")

require('lib.moonloader')
local inicfg = require 'inicfg'
local samp = require 'lib.samp.events'
local imgui = require 'imgui'
local encoding = require 'encoding'

local directIni = 'bettertrinity.ini'
local config = inicfg.load({
	removes = {
		remove_underlines = false,
		remove_system_messages = false,
		remove_armour_objects = false,
		remove_server_logo = false,
	},
	normalization = {
		normal_shout_color = false,
		normal_whisper_color = false,
		normal_chat_bubbles = false,
	},
	chat_blockirations = {
		cb_wanted = false,
		cb_911_calls = false,
		cb_advertisment = false,
		cb_ooc_radios = false,
		cb_rq = false,
		cb_hq = false,
		cb_r_radio = false,
		cb_d_radio = false,
		cb_div_radio = false,
	},
	chat_modifications = {
		cm_r_radio = false,
		cm_div_radio = false,
		cm_megaphone = false,
	},
	new_clists = {
		nc_status = false,
		nc_pd = false,
		nc_sd = false,
		nc_fd = false,
		nc_civils = false,
		nc_color_pd = "8D8DFFFF",
		nc_color_sd = "006400FF",
		nc_color_fd = "F08080FF",
		nc_color_civils = "FFFFFFFF",
	},
	radio_information = {
		ri_main_channel = "911",
		ri_main_slot = "0",
		ri_div_channel = "SPLX1",
		ri_div_slot = "1",
	}
}, directIni)
inicfg.save(config, directIni)

encoding.default = 'CP1251'
u8 = encoding.UTF8
local main_window_state = imgui.ImBool(false)

local im_remove_underlines = imgui.ImBool(config.removes.remove_underlines)
local im_remove_system_messages = imgui.ImBool(config.removes.remove_system_messages)
local im_remove_armour_objects = imgui.ImBool(config.removes.remove_armour_objects)
local im_remove_server_logo = imgui.ImBool(config.removes.remove_server_logo)
local im_remove_time = imgui.ImBool(false)

local im_normal_shout_color = imgui.ImBool(config.normalization.normal_shout_color)
local im_normal_chat_bubbles = imgui.ImBool(config.normalization.normal_chat_bubbles)
local im_normal_whisper_color = imgui.ImBool(config.normalization.normal_whisper_color)

local im_cb_wanted = imgui.ImBool(config.chat_blockirations.cb_wanted)
local im_cb_911_calls = imgui.ImBool(config.chat_blockirations.cb_911_calls)
local im_cb_advertisment = imgui.ImBool(config.chat_blockirations.cb_advertisment)
local im_cb_ooc_radios = imgui.ImBool(config.chat_blockirations.cb_ooc_radios)
local im_cb_rq = imgui.ImBool(config.chat_blockirations.cb_rq)
local im_cb_hq = imgui.ImBool(config.chat_blockirations.cb_hq)
local im_cb_r_radio = imgui.ImBool(config.chat_blockirations.cb_r_radio)
local im_cb_d_radio = imgui.ImBool(config.chat_blockirations.cb_d_radio)
local im_cb_div_radio = imgui.ImBool(config.chat_blockirations.cb_div_radio)

local im_cm_r_radio = imgui.ImBool(config.chat_modifications.cm_r_radio)
local im_cm_div_radio = imgui.ImBool(config.chat_modifications.cm_div_radio)
local im_cm_megaphone = imgui.ImBool(config.chat_modifications.cm_megaphone)

local im_nc_status = imgui.ImBool(config.new_clists.nc_status)
local im_nc_pd = imgui.ImBool(config.new_clists.nc_pd)
local im_nc_sd = imgui.ImBool(config.new_clists.nc_sd)
local im_nc_fd = imgui.ImBool(config.new_clists.nc_fd)
local im_nc_civils = imgui.ImBool(config.new_clists.nc_civils)

local im_ri_main_channel = imgui.ImBuffer(256)
local im_ri_main_slot = imgui.ImBuffer(256)
local im_ri_div_channel = imgui.ImBuffer(256)
local im_ri_div_slot = imgui.ImBuffer(256)

local pd_skins_ids = {265, 266, 267, 280, 281, 282, 283, 284, 285, 288, 300, 301, 302, 306, 307, 309, 310, 311}
local sd_skins_ids = {282, 283, 288, 302, 309, 310, 311}
local fd_skins_ids = {70, 274, 275, 276, 277, 278, 279, 308}
local armour_ids = {19142, 19515, 373, 1242}

local tag = "{F94A18}Better Trinity >{FFFFFF} "

local servers = {
	"185.169.134.84:7777",
	"185.169.134.85:7777",
	"185.169.134.83:7777",
}

local enable_autoupdate = true
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
	local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
	if updater_loaded then
		autoupdate_loaded, Update = pcall(Updater)
		if autoupdate_loaded then
			Update.json_url = "https://raw.githubusercontent.com/perkinson1251/better-trinity/main/better-trinity.json" .. tostring(os.clock())
			Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
			Update.url = "https://github.com/perkinson1251/better-trinity"
		end
	end
end

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	checkip()
	if autoupdate_loaded and enable_autoupdate and Update then
		pcall(Update.check, Update.json_url, Update.prefix, Update.url)
	end

	sampRegisterChatCommand("trinity", function()
		main_window_state.v = not main_window_state.v
		imgui.Process = main_window_state.v
	end)

	sampAddChatMessage(tag .. "Скрипт запущен! Команда - /trinity", -1)

	imgui.Process = false

	while true do wait(0)
		if main_window_state.v == false then imgui.Process = false end

		-- Server logo delete
		if config.removes.remove_server_logo then
			for a = 0, 2304 do
				if sampTextdrawIsExists(a) then
					if sampTextdrawGetString(a) == 'gta-trinity.com' then sampTextdrawSetString(a, '') end
				end
			end
		else
			for a = 0, 2304 do
				if sampTextdrawIsExists(a) then
					if sampTextdrawGetString(a) == '' then sampTextdrawSetString(a, 'gta-trinity.com') end
				end
			end
		end
		---------------------

		-- Remove armour
		local positionX, positionY, positionZ = getCharCoordinates(PLAYER_PED)
		local result, object = findAllRandomObjectsInSphere(positionX, positionY, positionZ, 150.0, true)
		if result and doesObjectExist(object) then
			local result, oX, oY, oZ = getObjectCoordinates(object)
			local modelId = getObjectModel(object)
			if config.removes.remove_armour_objects then
				for id in pairs(armour_ids) do
					if modelId == armour_ids[id] then setObjectVisible(object, false) end
				end
			else
				for id in pairs(armour_ids) do
					if modelId == armour_ids[id] then setObjectVisible(object, true) end
				end
			end
		end
		----------------

		-- Delete time texdraw (cringe)
		if im_remove_time.v then
			for a = 0, 2304 do
				if sampTextdrawIsExists(a) then
					for b = 0, 23 do
						if string.find(sampTextdrawGetString(a), b..":", 1, true) then
							posX, posY = sampTextdrawGetPos(a)
							sampTextdrawSetPos(a, posX + 1000, posY + 1000)
						end
					end
				end
			end
			for a = 0, 2304 do
				if sampTextdrawIsExists(a) then
					for c = 0, 31 do
						if string.find(sampTextdrawGetString(a), c.."st", 1, true) or string.find(sampTextdrawGetString(a), c.."nd", 1, true) or string.find(sampTextdrawGetString(a), c.."rd", 1, true) or string.find(sampTextdrawGetString(a), c.."th", 1, true) then
							posX, posY = sampTextdrawGetPos(a)
							sampTextdrawSetPos(a, posX + 1000, posY + 1000)
						end
					end
				end
			end
		else
			for a = 0, 2304 do
				if sampTextdrawIsExists(a) then
					for b = 0, 23 do
						if string.find(sampTextdrawGetString(a), b..":", 1, true) then
							posX, posY = sampTextdrawGetPos(a)
							if posX > 1000 and posY > 1000 then
								sampTextdrawSetPos(a, posX - 1000, posY - 1000)
							end
						end
					end
				end
			end
			for a = 0, 2304 do
				if sampTextdrawIsExists(a) then
					for c = 0, 31 do
						if string.find(sampTextdrawGetString(a), c.."st", 1, true) or string.find(sampTextdrawGetString(a), c.."nd", 1, true) or string.find(sampTextdrawGetString(a), c.."rd", 1, true) or string.find(sampTextdrawGetString(a), c.."th", 1, true) then
							posX, posY = sampTextdrawGetPos(a)
							if posX > 1000 and posY > 1000 then
								sampTextdrawSetPos(a, posX - 1000, posY - 1000)
							end
						end
					end
				end
			end
		end

		-- New clist system
		if config.new_clists.nc_status then
			local positionX, positionY, positionZ = getCharCoordinates(PLAYER_PED)
			local result, player = findAllRandomCharsInSphere(positionX, positionY, positionZ, 15.0, true, true)
			if result and doesCharExist(player) then
				local _, id = sampGetPlayerIdByCharHandle(player)
				idskin = getCharModel(player)
				-- if ('%X'):format(sampGetPlayerColor(id)) == 'FF2A51E2' then -- это проверка на клист. далее используется просто проверка на скин.
				if config.new_clists.nc_civils then
					if idskin > 0 then setcolor(id, config.new_clists.nc_color_civils) end
				end
				if config.new_clists.nc_pd then
					for value in pairs(pd_skins_ids) do
						if idskin == pd_skins_ids[value] then setcolor(id, config.new_clists.nc_color_pd) end
					end
				end
				if config.new_clists.nc_sd then
					for value in pairs(sd_skins_ids) do
						if idskin == sd_skins_ids[value] then setcolor(id, config.new_clists.nc_color_sd	) end
					end
				end
				if config.new_clists.nc_fd then
					for value in pairs(fd_skins_ids) do
						if idskin == fd_skins_ids[value] then setcolor(id, config.new_clists.nc_color_fd) end
					end
				end
			end
		end
	end
end

function checkip()
	local ip, port = sampGetCurrentServerAddress()
	for key, value in pairs(servers) do
		if value == ip .. ":" .. port then return true end
	end
	print(">> " .. thisScript().name .. ": Этот скрипт работает только на серверах Тринити.")
	thisScript():unload()
end

function setcolor(i, color)
	local bs_io = require 'samp.events.bitstream_io'
	local bs = raknetNewBitStream()
	bs_io['int16']['write'](bs, i)
	bs_io['int32']['write'](bs, tonumber(color, 16))
	raknetEmulRpcReceiveBitStream(72, bs)
	raknetDeleteBitStream(bs)
end

function samp.onServerMessage(color, text)
	-- Remove underlines in messages
	if config.removes.remove_underlines == true then
		for w in string.gmatch(text, '(%w+)_(%w+)') do
			text = string.gsub(text, '_', ' ')
		end
	end

	-- Remove systme messages
	if config.removes.remove_system_messages then
		if color == -1029514497 then 
			if string.find(text, '...', 1,2) then return true end
			if string.find(text, '* ', 1, 2) == nil and string.find(text, '! ', 1, 2) == nil then return false end
		end
	end

	-- Normal shout color
	if config.normalization.normal_shout_color then
		if color == 12582911 then
			text = '{e6e7e5}'..text text = string.gsub(text, '{00BFFF}', '{e6e7e5}')
		end
	end

	-- Normal whisper color
	-- TODO
	
	-- Wanted
	if config.chat_blockirations.cb_wanted then
		if color == -8224001 and string.find(text, "W: ", 1, true) then return false end
	end

	-- 911 cals
	if config.chat_blockirations.cb_911_calls then
		if color == -12320513 and string.find(text, "Вызов 911", 1, true) then return false end
	end

	-- AD ban
	if config.chat_blockirations.cb_advertisment then
		if color == -290866945 and string.find(text, "[Реклама", 1, true) then return false end
		if color == -290866945 and string.find(text, "[Гос. реклама", 1, true) then return false end
	end

	-- OOC radios ban
	if config.chat_blockirations.cb_ooc_radios then
		if color == 1515895807 then
			if string.find(text, "((", 1, true) or string.find(text, "))", 1, true) then return false end
		end
		if color == -1844375041 then
			if string.find(text, "((", 1, true) or string.find(text, "))", 1, true) then return false end
		end
		if color == -1438366465 then
			if string.find(text, "((", 1, true) or string.find(text, "))", 1, true) then return false end
		end
	end

	-- RQ ban
	if config.chat_blockirations.cb_rq then
		if color == 1687547391 and string.find(text, "Член", 1, true) then return false end
	end

	-- HQ ban
	if config.chat_blockirations.cb_hq then
		if color == -12254977 and string.find(text, "HQ: ", 1, true) then return false end
		if color == 1687547391 and string.find(text, "HQ: ", 1, true) then return false end
	end

	-- /r radio ban
	if config.chat_blockirations.cb_r_radio then
		if color == -1920073729 then return false end
	end

	-- /d radio ban
	if config.chat_blockirations.cb_d_radio then
		if color == -1844375041 then return false end
	end

	-- /i radio ban
	if config.chat_blockirations.cb_div_radio then
		if color == -1150916865 then return false end
	end

	-- New /r radio
	if config.chat_modifications.cm_r_radio then
		if color == -1920073729 then
			textm = text:match('.+')
			text = '{ffe4b5}' .. textm
			if text:find('%[%a+%] .+ (%a+_%a+): (.+)') then
				local nick, textr = text:match('%[%a+%] .+ (%a+_%a+): (.+)')
				text = "{ffe4b5}[CH: "..config.radio_information.ri_main_channel..", S: "..config.radio_information.ri_main_slot.."] "..nick..": "..textr
			end
			if text:find('.+ (%a+_%a+): (.+)') then
				local nick, textr = text:match('.+ (%a+_%a+): (.+)')
				text = "{ffe4b5}[CH: "..config.radio_information.ri_main_channel..", S: "..config.radio_information.ri_main_slot.."] "..nick..": "..textr
			end
		end
		if color == 1515895807 then
			textm = text:match('.+')
			text = '{6c92df}' .. textm
			if text:find('%[%a+%] .+ (%a+_%a+): (.+)') then
				local nick, textr = text:match('%[%a+%] .+ (%a+_%a+): (.+)')
				text = "{6c92df}[R!] "..nick..": "..textr
			end
			if text:find('.+ (%a+_%a+): (.+)') then
				local nick, textr = text:match('.+ (%a+_%a+): (.+)')
				text = "{6c92df}[R] "..nick..": "..textr
			end
		end
	end

	-- New /i radio
	if config.chat_modifications.cm_div_radio then
		if color == -1150916865 then
			textm = text:match('.+')
			text = '{ffe4b5}' .. textm
			if text:find('.+ (%a+_%a+): (.+)') then
				local nick, textr = text:match('.+ (%a+_%a+): (.+)')
				text = "{ffe4b5}[CH: "..config.radio_information.ri_div_channel..", S: "..cconfig.radio_information.ri_div_slot.."] "..nick..": "..textr
			end
		end
		if color == -1438366465 then
			textm = text:match('.+')
			text = '{6c92df}' .. textm

			if text:find('.+ (%a+_%a+): (.+)') then
				local nick, textr = text:match('.+ (%a+_%a+): (.+)')
				text = "{6c92df}[I] "..nick..": "..textr
			end
		end
	end

	-- New megaphone
	if config.chat_modifications.cm_megaphone then
		if text:find('в рупор:') then
			local nick, textm = text:match('(%a+_%a+) сказал в рупор: (.+)')
			text = "[Мегафон "..nick.."]: "..textm.." "
		end
	end
	return {color, text}
end

-- Normal player chat bubble
function samp.onPlayerChatBubble(playerId, color, distance, duration , message)
	if config.normalization.normal_chat_bubbles then
		if color == 885597439 then message = '{e6e7e5}'..message end
		if color == 597432063 then message = '{c4c4c4}'..message end
		if color == 12582911 then message = '{e6e7e5}'..message message = string.gsub(message, '{00BFFF}', '{e6e7e5}') end
	end
	return {playerId, color, distance, duration , message}
end

function imgui.OnDrawFrame()
	if main_window_state.v then
		local sw, sh = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(750, 600), imgui.Cond.FirstUseEver)

		imgui.Begin(thisScript().name, main_window_state, imgui.WindowFlags.NoResize)
			imgui.BeginChild(u8"Удаление", imgui.ImVec2(365, 150))
				imgui.CenterTextColoredRGB("Удаление объектов")
				if imgui.Checkbox(u8"Удаление нижних подчёркиваний", im_remove_underlines) then
					config.removes.remove_underlines = im_remove_underlines.v
					inicfg.save(config, directIni)
				end
				if imgui.Checkbox(u8"Удаление системных сообщений", im_remove_system_messages) then
					config.removes.remove_system_messages = im_remove_system_messages.v
					inicfg.save(config, directIni)
				end
				if imgui.Checkbox(u8"Удаление объектов бронежилетов", im_remove_armour_objects) then
					config.removes.remove_armour_objects = im_remove_armour_objects.v
					inicfg.save(config, directIni)
				end
				if imgui.Checkbox(u8"Удаление логотипа сервера", im_remove_server_logo) then
					config.removes.remove_server_logo = im_remove_server_logo.v
					inicfg.save(config, directIni)
				end
				imgui.Checkbox(u8"Удаление часов", im_remove_time)
			imgui.EndChild()
			imgui.SameLine()
			imgui.BeginChild(u8"Нормализация", imgui.ImVec2(365, 150))
				imgui.CenterTextColoredRGB("Нормализация чатов")
				if imgui.Checkbox(u8"Нормальный цвет крика", im_normal_shout_color) then
					config.normalization.normal_shout_color = im_normal_shout_color.v
					inicfg.save(config, directIni)
				end
				if imgui.Checkbox(u8"Нормальный цвет шёпота", im_normal_whisper_color) then
					config.normalization.normal_whisper_color = im_normal_whisper_color.v
					inicfg.save(config, directIni)
				end
				if imgui.Checkbox(u8"Нормальные цвета чатов над головой", im_normal_chat_bubbles) then
					config.normalization.normal_chat_bubbles = im_normal_chat_bubbles.v
					inicfg.save(config, directIni)
				end
			imgui.EndChild()
			imgui.BeginChild("Блокировка чатов", imgui.ImVec2(365, 250))
				imgui.CenterTextColoredRGB("Блокировка чатов")
				if imgui.Checkbox(u8"Удаление сообщений о выдачи розыска", im_cb_wanted) then
					config.chat_blockirations.cb_wanted = im_cb_wanted.v
					inicfg.save(config, directIni)
				end
				if imgui.Checkbox(u8"Удаление вызовов 911", im_cb_911_calls) then
					config.chat_blockirations.cb_911_calls = im_cb_911_calls.v
					inicfg.save(config, directIni)
				end
				if imgui.Checkbox(u8"Удаление рекламных объявлений", im_cb_advertisment) then
					config.chat_blockirations.cb_advertisment = im_cb_advertisment.v
					inicfg.save(config, directIni)
				end
				if imgui.Checkbox(u8"Удаление сообщений от ООС раций", im_cb_ooc_radios) then
					config.chat_blockirations.cb_ooc_radios = im_cb_ooc_radios.v
					inicfg.save(config, directIni)
				end
				if imgui.Checkbox(u8"Удаление сообщений RQ", im_cb_rq) then
					config.chat_blockirations.cb_rq = im_cb_rq.v
					inicfg.save(config, directIni)
				end
				if imgui.Checkbox(u8"Удаление сообщений HQ", im_cb_hq) then
					config.chat_blockirations.cb_hq = im_cb_hq.v
					inicfg.save(config, directIni)
				end
				if imgui.Checkbox(u8"Удаление сообщений /r", im_cb_r_radio) then
					config.chat_blockirations.cb_r_radio = im_cb_r_radio.v
					inicfg.save(config, directIni)
				end
				if imgui.Checkbox(u8"Удаление сообщений /d", im_cb_d_radio) then
					config.chat_blockirations.cb_d_radio = im_cb_d_radio.v
					inicfg.save(config, directIni)
				end
				if imgui.Checkbox(u8"Удаление сообщений /i", im_cb_div_radio) then
					config.chat_blockirations.cb_div_radio = im_cb_div_radio.v
					inicfg.save(config, directIni)
				end
			imgui.EndChild()
			imgui.SameLine()
			imgui.BeginChild(u8"Модификация чатов", imgui.ImVec2(365, 250))
				imgui.CenterTextColoredRGB("Новый вид чатов")
				if imgui.Checkbox(u8"Рация /r с гамбита", im_cm_r_radio) then
					config.chat_modifications.cm_r_radio = im_cm_r_radio.v
					inicfg.save(config, directIni)
				end
				if imgui.Checkbox(u8"Рация /i с гамбита", im_cm_div_radio) then
					config.chat_modifications.cm_div_radio = im_cm_div_radio.v
					inicfg.save(config, directIni)
				end
				if imgui.Checkbox(u8"Мегафон с гамбита", im_cm_megaphone) then
					config.chat_modifications.cm_megaphone = im_cm_megaphone.v
					inicfg.save(config, directIni)
				end
			imgui.EndChild()
			imgui.BeginChild(u8"Управление клистами", imgui.ImVec2(365, 150))
				imgui.TextQuestion(u8"Включая эту опцию, у вас появляеться возможность редактировать клисты обычных игроков.\nPD клисты - у игроков из ПД будет клист как на гамбите (вместо тёмно голубого будет бежевый)\nSD клисты - у полицейских в песочной форме будет зелёный клист как у игроков шериф департмента на гамбите\nFD клисты - у игроков из EMS будут клисты светлее чем обычно\nГражданские клисты - все клисты помимо выше перечисленных будут белыми (все крю, фбр и прочее)")
				imgui.SameLine()
				imgui.CenterTextColoredRGB("Редактор клистов")

				if imgui.Checkbox(u8"Новая система клистов", im_nc_status) then
					config.new_clists.nc_status = im_nc_status.v
					inicfg.save(config, directIni)
				end
				if config.new_clists.nc_status then
					if imgui.Checkbox(u8"PD клисты", im_nc_pd) then
						config.new_clists.nc_pd = im_nc_pd.v
						inicfg.save(config, directIni)
					end
					if imgui.Checkbox(u8"SD клисты", im_nc_sd) then
						config.new_clists.nc_sd = im_nc_sd.v
						inicfg.save(config, directIni)
					end
					if imgui.Checkbox(u8"FD клисты", im_nc_fd) then
						config.new_clists.nc_fd = im_nc_fd.v
						inicfg.save(config, directIni)
					end
					if imgui.Checkbox(u8"Гражданские клисты", im_nc_civils) then
						config.new_clists.nc_civils = im_nc_civils.v
						inicfg.save(config, directIni)
					end
				end
			imgui.EndChild()
			imgui.SameLine()
			imgui.BeginChild(u8"Редактор каналов", imgui.ImVec2(365, 150))
				imgui.CenterTextColoredRGB("Редактор каналов рации")

				imgui.PushItemWidth(120)
				imgui.InputText(u8"Редактор основного канала", im_ri_main_channel)
				imgui.PushItemWidth(120)
				imgui.InputText(u8"Редактор основного слота", im_ri_main_slot)
				imgui.PushItemWidth(120)
				imgui.InputText(u8"Редактор локального канала", im_ri_div_channel)
				imgui.PushItemWidth(120)
				imgui.InputText(u8"Редактор локального слота", im_ri_div_slot)
				if imgui.Button(u8"Сохранить каналы и слоты") then
					config.radio_information.ri_main_channel = im_ri_main_channel.v
					config.radio_information.ri_main_slot = im_ri_main_slot.v
					config.radio_information.ri_div_channel = im_ri_div_channel.v
					config.radio_information.ri_div_slot = im_ri_div_slot.v
					inicfg.save(config, directIni)
				end
			imgui.EndChild()
		imgui.End()
	end
end

function imgui.CenterTextColoredRGB(text)
	local width = imgui.GetWindowWidth()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local ImVec4 = imgui.ImVec4

	local explode_argb = function(argb)
		local a = bit.band(bit.rshift(argb, 24), 0xFF)
		local r = bit.band(bit.rshift(argb, 16), 0xFF)
		local g = bit.band(bit.rshift(argb, 8), 0xFF)
		local b = bit.band(argb, 0xFF)
		return a, r, g, b
	end

	local getcolor = function(color)
		if color:sub(1, 6):upper() == 'SSSSSS' then
			local r, g, b = colors[1].x, colors[1].y, colors[1].z
			local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
			return ImVec4(r, g, b, a / 255)
		end
		local color = type(color) == 'string' and tonumber(color, 16) or color
		if type(color) ~= 'number' then return end
		local r, g, b, a = explode_argb(color)
		return imgui.ImColor(r, g, b, a):GetVec4()
	end

	local render_text = function(text_)
		for w in text_:gmatch('[^\r\n]+') do
			local textsize = w:gsub('{.-}', '')
			local text_width = imgui.CalcTextSize(u8(textsize))
			imgui.SetCursorPosX( width / 2 - text_width .x / 2 )
			local text, colors_, m = {}, {}, 1
			w = w:gsub('{(......)}', '{%1FF}')
			while w:find('{........}') do
				local n, k = w:find('{........}')
				local color = getcolor(w:sub(n + 1, k - 1))
				if color then
					text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
					colors_[#colors_ + 1] = color
					m = n
				end
				w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
			end
			if text[0] then
				for i = 0, #text do
					imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
					imgui.SameLine(nil, 0)
				end
				imgui.NewLine()
			else
				imgui.Text(u8(w))
			end
		end
	end
	render_text(text)
end

function imgui.TextQuestion(text)
	imgui.TextDisabled('(?)')
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.PushTextWrapPos(450)
		imgui.TextUnformatted(text)
		imgui.PopTextWrapPos()
		imgui.EndTooltip()
	end
end

function theme()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	local ImVec2 = imgui.ImVec2

	style.WindowPadding = imgui.ImVec2(8, 8)
	style.WindowRounding = 6
	style.ChildWindowRounding = 5
	style.FramePadding = imgui.ImVec2(5, 3)
	style.FrameRounding = 3.0
	style.ItemSpacing = imgui.ImVec2(5, 4)
	style.ItemInnerSpacing = imgui.ImVec2(4, 4)
	style.IndentSpacing = 21
	style.ScrollbarSize = 10.0
	style.ScrollbarRounding = 13
	style.GrabMinSize = 8
	style.GrabRounding = 1
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)

	colors[clr.Text]                   = ImVec4(0.95, 0.96, 0.98, 1.00);
	colors[clr.TextDisabled]           = ImVec4(0.29, 0.29, 0.29, 1.00);
	colors[clr.WindowBg]               = ImVec4(0.14, 0.14, 0.14, 1.00);
	colors[clr.ChildWindowBg]          = ImVec4(0.12, 0.12, 0.12, 1.00);
	colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94);
	colors[clr.Border]                 = ImVec4(0.14, 0.14, 0.14, 1.00);
	colors[clr.BorderShadow]           = ImVec4(1.00, 1.00, 1.00, 0.10);
	colors[clr.FrameBg]                = ImVec4(0.22, 0.22, 0.22, 1.00);
	colors[clr.FrameBgHovered]         = ImVec4(0.18, 0.18, 0.18, 1.00);
	colors[clr.FrameBgActive]          = ImVec4(0.09, 0.12, 0.14, 1.00);
	colors[clr.TitleBg]                = ImVec4(0.14, 0.14, 0.14, 0.81);
	colors[clr.TitleBgActive]          = ImVec4(0.14, 0.14, 0.14, 1.00);
	colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51);
	colors[clr.MenuBarBg]              = ImVec4(0.20, 0.20, 0.20, 1.00);
	colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.39);
	colors[clr.ScrollbarGrab]          = ImVec4(0.36, 0.36, 0.36, 1.00);
	colors[clr.ScrollbarGrabHovered]   = ImVec4(0.18, 0.22, 0.25, 1.00);
	colors[clr.ScrollbarGrabActive]    = ImVec4(0.24, 0.24, 0.24, 1.00);
	colors[clr.ComboBg]                = ImVec4(0.24, 0.24, 0.24, 1.00);
	colors[clr.CheckMark]              = ImVec4(1.00, 0.28, 0.28, 1.00);
	colors[clr.SliderGrab]             = ImVec4(1.00, 0.28, 0.28, 1.00);
	colors[clr.SliderGrabActive]       = ImVec4(1.00, 0.28, 0.28, 1.00);
	colors[clr.Button]                 = ImVec4(1.00, 0.28, 0.28, 1.00);
	colors[clr.ButtonHovered]          = ImVec4(1.00, 0.39, 0.39, 1.00);
	colors[clr.ButtonActive]           = ImVec4(1.00, 0.21, 0.21, 1.00);
	colors[clr.Header]                 = ImVec4(1.00, 0.28, 0.28, 1.00);
	colors[clr.HeaderHovered]          = ImVec4(1.00, 0.39, 0.39, 1.00);
	colors[clr.HeaderActive]           = ImVec4(1.00, 0.21, 0.21, 1.00);
	colors[clr.ResizeGrip]             = ImVec4(1.00, 0.28, 0.28, 1.00);
	colors[clr.ResizeGripHovered]      = ImVec4(1.00, 0.39, 0.39, 1.00);
	colors[clr.ResizeGripActive]       = ImVec4(1.00, 0.19, 0.19, 1.00);
	colors[clr.CloseButton]            = ImVec4(0.40, 0.39, 0.38, 0.16);
	colors[clr.CloseButtonHovered]     = ImVec4(0.40, 0.39, 0.38, 0.39);
	colors[clr.CloseButtonActive]      = ImVec4(0.40, 0.39, 0.38, 1.00);
	colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00);
	colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00);
	colors[clr.PlotHistogram]          = ImVec4(1.00, 0.21, 0.21, 1.00);
	colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.18, 0.18, 1.00);
	colors[clr.TextSelectedBg]         = ImVec4(1.00, 0.32, 0.32, 1.00);
	colors[clr.ModalWindowDarkening]   = ImVec4(0.26, 0.26, 0.26, 0.60);
end
theme()