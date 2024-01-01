-- JukeboxHero Trait

JukeboxHero = JukeboxHero or {}

JukeboxHero.trait = function()
    JukeboxHero.traitData = TraitFactory.addTrait("JukeboxHero", "Jukebox Hero", 1, "Begin the game with a Jukebox Starter Kit and jam with your (surviving) fam.", false)
    JukeboxHero.traitData:getFreeRecipes():add("Craft Jukebox")
    JukeboxHero.traitData:getFreeRecipes():add("Construct Jukebox")
end

Events.OnGameBoot.Add(JukeboxHero.trait)

JukeboxHero.gifts = function(playerIndex, player)
    if player and player:HasTrait("JukeboxHero") and not player:getModData().jukeboxHero then
        local jukeboxStarterKitTag = "TrueMusicJukebox.StarterKit"
        player:getInventory():AddItem(jukeboxStarterKitTag);
        player:getModData().jukeboxHero = true
        player:transmitModData()
    end
end

Events.OnCreatePlayer.Add(JukeboxHero.gifts);