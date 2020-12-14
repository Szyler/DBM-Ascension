local mod		= DBM:NewMod("Gruul", "DBM-GruulsLair")
local L			= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 163 $"):sub(12, -3))
mod:SetCreatureID(19044)
--mod:RegisterCombat("yell", DBM_GRUUL_SAY_PULL)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_EMOTE",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"CHAT_MSG_RAID_WARNING",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START"
)

local warnShatter		= mod:NewSpellAnnounce(33525, 3)
local specWarnCave		= mod:NewSpecialWarningYou(36240)
local warnGrow			= mod:NewSpellAnnounce(36300, 3)
local warnSilence		= mod:NewSpellAnnounce(36297, 2)
local warnBoulder		= mod:NewAnnounce("Giant Boulder soon", 3, "Interface\\Icons\\inv_stone_10")

local timerNextSlam		= mod:NewNextTimer(120, 33525)
local timerShatter		= mod:NewTimer(10, "Shatter", "Interface\\Icons\\Spell_Nature_ThunderClap")
local timerSilence		= mod:NewCDTimer(15, 36297) --inconsistent af
local timerBoulder		= mod:NewTimer(30, "Giant Boulder CD", "Interface\\Icons\\inv_stone_10")

-- grow timer placed here because DBM hates me
local Grow				= 1;
local timerGrow			= mod:NewTimer(30, "Grow #%s", 36300)

local BoulderCD			= 31;



function mod:OnCombatStart(delay)
	Grow = 1
	BoulderCD = 31
	timerNextSlam:Start(90-delay)
	timerSilence:Start(115-delay)
	timerBoulder:Start(115-delay)
	timerGrow:Start(-delay, tostring(Grow))
	DBM.RangeCheck:Show(15)
end

function mod:OnCombatEnd()
	DBM.RangeCheck:Hide()
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(36300) then
		Grow = Grow + 1;
		warnGrow:Show()
		timerGrow:Start(30, tostring(Grow))
	elseif args:IsSpellID(36240) and args:IsPlayer() then
		specWarnCave:Show()
	elseif args:IsSpellID(36297) and args:IsPlayer() then
		warnSilence:Show()
		timerSilence:Start()
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(36300) then
		Grow = Grow + 1;
		warnGrow:Show()
		timerGrow:Start(30, tostring(Grow))
	end
end
	
function mod:SPELL_CAST_START(args)
	if args:IsSpellID(33525) then
		warnShatter:Show()
		timerShatter:Start()
	elseif args:IsSpellID(85020) then
		timerNextSlam:Start()
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == DBM_GRUUL_EMOTE_BOULDER then
		BoulderCD = BoulderCD - 1             -- Giant Boulder CD is decaying, starting from 30 seconds after initial one.
		timerBoulder:Start(BoulderCD)
		warnBoulder:Schedule(BoulderCD - 5)
		if BoulderCD < 4 then   -- Giant Boulder CD is capped at 4 seconds, it does not decay below that.
			BoulderCD = 4
		end
	end
end
		