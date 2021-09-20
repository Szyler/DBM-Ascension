local mod	= DBM:NewMod("Vashj", "DBM-Serpentshrine")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(21212)
mod:RegisterCombat("combat", 21212)
mod:SetUsedIcons(6,8)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"UNIT_DIED",
	"CHAT_MSG_MONSTER_YELL",
	"CHAT_MSG_LOOT",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_AURA"
)

local warnPhase2		= mod:NewPhaseAnnounce(2)
local warnPhase3		= mod:NewPhaseAnnounce(3)
local warnCharge		= mod:NewTargetAnnounce(38280, 4)
local warnEnvenom		= mod:NewTargetAnnounce(351381, 3)
local warnAimedShot		= mod:NewTargetAnnounce(351310, 4)
local warnMulti			= mod:NewSpellAnnounce(38310, 3)
local WarnHeal			= mod:NewSpellAnnounce(83565, 3)
local warnSporebat		= mod:NewAnnounce("WarnSporebat", 3, "Interface\\Icons\\Ability_Hunter_Pet_Sporebat")
local warnElemental		= mod:NewAnnounce("WarnElemental", 4, "Interface\\Icons\\Spell_Frost_SummonWaterElemental_2")
local warnHydra			= mod:NewAnnounce("WarnHydra", 3, "Interface\\Icons\\achievement_boss_bazil_akumai")
local warnNaga			= mod:NewAnnounce("WarnNaga", 3, "Interface\\Icons\\achievement_boss_warlord_kalithresh")
local warnEnchantress	= mod:NewAnnounce("WarnEnchantress", 3, "Interface\\Icons\\Spell_Holy_FlashHeal")
local warnLoot			= mod:NewAnnounce("WarnLoot", 3, "Interface\\Icons\\Spell_Nature_ElementalShields")
local warnPhoenix		= mod:NewAnnounce("WarnPhoenix", 3, "Interface\\Icons\\INV_Misc_PheonixPet_01")

local specWarnCharge	= mod:NewSpecialWarningMove(38280)
local specWarnDischarge	= mod:NewSpecialWarningMove(351379)
local specWarnToxic		= mod:NewSpecialWarningMove(38575)

local timerCharge		= mod:NewNextTimer(30, 38280)
local timerAimedShot	= mod:NewNextTimer(30, 351388)
local timerMulti		= mod:NewNextTimer(15, 38310)
local timerEnvenom		= mod:NewNextTimer(30, 351381)
local timerMark			= mod:NewTargetTimer(6, 351310)
local timerChargeDmg	= mod:NewTimer(8, "ChargeExplosion", 351375)
local timerElementalCD	= mod:NewTimer(65, "TimerElemental", "Interface\\Icons\\Spell_Frost_SummonWaterElemental_2")--75-82 variation. because of high variation the pre warning special warning not useful, fortunately we can detect spawns with precise timing.
local timerHydra		= mod:NewTimer(95, "TimerHydra", "INTERFACE\\ICONS\\Achievement_ZG_Gahz")
local timerNaga			= mod:NewTimer(49, "TimerNaga", "Interface\\Icons\\achievement_boss_warlord_kalithresh")
local timerEnchantress	= mod:NewTimer(47, "TimerEnchantress", "Interface\\Icons\\Spell_Holy_FlashHeal")
local timerGenerator	= mod:NewTimer(30, "NextGenerator", "Interface\\Icons\\Spell_Nature_LightningOverload")
local timerDischarge	= mod:NewTimer(9, "Discharge", "Interface\\Icons\\Spell_Nature_LightningOverload")
local timerSporebat		= mod:NewTimer(23, "NextSporebat", "Interface\\Icons\\Ability_Hunter_Pet_Sporebat")

-- Ascended Mechanics

local timerParasite		= mod:NewNextTimer(45, 83568)
local timerSiren		= mod:NewNextTimer(17, 83566)
local timerPhoenix		= mod:NewNextTimer(16, 351414) 

local warnParasite		= mod:NewTargetAnnounce(83568, 3)        
local warnSong			= mod:NewTargetAnnounce(83567, 3) 

local specWarnSiren		= mod:NewSpecialWarning("SpecWarnSiren")

local berserkTimer		= mod:NewBerserkTimer(900)

mod:AddBoolOption("RangeFrame", true)
mod:AddBoolOption(L.LootIcon)
mod:AddBoolOption(L.AimedIcon)
mod:AddBoolOption(L.ChargeYellOpt)
mod:AddBoolOption(L.AimedYellOpt)
mod:AddBoolOption(L.LootYellOpt)
mod:AddBoolOption("AutoChangeLootToFFA", false)

mod.vb.phase = 1
mod.vb.nagaCount = 1
mod.vb.elementalCount = 1
local lootmethod
local ChargeTargets = {}
local BatCD = 24;
local lastTriggerTime = 0;
local TaintedCoreTarget;


function mod:HydraSpawn()
	timerHydra:Stop()
	warnHydra:Show()
	timerHydra:Start()
end

function mod:NagaSpawn()
	timerNaga:Stop()
	warnNaga:Show(tostring(self.vb.nagaCount))
	timerNaga:Start(nil, tostring(self.vb.nagaCount))
	self.vb.nagaCount = self.vb.nagaCount + 1
end

function mod:EnchantressSpawn()
	timerEnchantress:Stop()
	warnEnchantress:Show()
	timerEnchantress:Start()
	self:ScheduleMethod(47,"EnchantressSpawn")
end

function mod:TaintedSpawn()
	timerElementalCD:Stop()
	warnElemental:Show(tostring(self.vb.elementalCount))
	self.vb.elementalCount = self.vb.elementalCount + 1
end

local function warnChargeTargets()
	warnCharge:Show(table.concat(ChargeTargets, "<, >"))
	timerCharge:Start()
	timerChargeDmg:Start()
	table.wipe(ChargeTargets)
end

function mod:SporebatSpawn()
	BatCD = BatCD - 1
	if BatCD <= 2 then		-- Toxic Sporebat CD is capped at 2 seconds, it does not decay below that.
		BatCD = 2
	end
	timerSporebat:Start(BatCD)
	warnSporebat:Show()
	self:ScheduleMethod(BatCD,"SporebatSpawn")
end
	

function mod:OnCombatStart(delay)
	self.vb.phase = 1
	self.vb.nagaCount = 1
	self.vb.elementalCount = 1
	if mod:IsDifficulty("heroic10", "heroic25") then
		timerMulti:Start(22-delay)
		timerEnvenom:Start(19-delay)
		timerAimedShot:Start(25-delay)
		timerCharge:Start(10-delay)
		timerParasite:Start(40-delay)
	else
		timerMulti:Start(22-delay)
		timerEnvenom:Start(19-delay)
		timerAimedShot:Start(25-delay)
		timerCharge:Start(10-delay)
	end
	if DBM:GetRaidRank() == 2 then
		lootmethod = GetLootMethod()
	end
	berserkTimer:Start(-delay)
	table.wipe(ChargeTargets)
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.AutoChangeLootToFFA and DBM:GetRaidRank() == 2 then
		if lootmethod then
			SetLootMethod(lootmethod)
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(38280, 351307) then
		ChargeTargets[#ChargeTargets + 1] = args.destName
		self:Unschedule(warnChargeTargets)
		self:Schedule(0.3, warnChargeTargets)
		if args:IsPlayer() then
			specWarnCharge:Show()
			if self.Options.ChargeYellOpt and args:IsPlayer() then
				SendChatMessage(L.ChargeYell, "YELL")
			end
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(10)
			end
		end
		if mod:IsDifficulty("heroic10", "heroic25") then
		timerCharge:Start(45)
		else
		timerCharge:Start()
		end
	elseif args:IsSpellID(38509) then
		warnAimedShot:Show(args.destName)
		timerMark:Start(args.destName)
		if mod:IsDifficulty("heroic10", "heroic25") then
		timerAimedShot:Start(45)
		else
		timerAimedShot:Start()
		end
		if self.Options.AimedYellOpt and args:IsPlayer() then
			SendChatMessage(L.AimedYell, "YELL")
		end
		if self.Options.AimedIcon then
			self:SetIcon(args.destName, 8, 6)
		end
	elseif args:IsSpellID(38132) then
		if self.Options.LootIcon then
			self:SetIcon(args.destName, 6)
		end
	elseif args:IsSpellID(83565) and (GetTime() - lastTriggerTime) >= 35 then
		lastTriggerTime = GetTime()
		self:UnscheduleMethod("EnchantressSpawn")
		self:EnchantressSpawn()
	elseif args.spellId	== 83568 then
		warnParasite:Show(args.destName)
		timerParasite:Start()
	elseif args.spellId == 83567 then
		warnSong:Show(args.destName)
		specWarnSiren:Show()
	elseif args.spellId == 85411 and args:IsPlayer() then
		specWarnToxic:Show()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(38280, 351307) then
		timerChargeDmg:Stop(args.destName)
		if self.Options.ChargeIcon then
			self:SetIcon(args.destName, 0)
		end
		if args:IsPlayer() then
			if self.Options.RangeFrame then
				DBM.RangeCheck:Hide()
			end
		end
	elseif args:IsSpellID(38132) then
		if self.Options.LootIcon then
			self:SetIcon(args.destName, 0)
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 38310 then
		warnMulti:Show()
		timerMulti:Start()
	end
end

function mod:SPELL_PERIODIC_HEAL(args)
	if args.spellId == 83565 then
		warnHeal:Show()
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L.DBM_VASHJ_DISCHARGE or msg:find(L.DBM_VASHJ_DISCHARGE) then
		timerDischarge:Start()
		specWarnDischarge:Show()
		if self.vb.phase == 2 and mod:IsDifficulty("heroic10", "heroic25") then
		timerSiren:Start()
		elseif self.vb.phase == 3 then
		timerGenerator:Start()
		end
	elseif msg == L.DBM_VASHJ_ELITE or msg:find(L.DBM_VASHJ_ELITE) then
		self:NagaSpawn()
	elseif msg == L.DBM_VASHJ_HYDRA or msg:find(L.DBM_VASHJ_HYDRA) then
		self:HydraSpawn()
	elseif msg == L.DBM_VASHJ_TAINTED or msg:find(L.DBM_VASHJ_TAINTED) then
		self:TaintedSpawn()
	elseif msg == L.DBM_VASHJ_TAINTED_DEAD or msg:find(L.DBM_VASHJ_TAINTED_DEAD) then
		timerElementalCD:Start(nil, tostring(self.vb.elementalCount))
	end
end
	
function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 351381 then
		warnEnvenom:Show(args.destName)
		timerEnvenom:Start()
	elseif args.spellID == 83566 then
		specWarnSiren:Show()
	elseif args.spellID == 351393 then
		timerPhoenix:Start()
		warnPhoenix:Show()
	end
end


function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.DBM_VASHJ_YELL_PHASE2 or msg:find(L.DBM_VASHJ_YELL_PHASE2) then
		timerMulti:Cancel()
		timerEnvenom:Cancel()
		timerAimedShot:Cancel()
		timerCharge:Cancel()
		self.vb.phase = 2
		self.vb.nagaCount = 1
		self.vb.elementalCount = 1
		warnPhase2:Show()
		timerNaga:Start(13, tostring(self.vb.nagaCount))
		timerEnchantress:Start(25)
		timerElementalCD:Start()
		timerHydra:Start(35)
		if self.Options.AutoChangeLootToFFA and DBM:GetRaidRank() == 2 then
			SetLootMethod("freeforall")
		end
	elseif (msg == L.DBM_VASHJ_YELL_PHASE3 or msg:find(L.DBM_VASHJ_YELL_PHASE3)) and self.vb.phase == 2 then
		self.vb.phase = 3
		warnPhase3:Show()
		timerNaga:Cancel()
		warnNaga:Cancel()
		timerElementalCD:Cancel()
		warnElemental:Cancel()
		timerHydra:Cancel()
		timerEnchantress:Cancel()
		warnEnchantress:Cancel()
		warnHydra:Cancel()
		self:UnscheduleMethod("NagaSpawn")
		self:UnscheduleMethod("EnchantressSpawn")
		self:UnscheduleMethod("TaintedSpawn")
		self:UnscheduleMethod("HydraSpawn")
		self:ScheduleMethod(10, "SporebatSpawn")
		timerSporebat:Start(10)
		if mod:IsDifficulty("heroic10", "heroic25") then
			timerPhoenix:Start(60)
			timerGenerator:Start(25)
			timerCharge:Start(15)
		else
			timerGenerator:Start(25)
			timerCharge:Start(15)
		end
		if self.Options.AutoChangeLootToFFA and DBM:GetRaidRank() == 2 then
			if lootmethod then
				SetLootMethod(lootmethod)
			end
		end
	end
end

function mod:UNIT_AURA(unit)
    local name = UnitName(unit);
    if (name ~= TaintedCoreTarget) and UnitDebuff(unit,"Tainted Core") then
        TaintedCoreTarget = name;
        warnLoot:Show(name)
    end
end