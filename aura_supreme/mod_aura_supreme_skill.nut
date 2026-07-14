::logInfo("[AuraSupreme] Loading Persistent Skill Asset Definition...");

::AuraSupreme.Skill <- ::inherit("scripts/skills/skill", {
    m = {
        IsUsed = false
    },
    function create()
    {
        this.m.ID = "active.aura_supreme";
        this.m.Name = "Aura Supreme";
        this.m.Description = "Unleash a terrifying presence that completely shatters the morale of all enemies around you, sending them into an absolute rout.";
        this.m.Icon = "skills/aura_supreme_icon.png";
        this.m.IconDisabled = "skills/aura_supreme_icon_sw.png";
        this.m.Overlay = "aura_supreme_icon";
        this.m.SoundOnUse = [
            "sounds/combat/indomitable_01.wav"
        ];
        this.m.Type = this.Const.SkillType.Active;
        this.m.Order = this.Const.SkillOrder.Any;
        this.m.IsActive = true;
        this.m.IsTargeted = false;
        this.m.IsAttack = false;
        this.m.ActionPointCost = 4;
        this.m.FatigueCost = 20;
        this.m.MinRange = 0;
        this.m.MaxRange = 0;
    }

    // FIXED: Prevents world map UI inventory screen breakages by safely hiding the combat skill when out of tactical mode
    function isHidden()
    {
        if (::Tactical.isActive())
        {
            return false;
        }
        return true;
    }

    function isUsable()
    {
        local restrictOnce = ::AuraSupreme.Mod.ModSettings.getSetting("IsOncePerBattle").getValue();
        if (restrictOnce && this.m.IsUsed)
        {
            return false;
        }
        return this.skill.isUsable();
    }

    function onCombatStarted()
    {
        this.m.IsUsed = false;
    }

    function onUse( _user, _targetTile )
    {
        this.m.IsUsed = true;
        local myTile = _user.getTile();
        local radius = ::AuraSupreme.Mod.ModSettings.getSetting("AuraRadius").getValue();
        local factions = _user.getFaction();

        ::logInfo("[AuraSupreme] Skill Triggered by " + _user.getName() + ". Scanning radius: " + radius + " tiles.");

        for( local i = 1; i <= radius; i = ++i )
        {
            local nearbyTiles = this.Tactical.getTilesInRange(myTile, i, i);
            foreach( tile in nearbyTiles )
            {
                if (!tile.IsOccupiedByActor)
                {
                    continue;
                }

                local target = tile.getEntity();

                if (target.getFaction() != factions && !target.isAlliedWith(_user))
                {
                    target.setMoraleState(this.Const.MoraleState.Fleeing);
                    this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " breaks completely from the Supreme Aura!");
                    this.spawnIcon("status_effect_04", tile);
                }
            }
        }
        return true;
    }
});