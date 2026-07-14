::AuraSupreme <- {
    ID = "mod_aura_supreme",
    Version = "1.0.0",
    Name = "Aura Supreme Mod"
};

::logInfo("[AuraSupreme] Early boot phase: Initializing hooks and registry...");

::AuraSupreme.HookMod <- ::Hooks.register(::AuraSupreme.ID, ::AuraSupreme.Version, ::AuraSupreme.Name);
::AuraSupreme.HookMod.require("mod_msu >= 1.9.0");

::AuraSupreme.HookMod.queue(">mod_msu", function()
{
    ::logInfo("[AuraSupreme] MSU detected. Building configuration panels...");

    ::AuraSupreme.Mod <- ::MSU.Class.Mod(::AuraSupreme.ID, ::AuraSupreme.Version, ::AuraSupreme.Name);
    local page = ::AuraSupreme.Mod.ModSettings.addPage("General");

    page.addBooleanSetting(
        "IsOncePerBattle",
        true,
        "Once Per Battle Restriction",
        "If checked, the active skill can only be cast a single time per combat encounter."
    );

    page.addRangeSetting(
        "AuraRadius",
        3, 1, 3, 1,
        "Aura Effect Radius (Tiles)",
        "Adjust how many tiles away (1-3) the routing aura will impact enemies."
    );

    ::logInfo("[AuraSupreme] Menu options initialized dynamically!");

    // ::include("aura_supreme/mod_aura_supreme_skill");
    ::include("aura_supreme/mod_aura_supreme_logic");
});

