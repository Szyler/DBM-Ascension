local mod	= DBM:NewMod("Leotheras", "DBM-Serpentshrine")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(21215)
mod:RegisterCombat("combat", 21215)
mod:SetUsedIcons(1, 5, 6, 7, 8)

mod:RegisterEvents(
	"UNIT_DIED",
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"CHAT_MSG_MONSTER_YELL"
)

local warnPhase			= mod:NewAnnounce("WarnPhase", 2)
local warnDemon			= mod:NewTargetAnnounce(2137830, 4)
local warnMC			= mod:NewTargetAnnounce(2137835, 4)
local warnPhase2		= mod:NewPhaseAnnounce(2, 2)

local specWarnWhirl		= mod:NewSpecialWarningRun(2137805)
local specWarnDemon		= mod:NewSpecialWarningYou(2137830)

local warnEven			= mod:NewTargetAnnounce(2137839, 3)
-- local specWarnEvenYou	= mod:NewSpecialWarningYou(2137839)
local warnChaos			= mod:NewTargetAnnounce(2137831, 3)
local specWarnChaosYou	= mod:NewSpecialWarningYou(2137831)

local timerNextWhirl	= mod:NewNextTimer(45, 2137805)
local timerWhirl		= mod:NewBuffActiveTimer(12, 2137805)
local timerPhase		= mod:NewTimer(62, "TimerPhase", 39088)
local timerNextDemon	= mod:NewNextTimer(23, 2137830)
local timerDemon		= mod:NewBuffActiveTimer(30, 2137830)
local timerChaos		= mod:NewTargetTimer(4, 2137831) --351271, 351272, 351273
local timerNextEven		= mod:NewNextTimer(32, 2137839)

local berserkTimer		= mod:NewBerserkTimer(720)

--mod:AddBoolOption(L.DemonIcon)
mod:AddBoolOption(L.ChaosIcon)
mod:AddBoolOption(L.ChaosYellOpt)

--local warnDemonTargets = {}
--local warnMCTargets = {}
mod.vb.binderKill = 0
--mod.vb.demonIcon = 8
mod.vb.ChaosIcon = 1
mod.vb.whirlCount = 0
mod.vb.phase = 1

function mod:humanWarns()
	self.vb.whirlCount = 0
	warnPhase:Show(L.Human)
	timerNextWhirl:Start(30)
	timerNextEven:Start(21)
	timerPhase:Start(nil, L.Demon)
end

--local function showDemonTargets(self)
--	warnDemon:Show(table.concat(warnDemonTargets, "<, >"))
--	table.wipe(warnDemonTargets)
--	self.vb.demonIcon = 8
--	timerDemon:Start()
--end

-- local function showMCTargets()
	-- warnMC:Show(table.concat(warnMCTargets, "<, >"))
	-- table.wipe(warnMCTargets)
-- end

function mod:Chaos()
	local target = nil
	if mod.vb.phase == 2 then
	    target = mod:GetBossTarget(21875)
    else
	    target = mod:GetBossTarget(21215)
	end
	local myName = UnitName("player")
	if target == myName then
		if self.Options.ChaosYellOpt then
			SendChatMessage(L.ChaosYell, "YELL");
		end
		specWarnChaosYou:Show()
	else
		warnChaos:Show(target) 
	end
	timerChaos:Start(target)
	if self.Options.ChaosIcon then
		self:SetIcon(target, 1, 4)
	end
end

function mod:OnCombatStart(delay)
	mod.vb.phase = 1
	self.vb.demonIcon = 8
	self.vb.whirlCount = 0
	timerPhase:Start(62, L.Demon)
	timerNextEven:Start(15-delay)
	timerNextWhirl:Start(30-delay)
end

function mod:OnCombatEnd(delay)
	self.vb.binderKill = 0
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 2137805 then
		specWarnWhirl:Show()
		timerWhirl:Start()
		if self.vb.phase == 2 then
			timerNextWhirl:Start()
		end
	-- elseif args:IsSpellID(2137830, 85361) then -- 85361
		-- warnDemonTargets[#warnDemonTargets + 1] = args.destName
		-- self:Unschedule(showDemonTargets)
		-- if self.Options.DemonIcon then
			-- self:SetIcon(args.destName, self.vb.demonIcon)
			-- self.vb.demonIcon = self.vb.demonIcon - 1
		-- end
		-- if args:IsPlayer() then
			-- specWarnDemon:Show()
		-- end
		-- if #warnDemonTargets >= 5 then
			-- showDemonTargets(self)
		-- else
			-- self:Schedule(0.7, showDemonTargets, self)
		-- end
	-- elseif args:IsSpellID(2137835, 85361) then -- 85361
		-- warnMCTargets[#warnMCTargets + 1] = args.destName
		-- self:Unschedule(showMCTargets)
		-- self:Schedule(0.3, showMCTargets)

	-- end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2137831, 2137832, 2137833, 2137834) then
		self:ScheduleMethod(0.3, "Chaos")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2137838, 2137839, 2137840) then -- Tank swap (Even out the Odds)
	warnEven:Show(args.destName)
	timerNextEven:Start()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellDemon or msg:find(L.YellDemon) then
		warnPhase:Show(L.Demon)
		timerWhirl:Cancel()
		timerNextWhirl:Cancel()
		timerNextEven:Cancel()
		timerPhase:Cancel()

		timerNextDemon:Start()
		timerPhase:Start(nil, L.Human)
		self:ScheduleMethod(65, "humanWarns")
	elseif msg == L.YellPhase2 or msg:find(L.YellPhase2) then
		self.vb.phase = 2
		self:UnscheduleMethod("humanWarns")
		timerPhase:Cancel()
		timerWhirl:Cancel()
		timerNextWhirl:Cancel()
		timerNextDemon:Cancel()
		warnPhase2:Show()
		timerNextWhirl:Start(40)
		timerNextEven:Start(25)
		timerNextDemon:Start(31)
	end
end

function mod:UNIT_DIED(args)
	local cId = self:GetCIDFromGUID(args.destGUID)
	if cId == 21806 then
		self.vb.binderKill = self.vb.binderKill + 1
		if self.vb.binderKill == 3 and not self:IsInCombat() then
			DBM:StartCombat(self, 0)
--			self.vb.demonIcon = 8
			self.vb.whirlCount = 0
			self.vb.phase = 1
--			table.wipe(warnMCTargets)
--			table.wipe(warnDemonTargets)
			timerNextWhirl:Start(30)
			timerNextEven:Start(15)
			timerPhase:Start(nil, L.Demon)
			berserkTimer:Start()
		end
	end
end

--  351306 - Mind Flay
--  351339 - Mind Flay - (Heroic)
--  351340 - Mind Flay - (Mythic)