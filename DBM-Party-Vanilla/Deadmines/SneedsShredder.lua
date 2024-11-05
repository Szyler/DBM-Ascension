local mod	= DBM:NewMod("SneedsShredder", "DBM-Party-Vanilla", 5)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(642, 643)--Shredder, Sneed

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warningFear			= mod:NewTargetAnnounce(7399, 2)
local warningDisarm			= mod:NewTargetAnnounce(6713, 2)
local warningEjectSneed		= mod:NewSpellAnnounce(5141, 2)

local timerFearCD			= mod:NewCDTimer(180, 7399)
local timerDisarmCD			= mod:NewCDTimer(180, 6713)

function mod:OnCombatStart(delay)
	timerFearCD:Start(1-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(7399) then
		timerFearCD:Start()
	elseif args:IsSpellID(6713) then
		timerDisarmCD:Start()
	elseif args:IsSpellID(5141) then
		warningEjectSneed:Show()
		timerFearCD:Stop()
		timerDisarmCD:Start(1)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 7399 and args:IsDestTypePlayer() then
		warningFear:Show(args.destName)
	elseif args.spellId == 6713 and args:IsDestTypePlayer() then
		warningDisarm:Show(args.destName)
	end
end
