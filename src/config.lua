local configPath = rom.paths.config()
local configFileName = _PLUGIN.guid .. ".cfg"
local configFilePath = rom.path.combine(configPath, configFileName)

default_config = {
    enabled = true;
    banned = {};
}

config = {
    enabled = true;
    banned = {};
}

function ReadConfig()
    if rom.path.exists(configFilePath) then
        local success, configData = pcall(rom.toml.decodeFromFile, configFilePath)
        if success then
            print("Config read successful")
            config.enabled = configData.enabled or default_config.enabled
            config.banned = configData.banned or default_config.banned
        else
            print("Config read failed, using default config")
            config = game.DeepCopyTable(default_config)
            WriteConfig()
        end
    else
        local success, fileString = pcall( rom.toml.encodeToFile, default_config, { file = configFilePath, overwrite = true } )
        if success then
            print("Initialzed default config")
        else
            print("Unable to initialzed default config")
        end
    end
end

function WriteConfig()
    local success, fileString = pcall( rom.toml.encodeToFile, config, { file = configFilePath, overwrite = true } )
    if success then
        print("Config file update successful")
    else
        print("Unable to update config file")
    end
end

ReadConfig()