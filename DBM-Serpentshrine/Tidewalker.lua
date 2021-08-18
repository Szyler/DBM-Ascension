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
	"SPELL_SUMMON"
)

local warnTidal			= mod:NewSpellAnnounce(37730, 3)
-- local warnGrave		= mod:NewTargetAnnounce(38049, 4)--TODO, make run out special warning instead?
-- local warnBubble		= mod:NewSpellAnnounce(37854, 4)
local warnEarthquakeSoon= mod:NewSoonAnnounce(37764, 3)
local warnShield		= mod:NewSpellAnnounce(83548, 4)
local WarnFreezing		= mod:NewAnnounce("WarnFreezingBubble", 4)

local warnRising		= mod:NewSpecialWarning("WarnRisingBubble",3)
local specWarnMurlocs	= mod:NewAnnounce("SpecWarnMurlocs", 4)

local timerShield		= mod:NewNextTimer(10, 83548)
local timerTidal		= mod:NewNextTimer(20, 37730)
-- local timerGraveCD		= mod:NewCDTimer(20, 38049)
local timerMurlocs		= mod:NewTimer(60, "TimerMurlocs", 39088)
local timerFreezing		= mod:NewTimer(30, "TimerFreezingBubble", "Interface\\Icons\\Spell_Frost_FrozenCore")
local timerRising		= mod:NewNextTimer(30, 83561)

local warnHealer		= mod:NewSpecialWarning(L.WarnHealer)--83544
local warnWarrior		= mod:NewSpecialWarning(L.WarnWarrior)--83551
local warnMage			= mod:NewSpecialWarning(L.WarnMage)--83554

local berserkTimer		= mod:NewBerserkTimer(600)

mod:AddBoolOption("RisingBubbleIcon")
mod:AddBoolOption("HealerIcon")
mod:AddBoolOption("WarriorIcon")
mod:AddBoolOption("MageIcon")

-- local warnGraveTargets = {}
local bubblespam = 0
local warriorAntiSpam = 0
local MageAntiSpam = 0
local murlocType = {[0] = "Healer", [1] = "Melee", [2] = "Frost"};
local murlocCount = 0

-- local function showGraveTargets()
-- 	warnGrave:Show(table.concat(warnGraveTargets, "<, >"))
-- 	table.wipe(warnGraveTargets)
-- 	timerGraveCD:Show()
-- end

function mod:OnCombatStart(delay)
	-- self.vb.graveIcon = 8
	-- table.wipe(warnGraveTargets)
	-- timerGraveCD:Start(20-delay)
	timerMurlocs:Start(28-delay)
	berserkTimer:Start(-delay)
	timerFreezing:Start(20-delay)
	self:ScheduleMethod(20,"FreezingBubble");
	if mod:IsDifficulty("heroic10", "heroic25") then
		timerRising:Start(-delay)
	self:ScheduleMethod(30,"RisingBubble");
	end
	murlocCount = 0
end

function mod:SPELL_AURA_APPLIED(args)
	-- if args:IsSpellID(38049) then --37850, 38023, 38024, 38025, -- Not used on Ascension
	-- 	warnGraveTargets[#warnGraveTargets + 1] = args.destName
	-- 	self:Unschedule(showGraveTargets)
	-- 	if self.Options.GraveIcon then
	-- 		self:SetIcon(args.destName, self.vb.graveIcon)
	-- 	end
	-- 	self.vb.graveIcon = self.vb.graveIcon - 1
	-- 	if #warnGraveTargets >= 4 then
	-- 		showGraveTargets()
	-- 	else
	-- 		self:Schedule(0.3, showGraveTargets)
	-- 	end
	-- elseif
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
	if args:IsSpellID(37730, 351345, 351346) then
		warnTidal:Show()
		timerTidal:Start()
	elseif args.spellId == 37764 then
		murlocCount = murlocCount + 1;
		warnEarthquakeSoon:Show()
		specWarnMurlocs:Show()
		timerMurlocs:Start(murlocType[(murlocCount % 3))
	elseif args.spellId == 83551 and warriorAntiSpam > 120 then
		warriorAntiSpam = GetTime()
		warnWarrior:Show()
		if self.Options.WarriorIcon then
			self:SetIcon(args.sourceName, 3)
		end
	end
end

function mod:FreezingBubble()
	self:UnscheduleMethod("FreezingBubble")
	WarnFreezing:Show()
	timerFreezing:Start()
	self:ScheduleMethod(30,"FreezingBubble")
end

function mod:RisingBubble()
	self:UnscheduleMethod("RisingBubble")
	local risingBubble    =self:GetUnitCreatureId(14481)
	warnRising:Show()
	if self.Options.RisingBubble then
		self:SetIcon(risingBubble, 8)
	end
	timerRising:Start()
	self:ScheduleMethod(30,"RisingBubble")
end