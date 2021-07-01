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
	"CHAT_MSG_LOOT",
	"CHAT_MSG_RAID_BOSS_EMOTE"
)

local warnCharge		= mod:NewTargetAnnounce(196779, 4)
--local warnEntangle		= mod:NewSpellAnnounce(38316, 3)
local warnPhase2		= mod:NewPhaseAnnounce(2)
local warnElemental		= mod:NewAnnounce("WarnElemental", 4)
local warnHydra			= mod:NewAnnounce("WarnHydra", 3)
local warnNaga			= mod:NewAnnounce("WarnNaga", 3)
--local warnShield		= mod:NewAnnounce("WarnShield", 3)
--local warnLoot			= mod:NewAnnounce("WarnLoot", 4)
local warnPhase3		= mod:NewPhaseAnnounce(3)
local warnAimedShot		= mod:NewTargetAnnounce(196782, 4)
local warnMulti			= mod:NewAnnounce("WarnMulti", 3)
local warnEnvenom		= mod:NewTargetAnnounce(196781, 3)

local specWarnCharge	= mod:NewSpecialWarningMove(196779)
local specWarnDischarge	= mod:NewSpecialWarningMove(351379)
-- local specWarnElemental	= mod:NewSpecialWarning("SpecWarnElemental")--Changed from soon to a now warning. the soon warning not accurate because of 11 second variation so not useful special warning.
local specWarnToxic		= mod:NewSpecialWarningMove(38575)
local specWarnHeal		= mod:NewSpecialWarning("SpecWarnHealer") -- 83565

local timerCharge		= mod:NewTimer(30, "Static Charge", 196779)
local timerChargeDmg	= mod:NewTargetTimer(8, 196780)
local timerAimedShot	= mod:NewTimer(30, "Aimed Shot", 196782)
local timerMark			= mod:NewTargetTimer(8, 196782)
-- local timerElemental	= mod:NewTimer(22, "TimerElementalActive")--Blizz says they are active 20 seconds per patch notes, but my logs don't match those results. 22 second up time.
local timerElementalCD	= mod:NewTimer(75, "TimerElemental")--75-82 variation. because of high variation the pre warning special warning not useful, fortunately we can detect spawns with precise timing.
local timerHydra		= mod:NewTimer(91, "TimerHydra")
local timerNaga			= mod:NewTimer(47, "TimerNaga")
local timerGenerator	= mod:NewTimer(30, "Next Generator", "Interface\\Icons\\Spell_Nature_LightningOverload")
local timerDischarge	= mod:NewTimer(9, "Discharge", "Interface\\Icons\\Spell_Nature_LightningOverload")
local timerMulti		= mod:NewTimer(15, "Multi-Shot", 196782)
local timerEnvenom		= mod:NewTimer(30, "Envenom", 196781)

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
	warnHydra:Schedule(86, tostring(self.vb.hydraCount))
	self:ScheduleMethod(91, "HydraSpawn")
end

function mod:NagaSpawn()
	self.vb.nagaCount = self.vb.nagaCount + 1
	timerNaga:Start(nil, tostring(self.vb.nagaCount))
	warnNaga:Schedule(42, tostring(self.vb.nagaCount))
	self:ScheduleMethod(47, "NagaSpawn")
end

function mod:OnCombatStart(delay)
	table.wipe(elementals)
	self.vb.phase = 1
	self.vb.shieldLeft = 4
	self.vb.nagaCount = 1
	self.vb.hydraCount = 1
	self.vb.elementalCount = 1
	timerMulti:Start(22-delay)
	timerEnvenom:Start(19-delay)
	timerAimedShot:Start(26-delay)
	timerCharge:Start(10-delay)
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 196779 then
		timerCharge:Start()
		timerChargeDmg:Start(args.destName)
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
	elseif args.spellId(196782) then
		warnAimedShot:Show(args.destName)
		timerMark:Start(args.destName)
		timerAimedShot:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 196779 then
		timerChargeDmg:Stop(args.destName)
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

function mod:SPELL_CAST_START(args) -- useless now that we have raid boss emote telling us when Tainted spawns.
	if args.spellId == 38310 then
		warnMulti:Show()
		timerMulti:Start()
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(args)
	if msg == DBM_VASHJ_DISCHARGE then
		timerDischarge:Start()
		specWarnDischarge:Show()
	elseif msg == DBM_VASHJ_ELITE then
		warnNaga:Show()
		timerNaga:Start()
	elseif msg == DBM_VASHJ_HYDRA then
		warnHydra:Show()
		timerHydra:Start()
	elseif msg == DBM_VASHJ_TAINTED then
		warnElemental:Show()
	end
end
	
function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 196781 then
		warnEnvenom:Show(args.destName)
		timerEnvenom:Start()
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 22009 then
		self.vb.elementalCount = self.vb.elementalCount + 1
		warnElemental:Schedule(70, tostring(self.vb.elementalCount))
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
		timerCharge:Cancel()
		timerAimedShot:Cancel()
		timerNaga:Start(nil, tostring(self.vb.nagaCount))
		warnNaga:Schedule(8, tostring(self.vb.elementalCount))
		self:ScheduleMethod(13, "NagaSpawn")
		timerElementalCD:Start(61, tostring(self.vb.elementalCount))
		warnElemental:Schedule(56, tostring(self.vb.elementalCount))
		timerHydra:Start(32, tostring(self.vb.hydraCount))
		warnHydra:Schedule(28, tostring(self.vb.hydraCount))
		self:ScheduleMethod(32, "HydraSpawn")
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
		timerGenerator:Start()
		timerCharge:Start(15)
	end
end

function mod:CHAT_MSG_LOOT(msg)
	-- DBM:AddMsg(msg) --> Meridium receives loot: [Tainted Core]
	local player, itemID = msg:match(L.LootMsg)
	if player and itemID and tonumber(itemID) == 31088 and self:IsInCombat() then
		warnLoot:Show(player)
		--if player == UnitName("player") then
		--		warnLootYou:Show()
		--end
	end
end
