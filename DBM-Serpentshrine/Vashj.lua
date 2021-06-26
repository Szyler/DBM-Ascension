local mod	= DBM:NewMod("Vashj", "DBM-Serpentshrine")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(21212)
mod:RegisterCombat("combat", 21212)
mod:SetUsedIcons(1)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"UNIT_DIED",
	"CHAT_MSG_MONSTER_YELL",
	"CHAT_MSG_LOOT"
)

local warnCharge		= mod:NewTargetAnnounce(38280, 4)
local warnEntangle		= mod:NewSpellAnnounce(38316, 3)
local warnPhase2		= mod:NewPhaseAnnounce(2)
local warnElemental		= mod:NewAnnounce("WarnElemental", 4)
local warnHydra			= mod:NewAnnounce("WarnHydra", 3)
local warnNaga			= mod:NewAnnounce("WarnNaga", 3)
--local warnShield		= mod:NewAnnounce("WarnShield", 3)
local warnLoot			= mod:NewAnnounce("WarnLoot", 4)
local warnLootYou		= mod:NewSpecialWarningYou(351397)
local warnPhase3		= mod:NewPhaseAnnounce(3)

local specWarnCharge	= mod:NewSpecialWarningMove(38280)
local specWarnElemental	= mod:NewSpecialWarning("SpecWarnElemental")--Changed from soon to a now warning. the soon warning not accurate because of 11 second variation so not useful special warning.
local specWarnToxic		= mod:NewSpecialWarningMove(38575)

local timerCharge		= mod:NewTargetTimer(20, 38280)
local timerElemental	= mod:NewTimer(22, "TimerElementalActive")--Blizz says they are active 20 seconds per patch notes, but my logs don't match those results. 22 second up time.
local timerElementalCD	= mod:NewTimer(45, "TimerElemental")--46-57 variation. because of high variation the pre warning special warning not useful, fortunately we can detect spawns with precise timing.
local timerHydra		= mod:NewTimer(63, "timerHydra")
local timerNaga			= mod:NewTimer(47.5, "TimerNaga")

mod:AddBoolOption("RangeFrame", true)
mod:AddBoolOption(L.ChargeIcon)

mod.vb.phase = 1
mod.vb.shieldLeft = 4
mod.vb.nagaCount = 1
mod.vb.hydraCount = 1
mod.vb.elementalCount = 1
local elementals = {}

function mod:HydraSpawn()
	self.vb.hydraCount = self.vb.hydraCount + 1
	timerHydra:Start(nil, tostring(self.vb.hydraCount))
	warnHydra:Schedule(57, tostring(self.vb.hydraCount))
	self:ScheduleMethod(63, "HydraSpawn")
end

function mod:NagaSpawn()
	self.vb.nagaCount = self.vb.nagaCount + 1
	timerNaga:Start(nil, tostring(self.vb.nagaCount))
	warnNaga:Schedule(42.5, tostring(self.vb.nagaCount))
	self:ScheduleMethod(47.5, "NagaSpawn")
end

function mod:OnCombatStart(delay)
	table.wipe(elementals)
	self.vb.phase = 1
	self.vb.shieldLeft = 4
	self.vb.nagaCount = 1
	self.vb.hydraCount = 1
	self.vb.elementalCount = 1
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 38280 then
		timerCharge:Start(args.destName)
		if args:IsPlayer() then
			specWarnCharge:Show()
			if self.Options.ChargeIcon then
				SendChatMessage(L.yellChargeVashj, "YELL")
			end
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(10)
			end
		else
			warnCharge:Show(args.destName)
		end
		if self.Options.ChargeIcon then
			self:SetIcon(args.destName, 1, 20)
		end
	elseif args:IsSpellID(38575,85411) and args:IsPlayer() then
		specWarnToxic:Show()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 38280 then
		timerCharge:Stop(args.destName)
		if self.Options.ChargeIcon then
			self:SetIcon(args.destName, 0)
		end
		if args:IsPlayer() then
			if self.Options.RangeFrame then
				DBM.RangeCheck:Hide()
			end
		end
	elseif args.spellId == 38132 then
		if self.Options.LootIcon then
			self:SetIcon(args.destName, 0)
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 38253 and not elementals[args.sourceGUID] then
		specWarnElemental:Show()
		timerElemental:Start()
		elementals[args.sourceGUID] = true
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 38316 then
		warnEntangle:Show()
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 22009 then
		self.vb.elementalCount = self.vb.elementalCount + 1
		timerElementalCD:Start(nil, tostring(self.vb.elementalCount))
		warnElemental:Schedule(45, tostring(self.vb.elementalCount))
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.DBM_VASHJ_YELL_PHASE2 or msg:find(L.DBM_VASHJ_YELL_PHASE2) then
		self.vb.phase = 2
		self.vb.nagaCount = 1
		self.vb.hydraCount = 1
		self.vb.elementalCount = 1
		self.vb.shieldLeft = 4
		warnPhase2:Show()
		timerNaga:Start(nil, tostring(self.vb.nagaCount))
		warnNaga:Schedule(42.5, tostring(self.vb.elementalCount))
		self:ScheduleMethod(47.5, "NagaSpawn")
		timerElementalCD:Start(nil, tostring(self.vb.elementalCount))
		warnElemental:Schedule(45, tostring(self.vb.elementalCount))
		timerHydra:Start(nil, tostring(self.vb.hydraCount))
		warnHydra:Schedule(57, tostring(self.vb.hydraCount))
		self:ScheduleMethod(63, "HydraSpawn")
	elseif msg == L.DBM_VASHJ_YELL_PHASE3 or msg:find(L.DBM_VASHJ_YELL_PHASE3) then
		self.vb.phase = 3
		warnPhase3:Show()
		timerNaga:Cancel()
		warnNaga:Cancel()
		timerElementalCD:Cancel()
		warnElemental:Cancel()
		timerHydra:Cancel()
		warnHydra:Cancel()
		self:UnscheduleMethod("NagaSpawn")
		self:UnscheduleMethod("HydraSpawn")
	end
end

function mod:CHAT_MSG_LOOT(msg)
	-- DBM:AddMsg(msg) --> Meridium receives loot: [Tainted Core]
	local player, itemID = msg:match(L.LootMsg)
	if player and itemID and tonumber(itemID) == 31088 and self:IsInCombat() then
		warnLoot:Show(player)
		if player == UnitName("player") then
			warnLootYou:Show()
		end
	end
end
