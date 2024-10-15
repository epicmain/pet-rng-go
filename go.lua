local Root = game:GetService("ReplicatedStorage")["__DIRECTORY"].Upgrades.Root
local Client = game:GetService("ReplicatedStorage"):WaitForChild("Library").Client
local network = require(game:GetService("ReplicatedStorage").Library.Client.Network)
local save = require(game:GetService("ReplicatedStorage").Library.Client.Save).Get()
local upgradeCmds = require(Client.UpgradeCmds)
local fruitCmds = require(Client.FruitCmds)

local orb = require(Client.OrbCmds.Orb)
local inventory = save.Inventory
local maxFruitQueue = fruitCmds.ComputeFruitQueueLimit()

local localPlayerName = game.Players.LocalPlayer.Name
local instantLuck3PotionId
local upgradeFruitTimeStart = tick()
local upgradeFruitDelay = 60


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


local function len(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end


local function findRelics()
    for i=1, 50 do
        if not save["Relics"][tostring(i)] then
            network.Invoke("Relic_Found", i)
            task.wait()
            print(i)
        end
    end
    if len(save["Relics"]) < 39 then
        game:GetService("ReplicatedStorage").Network["Travel to Trading Plaza"]:InvokeServer()
    end
end


local moreRelics = require(Root["Faster Egg Open"]["Faster Egg Open 2"]["Instant Egg Open"]["Golden Dice"]["Small Coin Piles"]["Large Coin Piles"]["More Breakables"]["Even More Breakables"].Relics["More Relics"])
if upgradeCmds.IsUnlocked(moreRelics) then
    findRelics()
    task.wait(3)
end
if game:GetService("Workspace"):FindFirstChild("TRADING") then
    while true do
        game:GetService("ReplicatedStorage").Network["Travel to Main World"]:InvokeServer()
        task.wait(5)
    end
end


game:GetService("Workspace").OUTER:Destroy()
game:GetService("Workspace").MAP.PARTS:Destroy()
game:GetService("ReplicatedStorage").Network["Move Server"]:Destroy()
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

require(Client.FriendCmds).HasOnlineFriends = function(...)
    return true
end

require(Client.FriendCmds).GetEffectiveFriendsOnline = function(...)
    return 110
end


-- VVV Optimizer VVV

-- turn off settings
local settingsCmds = require(Client.SettingsCmds)

game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Slider Setting"):InvokeServer("SFX", 0)
game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Slider Setting"):InvokeServer("Music", 0)

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


-- buy advanced merchant potions
network.Fired("Merchant_Updated"):Connect(function(...)
    local args = {...}
    local indexTokenAmount = 0

    for itemId, tbl in pairs(require(game:GetService("ReplicatedStorage").Library.Client.Save).Get().Inventory.Misc) do
        if tbl.id == "Index Token" and tbl._am ~= nil then
            indexTokenAmount = tbl._am
        end
    end    

    print("Offers for AdvancedIndexMerchant:")
    for offerIndex, offer in pairs(args[1]["AdvancedIndexMerchant"].Offers) do
        local itemId = offer.ItemData.data.id
        local tier = offer.ItemData.data.tn
        local stock = offer.Stock
        local priceId = offer.PriceData.data.id
        local cost = offer.PriceData.data._am

        if itemId == "The Cocktail" or itemId == "Instant Luck Potion" then
            if indexTokenAmount >= (cost * stock) then
                for i=1, stock do
                    game:GetService("ReplicatedStorage").Network["Merchant_RequestPurchase"]:InvokeServer("AdvancedIndexMerchant", tonumber(offerIndex))
                    print("Bought:", itemId .. ", Item Number:", offerIndex)
                    print(1)
                end
            else
                -- check if always not enough index or too much index tokens. then adjust script
                print("Can't Afford Index Item")
            end
        end
        
        print(string.format("Offer %d: Item: %s, Tier: %d, Stock: %d, Price ID: %s, Cost: %s", offerIndex, itemId, tier, stock, priceId, cost))
    end
end)


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

for _, v in pairs(game.Players:GetChildren()) do
    for _, v2 in pairs(v.Character:GetDescendants()) do
        if v2:IsA("BasePart") or v2:IsA("Decal") then
            v2.Transparency = 1
        end
    end
end

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
            if child.Name ~= "Trading Booths" and child.Name ~= "More Pet Details" and child.Name ~= "Hoverboard" and child.Name ~= "Faster Pets" then
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


-- local function buyIndexShop()
--     for i=1, 3 do
--         for i=1, 6 do
--             task.wait(0.5)
--             game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Merchant_RequestPurchase"):InvokeServer("AdvancedIndexMerchant", i)
--         end
--     end
-- end


local function consumeBestPotion()
    local cocktailConsumed
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

    if instantLuck3PotionId then
        -- check if cocktail been consumed
        for _, v in game:GetService("Players")[localPlayerName].PlayerGui.Main.Boosts.Inner:GetChildren() do
            if "Effects_The Cocktail" == v.Name then
                cocktailConsumed = true
                break
            end
        end

        if not cocktailConsumed then
            for itemId, tbl in pairs(require(game:GetService("ReplicatedStorage").Library.Client.Save).Get().Inventory.Consumable) do
                -- sub removes
                if tbl.id == ("Effects_The Cocktail"):sub(9) then
                    pcall(function() game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Consumables_Consume"):InvokeServer(itemId, 1) end)
                    cocktailConsumed = true
                    task.wait(1)
                    break
                end
            end
        end

        print("Using Instant Luck 3 Potion")
        if cocktailConsumed then
            pcall(function() game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Consumables_Consume"):InvokeServer(instantLuck3PotionId, 1) end)
            task.wait(0.5)
        end
        instantLuck3PotionId = nil
    end
end


local function smartPotionUpgrade()
    for itemId, tbl in pairs(require(game:GetService("ReplicatedStorage").Library.Client.Save).Get().Inventory.Consumable) do
        task.wait()
        if tbl.id == "Lucky Potion" then
            if tbl.tn == 1 and tbl._am ~= nil and tbl._am >= 3 then
                -- print("Crafted Lucky Tier 2")
                for i=1, math.floor(tbl._am / 3) do
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 1)
                    task.wait(1.5)
                end
    
            elseif tbl.tn == 2 and tbl._am ~= nil and tbl._am >= 4 then
                -- print("Crafted Lucky Tier 3")
                for i=1, math.floor(tbl._am / 4) do
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 2)
                    task.wait(1.5)
                end
    
            elseif tbl.tn == 3 and tbl._am ~= nil and tbl._am >= 5 then
                local stopCraftingTier4Lucky
                local lucky4Amount = 0
                for _, tbl2 in pairs(require(game:GetService("ReplicatedStorage").Library.Client.Save).Get().Inventory.Consumable) do
                    if tbl2.id == "Lucky Potion" and tbl2.tn == 4 and tbl2._am ~= nil then
                        if tbl2._am >= 143 then
                            stopCraftingTier4Lucky = true
                            -- print("stop crafting tier 4 lucky")
                            break
                        else
                            lucky4Amount = tbl2._am
                        end
                    end
                end
                if not stopCraftingTier4Lucky then
                    local amountToCraft
                    if math.floor(tbl._am / 4) >= (143 - lucky4Amount) then
                        amountToCraft = (143 - lucky4Amount)
                    else
                        amountToCraft = math.floor(tbl._am / 4)
                    end

                    for i=1, amountToCraft do
                        -- print("Crafted Lucky Tier 4")
                        game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 3)
                        task.wait(1.5)
                    end
                end
    
            elseif tbl.tn == 4 and tbl._am ~= nil and tbl._am >= 5 then
                local stopCraftingTier5Lucky
                local lucky5Amount = 0
                for _, tbl2 in pairs(require(game:GetService("ReplicatedStorage").Library.Client.Save).Get().Inventory.Consumable) do
                    if tbl2.id == "Lucky Potion" and tbl2.tn == 5 and tbl2._am ~= nil then
                        if tbl2._am >= 19 then
                            stopCraftingTier5Lucky = true
                            -- print("stop crafting tier 5 lucky")
                            break
                        else
                            lucky5Amount = tbl2._am
                        end
                    end
                end
                if not stopCraftingTier5Lucky then
                    local amountToCraft
                    if math.floor(tbl._am / 5) >= (19 - lucky5Amount) then
                        amountToCraft = (19 - lucky5Amount)
                    else 
                        amountToCraft = math.floor(tbl._am / 5)
                    end

                    for i=1, amountToCraft do
                        for _, tbl2 in pairs(require(game:GetService("ReplicatedStorage").Library.Client.Save).Get().Inventory.Fruit) do
                            if tbl2.id == "Orange" and tbl2._am ~= nil and tbl2._am >= 12 then
                                -- print("Crafted Lucky Tier 5")
                                game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 4)
                                task.wait(1.5)
                                break
                            end
                        end
                    end
                end
            end
        end
    
    
        if tbl.id == "Coins Potion" then
            if tbl.tn == 1 and tbl._am ~= nil and tbl._am >= 3 then
                -- print("Crafted Coins Potion 2")
                for i=1, math.floor(tbl._am / 3) do
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 5)
                    task.wait(1.5)
                end
    
            elseif tbl.tn == 2 and tbl._am ~= nil and tbl._am >= 4 then
                -- print("Crafted Coins Potion 3")
                for i=1, math.floor(tbl._am / 4) do
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 6)
                    task.wait(1.5)
                end
    
            elseif tbl.tn == 3 and tbl._am ~= nil and tbl._am >= 5 then
                -- print("Crafted Coins Potion 4")
                for i=1, math.floor(tbl._am / 5) do
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 7)
                    task.wait(1.5)
                end
    
            elseif tbl.tn == 4 and tbl._am ~= nil and tbl._am >= 5 then
                for _, tbl2 in pairs(require(game:GetService("ReplicatedStorage").Library.Client.Save).Get().Inventory.Fruit) do
                    if tbl2.id == "Banana" and tbl2._am >= 12 then
                        -- print("Crafted Coins Potion 5 (BEST)")
                        game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 8)
                        task.wait(1.5)
                    end
                end
            end
        end
    
    
        if tbl.id == "Breakables Potion" then
            if tbl.tn == 1 and tbl._am ~= nil and tbl._am >= 3 then
                -- print("Crafted Breakables Potion 2 (BEST)")
                for i=1, math.floor(tbl._am / 3) do
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 10)
                    task.wait(1.5)
                end
            end
        end
    
    
        if tbl.id == "Items Potion" then
            if tbl.tn == 1 and tbl._am ~= nil and tbl._am >= 3 then
                -- print("Crafted Items Potion 2")
                for i=1, math.floor(tbl._am / 3) do
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 13)
                    task.wait(1.5)
                end
    
            elseif tbl.tn == 2 and tbl._am ~= nil and tbl._am >= 4 then
                -- print("Crafted Items Potion 3 (BEST)")
                for i=1, math.floor(tbl._am / 4) do
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 14)
                    task.wait(1.5)
                end
            end
        end
    end
end


-- Get potion and fruit amounts from the player's inventory
local function getInventoryAmounts()
    local amounts = {
        instantLuck2Amount = 0,
        instantLuck1Amount = 0,
        rainbowDiceAmount = 0,
        goldenDiceAmount = 0,
        lucky5Amount = 0,
        lucky4Amount = 0,
        lucky3Amount = 0,
        rainbowFruitAmount = 0,
        orangeAmount = 0,
    }

    -- Get potions amount
    for itemId, tbl in pairs(require(game:GetService("ReplicatedStorage").Library.Client.Save).Get().Inventory.Consumable) do
        if tbl.id == "Instant Luck Potion" and tbl.tn == 2 and tbl._am ~= nil then
            amounts.instantLuck2Amount = tbl._am
        elseif tbl.id == "Instant Luck Potion" and tbl.tn == 1 and tbl._am ~= nil then
            amounts.instantLuck1Amount = tbl._am
        elseif tbl.id == "Rainbow Dice Potion" and tbl._am ~= nil then
            amounts.rainbowDiceAmount = tbl._am
        elseif tbl.id == "Golden Dice Potion" and tbl._am ~= nil then
            amounts.goldenDiceAmount = tbl._am
        elseif tbl.id == "Lucky Potion" and tbl.tn == 5 and tbl._am ~= nil then
            amounts.lucky5Amount = tbl._am
        elseif tbl.id == "Lucky Potion" and tbl.tn == 4 and tbl._am ~= nil then
            amounts.lucky4Amount = tbl._am
        elseif tbl.id == "Lucky Potion" and tbl.tn == 3 and tbl._am ~= nil then
            amounts.lucky3Amount = tbl._am
        end
    end

    -- Get orange and rainbow fruit amount
    for itemId, tbl in pairs(require(game:GetService("ReplicatedStorage").Library.Client.Save).Get().Inventory.Fruit) do
        if tbl.id == "Orange" and tbl._am ~= nil then
            amounts.orangeAmount = tbl._am
        elseif tbl.id == "Rainbow" and tbl._am ~= nil then
            amounts.rainbowFruitAmount = tbl._am
        end
    end

    return amounts
end

-- Function to craft potions using server invokes
local function craft(potion)
    local amounts = getInventoryAmounts()

    if potion == "instantLuck3" then
        if amounts.instantLuck2Amount >= 3 and amounts.rainbowDiceAmount >= 2 then
            amounts.instantLuck2Amount = amounts.instantLuck2Amount - 3
            amounts.rainbowDiceAmount = amounts.rainbowDiceAmount - 2
            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 22)
            task.wait(1.5)
            print("Crafted: Instant Luck 3")
        else
            while amounts.instantLuck2Amount < 3 or amounts.rainbowDiceAmount < 2 do
                task.wait() -- Default wait before trying again
                amounts = getInventoryAmounts()  -- Re-check inventory
                if amounts.instantLuck2Amount < 3 then
                    craft("instantLuck2")
                end
                if amounts.rainbowDiceAmount < 2 then
                    craft("rainbowDice")
                end
            end
            amounts.instantLuck2Amount = amounts.instantLuck2Amount - 3
            amounts.rainbowDiceAmount = amounts.rainbowDiceAmount - 2
            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 22)
            task.wait(1.5)
            print("Crafted: Instant Luck 3")
        end
    elseif potion == "instantLuck2" then
        if amounts.instantLuck1Amount < 3 then
            error("Not enough Instant Luck 1 potions to craft Instant Luck 2, quitting process.")
        else
            while amounts.rainbowDiceAmount < 2 do
                task.wait() -- Default wait before trying again
                amounts = getInventoryAmounts()  -- Re-check inventory
                if amounts.rainbowDiceAmount < 2 then
                    craft("rainbowDice")
                end
            end
            amounts.instantLuck1Amount = amounts.instantLuck1Amount - 3
            amounts.rainbowDiceAmount = amounts.rainbowDiceAmount - 2
            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 21)
            task.wait(1.5)
            print("Crafted: Instant Luck 2")
        end
    elseif potion == "rainbowDice" then
        if amounts.lucky4Amount >= 2 and amounts.rainbowFruitAmount >= 4 then
            amounts.lucky4Amount = amounts.lucky4Amount - 2
            amounts.rainbowFruitAmount = amounts.rainbowFruitAmount - 4
            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CraftingMachine_Craft"):InvokeServer("PotionCraftingMachine", 19)
            task.wait(1.5)
            print("Crafted: Rainbow Dice")
        else
            error("Not enough materials to craft Rainbow Dice, quitting process.")
        end
    end
end


local function upgradeFruits()
    teleportToMachine("UpgradeFruitsMachine")
    local rainbowFruitAmount
    for _, tbl in pairs(require(game:GetService("ReplicatedStorage").Library.Client.Save).Get().Inventory.Fruit) do
        if tbl.id == "Rainbow" then
            rainbowFruitAmount = tbl._am
            break
        end
    end
    
    for fruitId, tbl in pairs(require(game:GetService("ReplicatedStorage").Library.Client.Save).Get().Inventory.Fruit) do
        if tbl._am ~= nil and tbl._am >= 425 and rainbowFruitAmount <= 2000 then  -- keep 400, use 25 to make rainbow fruit
            local args = {
                [1] = {
                    [fruitId] = (tbl._am - 400)
                }
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("UpgradeFruitsMachine_Activate"):InvokeServer(unpack(args))
            task.wait(2)
        end
    end
end



if require(Client.HoverboardCmds).IsEquipped() then
    require(Client.HoverboardCmds).RequestUnequip()
end


local fruitBoost = require(Root["Faster Egg Open"]["Faster Egg Open 2"].Inventory.Fruit)
local potionsUpgrade = require(Root["Faster Egg Open"]["Faster Egg Open 2"].Inventory.Fruit["Lucky Potion"])

-- background stuff
task.spawn(function()
    while true do
        task.wait()
        traverseModules(Root)

        if not require(game:GetService("ReplicatedStorage").Library.Client.EggCmds).IsRolling() and save.DiceCombos["Rainbow"] ~= 80 then
            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Eggs_Roll"):InvokeServer()
            task.wait(0.5)
            
        elseif save.DiceCombos["Rainbow"] == 80 then
            print("Rainbow READY")
            local instantLuck3PotionFound
            for itemId, tbl in pairs(require(game:GetService("ReplicatedStorage").Library.Client.Save).Get().Inventory.Consumable) do
                if tbl.id == "Instant Luck Potion" and tbl.tn == 3 then
                    instantLuck3PotionFound = true
                    instantLuck3PotionId = itemId
                    pcall(consumeBestPotion)  -- use every best potion + instant luck 3
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Eggs_Roll"):InvokeServer()
                    task.wait(0.5)
                    break
                end
            end
            if not instantLuck3PotionFound then
                print("No Instant Luck 3 Potions Detected")
                game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Eggs_Roll"):InvokeServer()
                task.wait(0.5)
            end
        end
        
        pcall(checkAndConsumeFruits)
    
        pcall(consumeBestPotion)
        

        if game:GetService("Players").LocalPlayer.PlayerGui.Message.Enabled then
            game:GetService("Players").LocalPlayer.PlayerGui.Message.Enabled = false
        end
    end
end)


local breakables = require(Root["Faster Egg Open"]["Faster Egg Open 2"]["Instant Egg Open"]["Golden Dice"]["Small Coin Piles"])
task.spawn(function()
    while true do
        task.wait()
        pcall(petTargetChestAndBreakables)
        pcall(tapChestAndBreakables)
    end
end)


local advancedIndexShop = require(Root["Faster Egg Open"]["Faster Egg Open 2"].Inventory.Trading["Pet Index"]["Index Shop"]["Advanced Index Shop"])
local coinPresents = require(Root["Faster Egg Open"]["Faster Egg Open 2"]["Instant Egg Open"]["Golden Dice"]["Small Coin Piles"]["Large Coin Piles"]["Coin Crates"]["Coin Presents"])
local petDigCoins = require(Root["Faster Egg Open"]["Faster Egg Open 2"]["Instant Egg Open"]["Auto Roll"].Luckier["Even Luckier"]["Egg 2"]["Egg 3"]["Pet Dig Coins"])
local potionVending = require(Root["Faster Egg Open"]["Faster Egg Open 2"].Inventory.Fruit["Lucky Potion"]["Potion Vending"])
local potionWizard = require(Root["Faster Egg Open"]["Faster Egg Open 2"].Inventory.Fruit["Lucky Potion"]["Lucky Potion Tier 2"]["Potion Crafting"]["Crafting More Potion Recipes"]["Potion Wizard"])
local fruitMachine = require(Root["Faster Egg Open"]["Faster Egg Open 2"].Inventory.Fruit["More Fruit"]["Finding Fruit"]["Rainbow Fruit"]["Fruit Machine"])

-- background stuff
while true do
    task.wait()
    
    -- if upgradeCmds.IsUnlocked(advancedIndexShop) then
    --     buyIndexShop()
    -- end
    

    pcall(collectHiddenGift)

    pcall(teleportToDig)

    if upgradeCmds.IsUnlocked(potionVending) and save["VendingStocks"].PotionVendingMachine > 0 then
        teleportToMachine("PotionVendingMachine")
        for i=1, save["VendingStocks"].PotionVendingMachine do
            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("VendingMachines_Purchase"):InvokeServer("PotionVendingMachine")
            task.wait(0.5)
        end
    end
    if upgradeCmds.IsUnlocked(potionWizard) then
        local potionCraftingMagnitude = (game:GetService("Workspace")[localPlayerName].HumanoidRootPart.Position - game:GetService("Workspace").MAP.INTERACT.Machines.PotionCraftingMachine.PadGlow.Position).Magnitude
        if potionCraftingMagnitude > 30 then
            teleportToMachine("PotionCraftingMachine")
        end
        pcall(smartPotionUpgrade)
        pcall(craft, "instantLuck3")
    end
    
    if upgradeCmds.IsUnlocked(fruitMachine) and (tick() - upgradeFruitTimeStart) >= upgradeFruitDelay then
        upgradeFruitTimeStart = tick()
        pcall(upgradeFruits)
    end

    if require(game:GetService("ReplicatedStorage").Library.Client.LoginStreakCmds).CanClaim() then
        game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Login Streaks: Bonus Roll Request"):InvokeServer()
    end
end


-- REMEMBER TO MAKE AN INVENTORY SEARCHER THAT SEARCHES EVERYTHING THEN RETURN EVERYTHING SO I CAN JUST USE "." TO GET TO IT
