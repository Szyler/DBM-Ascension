local mod	= DBM:NewMod("Fathomlord", "DBM-Serpentshrine")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(21214)
mod:RegisterCombat("combat", 21214)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_START",
	"SPELL_SUMMON"
)

local warnCariPower		= mod:NewSpellAnnounce(38451, 3)
local warnTidalPower	= mod:NewSpellAnnounce(38452, 3)
local warnSharPower		= mod:NewSpellAnnounce(38455, 3)

local specWarnHeal		= mod:NewSpellAnnounce(38330, 3)
local specWarnTotem		= mod:NewSpecialWarning("Kill totem?")

local berserkTimer		= mod:NewBerserkTimer(600)

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 38451 then
		warnCariPower:Show()
	elseif args.spellId == 38452 then
		warnTidalPower:Show()
	elseif args.spellId == 38455 then
		warnSharPower:Show()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 38330 then
		specWarnHeal:Show(args.sourceName)
	end
end

function mod:SPELL_SUMMON(args)
	if args.spellId == 38236 then
		specWarnTotem:Show()
		specWarnTotem:Play("attacktotem")
	end
end
