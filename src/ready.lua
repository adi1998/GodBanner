---@meta _
---@diagnostic disable: lowercase-global

modutil.mod.Path.Wrap("GetEligibleLootNames", function(base, excludeLootNames)
	if config.enabled then
		local lootNames = base(excludeLootNames)

		-- make local copy of the banned gods list
		local banned_copy = {}
		print("Banned gods")
		for key, value in pairs(config.banned) do
			if value then
				table.insert(banned_copy, mod.originalGodNames[key])
				print(value)
			end
		end

		-- unban gods we have seen before in the run
		print("unbanning seen gods")
		local interactedGods = game.GetInteractedGodsThisRun()
		for index, value in pairs(interactedGods) do
			game.RemoveValue(banned_copy, value)
			print(value)
		end

		-- remove banned gods from the list returned by base game
		print("removing banned gods from loot")
		for index, value in pairs(banned_copy) do
			print(value)
			game.RemoveValue(lootNames, value)
		end

		return lootNames
	end
	return base(excludeLootNames)
end)