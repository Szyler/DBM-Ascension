local mod	= DBM:NewMod("Halazzi", "DBM-ZulAman")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5015 $"):sub(12, -3))
mod:SetCreatureID(23577)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_SUMMON",
	"SPELL_DISPEL",
	"CHAT_MSG_MONSTER_YELL"
)

local warnShock				= mod:NewTargetAnnounce(43303, 3)
local warnEnrage			= mod:NewSpellAnnounce(43139, 3)
local warnFrenzy			= mod:NewSpellAnnounce(43290, 3)
local warnSpirit			= mod:NewAnnounce("WarnSpirit", 4, 39414)
local warnNormal			= mod:NewAnnounce("WarnNormal", 4, 39414)
local warnSplit				= mod:NewSpellAnnounce(2136032, 3)

local specWarnTotem			= mod:NewSpellAnnounce(2136034)
local specWarnEnrage		= mod:NewSpecialWarningDispel(2136001)
--local specWarnSaberStack= mod:NewSpecialWarningStack(2136000, nil, 3)

local timerNextFlameShock	= mod:NewNextTimer(10, 2136002)
local timerNextEarthShock	= mod:NewNextTimer(10, 2136015)
local timerNextFrostShock	= mod:NewNextTimer(10, 2136023)
local timerNextSaber		= mod:NewNextTimer(15, 2136000)
local timerNextCapacitor	= mod:NewNextTimer(20, 2136034)

local berserkTimer			= mod:NewBerserkTimer(600)

local yellFlameShock		= mod:NewFadesYell(2136002)
local yellEarthShock		= mod:NewFadesYell(2136015)
local yellFrostShock		= mod:NewFadesYell(2136023)

mod:AddBoolOption(L.ShockYellOpt)

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	timerNextSaber:Start(13)

end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2136001) then
		if self.Options.SpecWarndispel then
			specWarnEnrage:Show(args.destName)
		else
			warnEnrage:Show()
		end
	elseif args:IsSpellID(43290) then
		warnFrenzy:Show()
	elseif args:IsSpellID(2136000) then
		timerNextSaber:Start()
	elseif args:IsSpellID(2136032) then
		warnSplit:Show()
		timerNextCapacitor:Cancel()
		timerNextFlameShock:Start(4)
		timerNextEarthShock:Start(8)
		timerNextFrostShock:Start(12)
		timerNextSaber:Cancel()
	elseif args:IsSpellID(2136002, 2136003, 2136004, 2136005) then
		timerNextFlameShock:Start()
		if args:IsPlayer() then
			SendChatMessage(L.FlameShockYell, "YELL")
			yellFlameShock:Countdown(12, 3)
		end
	elseif args:IsSpellID(2136015, 2136016, 2136017, 2136018) then
		timerNextEarthShock:Start()
		if args:IsPlayer() then
			SendChatMessage(L.EarthShockYell, "YELL")
			yellEarthShock:Countdown(4, 4)
		end
		
	elseif args:IsSpellID(2136023, 2136024, 2136025, 2136026) then
		timerNextEarthShock:Start()
		if args:IsPlayer() then
			SendChatMessage(L.FrostShockYell, "YELL")
			yellFrostShock:Countdown(5, 3)
		end
	end

end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(2136032) then
		timerNextSaber:Start(14)
		timerNextEarthShock:Cancel()
		timerNextFlameShock:Cancel()
		timerNextFrostShock:Cancel()
	end
	
end

function mod:SPELL_DISPEL(args)
	if args:IsSpellID(2136002, 2136003, 2136004, 2136005) and args:IsPlayer() then
		yellFlameShock:Cancel()
		SendChatMessage("Dispelled by" ..args.sourceName, "YELL")
	elseif args:IsSpellID(2136015, 2136016, 2136017, 2136018) and args:IsPlayer() then
		yellEarthShock:Cancel()
		SendChatMessage("Dispelled by" ..args.sourceName, "YELL")
	elseif args:IsSpellID(2136023, 2136024, 2136025, 2136026) and args:IsPlayer() then
		yellFrostShock:Cancel()
		SendChatMessage("Dispelled by" ..args.sourceName, "YELL")
	end
end

function mod:SPELL_SUMMON(args)
	if args:IsSpellID(2136034) then
		specWarnTotem:Show()
		timerNextCapacitor:Start()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellSpirit or msg:find(L.YellSpirit) then
		warnSpirit:Show()
	elseif msg == L.YellNormal or msg:find(L.YellNormal) then
		warnNormal:Show()
	end
end
