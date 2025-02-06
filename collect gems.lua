script_key="lCLhfKFjHxkFqWzbhAEjckNKrAKIyCPl";
setfpscap(3)
getgenv().petsGoConfig = {
    -- true/false
    CONSUME_CORRUPTED_HUGE_BAIT = true,
    CONSUME_ALL_ENCHANT_SAFE = false,
    CONSUME_ALL_MINING_CHEST = false,
    CONSUME_EVENT_GIFT_BAG = false,
    CONSUME_EVENT_EGG = false, -- Hype eggs not included

    WEBHOOK_URL = "https://discordapp.com/api/webhooks/1332679074933510239/DqzGuqp98v9mU8jz7U0fOc8l2A5wgMjqDMjzxMH7YKJOecVYiHGnlp7ezUocFvGT_q8O",
    MAILING_WEBHOOK_URL = "https://discordapp.com/api/webhooks/1332679165442265129/N4G73oCnpZS-WMWLtSYvEyobeN1Tu6zxH7AD26CDc0rdaED8miWorKPnhP1Iqf0Os_LS",
    DISCORD_ID = "1168121186790686779",  -- Required!!! (For public-webhook)
    WEBHOOK_ODDS = 1000000000, -- Minimum Pet Odds To Trigger Webhook

    DIAMOND_EGG = true,  -- true = Diamond Egg, false = F2P Egg
    MINE_ALL_ORES = true,  -- true = all ore, false = runic & event ore
    
    MAILING = true,  -- Auto mail
    MAIL_WEBHOOK_ODDS = 1000000000, -- Minimum Pet Odds To Trigger MAIL Webhook
    MAIL_PET_ODDS = 1000000000,  -- Minimum Pet Odds To Mail
    MAIL_GEMS_MIN = 1000000,  -- Minimum Gems to mail out

    USERNAME_TO_MAIL = {
        "ohiosigmawth1",
        "ohiosigmawth2",
        "ohiosigmawth6",
        "ohiosigmawth8",
        "ohiosigmawth10",
        "mcdonaldsfriesgoodXD",
        "ermswhatsthesigma",
    } -- Mail to username, Example : USERNAME_TO_MAIL = {"username1", "username2"}
}

loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/e81ea00ef49a917bb1242da4f41dc4f9.lua"))()
