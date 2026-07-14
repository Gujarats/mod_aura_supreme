::AuraSupreme <- {
    ID = "mod_aura_supreme",
    Version = "0.0.1",
    Name = "Aura Supreme Mod"
};

::logInfo("[AuraSupreme] Initializing loader with dynamic menu configuration...");

::AuraSupreme.HookMod <- ::Hooks.register(::AuraSupreme.ID, ::AuraSupreme.Version, ::AuraSupreme.Name);
::AuraSupreme.HookMod.require("mod_msu >= 1.9.0");

::AuraSupreme.HookMod.queue(">mod_msu", function()
{
    ::AuraSupreme.Mod <- ::MSU.Class.Mod(::AuraSupreme.ID, ::AuraSupreme.Version, ::AuraSupreme.Name);
    local page = ::AuraSupreme.Mod.ModSettings.addPage("General");
    
    // 3a. Level Cap for Perk Tier (1-10)
    page.addRangeSetting(
        "PerkTierLevel",
        7, 1, 10, 1,
        "Perk Level Requirement",
        "Adjust which level row (Tier 1-10) the perk appears on. Requires a game restart to visually move rows."
    );

    // 3b. Once Per Battle Checkbox Toggle
    page.addBooleanSetting(
        "IsOncePerBattle",
        true,
        "Once Per Battle Restriction",
        "If checked, the active skill can only be cast a single time per combat encounter."
    );

    // 3c. Dynamic distance radius slider (1-3)
    page.addRangeSetting(
        "AuraRadius",
        3, 1, 3, 1,
        "Aura Effect Radius (Tiles)",
        "Adjust how many tiles away (1-3) the routing aura will impact enemies."
    );

    ::logInfo("[AuraSupreme] Menu options initialized dynamically!");
    
    ::include("aura_supreme/mod_aura_supreme_skill");
    ::include("aura_supreme/mod_aura_supreme_logic");
});