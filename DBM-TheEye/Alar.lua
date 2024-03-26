local mod	= DBM:NewMod("Alar", "DBM-TheEye", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(19514)
mod:RegisterCombat("combat", 19551)
-- mod:RegisterKill("yell", L.NeverHappen) --There is no yell. Just abusing it so DBM doesnt end combat when al'ar dies in between Phases
mod:SetWipeTime(25) 

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REFRESH",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_DIED"
)

-- local warn
local warnEmber					= mod:NewAnnounce("WarnEmber", 2, 2135208)
-- local warnDive					= mod:NewAnnounce("WarnDive", 2, "Interface\\Icons\\Spell_Fire_Fireball02")
local warnDive					= mod:NewSpecialWarningRun(2135164)
local warnAlarRebirth			= mod:NewSpellAnnounce(2135200, 4) --Heroic 2135201, Ascended 10Man-2135202, 25Man-2135203
local warnFlameCascade			= mod:NewSpellAnnounce(2135190, 3)
local specWarnFeather			= mod:NewSpecialWarning("SpecWarnFeather")
local specWarnGround			= mod:NewSpecialWarningYou(2135186)
local warnFlameBreath			= mod:NewAnnounce(L.FlameBreath, 2, 2135155)

-- local timer
local timerNextPlatform        	= mod:NewTimer(30, "NextPlatform", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp") -- timer might be slightly off need to test in action
local berserkTimer				= mod:NewTimer(720, "Berserk", 26662)
local timerAlarUp				= mod:NewTimer(30, "AlarUp", "Interface\\Icons\\Spell_Fire_Fireball02")
local timerAlarDive				= mod:NewTimer(14, "AlarDive", "Interface\\Icons\\Spell_Fire_Fireball02")
local timerEmberSpawn			= mod:NewTimer(12, "TimerEmberSpawn", 2135208)  --heroic 2135209 , Ascended 10Man-2135210, 25Man-2135211
local timerNextBreath			= mod:NewNextTimer(10, 2135154)  --Heroic 2135155 , Ascended 10Man-2135156, 25Man-2135157
local timerNextAlarRebirth		= mod:NewNextTimer(10, 2135200)
local timerNextFlameCascade		= mod:NewNextTimer(60, 2135190)
local timerFlameCascade			= mod:NewBuffActiveTimer(17, 2135190)

--Ascended mechanics:
local yellLivingBomb			= mod:NewFadesYell(2135176)
mod:AddBoolOption(L.LivingBombYellOpt, true)

-- local variables

-- local options
mod.vb.phase = 1

function mod:PlatformSwap()
	self:UnscheduleMethod("PlatformSwap")
	timerEmberSpawn:Start()
	warnEmber:Schedule(12)
	timerNextPlatform:Start(32)
	self:ScheduleMethod(32, "PlatformSwap")
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	timerNextPlatform:Start(-delay)
	self:ScheduleMethod(32-delay, "PlatformSwap")
	timerNextBreath:Start(-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2135190) then
		timerFlameCascade:Start()
		timerEmberSpawn:Cancel()
		warnFlameCascade:Show()
	elseif args:IsSpellID(2135186, 2135187, 2135188, 2135189)  and args:IsPlayer() then
		specWarnGround:Show()
	elseif args:IsSpellID(2135174) and args:IsPlayer() then
		specWarnFeather:Schedule(45)
	elseif args:IsSpellID(2135154, 2135155, 2135156, 2135157) then --Flame Breath debuffs on tanks
		warnFlameBreath:Show(args.spellName, args.destName, args.amount or 1)
	elseif args:IsSpellID(2135176, 2135177, 2135178, 2135179) and self.Options.LivingBombYellOpt and args:IsPlayer() then
		SendChatMessage("Living Bomb on "..args.destName.."!", "YELL")
		yellLivingBomb:Countdown(12)
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(2135154, 2135155, 2135156, 2135157) then
		warnFlameBreath:Show(args.spellName, args.destName, args.amount or 1)
	end
end

function mod:SPELL_AURA_REFRESH(args)
	if args:IsSpellID(2135174) and args:IsPlayer() then
		self:Unschedule(specWarnFeather)
		specWarnFeather:Schedule(45)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(2135190) then
		timerEmberSpawn:Start(11)
		timerNextFlameCascade:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2135154, 2135155, 2135156, 2135157) and self.vb.phase ~= 3 then
		timerNextBreath:Start()
	elseif args:IsSpellID(2135196, 2135197, 2135198, 2135199) then
		if self.vb.phase == 1 then
			self.vb.phase = 2
			timerEmberSpawn:Stop()
			timerAlarUp:Start(40)
			timerNextBreath:Stop()
			timerNextPlatform:Stop()
			self:UnscheduleMethod("PlatformSwap")
		elseif self.vb.phase == 2 then
			self.vb.phase = 3
			timerNextBreath:Stop()
			timerEmberSpawn:Stop()
			timerAlarUp:Stop()
		end
	elseif args:IsSpellID(2135190) then
		timerEmberSpawn:Start()
		timerNextFlameCascade:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2135200, 2135201, 2135202, 2135203) then
		warnAlarRebirth:Show()
		timerNextBreath:Start(2)
		if self.vb.phase == 2 then
			timerAlarUp:Start(33)
			timerNextBreath:Start(18)
		end
	elseif args:IsSpellID(2135208, 2135209, 2135210, 2135211) then
		warnEmber:Show()
		self:SetIcon(args.sourceName, 5, 30)
		if self.vb.phase == 1 then
			timerEmberSpawn:Start(45) -- 45 sec unless boss goes into the air
		elseif self.vb.phase == 3 then
			timerEmberSpawn:Start(12)
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L.EmoteAlarUp or msg:find(L.EmoteAlarUp) then
		timerNextBreath:Stop()
		timerAlarDive:Start()
		timerEmberSpawn:Start(24)
		warnDive:Schedule(14)
		timerAlarUp:Start()
	elseif msg == L.EmotePhase3 or msg:find(L.EmotePhase3) then
		timerAlarUp:Stop()
		timerEmberSpawn:Start(22)
		timerNextFlameCascade:Start()
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
    if cid == 19514 then
		if self.vb.phase == 1 then
			self.vb.phase = 2
			mod:IsInCombat()	
			mod.inCombat = true
			timerNextAlarRebirth:Start()
		elseif self.vb.phase == 2 then
			self.vb.phase = 3
		end
	end
end


-- Old Alar code


-- Alar:RegisterEvents(
-- 	"SPELL_AURA_APPLIED"
-- );


-- Alar:AddOption("WarnArmor", true, DBM_ALAR_OPTION_MELTARMOR);
-- Alar:AddOption("Meteor", true, DBM_ALAR_OPTION_METEOR);

-- Alar:AddBarOption("Enrage")
-- Alar:AddBarOption("Meteor")
-- Alar:AddBarOption("Melt Armor: (.*)")

-- function Alar:OnCombatStart(delay)
-- 	self:ScheduleSelf(10, "CheckForAlar"); -- to prevent bugs if you are using an unsupported client language...
-- end

-- function Alar:OnEvent(event, arg1)
-- 	if event == "CheckForAlar" then
-- 		for i = 1, GetNumRaidMembers() do
-- 			if UnitName("raid"..i.."target") == DBM_ALAR_NAME and UnitAffectingCombat("raid"..i.."target") then
-- 				warnPhase = true;
-- 				break;
-- 			end
-- 		end
-- 		if not warnPhase then
-- 			langError = true;
-- 		end

-- 	elseif event == "SPELL_AURA_APPLIED" then
-- 		if arg1.spellId == 35383 and arg1.destName == UnitName("player") then
-- 			self:AddSpecialWarning(DBM_ALAR_WARN_FIRE);
-- 		elseif arg1.spellId == 35410 then
-- 			self:SendSync("MeltArmor"..tostring(arg1.destName));
-- 		end
-- 	elseif event == "MeteorSoon" then
-- 		if self.Options.Meteor then
-- 			self:Announce(DBM_ALAR_WARN_METEOR_SOON, 1);
-- 		end

-- 	elseif event == "EnrageWarn" and type(arg1) == "number" then
-- 		if arg1 >= 60 then
-- 			self:Announce(string.format(DBM_ALAR_WARN_ENRAGE, (arg1/60), DBM_MIN), 1);
-- 		else
-- 			self:Announce(string.format(DBM_ALAR_WARN_ENRAGE, arg1, DBM_SEC), 3);
-- 		end
-- 	end
-- end

-- function Alar:OnSync(msg)
-- 	if msg == "Rebirth" and not self:IsWipe() and self.InCombat then
-- 		self:Announce(DBM_ALAR_WARN_REBIRTH, 2);
-- 		self:EndStatusBarTimer("Next Platform");
-- 		self:ScheduleSelf(47, "MeteorSoon");
-- 		self:StartStatusBarTimer(52, "Meteor", "Interface\\Icons\\Spell_Fire_Fireball02");
-- 		self:StartStatusBarTimer(600, "Enrage", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy");
-- 		self:ScheduleSelf(300, "EnrageWarn", 300);
-- 		self:ScheduleSelf(480, "EnrageWarn", 120);
-- 		self:ScheduleSelf(540, "EnrageWarn", 60);
-- 		self:ScheduleSelf(570, "EnrageWarn", 30);
-- 		self:ScheduleSelf(590, "EnrageWarn", 10);

-- 	elseif string.sub(msg, 0, 9) == "MeltArmor" then
-- 		local target = string.sub(msg, 10);
-- 		if target then
-- 			if self:GetStatusBarTimerTimeLeft("Melt Armor: "..target) then
-- 				self:UpdateStatusBarTimer("Melt Armor: "..target, 0, 60);
-- 			else
-- 				self:StartStatusBarTimer(60, "Melt Armor: "..target, "Interface\\Icons\\Spell_Fire_Immolation");
-- 			end
-- 			if self.Options.WarnArmor then
-- 				self:Announce(DBM_ALAR_WARN_MELTARMOR:format(target), 1);
-- 			end
-- 		end
-- 	elseif msg == "AddInc" and (GetTime() - lastAdd) > 15 and self.InCombat then
-- 		lastAdd = GetTime();
-- 		flying = true;
-- 		self:EndStatusBarTimer("Next Platform");
-- 		self:Announce(DBM_ALAR_WARN_ADD, 2);
-- 	elseif msg == "Meteor" and (GetTime() - lastMeteor) > 30 and self.InCombat then
-- 		lastMeteor = GetTime();
-- 		if self.Options.Meteor then
-- 			self:Announce(DBM_ALAR_WARN_METEOR, 3);
-- 		end
-- 		self:ScheduleSelf(49, "MeteorSoon");
-- 		self:StartStatusBarTimer(54.5, "Meteor", "Interface\\Icons\\Spell_Fire_Fireball02");
-- 	elseif msg == "NextPlatform" and self.InCombat then
-- 	end
-- end


-- function Alar:OnUpdate(elapsed)
-- 	if self.InCombat and not langError and not self:IsWipe() then
-- 		local foundIt;
-- 		local target;
-- 		for i = 1, GetNumRaidMembers() do
-- 			if UnitName("raid"..i.."target") == DBM_ALAR_NAME then
-- 				foundIt = true;
-- 				target = UnitName("raid"..i.."targettarget");
-- 				if not target and UnitCastingInfo("raid"..i.."target") == DBM_ALAR_FLAME_BUFFET then
-- 					target = "Dummy";
-- 				end
-- 				break;
-- 			end
-- 		end

-- 		if not foundIt and warnPhase then
-- 			self:SendSync("Rebirth");
-- 		end

-- 		if foundIt and not target and not phase2 then
-- 			self:SendSync("AddInc");
-- 		elseif not target and type(phase2) == "number" and (GetTime() - phase2) > 25 then
-- 			self:SendSync("Meteor");
-- 		elseif target and flying then
-- 			self:SendSync("NextPlatform");
-- 		end
-- 	end
-- end
