-- JukeboxHero Trait

local Jukebox = require("Jukebox/Utility")

local JukeboxHero = {}

JukeboxHero.trait = function()
    JukeboxHero.traitData = TraitFactory.addTrait("JukeboxHero", Jukebox.translation.jukeboxHero, 1, Jukebox.translation.jukeboxHeroTooltip, false)
    JukeboxHero.traitData:getFreeRecipes():add("Craft Jukebox")
    JukeboxHero.traitData:getFreeRecipes():add("Construct Jukebox")
end

Events.OnGameBoot.Add(JukeboxHero.trait)

JukeboxHero.giveMusic = function(player)
    local selectedIndex = (#JukeboxHero.globalPlaylist > 2 and (Jukebox.random(#JukeboxHero.globalPlaylist - 2) + 2)) or Jukebox.random(#JukeboxHero.globalPlaylist)
	local musicItem = "Tsarcraft." .. JukeboxHero.globalPlaylist[selectedIndex]
	player:getInventory():AddItem(musicItem)
end

JukeboxHero.gifts = function(playerIndex, player)
    if player and player:HasTrait("JukeboxHero") and not player:getModData().jukeboxHero then
        if not (SandboxVars.TrueMusicJukebox and SandboxVars.TrueMusicJukebox.partyPooper) then
            local jukeboxStarterKitTag = "TrueMusicJukebox.StarterKit"
            player:getInventory():AddItem(jukeboxStarterKitTag)
        end

        if GlobalMusic and not JukeboxHero.globalPlaylist then 
            JukeboxHero.globalPlaylist = {}
            for key in pairs(GlobalMusic) do
                JukeboxHero.globalPlaylist[#JukeboxHero.globalPlaylist + 1] = key
            end
        end
      
        local tracks = (SandboxVars.TrueMusicJukebox and SandboxVars.TrueMusicJukebox.heroStarterTracks) or 11
        if GlobalMusic and tracks > 0 then 
            for index = 1, tracks do
                JukeboxHero.giveMusic(player)
            end
        end
        
        player:getModData().jukeboxHero = true
        player:transmitModData()
    end
end

Events.OnCreatePlayer.Add(JukeboxHero.gifts)

return JukeboxHero