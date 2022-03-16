local mod	= DBM:NewMod("VoidReaver", "DBM-TheEye", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(19516)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_SUCCESS"
)

-- local warn
local warnPounding			= mod:NewSpellAnnounce(2135296, 3)
local warnDismantle			= mod:NewTargetAnnounce(2135333, 3)
local warnEradication		= mod:NewSpecialWarningYou(21352325)

-- local timer
local timerNextEnrage		= mod:NewNextTimer(120, 2135312)
local timerNextPounding		= mod:NewNextTimer(60, 2135296)
local timerNextDismantle	= mod:NewNextTimer(15, 2135333)

local timerPounding			= mod:NewCastTimer(20, 2135296)
local timerDismantle		= mod:NewTargetTimer(15, 2135333)

function mod:OnCombatStart(delay)
	timerNextEnrage:Start(-delay)
	timerNextPounding:Start(40-delay)
	timerNextDismantle:Start(15-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2135501) then -- [Maintenance Mode]
		timerNextEnrage:Stop()
		timerNextEnrage:Start()
	elseif args:IsSpellID(2135324, 2135325, 2135326, 2135327) and args:IsPlayer() then
		warnEradication:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2135296) then     
		warnPounding:Show()
		timerPounding:Start()
		timerNextPounding:Start()
	elseif args:IsSpellID(2135296) then
		warnDismantle:Show(args.destName)
		timerDismantle:Start(args.destName)
	end
end

function mod:OnCombatEnd()

end

-- Old VoidReaver Code

-- local lastTarget = nil;

-- VoidReaver:RegisterEvents(
-- 	"UNIT_SPELLCAST_CHANNEL_START",
-- 	"SPELL_CAST_SUCCESS"
-- );

-- VoidReaver:SetCreatureID(19516)
-- VoidReaver:RegisterCombat("combat")

-- VoidReaver:AddOption("WarnOrb", false, DBM_VOIDREAVER_OPTION_WARN_ORB);
-- VoidReaver:AddOption("YellOrb", true, DBM_VOIDREAVER_OPTION_YELL_ORB);
-- VoidReaver:AddOption("SoundWarning", false, DBM_VOIDREAVER_OPTION_SOUND);
-- VoidReaver:AddOption("IconOrb", false, DBM_VOIDREAVER_OPTION_ORB_ICON);
-- VoidReaver:AddOption("WarnPounding", true, DBM_VOIDREAVER_OPTION_WARN_POUNDING);
-- VoidReaver:AddOption("WarnPoundingSoon", true, DBM_VOIDREAVER_OPTION_WARN_POUNDINGSOON);

-- VoidReaver:AddBarOption("Enrage")
-- VoidReaver:AddBarOption("Next Pounding")
-- VoidReaver:AddBarOption("Pounding")

-- function VoidReaver:OnCombatStart(delay)

-- 	self:StartStatusBarTimer(600 - delay, "Enrage", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy");
-- 	self:ScheduleSelf(300 - delay, "EnrageWarn", 300);
-- 	self:ScheduleSelf(480 - delay, "EnrageWarn", 120);
-- 	self:ScheduleSelf(540 - delay, "EnrageWarn", 60);
-- 	self:ScheduleSelf(570 - delay, "EnrageWarn", 30);
-- 	self:ScheduleSelf(590 - delay, "EnrageWarn", 10);
	
-- 	self:StartStatusBarTimer(13 - delay, "Next Pounding", "Interface\\Icons\\Ability_ThunderClap");
-- 	self:ScheduleSelf(8 - delay, "PoundingWarn");
-- end

-- function VoidReaver:OnEvent(event, arg1)
-- 	if event == "UNIT_SPELLCAST_CHANNEL_START" and type(arg1) == "string" and UnitName(arg1) == DBM_VOIDREAVER_NAME then
-- 		if UnitChannelInfo(arg1) == DBM_VOIDREAVER_POUNDING then
-- 			self:SendSync("Pounding");
-- 		end
		
-- 	elseif event == "PoundingWarn" then
-- 		if self.Options.WarnPoundingSoon then
-- 			self:Announce(DBM_VOIDREAVER_WARN_POUNDING_SOON, 2);
-- 		end
		
-- 	elseif event == "EnrageWarn" and type(arg1) == "number" then
-- 		if arg1 >= 60 then
-- 			self:Announce(string.format(DBM_VOIDREAVER_WARN_ENRAGE, (arg1/60), DBM_MIN), 1);
-- 		else
-- 			self:Announce(string.format(DBM_VOIDREAVER_WARN_ENRAGE, arg1, DBM_SEC), 3);
-- 		end
-- 	elseif event == "SPELL_CAST_SUCCESS" then
-- 		if arg1.spellId == 34172 then
-- 			self:OnArcaneOrb(arg1.destName)
-- 		end
-- 	end
-- end



-- function VoidReaver:OnArcaneOrb(target)
-- 	if type(target) ~= "string" or string.find(target, " ") then -- to filter out "Arcane Orb Target"....(wtf?)
-- 		return;
-- 	end
	
	
-- 	if target == UnitName("player") then
-- 		if self.Options.YellOrb then
-- 			SendChatMessage(DBM_VOIDREAVER_YELL_ORB, "SAY");
-- 		end
-- 		self:AddSpecialWarning(DBM_VOIDREAVER_SPECWARN_ORB);
-- 		if self.Options.SoundWarning then
-- 			PlaySoundFile("Sound\\Spells\\PVPFlagTaken.wav"); 
-- 			PlaySoundFile("Sound\\Creature\\HoodWolf\\HoodWolfTransformPlayer01.wav");
-- 		end 
-- 	end
	

-- 	if self.Options.IconOrb then
-- 		self:SetIcon(target)
-- 	end
	
-- 	if self.Options.WarnOrb then
-- 		self:Announce(string.format(DBM_VOIDREAVER_WARN_ORB, target), 1)
-- 	end
-- end

-- function VoidReaver:OnSync(msg)
-- 	if msg == "Pounding" then
-- 		self:StartStatusBarTimer(14, "Next Pounding", "Interface\\Icons\\Ability_ThunderClap");
-- 		self:StartStatusBarTimer(3, "Pounding", "Interface\\Icons\\Ability_ThunderClap");
-- 		self:ScheduleSelf(9, "PoundingWarn");
-- 		if self.Options.WarnPounding then
-- 			self:Announce(DBM_VOIDREAVER_WARN_POUNDING, 3);
-- 		end
-- 	end
-- end
