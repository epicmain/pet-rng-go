local Root = game:GetService("ReplicatedStorage")["__DIRECTORY"].Upgrades.Root
local Client = game:GetService("ReplicatedStorage"):WaitForChild("Library").Client
local upgradeCmds = require(Client.UpgradeCmds)
local fruitCmds = require(Client.FruitCmds)

local orb = require(Client.OrbCmds.Orb)
local clientSaveGet = require(Client.Save).Get()
local inventory = clientSaveGet.Inventory
local maxFruitQueue = fruitCmds.ComputeFruitQueueLimit()

local localPlayerName = game.Players.LocalPlayer.Name


orb.DefaultPickupDistance = 0  -- slowly comes to player, disable
orb.CollectDistance = 400  -- insane instant magnet
orb.BillboardDistance = 0  -- disables gui showing collected coins
orb.SoundDistance = 0
orb.CombineDelay = 0
orb.CombineDistance = 400


while not upgradeCmds.IsUnlocked(require(Root)) do
    task.wait(1)
    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Eggs_Roll"):InvokeServer()
    task.wait(1)
    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Tutorial_ClickedUpgrades"):FireServer()
    task.wait(1)
    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Upgrades_Purchase"):InvokeServer("Root")
end



game:GetService("Workspace").OUTER:Destroy()
game:GetService("Workspace").MAP.PARTS:Destroy()
game:GetService("Workspace")[localPlayerName].HumanoidRootPart.Anchored = true

local platform = Instance.new("Part")
platform.Parent = game:GetService("Workspace")
platform.Anchored = true
platform.CFrame = game:GetService("Workspace").MAP.SPAWNS.Spawn.CFrame + Vector3.new(0, -5.5, 0)
platform.Size = Vector3.new(500, 1, 500)
-- platform.Transparency = 1
game:GetService("Workspace")[localPlayerName].HumanoidRootPart.Anchored = false



require(Client.PlayerPet).CalculateSpeedMultiplier = function(...)
    return 500
end


-- VVV Optimizer VVV

-- turn off settings
local settingsCmds = require(game:GetService("ReplicatedStorage").Library.Client.SettingsCmds)

game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Slider Setting"):InvokeServer("SFX", 0)
print('s')
game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Slider Setting"):InvokeServer("Music", 0)
print('ss')

local toggleSettings = {
    "Notifications",
    "ItemNotifications",
    "GlobalHatchMessages",
    "ServerHatchMessages",
    "GlobalNameDisplay",
    "FireworkShow",
    "ShowOtherPets",
    "PetSFX",
    "PetAuras",
    "Vibrations"
}

for _, settingNames in pairs(toggleSettings) do
    print('sss')
    if settingsCmds.Get(settingNames) == "Off" then
        -- turn off and on for it to work
        game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Toggle Setting"):InvokeServer(settingNames)
        task.wait(1)
        game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Toggle Setting"):InvokeServer(settingNames)
    else
        game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Toggle Setting"):InvokeServer(settingNames)
    end
end

game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.Core["Idle Tracking"].Disabled = true
if getconnections then
    for _, v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
        v:Disable()
    end
else
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        virtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        virtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end
print("[Anti-AFK Activated!]")


local function clearTextures(v)
    if v:IsA("BasePart") and not v:IsA("MeshPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") and v.Name == "Item" then
        v:Destroy()
    elseif v:IsA("MeshPart") and tostring(v.Parent) == "Orbs" then
        v.Transparency = 1
    elseif (v:IsA("Decal") or v:IsA("Texture")) then
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Lifetime = NumberRange.new(0)
    elseif v:IsA("Explosion") then
        v.BlastPressure = 1
        v.BlastRadius = 1
    elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
        v.Enabled = false
    elseif v:IsA("MeshPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
        v.TextureID = 10385902758728957
        v.Transparency = 1
    elseif v:IsA("SpecialMesh") then
        v.TextureId = 0
    elseif v:IsA("ShirtGraphic") then
        v.Graphic = 1
    elseif (v:IsA("Shirt") or v:IsA("Pants")) then
        v[v.ClassName .. "Template"] = 1
    end
end

for _, v in pairs(Workspace:GetDescendants()) do
    clearTextures(v)
end


-- make player invis

pcall(function()
    for _, v in pairs(game.Players:GetChildren()) do
        for _, v2 in pairs(v.Character:GetDescendants()) do
            if v2:IsA("BasePart") or v2:IsA("Decal") then
                v2.Transparency = 1
            end
        end
    end
end)

for _, v in pairs(game:GetService("Workspace").MAP.INTERACT:GetChildren()) do
    if v.Name ~= "Machines" and v.Name ~= "Items" then
        v:Destroy()
    end
end

game:GetService("Players").LocalPlayer.PlayerGui.Notifications:Destroy()

hookfunction(require(game:GetService("ReplicatedStorage").Library.Client.OrbCmds.Orb).RenderParticles, function()
    return
end)

hookfunction(require(game:GetService("ReplicatedStorage").Library.Client.OrbCmds.Orb).SimulatePhysics, function()
    return
end)

hookfunction(require(game:GetService("ReplicatedStorage").Library.Client.GUIFX.Confetti).Play, function()
    return
end)

local worldFXList = {"Confetti", "RewardImage", "QuestGlow", "Damage", "SpinningChests", "RewardItem", "Sparkles", "AnimatePad", "PlayerTeleport", "AnimateChest", "Poof",
"SmallPuff", "Flash", "Arrow3D", "ArrowPointer3D", "RainbowGlow"}

for x, y in pairs(worldFXList) do
    hookfunction(require(game:GetService("ReplicatedStorage").Library.Client.WorldFX[y]), function()
        return
    end)
end

for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
    if v:IsA("Part") or v:IsA("BasePart") then
        v.Transparency = 1
    end
end


game:GetService("Workspace").DescendantAdded:Connect(function(v)
    clearTextures(v)
end)

pcall(function()
    local RunService = game:GetService("RunService")
    RunService:Set3dRenderingEnabled(false)
end)
-- ^^^ Optimizer ^^^


local function findChest()
    for _, v in game:GetService("Workspace")["__THINGS"].Breakables:GetChildren() do
        if v:FindFirstChild("Top") then
            return tonumber(v.Name)
        end
    end
end


local function findNormal()
    local normal = {}
    for _, v in game:GetService("Workspace")["__THINGS"].Breakables:GetChildren() do
        if v:FindFirstChild("1") or v:FindFirstChild("2") or v:FindFirstChild("3") then
            table.insert(normal, tonumber(v.Name))
        end
    end
    return normal
end


local function findFruitCrate()
    for _, v in game:GetService("Workspace")["__THINGS"].Breakables:GetChildren() do
        if v:FindFirstChild("Apple") or v:FindFirstChild("Banana") or v:FindFirstChild("Pineapple") then
            return tonumber(v.Name)
        end
    end
end


local function petTargetChestAndBreakables()
    local chestNum = findChest()
    local fruitCrateNum
    local normalNum  -- table

    if not chestNum then
        fruitCrateNum = findFruitCrate()
    end
    if not chestNum or not fruitCrateNum then
        normal = findNormal()
    end
    
    local normalIndex = 0
    local args = {
        [1] = {}
    }
    for petId, _ in pairs(require(game:GetService("ReplicatedStorage").Library.Client.PlayerPet).GetAll()) do
        normalIndex = normalIndex + 1
        if chestNum then 
            args[1][petId] = chestNum
        elseif fruitCrateNum then
            args[1][petId] = fruitCrateNum
        else
            pcall(function()
                args[1][petId] = normal[normalIndex]
            end)
        end
    end

    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Breakables_JoinPetBulk"):FireServer(unpack(args))
end


local function tapChestAndBreakables()
    local target = findChest()

    if not target then  -- target is assigned to chest first, if failed, assign fruit crate
        target = findFruitCrate()
    end
    if not target then  -- if fruit crate failed, then assign normal breakable
        for _, v in game:GetService("Workspace")["__THINGS"].Breakables:GetChildren() do
            if v:FindFirstChild("1") or v:FindFirstChild("2") or v:FindFirstChild("3") then
                target = tonumber(v.Name)
                break
            end
        end
    end

    for _, v in game:GetService("Workspace")["__THINGS"].Breakables:GetChildren() do
        if v:FindFirstChild("base") then
            target = tonumber(v.Name)
            break
        end
    end

    game.ReplicatedStorage.Network["Breakables_PlayerDealDamage"]:FireServer(target)
end


local function traverseModules(module)
    for _, child in ipairs(module:GetChildren()) do
        if upgradeCmds.IsUnlocked(child.Name) then
            traverseModules(child)
        elseif upgradeCmds.CanAfford(child.Name) then
            if child.Name ~= "Trading Booths" and child.Name ~= "More Pet Details" and child.Name ~= "Hoverboard" and 
            child.Name ~= "Friends Boost" and child.Name ~= "Faster Pets" then
                upgradeCmds.Unlock(child.Name)
                print("Bought affordable upgrade: " .. child.Name)
            end
        end
    end
end


local function checkAndConsumeFruits()
    for fruitId, tbl in pairs(inventory.Fruit) do
        task.wait(0.5)
        if fruitCmds.GetActiveFruits()[tbl.id] ~= nil then
            if (#fruitCmds.GetActiveFruits()[tbl.id]["Normal"] < maxFruitQueue) and (tbl._am ~= nil) then
                -- print("Continue consuming ", tbl.id)
                if tbl._am < fruitCmds.GetMaxConsume(fruitId) then
                    fruitCmds.Consume(fruitId, tonumber(tbl._am))
                else
                    fruitCmds.Consume(fruitId, fruitCmds.GetMaxConsume(fruitId))
                end
            end
        else
            fruitCmds.Consume(fruitId)
        end
    end
end


-- local function collectFruit()
--     for _, v in game:GetService("Workspace")["__THINGS"].Breakables:GetChildren() do
--         task.wait(0.5)
--         if v:FindFirstChild("base") then
--             print(v.Name)
--             game.ReplicatedStorage.Network["Breakables_PlayerDealDamage"]:FireServer(tonumber(v.Name))
--         end
--     end
-- end


local function collectHiddenGift()
    for _, v in game:GetService("Workspace")["__THINGS"].HiddenGifts:GetChildren() do
        for _, v2 in v:GetChildren() do
            task.wait(0.5)
            game:GetService("Workspace")[localPlayerName].HumanoidRootPart.CFrame = v2.CFrame + Vector3.new(10, 0, 0)

            local character = game.Players.LocalPlayer.Character

            if character and character:FindFirstChild("Humanoid") then
                local humanoid = character.Humanoid
                local targetPosition = v2.Position

                humanoid:MoveTo(targetPosition)
            end
    
            local loaded = false
            local detectLoad = game:GetService("Workspace")["__THINGS"].HiddenGifts.ChildRemoved:Connect(function(child)
                if child.Name == "Model" then
                    loaded = true
                end
            end)
    
            repeat
                task.wait()
            until loaded
    
            detectLoad:Disconnect()
        end
    end
end


local function teleportToDig()
    for _, v in game:GetService("Workspace")["__THINGS"].Digging:GetChildren() do
        task.wait()
        game:GetService("Workspace")[localPlayerName].HumanoidRootPart.CFrame = v.CFrame
    end
end


local function teleportToMachine(machineName)    
    game:GetService("Workspace")[localPlayerName].HumanoidRootPart.CFrame = game:GetService("Workspace").MAP.INTERACT.Machines[machineName].PadGlow.CFrame + Vector3.new(0, -8, 0)
    task.wait(1)
end


local function buyIndexShop()
    for i=1, 3 do
        for i=1, 6 do
            task.wait(0.5)
            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Merchant_RequestPurchase"):InvokeServer("AdvancedIndexMerchant", i)
        end
    end
end


local function consumeBestPotion()
    local potionNames = {"Effects_Breakables Potion", "Effects_Coins Potion", "Effects_Faster Rolls Potion", "Effects_Items Potion", "Effects_Lucky Potion"}
    -- local dicePotion = {"Effects_Golden Dice Potion", "Effects_Rainbow Dice Potion", "Effects_Instant Luck Potion", "Effects_The Cocktail"}
    
    for _, potionName in pairs(potionNames) do
        local hasBeenConsumed
        for _, v in game:GetService("Players")[localPlayerName].PlayerGui.Main.Boosts.Inner:GetChildren() do
            if potionName == v.Name then
                hasBeenConsumed = true
                break
            end
        end
        if not hasBeenConsumed then
            local highestTierPotion = 0
            local highestTierPotionId
            for itemId, tbl in pairs(require(game:GetService("ReplicatedStorage").Library.Client.Save).Get().Inventory.Consumable) do
                -- sub removes
                if tbl.id == potionName:sub(9) and tbl.tn > highestTierPotion then
                    highestTierPotion = tbl.tn
                    highestTierPotionId = itemId
                    -- print("Consumed:", highestTierPotion)
                end
            end
            pcall(function() game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Consumables_Consume"):InvokeServer(highestTierPotionId, 1) end)
            task.wait(0.5)
        end
    end
end


local function smartPotionUpgrade()
    teleportToMachine("PotionCraftingMachine")
    for itemId, tbl in pairs(require(game:GetService("ReplicatedStorage").Library.Client.Save).Get().Inventory.Consumable) do
        if tbl.id == "Lucky Potion" then
            task.wait(1.5)
            if tbl.tn == 1 and tbl._am ~= nil and tbl._am >= 3 then
                -- print("Crafted Lucky Tier 2")
                game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 1)
    
            elseif tbl.tn == 2 and tbl._am ~= nil and tbl._am >= 4 then
                -- print("Crafted Lucky Tier 3")
                game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 2)
    
            elseif tbl.tn == 3 and tbl._am ~= nil and tbl._am >= 5 then
                local stopCraftingTier4Lucky
                for _, tbl2 in pairs(require(game:GetService("ReplicatedStorage").Library.Client.Save).Get().Inventory.Consumable) do
                    if tbl2.id == "Lucky Potion" and tbl2.tn == 4 and tbl2._am ~= nil and tbl2._am >= 12 then
                        stopCraftingTier4Lucky = true
                        -- print("stop crafting tier 4 lucky")
                        break
                    end
                end
                if not stopCraftingTier4Lucky then
                    -- print("Crafted Lucky Tier 4")
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 3)
                end
    
            elseif tbl.tn == 4 and tbl._am ~= nil and tbl._am >= 5 then
                local stopCraftingTier5Lucky
                for _, tbl2 in pairs(require(game:GetService("ReplicatedStorage").Library.Client.Save).Get().Inventory.Consumable) do
                    if tbl2.id == "Lucky Potion" and tbl2.tn == 5 and tbl2._am ~= nil and tbl2._am >= 3 then
                        stopCraftingTier5Lucky = true
                        -- print("stop crafting tier 5 lucky")
                        break
                    end
                end
                if not stopCraftingTier5Lucky then
                    for _, tbl2 in pairs(require(game:GetService("ReplicatedStorage").Library.Client.Save).Get().Inventory.Fruit) do
                        if tbl2.id == "Orange" and tbl2._am >= 12 then
                            -- print("Crafted Lucky Tier 5")
                            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 4)
                            break
                        end
                    end
                end
            end
        end
    
    
        if tbl.id == "Coins Potion" then
            task.wait(1.5)
            if tbl.tn == 1 and tbl._am ~= nil and tbl._am >= 3 then
                -- print("Crafted Coins Potion 2")
                game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 5)
    
            elseif tbl.tn == 2 and tbl._am ~= nil and tbl._am >= 4 then
                -- print("Crafted Coins Potion 3")
                game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 6)
    
            elseif tbl.tn == 3 and tbl._am ~= nil and tbl._am >= 5 then
                -- print("Crafted Coins Potion 4")
                game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 7)
    
            elseif tbl.tn == 4 and tbl._am ~= nil and tbl._am >= 5 then
                for _, tbl2 in pairs(require(game:GetService("ReplicatedStorage").Library.Client.Save).Get().Inventory.Fruit) do
                    if tbl2.id == "Banana" and tbl2._am >= 12 then
                        -- print("Crafted Coins Potion 5 (BEST)")
                        game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 8)
                    end
                end
            end
        end
    
    
        if tbl.id == "Breakables Potion" then
            task.wait(1.5)
            if tbl.tn == 1 and tbl._am ~= nil and tbl._am >= 3 then
                -- print("Crafted Breakables Potion 2 (BEST)")
                game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 10)
            end
        end
    
    
        if tbl.id == "Items Potion" then
            task.wait(1.5)
            if tbl.tn == 1 and tbl._am ~= nil and tbl._am >= 3 then
                -- print("Crafted Items Potion 2")
                game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 13)
    
            elseif tbl.tn == 2 and tbl._am ~= nil and tbl._am >= 4 then
                -- print("Crafted Items Potion 3 (BEST)")
                game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 14)
            end
        end
    end
end


if require(Client.HoverboardCmds).IsEquipped() then
    require(Client.HoverboardCmds).RequestUnequip()
end


local fruitBoost = require(game:GetService("ReplicatedStorage")["__DIRECTORY"].Upgrades.Root["Faster Egg Open"]["Faster Egg Open 2"].Inventory.Fruit)
local potionsUpgrade = require(game:GetService("ReplicatedStorage")["__DIRECTORY"].Upgrades.Root["Faster Egg Open"]["Faster Egg Open 2"].Inventory.Fruit["Lucky Potion"])

-- background stuff
task.spawn(function()
    while true do
        task.wait()
        traverseModules(Root)
        if not require(Client.EggCmds).IsRolling() then
            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Eggs_Roll"):InvokeServer()
        end
        
        pcall(checkAndConsumeFruits)
    
        pcall(consumeBestPotion)
        

        if game:GetService("Players").LocalPlayer.PlayerGui.Message.Enabled then
            game:GetService("Players").LocalPlayer.PlayerGui.Message.Enabled = false
        end
    end
end)


local breakables = require(game:GetService("ReplicatedStorage")["__DIRECTORY"].Upgrades.Root["Faster Egg Open"]["Faster Egg Open 2"]["Instant Egg Open"]["Golden Dice"]["Small Coin Piles"])
task.spawn(function()
    while true do
        task.wait()
        pcall(petTargetChestAndBreakables)
        pcall(tapChestAndBreakables)
    end
end)


local advancedIndexShop = require(game:GetService("ReplicatedStorage")["__DIRECTORY"].Upgrades.Root["Faster Egg Open"]["Faster Egg Open 2"].Inventory.Trading["Pet Index"]["Index Shop"]["Advanced Index Shop"])
local coinPresents = require(game:GetService("ReplicatedStorage")["__DIRECTORY"].Upgrades.Root["Faster Egg Open"]["Faster Egg Open 2"]["Instant Egg Open"]["Golden Dice"]["Small Coin Piles"]["Large Coin Piles"]["Coin Crates"]["Coin Presents"])
local petDigCoins = require(game:GetService("ReplicatedStorage")["__DIRECTORY"].Upgrades.Root["Faster Egg Open"]["Faster Egg Open 2"]["Instant Egg Open"]["Auto Roll"].Luckier["Even Luckier"]["Egg 2"]["Egg 3"]["Pet Dig Coins"])
local potionVending = require(game:GetService("ReplicatedStorage")["__DIRECTORY"].Upgrades.Root["Faster Egg Open"]["Faster Egg Open 2"].Inventory.Fruit["Lucky Potion"]["Potion Vending"])
local potionWizard = require(game:GetService("ReplicatedStorage")["__DIRECTORY"].Upgrades.Root["Faster Egg Open"]["Faster Egg Open 2"].Inventory.Fruit["Lucky Potion"]["Lucky Potion Tier 2"]["Potion Crafting"]["Crafting More Potion Recipes"]["Potion Wizard"])
-- background stuff
while true do
    task.wait()
    
    if upgradeCmds.IsUnlocked(advancedIndexShop) then
        buyIndexShop()
    end
    
    -- pcall(collectFruit)

    pcall(collectHiddenGift)

    pcall(teleportToDig)
    


    if upgradeCmds.IsUnlocked(potionVending) and clientSaveGet["VendingStocks"].PotionVendingMachine > 0 then
        teleportToMachine("PotionVendingMachine")
        for i=1, clientSaveGet["VendingStocks"].PotionVendingMachine do
            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("VendingMachines_Purchase"):InvokeServer("PotionVendingMachine")
            task.wait(0.5)
        end
    end
    if upgradeCmds.IsUnlocked(potionWizard) then
        smartPotionUpgrade()
    end

    if require(game:GetService("ReplicatedStorage").Library.Client.LoginStreakCmds).CanClaim() then
        game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Login Streaks: Bonus Roll Request"):InvokeServer()
    end
end









            








