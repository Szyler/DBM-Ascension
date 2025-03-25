local mod	= DBM:NewMod("Attumen", "DBM-Karazhan")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(15550, 16151)
mod:RegisterCombat("combat", 15550)
mod:RegisterKill("yell", L.KillAttumen)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"CHAT_MSG_MONSTER_YELL",
	"SPELL_CAST_SUCCESS",
	"SPELL_SUMMON"
)

local warnPhase2			= mod:NewPhaseAnnounce(2)
local warningCurseSoon		= mod:NewSoonAnnounce(2130500, 2)
local warningCurse			= mod:NewSpellAnnounce(2130500, 3)
local warnCharge			= mod:NewTargetAnnounce(2130504, 3)
local warnAttumen			= mod:NewSpellAnnounce(29714, 3)
local warnSunder			= mod:NewAnnounce(L.AttSunder, 2, 2130505)
local warnFireball			= mod:NewTargetAnnounce(2130506, 2)  -- heroic

local timerCurse			= mod:NewNextTimer(30, 2130500)
local timerChargeCD			= mod:NewCDTimer(28, 2130504)
local timerFireball			= mod:NewCDTimer(12, 2130506)   -- heroic

local Phase	= 1
local lastCurse = 0

function mod:OnCombatStart(delay)
	Phase = 1
	self.vb.phase = 1
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2130500, 2130501, 2130502, 2130503) then
		warningCurse:Show()
	elseif args:IsSpellID(2130505) then
		warnSunder:Show(args.spellName, args.destName, args.amount or 1)
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(2130505) then
		warnSunder:Show(args.spellName, args.destName, args.amount or 1)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2130500, 2130501, 2130502, 2130503) then     
		warningCurse:Show()
		timerCurse:Start()
	elseif args:IsSpellID(2130504) then
		timerChargeCD:Start()
		warnCharge:Show(args.destName)
	elseif args:IsSpellID(2130506, 2130507, 2130508, 2130509) then   -- heroic
		warnFireball:Show(args.destName)
		timerFireball:Show()
	end
end

function mod:SPELL_SUMMON(args)
	if args:IsSpellID(29799) then
		Phase = 2
		self.vb.phase = 2
		warnPhase2:Show()
		timerChargeCD:Start()
	elseif args:IsSpellID(29714) then
		warnAttumen:Show()
	end
end
		

