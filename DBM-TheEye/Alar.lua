local mod	= DBM:NewMod("Alar", "DBM-TheEye", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(19514)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"UNIT_DIED"
)


-- local warn
local warnEmber					= mod:NewAnnounce("WarnEmber", 2, 2135208)
local warnDive					= mod:NewAnnounce("WarnDive", 2, "Interface\\Icons\\Spell_Fire_Fireball02")
local warnAlarRebirth			= mod:NewSpellAnnounce(2135200, 4) --Heroic 2135201, Ascended 10Man-2135202, 25Man-2135203
local warnFlameCascade			= mod:NewSpellAnnounce(2135190, 3)
local warnFeather				= mod.NewAnnounce("WarnFeather", 2, 2135174)
local warnBurningGround			= mod.NewSpecialWarningYou(2135186)

-- local timer
local timerNextPlatform        	= mod:NewTimer(30, "NextPlatform", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp")
local berserkTimer				= mod:NewTimer(720, "Berserk", 26662)
local timerAlarUp				= mod:NewTimer(30, "AlarUp", "Interface\\Icons\\Spell_Fire_Fireball02")
local timerAlarDive				= mod:NewTimer(10, "AlarDive", "Interface\\Icons\\Spell_Fire_Fireball02")
local timerEmberSpawn			= mod:NewTimer(12, "TimerEmberSpawn", 2135208)  --heroic 2135209 , Ascended 10Man-2135210, 25Man-2135211
local timerNextBreath			= mod:NewNextTimer(10, 2135154)  --Heroic 2135155 , Ascended 10Man-2135156, 25Man-2135157
local timerNextAlarRebirth		= mod:NewNextTimer(10, 2135200)
local timerNextFlameCascade		= mod:NewNextTimer(60, 2135190)
local timerFlameCascade			= mod:NewBuffActiveTimer(17, 2135190)

--Ascended mechanics:
--Living bomb?

-- local variables


-- local options


function mod:OnCombatStart(delay)
	self.vb.phase = 1
	berserkTimer:Start(-delay)
	timerNextPlatform:Start()
	timerEmberSpawn:Start(40-delay)
	timerNextBreath:Start(-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2135190) then
		timerFlameCascade:Start()
		timerEmberSpawn:Cancel()
		warnFlameCascade:Show()
	elseif args:IsSpellID(2135186, 2135187, 2135188, 2135189) and args:IsPlayer() then
		warnBurningGround:Show()
	elseif args:IsSpellID(2135174) and args:IsPlayer() then
		warnFeather:Schedule(45)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(2135190) then
		timerEmberSpawn:Start()
		timerNextFlameCascade:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2135154, 2135155, 2135156, 2135157) and self.vb.phase ~= 3 then
		timerNextBreath:Start()
	elseif args:IsSpellID(2135196, 2135197, 2135198, 2135199) then
		if self.vb.phase == 1 then
		self.vb.phase = 2
		timerAlarUp:Start(40)
		timerNextAlarRebirth:Start()
		timerNextBreath:Stop()
		elseif self.vb.phase ==2 then
			self.vb.phase = 3
			timerNextAlarRebirth:Start()
			timerNextBreath:Stop()
		end	
	end

end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2135200, 2135201, 2135202, 2135203) then
		warnAlarRebirth:Show()
		timerNextBreath:Start(3)
	elseif args:IsSpellID(2135208, 2135209, 2135210, 2135211) then
		warnEmber:Show()
		if (self.vb.phase == 1 or self.vb.phase == 2) then
			timerEmberSpawn:Start(30)
		else
			timerEmberSpawn:Start(10)
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L.EmoteAlarUp or msg:find(L.EmoteAlarUp) then
		timerAlarDive:Start()
		timerEmberSpawn:Start(22)
		warnDive:Schedule(11)
	elseif msg == L.EmotePhase3 or msg:find(L.EmotePhase3) then
		timerEmberSpawn:start(22)
		timerNextFlameCascade:Start()
	end
end

function mod:UNIT_DIED(unit)
    local name = UnitName(unit);
    if (name == "Egg of Al'ar") and self.vb.phase == 1 then
		timerNextPlatform:Start(25)
	end
end


-- Old Alar code

-- local warnPhase = false;
-- local phase2	= false;
-- local lastAdd	= 0;
-- local flying	= false;
-- local langError	= false;
-- local lastMeteor= 0;

-- Alar:RegisterEvents(
-- 	"SPELL_AURA_APPLIED"	
-- );


-- Alar:AddOption("WarnArmor", true, DBM_ALAR_OPTION_MELTARMOR);
-- Alar:AddOption("Meteor", true, DBM_ALAR_OPTION_METEOR);

-- Alar:AddBarOption("Enrage")
-- Alar:AddBarOption("Meteor")
-- Alar:AddBarOption("Melt Armor: (.*)")

-- function Alar:OnCombatStart(delay)	
-- 	warnPhase = false;
-- 	phase2	= false;
-- 	lastAdd	= 0;
-- 	flying = false;
-- 	langError = false;
-- 	self:StartStatusBarTimer(35 - delay, "Next Platform", "Interface\\AddOns\\DBM_API\\Textures\\CryptFiendUnBurrow");
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
-- 		warnPhase = false;
-- 		phase2 = GetTime();
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
-- 		flying = false;
-- 		self:StartStatusBarTimer(35, "Next Platform", "Interface\\AddOns\\DBM_API\\Textures\\CryptFiendUnBurrow");
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
