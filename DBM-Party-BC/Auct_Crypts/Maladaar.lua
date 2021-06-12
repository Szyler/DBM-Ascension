local mod	= DBM:NewMod("Maladaar", "DBM-Party-BC", 7)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 128 $"):sub(12, -3))
mod:SetCreatureID(18373)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED"
)

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED"
)

local warnRibbon		 		= mod:NewSpellAnnounce(32422, 3)
local timerRibbonCast			= mod:NewCastTimer(1.5, 32422)
local timerNextRibbon			= mod:NewNextTimer(10, 32422)
local timerSoulCast				= mod:NewCastTimer(1.5, 32346)
local timerNextSoul				= mod:NewNextTimer(25, 32346)
local warningSoul				= mod:NewTargetAnnounce(32346, 2)
local warningAvatar				= mod:NewSpellAnnounce(32424, 3)
local timerNextAvatar			= mod:NewNextTimer(45, 32346)

function mod:OnCombatStart(delay)
	timerNextRibbon:Start(5-delay)
	timerNextSoul:Start(50-delay)
	timerNextAvatar:Start(55-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(32424) then
		warningAvatar:Show()
	elseif args.spellId == 32422 then
		warnRibbon:Show()
		timerRibbonCast:Start()
		timerNextRibbon:Start()
	elseif args.spellId == 32346 then
		-- warnSoul:Show()
		timerSoulCast:Start()
		timerNextSoul:Start()
		warningSoul:Show(args.destName)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(32346) then
		warningSoul:Show(args.destName)
	end
end

-- 32422 - Ribbon of Souls
-- 32346 - Stolen Soul