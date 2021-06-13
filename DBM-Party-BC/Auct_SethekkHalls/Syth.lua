local mod = DBM:NewMod("Syth", "DBM-Party-BC", 9)
local L = mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 147 $"):sub(12, -3))

mod:SetCreatureID(18472)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_SUMMON",
	"SPELL_CAST_START"
)

local warnSummon   				= mod:NewAnnounce("SummonElementals", 3, 33539)
local timerCDSummon				= mod:NewCDTimer(25, 31704)
local warnChain		 			= mod:NewSpellAnnounce(15305, 3)
local timerLightningCast		= mod:NewCastTimer(3, 15305)
local timerNextLightning		= mod:NewNextTimer(12, 15305)

local spam = 0
function mod:SPELL_SUMMON(args)
	if args:IsSpellID(33537, 33538, 33539, 33540) and GetTime() - spam > 3 then
		warnSummon:Show()
		spam = GetTime()
		timerCDSummon:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(15305) then
		warnChain:Show()
		timerLightningCast:Start()
		timerNextLightning:Start()
	end
end

-- 15305 - Chain Lightning