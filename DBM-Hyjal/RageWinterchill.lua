local mod	= DBM:NewMod("Rage", "DBM-Hyjal")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(17767)
mod:SetUsedIcons(8)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START"
)

local warnIceBolt		= mod:NewSpellAnnounce(31249, 3)
local warnDnd			= mod:NewSpellAnnounce(31258, 3)

local specWarnIceBolt	= mod:NewSpecialWarningYou(31249)
local specWarnDnD		= mod:NewSpecialWarningGTFO(31258)

local timerDndCD		= mod:NewCDTimer(46, 31258)

local berserkTimer		= mod:NewBerserkTimer(600)

mod:AddBoolOption("IceBoltIcon", false)

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 31249 then
		if args:IsPlayer() then
			specWarnIceBolt:Show()
		else
			warnIceBolt:Show(args.destName)
		end
		if self.Options.IceBoltIcon then
			self:SetIcon(args.destName, 8)
		end
	elseif args.spellId == 31258 and args:IsPlayer() and self:AntiSpam() then
		specWarnDnD:Show(args.spellName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 31249 then
		if self.Options.IceBoltIcon then
			self:SetIcon(args.destName, 0)
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 31258 then
		warnDnd:Show()
		timerDndCD:Start()
	end
end
