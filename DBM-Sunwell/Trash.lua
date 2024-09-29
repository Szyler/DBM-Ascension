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

local castChainLightning          = mod:NewCastTimer(4, 2145227)
local warnChainLightning          = mod:NewTargetAnnounce(4, 2145227)
local specWarnChainLightning      = mod:NewSpecialWarningYou(2145227)
local timerChainLightning         = mod:NewCDTimer(10, 2145227)

local castFelLightning            = mod:NewCastTimer(4, 2145224)
local warnFelLightning            = mod:NewTargetAnnounce(4, 2145224)
local specWarnFelLightning        = mod:NewSpecialWarningYou(2145224)
local timerFelLightning           = mod:NewCDTimer(10, 2145224)

local castEMP                     = mod:NewCastTimer(6, 2145228)
local warnEMP                     = mod:NewSpellAnnounce(2145228)
local timerEMP                    = mod:NewNextTimer(45, 2145228)

function mod:ChainLightning()
	local targetCL = mod:GetBossTarget(25507)
	if targetCL == UnitName("player") then
		specWarnChainLightning:Show()
		SendChatMessage("Chain Lightning on "..UnitName("PLAYER").."!", "Say")
	else
		warnChainLightning:Show(targetCL)
	end
	castChainLightning:Start()
	self:SetIcon(targetCL, 6, 4)
end

function mod:FelLightning()
	local targetFL = mod:GetBossTarget(25507)
	if targetFL == UnitName("player") then
		specWarnFelLightning:Show()
		SendChatMessage("Chain Lightning on "..UnitName("PLAYER").."!", "Say")
	else
		warnFelLightning:Show(targetFL)
	end
	castFelLightning:Start()
	self:SetIcon(targetFL, 6, 4)
end

function mod:SPELL_CAST_START(args)
    if args:IsSpellID(2145224) and args.sourceName == "Sunwell Protector" then
        self:ScheduleMethod(0.2, "FelLightning")
        timerFelLightning:Start()
    elseif args:IsSpellID(2145227) and args.sourceName == "Sunwell Protector" then
        self:ScheduleMethod(0.2, "ChainLightning")
        timerChainLightning:Start()
    elseif args:IsSpellID(2145228) and args.sourceName == "Sunwell Protector" then
        castEMP:Start()
        warnEMP:Show()
        timerEMP:Start()
    end
end

function mod:onCombatEnd()
    timerEMP:Cancel()
    timerChainLightning:Cancel()
    timerFelLightning:Cancel()
end