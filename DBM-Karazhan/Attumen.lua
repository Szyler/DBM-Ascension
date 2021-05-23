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
local warningCurseSoon		= mod:NewSoonAnnounce(85154, 2)
local warningCurse			= mod:NewSpellAnnounce(85154, 3)
local warnCharge			= mod:NewTargetAnnounce(85157, 3)
local warnAttumen			= mod:NewSpellAnnounce(29714, 3)
local warnSunder			= mod:NewAnnounce(L.AttSunder, 2, 85178)
local warnFireball			= mod:NewTargetAnnounce(85209, 2)  -- heroic

local timerCurse			= mod:NewNextTimer(30, 85154)
local timerChargeCD			= mod:NewCDTimer(28, 85157)
local timerFireball			= mod:NewCDTimer(12, 85209)   -- heroic

local Phase	= 1
local lastCurse = 0

function mod:OnCombatStart(delay)
	Phase = 1
	self.vb.phase = 1
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(43127, 29833) then
		warningCurse:Show()
	elseif args:IsSpellID(85178) then
		warnSunder:Show(args.spellName, args.destName, args.amount or 1)
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(85178) then
		warnSunder:Show(args.spellName, args.destName, args.amount or 1)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(85154, 85155, 85156) then     
		warningCurse:Show()
		timerCurse:Start()
	elseif args:IsSpellID(85157, 85158, 85159) then -- 3 different spell IDs? why Ascension?
		timerChargeCD:Start()
		warnCharge:Show(args.destName)
	elseif args:IsSpellID(85209) then   -- heroic
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
		

