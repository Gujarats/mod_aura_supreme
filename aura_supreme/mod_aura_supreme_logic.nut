local mod = ::AuraSupreme.HookMod;

mod.queue(">mod_msu", function()
{
    if (!("AuraSupremePerk" in ::Const.Perks.PerkDefs))
    {
        ::Const.Perks.PerkDefs.AuraSupremePerk <- "perk.aura_supreme";
        
        local auraPerkStructure = {
            ID = ::Const.Perks.PerkDefs.AuraSupremePerk,
            Name = "Supreme Presence",
            Tooltip = "Unlocks the 'Aura Supreme' active ability, allowing you to instantly break the morale of surrounding enemies.",
            Icon = "ui/perks/aura_supreme_perk.png", 
            IconDisabled = "ui/perks/aura_supreme_perk_sw.png"
        };

        // 3a. Read chosen level row (1-10 mapped to array index 0-9)
        local targetTier = ::AuraSupreme.Mod.ModSettings.getSetting("PerkTierLevel").getValue() - 1;
        
        // Safety bound check just in case arrays look different due to other overhaul mods
        if (targetTier >= 0 && targetTier < ::Const.Perks.UserSkillTree.len())
        {
            ::Const.Perks.UserSkillTree[targetTier].push(auraPerkStructure);
        }
        else
        {
            // Fallback default to Tier 7 (index 6) if row configurations are broken out of bounds
            ::Const.Perks.UserSkillTree[6].push(auraPerkStructure);
        }
    }
});

// Hook into character skill generation updates
mod.hook("scripts/entity/tactical/player", function(q) 
{
    q.onCombatStart = @(__original) function()
    {
        __original();
        
        if (this.getSkills().hasSkill(::Const.Perks.PerkDefs.AuraSupremePerk))
        {
            if (!this.getSkills().hasSkill("active.aura_supreme"))
            {
                this.getSkills().add(::new("mod_aura_supreme_skill"));
            }
        }
    };
});