local mod	= DBM:NewMod("Arynyes", "DBM-Sunwell")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5021 $"):sub(12, -3))
mod:SetCreatureID(1000000)
mod:SetUsedIcons()

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_MISSED",
	"UNIT_DIED"
)

local warnMeteor		= mod:NewSpellAnnounce(45150, 3)
local warnBurn			= mod:NewTargetAnnounce(46394, 3)
local warnStomp			= mod:NewTargetAnnounce(45185, 3)

local timerMeteorCD		= mod:NewCDTimer(10, 45150)
local timerBurn			= mod:NewTargetTimer(59, 46394)

local berserkTimer		= mod:NewBerserkTimer(360)


function mod:OnCombatStart(delay)

end

function mod:OnCombatEnd()

end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 46394 then
		warnBurn:Show(args.destName)
		
	elseif args.spellId == 45185 then
		warnStomp:Show(args.destName)
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 46394 then
		if self.Options.BurnIcon then
			self:SetIcon(args.destName, 0)
		end
		timerBurn:Cancel(args.destName)
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 45150 then
		warnMeteor:Show()
		timerMeteorCD:Start()
	end
end

function mod:SPELL_MISSED(args)
	if args.spellId == 46394 then
		warnBurn:Show("MISSED")
	end
end

function mod:UNIT_DIED(args)
	timerBurn:Cancel(args.destName)
end