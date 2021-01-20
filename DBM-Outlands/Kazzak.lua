-- Kazzak:RegisterEvents(
-- 	"SPELL_AURA_APPLIED",
-- 	"CHAT_MSG_MONSTER_YELL",
-- 	"CHAT_MSG_MONSTER_EMOTE"
-- );

local mod		= DBM:NewMod("Kazzak", "DBM-Outlands")
local L			= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 163 $"):sub(12, -3))
mod:SetCreatureID(18728)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL",
	"CHAT_MSG_MONSTER_EMOTE",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_SUCCESS"
)

local WarnEnrageSoon	= mod:NewSoonAnnounce(32964, 2) 
local WarnEnrage		= mod:NewSpellAnnounce(32964, 2) 
local WarnThunderclap	= mod:NewSpellAnnounce(36706, 3)
local WarnMark			= mod:NewTargetAnnounce(32960, 3)
local WarnMarkYou		= mod:NewSpecialWarningYou(32960, true)
local WarnTwisted		= mod:NewTargetAnnounce(21063, 3)
local WarnTwistedYou	= mod:NewSpecialWarningYou(21063, true)
-- local WarnShadowBolt	= mod:NewCastAnnounce(32963, 3)

local TimerNextShadowBolt	= mod:NewCDTimer(4, 32963)
local TimerNextThunderclap	= mod:NewNextTimer(12, 36706)
local TimerNextMark			= mod:NewNextTimer(20, 32960)
local TimerNextTwisted		= mod:NewNextTimer(30, 21063)

-- local TimerShadowBoltCD	= mod:NewCDTimer(20, 32963)
local TimerMark			= mod:NewTargetTimer(10, 32960)
local TimerTwisted		= mod:NewTargetTimer(15, 21063)
local TimerEnrage		= mod:NewBerserkTimer(30, "Berserk Shadowbolt Volley", "Berserk Shadowbolt Volley", nil, 32964)

mod:SetUsedIcons(8)

mod:AddBoolOption(L.KazzakIcon)
mod:AddBoolOption(L.KazzakWhisper, false)
-- local Whisper			= mod:NewAnnounce("Giant Boulder soon", 3, "Interface\\Icons\\inv_stone_10")


-- Kazzak:AddOption("EnrageWarn", true, DBM_KAZZAK_OPTION_1);
-- Kazzak:AddOption("TwistedWarn", true, DBM_KAZZAK_OPTION_2);
-- Kazzak:AddOption("MarkWarn", true, DBM_KAZZAK_OPTION_3);
-- Kazzak:AddOption("Icon", true, DBM_KAZZAK_OPTION_4);
-- Kazzak:AddOption("Whisper", false, DBM_KAZZAK_OPTION_5);

-- Kazzak:AddBarOption("Enrage")
-- Kazzak:AddBarOption("Mark of Kazzak")

function mod:EnrageRepeat()
	TimerEnrage:Stop()
	self:Unschedule("WarnEnrageSoon")

	TimerEnrage:Start(-6)
	WarnEnrageSoon:Schedule(30-6)
end

function mod:OnCombatStart(delay)
	if (GetTime() - LastPull) < 20 then
		delay = GetTime() - LastPull; -- use more accurate delay if possible
	end
	TimerEnrage:Start(60-delay)
	WarnEnrageSoon:Schedule(55-delay)
	TimerNextShadowBolt:Start(6)
	TimerNextThunderclap:Start(16)
	TimerNextMark:Start(24)
	TimerNextTwisted:Start(32)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(32963) then
		TimerNextShadowBolt:Start()
	elseif args:IsSpellID(36706) then
		WarnThunderclap:Show()
		TimerNextThunderclap:Start()
	elseif args:IsSpellID(32960) then
		TimerNextMark:Start()
	elseif args:IsSpellID(21063) then
		TimerNextTwisted:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(21063) then
		if args.destName == UnitName("player") then 
			WarnTwistedYou:Show()
		end
		WarnTwisted:Show(args.destName)
		TimerTwisted:Start(args.destName)
	elseif args:IsSpellID(32960) then
		-- local target = tostring(args.destName)
		if args.destName == UnitName("player") then 
			WarnMarkYou:Show()
		else
			if self.Options.KazzakWhisper and DBM:GetRaidRank() >= 1 then
				SendChatMessage(L.DBM_KAZZAK_MARK_SPEC_WARN, "WHISPER", "COMMON", args.destName)
				-- self:sendWhisper(target, DBM_KAZZAK_MARK_SPEC_WARN);
			end
		end
		WarnMark:Show(args.destName)
		TimerMark:Start(args.destName)
		if self.Options.KazzakIcon then
			self:SetIcon(args.destName, 8, 10)
		end
	elseif args:IsSpellID(32964) then
		WarnEnrage:Show()
		mod:EnrageRepeat()
		-- self:ScheduleMethod(6,"EnrageRepeat");
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(21063) then
		TimerTwisted:Stop(args.destName)
	elseif args:IsSpellID(32960) then
		TimerMark:Stop(args.destName)
		if self.Options.KazzakIcon then
			self:RemoveIcon(args.destName);
		end
	-- elseif args:IsSpellID(32964) then
	-- 	WarnEnrage:Show()
	-- 	-- self:ScheduleMethod(6,"EnrageRepeat");
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if arg1 == DBM_KAZZAK_YELL_PULL or arg1 == DBM_KAZZAK_YELL_PULL2 then
		LastPull = GetTime();
	end
end

-- function mod:CHAT_MSG_MONSTER_EMOTE(msg)
-- 	if arg1 == DBM_KAZZAK_EMOTE_ENRAGE and arg2 == DBM_KAZZAK_NAME then
-- 		mod:EnrageRepeat()
-- 		-- self:ScheduleMethod(6,"EnrageRepeat");
-- 	end
-- end


-- function Kazzak:OnCombatStart(delay) -- I don't want to use the yell for start detection because this would trigger the boss mod every time someone pulls Kazzak while you are in hellfire peninsula
-- 	if (GetTime() - self.LastPull) < 20 then
-- 		delay = GetTime() - self.LastPull; -- use more accurate delay if possible
-- 	end
-- 	local enrageTimer = 56;
-- 	self:StartStatusBarTimer(enrageTimer - delay, "Enrage", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy"); -- ?
-- 	self:ScheduleSelf(enrageTimer - 45 - delay, "EnrageWarn", 45);
-- 	self:ScheduleSelf(enrageTimer - 30 - delay, "EnrageWarn", 30);
-- 	self:ScheduleSelf(enrageTimer - 15 - delay, "EnrageWarn", 15);
-- 	self:ScheduleSelf(enrageTimer - 5 - delay, "EnrageWarn", 5);
-- end

-- function Kazzak:OnEvent(event, arg1)
-- 	if event == "SPELL_AURA_APPLIED" then
-- 		if arg1.spellId == 21063 then
-- 			-- if self.Options.TwistedWarn then
-- 			-- 	self:Announce(string.format(DBM_KAZZAK_TWISTED_WARN, tostring(arg1.destName)))
-- 			-- end
			
-- 		elseif arg1.spellId == 32960 then
-- 			local target = tostring(arg1.destName)
-- 			if target == UnitName("player") then
-- 				self:AddSpecialWarning(DBM_KAZZAK_MARK_SPEC_WARN);
-- 				self:StartStatusBarTimer(8, "Mark of Kazzak", "Interface\\Icons\\Spell_Shadow_AntiShadow", true);
-- 			elseif self.Options.Whisper and target then
-- 				self:SendHiddenWhisper(DBM_KAZZAK_MARK_SPEC_WARN, target);
-- 			end
-- 			if target and self.Options.MarkWarn then
-- 				self:Announce(string.format(DBM_KAZZAK_MARK_WARN, target))
-- 			end
-- 			if target and self.Options.Icon then
-- 				self:SetIcon(target, 8);
-- 			end
-- 		end
-- 	elseif event == "CHAT_MSG_MONSTER_YELL" then
-- 		if arg1 == DBM_KAZZAK_YELL_PULL or arg1 == DBM_KAZZAK_YELL_PULL2 then
-- 			self.LastPull = GetTime();
-- 		end
		
-- 	elseif event == "CHAT_MSG_MONSTER_EMOTE" then
-- 		if arg1 == DBM_KAZZAK_EMOTE_ENRAGE and arg2 == DBM_KAZZAK_NAME then
-- 			if self.Options.EnrageWarn then
-- 				self:Announce(DBM_KAZZAK_WARN_ENRAGE);
-- 			end
-- 			self:ScheduleSelf(6, "NextEnrage");
-- 		end
		
-- 	elseif event == "EnrageWarn" and arg1 then
-- 		if self.Options.EnrageWarn then
-- 			if arg1 == 5 then
-- 				self:Announce(DBM_KAZZAK_SUP_SOON);
-- 			else
-- 				self:Announce(string.format(DBM_KAZZAK_SUP_SEC, arg1));
-- 			end
-- 		end
	
-- 	elseif event == "NextEnrage" then
-- 		self:StartStatusBarTimer(54, "Enrage", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy");
-- 		self:ScheduleSelf(9, "EnrageWarn", 45);
-- 		self:ScheduleSelf(24, "EnrageWarn", 30);
-- 		self:ScheduleSelf(39, "EnrageWarn", 15);
-- 		self:ScheduleSelf(49, "EnrageWarn", 5);
-- 	end
-- end