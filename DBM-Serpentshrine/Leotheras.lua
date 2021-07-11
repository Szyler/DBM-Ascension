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
local warnDemon			= mod:NewTargetAnnounce(37676, 4)
local warnMC			= mod:NewTargetAnnounce(37749, 4)
local warnPhase2		= mod:NewPhaseAnnounce(2, 2)

local specWarnWhirl		= mod:NewSpecialWarningRun(37640)
local specWarnDemon		= mod:NewSpecialWarningYou(37676)

local warnEven			= mod:NewTargetAnnounce(351201, 3)
local specWarnEvenYou	= mod:NewSpecialWarningYou(351201)
local warnChaos			= mod:NewTargetAnnounce(85365, 3)
local specWarnChaosYou	= mod:NewSpecialWarningYou(85365)

local timerWhirlCD		= mod:NewCDTimer(27, 37640)
local timerWhirl		= mod:NewBuffActiveTimer(12, 37640)
local timerPhase		= mod:NewTimer(60, "TimerPhase", 39088)
local timerDemonCD		= mod:NewCDTimer(23, 37676)
local timerDemon		= mod:NewBuffActiveTimer(30, 37676)
local timerChaos		= mod:NewTargetTimer(4, 85365) --351271, 351272, 351273

local berserkTimer		= mod:NewBerserkTimer(600)

mod:AddBoolOption(L.DemonIcon)
mod:AddBoolOption(L.ChaosIcon)
mod:AddBoolOption(L.ChaosYellOpt)

local warnDemonTargets = {}
local warnMCTargets = {}
mod.vb.binderKill = 0
mod.vb.demonIcon = 8
mod.vb.ChaosIcon = 1
mod.vb.whirlCount = 0
mod.vb.phase = 1

local function humanWarns(self)
	self.vb.whirlCount = 0
	warnPhase:Show(L.Human)
	timerWhirlCD:Start(15)
	timerPhase:Start(nil, L.Demon)
end

local function showDemonTargets(self)
	warnDemon:Show(table.concat(warnDemonTargets, "<, >"))
	table.wipe(warnDemonTargets)
	self.vb.demonIcon = 8
	timerDemon:Start()
end

local function showMCTargets()
	warnMC:Show(table.concat(warnMCTargets, "<, >"))
	table.wipe(warnMCTargets)
end

function mod:Chaos()
	local target = mod:GetBossTarget(21215)
	if(target == UnitName("player")) then
		if self.Options.ChaosYellOpt then
			SendChatMessage(L.ChaosYell, "YELL")
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
	self.vb.demonIcon = 8
	self.vb.whirlCount = 0
	timerPhase:Start(115, L.Demon)
end

function mod:OnCombatEnd(delay)
	self.vb.binderKill = 0
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 37640 then
		specWarnWhirl:Show()
		-- specWarnWhirl:Play("justrun")
		timerWhirl:Start()
		if self.vb.phase ~= 2 then
			self.vb.whirlCount = self.vb.whirlCount + 1
			if self.vb.whirlCount < 3 then
				timerWhirlCD:Start()
			end
		else
			timerWhirlCD:Start()
		end
	elseif args:IsSpellID(37676, 85361) then -- 85361
		warnDemonTargets[#warnDemonTargets + 1] = args.destName
		self:Unschedule(showDemonTargets)
		if self.Options.DemonIcon then
			self:SetIcon(args.destName, self.vb.demonIcon)
			self.vb.demonIcon = self.vb.demonIcon - 1
		end
		if args:IsPlayer() then
			specWarnDemon:Show()
			-- specWarnDemon:Play("targetyou")
		end
		if #warnDemonTargets >= 5 then
			showDemonTargets(self)
		else
			self:Schedule(0.7, showDemonTargets, self)
		end
	elseif args:IsSpellID(37749, 85361) then -- 85361
		warnMCTargets[#warnMCTargets + 1] = args.destName
		self:Unschedule(showMCTargets)
		self:Schedule(0.3, showMCTargets)

	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(85365, 351271, 351272, 351273) then
		self:ScheduleMethod(0.3, "Chaos")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(351201, 351202) then -- Tank swap (Even out the Odds)
		if args:IsPlayer() then
			specWarnEvenYou:Show()
		end
		warnEven:Show()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellDemon or msg:find(L.YellDemon) then
		warnPhase:Show(L.Demon)
		timerWhirl:Cancel()
		timerWhirlCD:Cancel()
		timerPhase:Cancel()
		timerDemonCD:Start()
		timerPhase:Start(nil, L.Human)
		self:Schedule(60, humanWarns, self)
	elseif msg == L.YellPhase2 or msg:find(L.YellPhase2) then
		self.vb.phase = 2
		self:Unschedule(humanWarns)
		timerPhase:Cancel()
		timerWhirl:Cancel()
		timerWhirlCD:Cancel()
		timerDemonCD:Cancel()
		warnPhase2:Show()
		timerWhirlCD:Start(22.5)
	end
end

function mod:UNIT_DIED(args)
	local cId = self:GetCIDFromGUID(args.destGUID)
	if cId == 21806 then
		self.vb.binderKill = self.vb.binderKill + 1
		if self.vb.binderKill == 3 and not self:IsInCombat() then
			DBM:StartCombat(self, 0)
			self.vb.demonIcon = 8
			self.vb.whirlCount = 0
			self.vb.phase = 1
			table.wipe(warnMCTargets)
			table.wipe(warnDemonTargets)
			timerWhirlCD:Start(15)
			timerPhase:Start(nil, L.Demon)
			berserkTimer:Start()
		end
	end
end

--  351306 - Mind Flay
--  351339 - Mind Flay - (Heroic)
--  351340 - Mind Flay - (Mythic)