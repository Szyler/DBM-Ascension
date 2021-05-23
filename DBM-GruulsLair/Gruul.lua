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
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS"
)

local warnShatter		= mod:NewSpellAnnounce(33525, 3)
local specWarnCave		= mod:NewSpecialWarningYou(36240)
local warnGrow			= mod:NewSpellAnnounce(36300, 3)
local warnSilence		= mod:NewSpellAnnounce(36297, 2)
local warnBoulder		= mod:NewAnnounce("Giant Boulder soon", 3, "Interface\\Icons\\inv_stone_10")

local timerNextSlam		= mod:NewNextTimer(110, 33525)
local timerShatter		= mod:NewTimer(10, "Shatter", "Interface\\Icons\\Spell_Nature_ThunderClap")
local timerSilence		= mod:NewCDTimer(15, 36297)
local timerMaybeSilence	= mod:NewTimer(10, "Incoming Silence", "Interface\\Icons\\Spell_Holy_ImprovedResistanceAuras", false, "Show the cast window of $spell:36297 as a bar timer")
local timerBoulder		= mod:NewTimer(24, "Giant Boulder CD", "Interface\\Icons\\inv_stone_10")
local timerCaveIn		= mod:NewTimer(24, "Cave In CD", "Interface\\Icons\\INV_Ammo_Bullet_02")

local timerNextHateful		= mod:NewNextTimer(6, 33813, nil, false)--, mod:IsTank() or mod:IsHealer())
local timerNextHatefulAscended	= mod:NewNextTimer(3, 33813, nil, false)--, mod:IsTank() or mod:IsHealer())

-- grow timer placed here because DBM hates me
local Grow				= 1;
local timerGrow			= mod:NewTimer(24, "Grow #%s", 36300)

local BoulderCD			= 24;
local CaveInCD			= 24;

mod:AddBoolOption(L.CaveinYellOpt)
mod:AddBoolOption(L.SilenceWindow, false)

function mod:OnCombatStart(delay)
	Grow = 1
	BoulderCD = 24
	CaveInCD = 24
	timerNextSlam:Start(90-delay)
	timerSilence:Start(115-delay)
	timerBoulder:Start(115-delay)
	timerCaveIn:Start(-delay)
	timerGrow:Start(-delay, tostring(Grow))
	DBM.RangeCheck:Show(15)
end

function mod:SilenceWindow()
	timerMaybeSilence:Start()
end

function mod:OnCombatEnd()
	DBM.RangeCheck:Hide()
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(36300) then
		Grow = Grow + 1;
		warnGrow:Show()
		timerGrow:Start(24, tostring(Grow))
	elseif args:IsSpellID(36240, 85376) and args:IsPlayer() then
		specWarnCave:Show()
		if self.Options.CaveinYellOpt then
			SendChatMessage(L.CaveinYell, "YELL")
		end
	elseif args:IsSpellID(36297) and args:IsPlayer() then
		warnSilence:Show()
		timerSilence:Start()		
		timerMaybeSilence:Cancel()
		if self.Options.SilenceWindow then
			self:ScheduleMethod(15,"SilenceWindow");
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(36300) then
		Grow = Grow + 1;
		warnGrow:Show()
		timerGrow:Start(24, tostring(Grow))
	elseif args:IsSpellID(36240, 85376) and args:IsPlayer() then
		specWarnCave:Show()
		if self.Options.CaveinYellOpt then
			SendChatMessage(L.CaveinYell, "YELL")
		end
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

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(85376, 36240, 351074) then
		CaveInCD = CaveInCD - 1
		timerCaveIn:Start(CaveInCD)
		if CaveInCD < 4 then	-- Cave In CD is capped at 4 seconds, it does not decay below that.
			CaveInCD = 4
		end
	elseif args:IsSpellID(33813) then
		-----Hateful Strike-----
		if mod:IsDifficulty("heroic10", "heroic25") then
			timerNextHatefulAscended:Start()
		else
			timerNextHateful:Start()
		end
	end
end