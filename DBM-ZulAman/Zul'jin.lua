local mod	= DBM:NewMod("ZulJin", "DBM-ZulAman")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5015 $"):sub(12, -3))
mod:SetCreatureID(23863)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_SUCCESS",
	"SPELL_DAMAGE",
	"CHAT_MSG_MONSTER_YELL"
)

local warnThrow					= mod:NewTargetAnnounce(43093, 3)
local warnClaw					= mod:NewTargetAnnounce(2136377, 3) --2136377, 2136378, 2136379, 2136380, 2136381
local warnFlame					= mod:NewSpellAnnounce(2135908, 3) --2135908, 2135909, 2135910, 2135911, 2135912
		
local warnPhase1				= mod:NewPhaseAnnounce(1)
local warnPhase2				= mod:NewPhaseAnnounce(2)
local warnPhase3				= mod:NewPhaseAnnounce(3)
local warnPhase4				= mod:NewPhaseAnnounce(4)

local warnPhaseBerserk			= mod:NewPhaseAnnounce(5) --2136318, 2136319


local warnPhaseEagle			= mod:NewSpecialWarningSpell(2136336) --2136336, Shape of the Bear, ASC D0 T5
local timerNextTurbulentWinds	= mod:NewNextTimer(15, 2136342) --2136342, 2136343, 2136344, 2136345, 2136346
local timerCastTurbulentWinds	= mod:NewCastTimer(5, 2136343) --2136342, 2136343, 2136344, 2136345, 2136346


local warnPhaseBear				= mod:NewSpecialWarningSpell(2136337) --2136337, Shape of the Eagle, ASC D0 T5
local timerNextDeafeningRoar	= mod:NewNextTimer(15, 2135829) --2135829, 2135830, 2135831, 2135832


local warnPhaseDragonhawk		= mod:NewSpecialWarningSpell(2136357) --2136357, Shape of the Dragonhawk, ASC D0 T5
local timerNextScorchingBreath	= mod:NewNextTimer(26, 2136358) --2136358, 2136359, 2136360, 2136361, 2136362
local timerNextArmageddon		= mod:NewNextTimer(23, 2136372) --2136372, 2136373, 2136374, 2136375


local warnPhaseLynx				= mod:NewSpecialWarningSpell(2136376) --2136376, Shape of the Lynx, ASC D0 T5

		
local timerNextGrievous			= mod:NewNextTimer(10, 2136300) --2136301, 2136302, 2136303
local timerNextWhirlwind		= mod:NewNextTimer(45, 2136316) --2136316, Whirlwind
local timerNextImpale			= mod:NewNextTimer(45, 2136304) --2136304, 2136305, 2136306, 2136307, 2136308, 2136309

mod.vb.phase = 1


function mod:PhaseIncrease()
	self.vb.phase = self.vb.phase + 1

	if self.vb.phase == 2 then
		warnPhase2:Show()
	elseif self.vb.phase == 3 then
		warnPhase3:Show()
	elseif self.vb.phase == 4 then
		warnPhase4:Show()
	end
end

function mod:OnCombatStart(delay)
	self.vb.phase = 1
	timerNextGrievous:Start(4)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2136301) then
		warnThrow:Show(args.destName)
	elseif args:IsSpellID(2136378) then
		warnClaw:Show(args.destName)
	elseif args:IsSpellID(2135909) then
		warnFlame:Show()
	elseif args:IsSpellID(2136318, 2136319) then
		warnPhaseBerserk:Show()
		self.vb.phase = 5
		timerNextGrievous:Start(7)
		timerNextImpale:Start(15)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2136336) then
		warnPhaseEagle:Start()
		timerNextTurbulentWinds:Start()
		self:PhaseIncrease()
	elseif args:IsSpellID(2136337) then
		warnPhaseBear:Start()
		timerNextDeafeningRoar:Start(8)
		self:PhaseIncrease()
	elseif args:IsSpellID(2136357) then
		warnPhaseDragonhawk:Start()
		timerNextScorchingBreath:Start()
		timerNextArmageddon:Start()
		self:PhaseIncrease()
	elseif args:IsSpellID(2136376) then
		warnPhaseLynx:Start()
		self:PhaseIncrease()
	elseif args:IsSpellID(2136316) then
		timerNextWhirlwind:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2136342) then
		timerNextTurbulentWinds:Start()
		timerCastTurbulentWinds:Start()
		--Turbulent winds targeting function here
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(2136301, 2136302, 2136303) then
		timerNextGrievous:Start()
	elseif args:IsSpellID(2135829, 2135830, 2135831, 2135832) then
		timerNextDeafeningRoar:Start()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellPhase2 or msg:find(L.YellPhase2) then
		warnPhase2:Show()
		self.vb.phase = 2
	elseif msg == L.YellPhase3 or msg:find(L.YellPhase3) then
		warnPhase3:Show()
		self.vb.phase = 3
	elseif msg == L.YellPhase4 or msg:find(L.YellPhase4) then
		warnPhase4:Show()
		self.vb.phase = 4
	elseif msg == L.YellPhase5 or msg:find(L.YellPhase5) then
		warnPhase5:Show()
		self.vb.phase = 5
	end
end
