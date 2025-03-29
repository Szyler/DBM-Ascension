local mod	= DBM:NewMod("Nightbane", "DBM-Karazhan")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 176 $"):sub(12, -3))
mod:SetCreatureID(17225)
--mod:RegisterCombat("yell", L.DBM_NB_YELL_PULL)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"CHAT_MSG_MONSTER_YELL",
	"CHAT_MSG_MONSTER_EMOTE",
	"SPELL_AURA_APPLIED_DOSE"
)

local warningBone			= mod:NewSpellAnnounce(37098, 3)
local warningFearSoon		= mod:NewSoonAnnounce(2130900, 2)
local warningFear			= mod:NewSpellAnnounce(2130900, 3)
local WarnAir				= mod:NewAnnounce("DBM_NB_AIR_WARN", 2, "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp")
local WarnNBDown1			= mod:NewAnnounce("DBM_NB_DOWN_WARN", 2, nil, nil, false)
local WarnNBDown2			= mod:NewAnnounce("DBM_NB_DOWN_WARN2", 3, nil, nil, false)
local warnCharred			= mod:NewSpellAnnounce(2130901, 2)
local warnFinalHour			= mod:NewSpellAnnounce(2130920, 2)
local warnBreath			= mod:NewAnnounce(L.SmolderingBreath, 3, 2130925)

local specWarnCharred		= mod:NewSpecialWarningMove(2130901)

local timerNightbane		= mod:NewTimer(34, "timerNightbane", "Interface\\Icons\\Ability_Mount_Undeadhorse")
local timerAirPhase			= mod:NewTimer(50, "timerAirPhase", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp")
local timerFearCD			= mod:NewNextTimer(40, 2130900)
local timerFear				= mod:NewCastTimer(2, 2130900)
local timerCharred			= mod:NewNextTimer(30, 2130901)
local timerNextFinalHour	= mod:NewNextTimer(10, 2130901)
local timerFinalHour		= mod:NewBuffActiveTimer(60, 2130920, 60)

mod:AddBoolOption("PrewarnGroundPhase", true, "announce")

function mod:OnCombatStart(delay)
	timerNextFinalHour:Start(10-delay)
	timerCharred:Start(15-delay)
	timerFear:Start(40-delay)
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L.DBM_NB_EMOTE_PULL then
		timerNightbane:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2130900) then
		warningFearSoon:Cancel()
		warningFear:Show()
		timerFear:Start()
		timerFearCD:Start()
		warningFearSoon:Schedule(35)
	end
end

-- function mod:SPELL_CAST_SUCCESS(args)
-- 	if args:IsSpellID(2130906) then
-- 		warningBone:Show()
-- 	end
-- end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2130901, 2130902, 2130903, 2130904) and args:IsPlayer() then
		specWarnCharred:Show()
	elseif args:IsSpellID(2130920) then
		timerFinalHour:Start(args.destName)
		if DBM:AntiSpam(2) then
			warnFinalHour:Show()
		end
	elseif args:IsSpellID(2130925, 2130926, 2130927, 2130928) then
		warnBreath:Show("Smoldering Breath", args.destName, args.amount or 1)
	elseif args:IsSpellID(2130906, 2130907, 2130908, 2130909) and DBM:AntiSpam() then
		warningBone:Show()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(2130920) then
		timerFinalHour:Cancel(args.destName)
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(2130925, 2130926, 2130927, 2130928) then
		warnBreath:Show("Smoldering Breath", args.destName, args.amount or 1)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.DBM_NB_YELL_AIR then
		WarnAir:Show()
		timerAirPhase:Start()
		timerCharred:Stop()
		timerFear:Stop()
		timerFearCD:Stop()
		warningFearSoon:Cancel()
		if self.Options.PrewarnGroundPhase then
			WarnNBDown1:Cancel()
			WarnNBDown2:Cancel()
			WarnNBDown1:Schedule(36)
			WarnNBDown2:Schedule(46)
		end
	elseif msg == L.DBM_NB_YELL_GROUND or msg == L.DBM_NB_YELL_GROUND2 then
		timerCharred:Start(27)
		timerFearCD:Start(48)
	end
end
