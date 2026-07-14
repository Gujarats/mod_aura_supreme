::logInfo("[AuraSupreme] Injecting world map roster monitoring systems...");

local mod = ::AuraSupreme.HookMod;

mod.hook("scripts/states/world_state", function(q)
{
    // Hook into the initialization/loading phase of the world map screen
    q.onInit = @(__original) function()
    {
        __original();

        ::logInfo("[AuraSupreme] World map state initialized. Scanning player roster...");

        local roster = ::World.getPlayerRoster().getAll();
        foreach (bro in roster)
        {
            local characterLevel = bro.getLevel();

            // Check if they meet your level 7 requirement
            if (characterLevel >= 7)
            {
                if (!bro.getSkills().hasSkill("active.aura_supreme"))
                {
                    // Clean instantiation via class reference we fixed earlier
                    bro.getSkills().add(::new("aura_supreme/mod_aura_supreme_skill"));
                    ::logInfo("[AuraSupreme] Permanently bound Supreme Aura to roster unit: " + bro.getName());
                }
            }
        }
    };
});