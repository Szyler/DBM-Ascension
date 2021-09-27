local mod	= DBM:NewMod("Tidewalker", "DBM-Serpentshrine")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(21213)
mod:RegisterCombat("combat", 21213)
mod:SetUsedIcons(1,2,3,8)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	-- "SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_SUMMON",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_DIED"
)

-- local warnTidal			= mod:NewSpellAnnounce(37730, 3) -- useless, nobody cares about the tank debuff, might as well remove to reduce bloat
local warnBubble			= mod:NewSpellAnnounce(37854, 4)
local warnEarthquakeSoon	= mod:NewSoonAnnounce(37764, 3)
local warnShield			= mod:NewSpellAnnounce(83548, 4)
local WarnWatery			= mod:NewAnnounce("WarnWateryGlobule", 4)

local warnBubble		= mod:NewSpecialWarning("WarnRisingBubble",3)
local specWarnMurlocs	= mod:NewAnnounce("SpecWarnMurlocs", 4)

local timerShield		= mod:NewNextTimer(10, 83548)
-- local timerTidal		= mod:NewNextTimer(20, 37730)
local timerMurlocs		= mod:NewTimer(60, "TimerMurlocs", 39088)
local timerWatery		= mod:NewTimer(30, "TimerWateryGlobule", "Interface\\Icons\\Spell_Frost_FrozenCore")
local timerBubble		= mod:NewTimer(30, "TimerBubble", "Interface\\Icons\\INV_Elemental_Primal_Water")
local timerBurst		= mod:NewTimer(25, "TimerBurst", 83560)

local warnHealer		= mod:NewSpecialWarning(L.WarnHealer)--83544
local warnWarrior		= mod:NewSpecialWarning(L.WarnWarrior)--83551
local warnMage			= mod:NewSpecialWarning(L.WarnMage)--83554
local warnHealthLost	= mod:NewAnnounce("HPLoss", 3)

local berserkTimer		= mod:NewBerserkTimer(600)

mod:AddBoolOption("RisingBubbleIcon")
mod:AddBoolOption("HealerIcon")
mod:AddBoolOption("WarriorIcon")
mod:AddBoolOption("MageIcon")

local bubblespam = 0
local warriorAntiSpam = 0
local MageAntiSpam = 0
local murlocType = {[0] = "Healer", [1] = "Melee", [2] = "Frost"};
local murlocCount = 0
local prevHp = 0

function mod:OnCombatStart(delay)
	timerMurlocs:Start(28-delay)
	berserkTimer:Start(-delay)
	timerWatery:Start(20-delay)
	self:ScheduleMethod(20,"WateryGlobule");
	if mod:IsDifficulty("heroic10", "heroic25") then
		timerBubble:Start(-delay)
	self:ScheduleMethod(30,"RisingBubble");
	end
	murlocCount = 0
	prevHp = 0
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 83544 then
		warnHealer:Show()
		if self.Options.HealerIcon then
			self:SetIcon(args.sourceName, 1)
		end
	elseif args.spellId == 83554 and MageAntiSpam > 120 then
		MageAntiSpam = GetTime()
		warnMage:Show()
		if self.Options.MageIcon then
			self:SetIcon(args.sourceName, 2)
		end
	elseif args.spellId == 83548 then
		warnShield:Show()
		timerShield:Start()
	end
end

-- function mod:SPELL_CAST_START(args)
-- end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 37764 then
		murlocCount = murlocCount + 1;
		warnEarthquakeSoon:Show()
		specWarnMurlocs:Show()
		timerMurlocs:Start(murlocType[(murlocCount % 3)])
	elseif args.spellId == 83551 and warriorAntiSpam > 120 then
		warriorAntiSpam = GetTime()
		warnWarrior:Show()
		if self.Options.WarriorIcon then
			self:SetIcon(args.sourceName, 3)
		end
	end
end

function mod:WateryGlobule()							
	self:UnscheduleMethod("WateryGlobule")
	WarnWatery:Show()
	timerFreezing:Start()
	self:ScheduleMethod(30,"WateryGlobule")
end

function mod:RisingBubble()
	self:UnscheduleMethod("RisingBubble")
	local risingBubble    =self:GetUnitCreatureId(14481)
	warnBubble:Show()
	if self.Options.RisingBubble then
		self:SetIcon(risingBubble, 8)
	end
	timerBubble:Start()
	self:ScheduleMethod(30,"RisingBubble")
end

function mod:BurstingDamageStart(unit)
	self:UnscheduleMethod("BurstingDamageStart")
	local unit = "boss1"
	if unit then
		prevHp = self:GetHealth(unit)
	end
	self:ScheduleMethod(2, "BurstingDamageEnd")
end

function mod:BurstingDamageEnd(unit)
	self:UnscheduleMethod("BurstingDamageEnd")
	local unit = "boss1"
	if unit and prevHp ~= 0 then
		local percentHealthLost = self:GetHealth(unit) - prevHp
		warnHealthLost:Show(percentHealthLost)
		prevHp = 0
		end
	end


function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L.DBM_MOROGRIM_BURSTING_SPAWN or msg:find(L.DBM_MOROGRIM_BURSTING_SPAWN) then
		timerBurst:Start()
		self:ScheduleMethod(24, "BurstingDamageStart")
	end
end