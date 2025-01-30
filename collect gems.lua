script_key="lCLhfKFjHxkFqWzbhAEjckNKrAKIyCPl";

getgenv().petsGoConfig = {
    -- true/false
    IGNORE_FULL_CHARGE_MEGA_EGG = false,

    CONSUME_CORRUPTED_HUGE_BAIT = true,
    CONSUME_ALL_ENCHANT_SAFE = true,
    CONSUME_ALL_MINING_CHEST = true,
    CONSUME_EVENT_GIFT_BAG = false,
    CONSUME_EVENT_EGG = false, -- Hype eggs not included

    WEBHOOK_URL = "https://discordapp.com/api/webhooks/1332679074933510239/DqzGuqp98v9mU8jz7U0fOc8l2A5wgMjqDMjzxMH7YKJOecVYiHGnlp7ezUocFvGT_q8O",
    MAILING_WEBHOOK_URL = "https://discordapp.com/api/webhooks/1332679165442265129/N4G73oCnpZS-WMWLtSYvEyobeN1Tu6zxH7AD26CDc0rdaED8miWorKPnhP1Iqf0Os_LS",
    DISCORD_ID = "1168121186790686779",  -- Required!!! (For public-webhook)
    WEBHOOK_ODDS = 1000000000, -- Minimum Pet Odds To Trigger Webhook

    DIAMOND_EGG = true,  -- true = Diamond Egg, false = F2P Egg
    MINE_ALL_ORES = true,  -- true = all ore, false = runic & event ore
    
    -- Allowed enchant keywords : Criticals, Loot, Speed, Strength, Chests, Diamonds, Huges, Lightning, TNT
    PICKAXE_ENCHANTS = {"Speed", "Loot", "Criticals"},
    
    MAILING = true,  -- Auto mail
    MAIL_FISHING_ROD = false,  -- true = mail, false = keep fishing rod on account (FASTER Fishing)
    MAIL_WEBHOOK_ODDS = 1000000000, -- Minimum Pet Odds To Trigger MAIL Webhook
    MAIL_PET_ODDS = 1000000000,  -- Minimum Pet Odds To Mail
    MAIL_GEMS_MIN = 10000000,  -- Minimum Gems to mail out

    MIN_MAIL_AMOUNT = {  -- Rare items not listed, default min 1
      -- General
      INSTA_POTION_IV = 10,
      CORRUPTED_HUGE_BAIT = 100,
      CRYSTAL_KEY = 5, CRYSTAL_KEY_UPPER_HALF = 20, CRYSTAL_KEY_LOWER_HALF = 20,
      EXCLUSIVE_TREASURE_CHEST = 10, ABYSSAL_TREASURE_CHEST = 10,
      CELESTIAL_MINING_CHEST = 10, RUNIC_MINING_CHEST = 5,
      CELESTIAL_ENCHANT_SAFE = 10,
      -- Event
      HUGE_CHARGE_TOKEN = 10, TITANIC_CHARGE_TOKEN = 5,
      EVENT_GIFT_BAG = 10,
    },  
    
    USERNAME_TO_MAIL = {"ohiosigmawth", "ohiosigmawth1", "ohiosigmawth2", "ohiosigmawth3", "ohiosigmawth4", "ohiosigmawth5", "ohiosigmawth6", "ohiosigmawth7", "ohiosigmawth8", "ohiosigmawth9"} -- Mail to username, Example : USERNAME_TO_MAIL = {"username1", "username2"}
}

loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/e81ea00ef49a917bb1242da4f41dc4f9.lua"))()
