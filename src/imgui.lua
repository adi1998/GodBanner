---@meta _
---@diagnostic disable: lowercase-global

mod.originalGodNames = {}

local function CheckGods()
	local lootList = game.OrderedKeysToList(game.LootData)
	local godList = {}
	mod.originalGodNames = {}

	for i, lootName in ipairs(lootList) do
		local lootData = game.LootData[lootName]

		if lootData and not lootData.DebugOnly and lootData.GodLoot then
			local godName = lootName:gsub("^.*%-", ""):gsub("Upgrade$", "")

			mod.originalGodNames[godName] = lootName
			if godName ~= lootName then
				table.insert(godList, godName)
			else
				table.insert(godList, lootName)
			end
		end
	end

	return godList
end

local godList = CheckGods()

function drawMenu()
	local show_warning = true

	local value, checked = rom.ImGui.Checkbox("Enabled", config.enabled)
	if checked then
		config.enabled = value
		WriteConfig()
	end

	if config.enabled then
		for i, god in ipairs(godList) do
			value, checked = rom.ImGui.Checkbox(god, config.banned[god] == true)
			if checked then
				config.banned[god] = value
				WriteConfig()
			end
			if value == false then
				show_warning = false
			end

			if i % 3 ~= 0 and i ~= #godList then
				rom.ImGui.SameLine()
			end
		end

		rom.ImGui.Spacing()

		if show_warning then
			rom.ImGui.Text("Warning: Atleast one god should not be banned")
		end
	end
end

rom.gui.add_imgui(function()
	if rom.ImGui.Begin("God Banner") then
		drawMenu()
		rom.ImGui.End()
	end
end)

rom.gui.add_to_menu_bar(function()
	if rom.ImGui.BeginMenu("Configure") then
		drawMenu()
		rom.ImGui.EndMenu()
	end
end)
