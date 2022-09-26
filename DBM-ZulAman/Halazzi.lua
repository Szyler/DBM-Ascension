local mod	= DBM:NewMod("Halazzi", "DBM-ZulAman")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("$Revision: 5015 $"):sub(12, -3)
mod:SetCreatureID(23577)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_SUMMON",
	"CHAT_MSG_MONSTER_YELL"
)

local warnShock			= mod:NewTargetAnnounce(43303, 3)
local warnEnrage		= mod:NewSpellAnnounce(43139, 3)
local warnFrenzy		= mod:NewSpellAnnounce(43290, 3)
local warnSpirit		= mod:NewAnnounce("WarnSpirit", 4, 39414)
local warnNormal		= mod:NewAnnounce("WarnNormal", 4, 39414)

local specWarnTotem		= mod:NewSpellAnnounce(43302)
local specWarnEnrage	= mod:NewSpecialWarningDispel(43139)

local timerShock		= mod:NewTargetTimer(12, 43303)

local berserkTimer		= mod:NewBerserkTimer(600)

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(43303) then
		warnShock:Show(args.destName)
		timerShock:Show(args.destName)
	elseif args:IsSpellID(43139) then
		if self.Options.SpecWarn43139dispel then
			specWarnEnrage:Show(args.destName)
		else
			warnEnrage:Show()
		end
	elseif args:IsSpellID(43290) then
		warnFrenzy:Show()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(43303) then
		timerShock:Stop(args.destName)
	end
end

function mod:SPELL_SUMMON(args)
	if args:IsSpellID(43302) then
		specWarnTotem:Show()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellSpirit or msg:find(L.YellSpirit) then
		warnSpirit:Show()
	elseif msg == L.YellNormal or msg:find(L.YellNormal) then
		warnNormal:Show()
	end
end
