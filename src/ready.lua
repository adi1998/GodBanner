---@meta _
---@diagnostic disable: lowercase-global

modutil.mod.Path.Wrap("GetEligibleLootNames", function(base, excludeLootNames)
	if config.enabled then
		local lootNames = base(excludeLootNames)

		-- make local copy of the banned gods list
		local banned_copy = {}
		for key, value in pairs(config.banned) do
			if value then
				table.insert(banned_copy, mod.originalGodNames[key])
			end
		end

		-- unban gods we have seen before in the run
		local interactedGods = game.GetInteractedGodsThisRun()
		for index, value in pairs(interactedGods) do
			game.RemoveValue(banned_copy, value)
		end

		-- remove banned gods from the list returned by base game
		for index, value in pairs(banned_copy) do
			game.RemoveValue(lootNames, value)
		end

		return lootNames
	end
	return base(excludeLootNames)
end)