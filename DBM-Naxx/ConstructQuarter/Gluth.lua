local mod	= DBM:NewMod("Gluth", "DBM-Naxx", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2869 $"):sub(12, -3))
mod:SetCreatureID(15932)
mod:RegisterCombat("combat")
mod:EnableModel()
mod:RegisterEvents(
	"SPELL_DAMAGE",
	"PLAYER_ALIVE"
)

-----DECIMATE-----
local warnDecimateSoon	= mod:NewSoonAnnounce(54426, 2)
local warnDecimateNow	= mod:NewSpellAnnounce(54426, 3)
local timerDecimate		= mod:NewNextTimer(120, 54426)
-----MISC-----
local enrageTimer		= mod:NewBerserkTimer(480)

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	enrageTimer:Start(480 - delay)
	timerDecimate:Start(120 - delay)
	warnDecimateSoon:Schedule(115 - delay)
end

local decimateSpam = 0
function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(28375) and (GetTime() - decimateSpam) > 20 then
		decimateSpam = GetTime()
		warnDecimateNow:Show()
		timerDecimate:Start()
		warnDecimateSoon:Schedule(115)
	end
end