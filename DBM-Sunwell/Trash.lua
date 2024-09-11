local mod	= DBM:NewMod("Trash", "DBM-Sunwell")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5021 $"):sub(12, -3))
mod:SetCreatureID(25507)
mod:RegisterCombat("combat", 25507)

mod:RegisterEventsInCombat(
"SPELL_CAST_START"
)

-- Fel Chain Lightning (2145224)
-- Chain Lightning (2145227)
-- Electro-Magnetic Pulse (2145228)

local castChainLightning           mod: NewCastTimer(2145227)
local warnChainLightning           mod: NewTimer(4, "Chain Lightning on %s", 2145227)
local specWarnChainLightning       mod: NewSpecialWarning("Chain Lightning on >YOU<", 2145227)
local timerChainLightning          mod: NewNextTimer(10, 2145227)

local castFelLightning             mod: NewCastTimer(2145224)
local warnFelLightning             mod: NewTimer(4, "Fel Chain Lightning on %s", 2145224)
local specWarnFelLightning         mod: NewSpecialWarning("Fel Chain Lightning on >YOU<", 2145224)
local timerFelLightning            mod: NewNextTimer(10, 2145224)

local castEMP                      mod: NewCastTimer(6, 2145228)
local warnEMP                      mod: NewSpellAnnounce(2145228)
local timerEMP                     mod: NewNextTimer(45, 2145228)

function mod:ChainLightning()
	local targetCL = mod:GetBossTarget(25507) or mod:GetBossTarget(25507)
	if targetCL == UnitName("player") then
		specWarnChainLightning:Show()
		SendChatMessage("Chain Lightning on "..UnitName("PLAYER").."!", "Say")
	else
		warnChainLightning:Show(targetCL)
	end
	castChainLightning:Start(targetCL)
    
	self:SetIcon(targetCL, 6, 4)
end

function mod:FelLightning()
	local targetFL = mod:GetBossTarget(25507) or mod:GetBossTarget(25507)
	if targetFL == UnitName("player") then
		specWarnFelLightning:Show()
		SendChatMessage("Chain Lightning on "..UnitName("PLAYER").."!", "Say")
	else
		warnFelLightning:Show(targetFL)
	end
	castFelLightning:Start(targetFL)
    
	self:SetIcon(targetFL, 6, 4)
end

function mod:SPELL_CAST_START(args)
    if args.sourceName == "Sunwell Protector" and args:IsSpellID(2145224) then
        self:ScheduleMethod(0.2, "FelLightning")
        timerFelLightning:start()
    elseif args.sourceName == "Sunwell Protector" and args:IsSpellID(2145227) then
        self:ScheduleMethod(0.2, "ChainLightning")
        timerChainLightning:Start()
    elseif args.sourceName == "Sunwell Protector" and args:IsSpellID(2145228) then
        castEMP:Start()
        warnEMP:Show()
        timerEMP:Start()
    end
end
