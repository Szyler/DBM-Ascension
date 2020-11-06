local mod	= DBM:NewMod("Attumen", "DBM-Karazhan")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(15550, 16151)
mod:RegisterCombat("combat", 15550)
mod:RegisterKill("yell", L.KillAttumen)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"CHAT_MSG_MONSTER_YELL",
	"SPELL_CAST_SUCCESS",
	"SPELL_SUMMON"
)

local warnPhase2			= mod:NewPhaseAnnounce(2)
local warningCurseSoon		= mod:NewSoonAnnounce(85154, 2)
local warningCurse			= mod:NewSpellAnnounce(85154, 3)
local warnCharge			= mod:NewTargetAnnounce(85157, 3)

local timerCurseCD			= mod:NewNextTimer(31, 85154)
local timerChargeCD			= mod:NewCDTimer(28, 85157)

local Phase	= 1
local lastCurse = 0

function mod:OnCombatStart(delay)
	Phase = 1
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(43127, 29833) then
		warningCurse:Show()
	end
end


function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(85154) then
		warningCurse:Show()
	elseif args:IsSpellID(85154) then
		timerChargeCD:Start()
		warnCharge:Show(args.destName)
	end
end

function mod:SPELL_SUMMON(args)
	if args:IsSpellID(29799) then
		Phase = 2
		warnPhase2:Show()
		timerChargeCD:Start()
	end
end
		

