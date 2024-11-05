local mod	= DBM:NewMod("WolfMasterNandos", "DBM-Party-Vanilla", 14)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(3927)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START"
)

local warningBleakWorg		= mod:NewSpellAnnounce(7487, 2)
local warningLupineHorror	= mod:NewSpellAnnounce(7489, 2)
local warningSlaveringWorg	= mod:NewSpellAnnounce(7488, 2)

local timerBleakWorgCD		= mod:NewCDTimer(180, 7487)
local timerLupineHorrorCD	= mod:NewCDTimer(180, 7489)
local timerSlaveringWorgCD	= mod:NewCDTimer(180, 7488)

function mod:OnCombatStart(delay)
	timerBleakWorgCD:Start(1-delay)
	timerLupineHorrorCD:Start(1-delay)
	timerSlaveringWorgCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(7487) then
		warningBleakWorg:Show()
		timerBleakWorgCD:Start()
	elseif args:IsSpellID(7489) then
		warningLupineHorror:Show()
		timerLupineHorrorCD:Start()
	elseif args:IsSpellID(7488) then
		warningSlaveringWorg:Show()
		timerSlaveringWorgCD:Start()
	end
end
