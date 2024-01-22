local JukeboxDistribution = {}

JukeboxDistribution.truncate = function(number)
    return math.floor(number * 100) / 100
end

JukeboxDistribution.calculateLiteratureAdjustment = function()

    local setting = tonumber(getSandboxOptions():getOptionByName("LiteratureLoot"):asConfigOption():getValueAsString())

    if setting > 3 then
        return 1.25
    elseif setting > 4 then
        return 1.5
    elseif setting > 5 then
        return 1.75
    elseif setting > 6 then
        return 2
    end
     
    return 1

end

JukeboxDistribution.addBooks = function()
    
    -- Base Rates
    local rateForBooks = 2
    local rateForJukeboxStarterKits = 1.5

    if SandboxVars.TrueMusicJukebox and SandboxVars.TrueMusicJukebox.literatureFrequencyMultiplier then
        rateForBooks = rateForBooks * SandboxVars.TrueMusicJukebox.literatureFrequencyMultiplier
    end

    if SandboxVars.TrueMusicJukebox and SandboxVars.TrueMusicJukebox.starterKitFrequencyMultiplier then
        rateForJukeboxStarterKits = rateForJukeboxStarterKits * SandboxVars.TrueMusicJukebox.starterKitFrequencyMultiplier
    end

    local literatureAdjustment = JukeboxDistribution.calculateLiteratureAdjustment()

    local rateForBooks = JukeboxDistribution.truncate(rateForBooks * literatureAdjustment)

    table.insert(ProceduralDistributions.list["Antiques"].items, "TrueMusicJukebox.StarterKit")
    table.insert(ProceduralDistributions.list["Antiques"].items, rateForJukeboxStarterKits)
    table.insert(ProceduralDistributions.list["ClosetInstruments"].items, "TrueMusicJukebox.StarterKit")
    table.insert(ProceduralDistributions.list["ClosetInstruments"].items, rateForJukeboxStarterKits)
    table.insert(ProceduralDistributions.list["ClosetShelfGeneric"].items, "TrueMusicJukebox.StarterKit")
    table.insert(ProceduralDistributions.list["ClosetShelfGeneric"].items, rateForJukeboxStarterKits)
    table.insert(ProceduralDistributions.list["CrateCarpentry"].items, "TrueMusicJukebox.StarterKit")
    table.insert(ProceduralDistributions.list["CrateCarpentry"].items, rateForJukeboxStarterKits)
    table.insert(ProceduralDistributions.list["CrateCompactDiscs"].items, "TrueMusicJukebox.StarterKit")
    table.insert(ProceduralDistributions.list["CrateCompactDiscs"].items, rateForJukeboxStarterKits)
    table.insert(ProceduralDistributions.list["CrateComputer"].items, "TrueMusicJukebox.StarterKit")
    table.insert(ProceduralDistributions.list["CrateComputer"].items, rateForJukeboxStarterKits)
    table.insert(ProceduralDistributions.list["CrateElectronics"].items, "TrueMusicJukebox.StarterKit")
    table.insert(ProceduralDistributions.list["CrateElectronics"].items, rateForJukeboxStarterKits)
    table.insert(ProceduralDistributions.list["CrateInstruments"].items, "TrueMusicJukebox.StarterKit")
    table.insert(ProceduralDistributions.list["CrateInstruments"].items, rateForJukeboxStarterKits)
    table.insert(ProceduralDistributions.list["CrateMetalwork"].items, "TrueMusicJukebox.StarterKit")
    table.insert(ProceduralDistributions.list["CrateMetalwork"].items, rateForJukeboxStarterKits)
    table.insert(ProceduralDistributions.list["CrateTools"].items, "TrueMusicJukebox.StarterKit")
    table.insert(ProceduralDistributions.list["CrateTools"].items, rateForJukeboxStarterKits)
    table.insert(ProceduralDistributions.list["ElectronicStoreAppliances"].items, "TrueMusicJukebox.StarterKit")
    table.insert(ProceduralDistributions.list["ElectronicStoreAppliances"].items, rateForJukeboxStarterKits)
    table.insert(ProceduralDistributions.list["ElectronicStoreMusic"].items, "TrueMusicJukebox.StarterKit")
    table.insert(ProceduralDistributions.list["ElectronicStoreMusic"].items, rateForJukeboxStarterKits)
    table.insert(ProceduralDistributions.list["GarageCarpentry"].items, "TrueMusicJukebox.StarterKit")
    table.insert(ProceduralDistributions.list["GarageCarpentry"].items, rateForJukeboxStarterKits)
    table.insert(ProceduralDistributions.list["GigamartHouseElectronics"].items, "TrueMusicJukebox.StarterKit")
    table.insert(ProceduralDistributions.list["GigamartHouseElectronics"].items, rateForJukeboxStarterKits)
    table.insert(ProceduralDistributions.list["MusicStoreSpeaker"].items, "TrueMusicJukebox.StarterKit")
    table.insert(ProceduralDistributions.list["MusicStoreSpeaker"].items, rateForJukeboxStarterKits)
    table.insert(ProceduralDistributions.list["PawnShopCases"].items, "TrueMusicJukebox.StarterKit")
    table.insert(ProceduralDistributions.list["PawnShopCases"].items, rateForJukeboxStarterKits)
    table.insert(ProceduralDistributions.list["StoreShelfElectronics"].items, "TrueMusicJukebox.StarterKit")
    table.insert(ProceduralDistributions.list["StoreShelfElectronics"].items, rateForJukeboxStarterKits)
    table.insert(ProceduralDistributions.list["WardrobeMan"].items, "TrueMusicJukebox.StarterKit")
    table.insert(ProceduralDistributions.list["WardrobeMan"].items, rateForJukeboxStarterKits)
    table.insert(ProceduralDistributions.list["WardrobeWoman"].items, "TrueMusicJukebox.StarterKit")
    table.insert(ProceduralDistributions.list["WardrobeWoman"].items, rateForJukeboxStarterKits)
    table.insert(ProceduralDistributions.list["WardrobeManClassy"].items, "TrueMusicJukebox.StarterKit")
    table.insert(ProceduralDistributions.list["WardrobeManClassy"].items, rateForJukeboxStarterKits)
    table.insert(ProceduralDistributions.list["WardrobeWomanClassy"].items, "TrueMusicJukebox.StarterKit")
    table.insert(ProceduralDistributions.list["WardrobeWomanClassy"].items, rateForJukeboxStarterKits)

    table.insert(ProceduralDistributions.list["ShelfGeneric"].items, "TrueMusicJukebox.InstructionManual")
    table.insert(ProceduralDistributions.list["ShelfGeneric"].items, rateForBooks)
    table.insert(ProceduralDistributions.list["ShelfGeneric"].items, "TrueMusicJukebox.InstructionManual")
    table.insert(ProceduralDistributions.list["ShelfGeneric"].items, rateForBooks)
    table.insert(ProceduralDistributions.list["LockerClassy"].items, "TrueMusicJukebox.InstructionManual")
    table.insert(ProceduralDistributions.list["LockerClassy"].items, JukeboxDistribution.truncate(rateForBooks / 4))
    table.insert(ProceduralDistributions.list["SchoolLockers"].items, "TrueMusicJukebox.InstructionManual")
    table.insert(ProceduralDistributions.list["SchoolLockers"].items, JukeboxDistribution.truncate(rateForBooks / 4))
    table.insert(ProceduralDistributions.list["LibraryBooks"].items, "TrueMusicJukebox.InstructionManual")
    table.insert(ProceduralDistributions.list["LibraryBooks"].items, rateForBooks)
    table.insert(ProceduralDistributions.list["BookstoreBooks"].items, "TrueMusicJukebox.InstructionManual")
    table.insert(ProceduralDistributions.list["BookstoreBooks"].items, rateForBooks)
    table.insert(ProceduralDistributions.list["BreakRoomShelves"].items, "TrueMusicJukebox.InstructionManual")
    table.insert(ProceduralDistributions.list["BreakRoomShelves"].items, rateForBooks)
    table.insert(ProceduralDistributions.list["MedicalOfficeBooks"].items, "TrueMusicJukebox.InstructionManual")
    table.insert(ProceduralDistributions.list["MedicalOfficeBooks"].items, rateForBooks / 2)
    table.insert(ProceduralDistributions.list["OfficeDeskHome"].items, "TrueMusicJukebox.InstructionManual")
    table.insert(ProceduralDistributions.list["OfficeDeskHome"].items, rateForBooks / 2)
    table.insert(ProceduralDistributions.list["VacationStuff"].items, "TrueMusicJukebox.InstructionManual")
    table.insert(ProceduralDistributions.list["VacationStuff"].items, rateForBooks / 4)
    table.insert(ProceduralDistributions.list["PostOfficeBooks"].items, "TrueMusicJukebox.InstructionManual")
    table.insert(ProceduralDistributions.list["PostOfficeBooks"].items, rateForBooks / 2)

    ItemPickerJava.Parse()

end

Events.OnInitGlobalModData.Add(JukeboxDistribution.addBooks)

return JukeboxDistribution
