local mod	= DBM:NewMod("Kalithresh", "DBM-Party-BC", 6)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 128 $"):sub(12, -3))
mod:SetCreatureID(17798)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local WarnChannel   			= mod:NewAnnounce("Kill Distiller")
local WarnReflect   			= mod:NewSpellAnnounce(31534)
local timerReflect  			= mod:NewBuffActiveTimer(8, 31534)
local timerNextReflect			= mod:NewNextTimer(20, 31534)
local WarnImpale   				= mod:NewSpellAnnounce(839061)
local timerImpale  				= mod:NewBuffActiveTimer(12, 839061)
local timerNextImpale			= mod:NewNextTimer(60, 839061)
local WarnCrack   				= mod:NewSpellAnnounce(16172)
local timerCrack  				= mod:NewBuffActiveTimer(12, 16172)
local timerNextCrack			= mod:NewNextTimer(60, 16172)
local timerNextDistiller		= mod:NewNextTimer(30, 31543)

function mod:OnCombatStart(delay)
	timerNextDistiller:Start(15-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(31543) then
		WarnChannel:Show()
		timerNextDistiller:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(31534) then
		WarnReflect:Show(args.destName)
		timerReflect:Start(args.destName)
		timerNextReflect:Start()
	elseif args:IsSpellID(839061) then
		WarnImpale:Show(args.destName)
		timerImpale:Start(args.destName)
		timerNextImpale:Start()
	elseif args:IsSpellID(16172) then
		WarnCrack:Show(args.destName)
		timerCrack:Start(args.destName)
		timerNextCrack:Start()
	end
end

-- function IsleOfConquest:UNIT_DIED(args)
-- 	local cid = self:GetCIDFromGUID(args.destGUID)
-- 	if cid == 17954 then
-- 		timerNextDistiller:Start()
-- 	end
-- end

-- 839061 - Impale
-- 16172 - Head Crack