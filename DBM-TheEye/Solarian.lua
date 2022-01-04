local mod	= DBM:NewMod("Solarian", "DBM-TheEye", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(18805)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_SUCCESS",
	"SPELL_CAST_START"
)


-- local warn
local specWarnHeal			= mod:NewSpecialWarningInterupt(2135264) --Heroic and ascended : 2135265
local specWarnAdds			= mod:NewSpecialWarning("SpecWarnAdds")
local specWarnLunar			= mod:NewSpecialWarning("SpecWarnLunar") --Heroic: 2135279 ,Ascended 10Man: 2135280 , 25Man: 2135281
local specWarnSolar			= mod:NewSpecialWarningMove(2135292) --Heroic: 2135293, Ascended 10Man: 2135294 , 25Man: 2135295
local specWarnFireL			= mod:NewSpecialWarningSpell(2135230) --Heroic: 2135231, Ascended 10Man: 2135232, 25Man: 2135233
local specWarnFireS			= mod:NewSpecialWarningSpell(2135234) --Heroic: 2135235, Ascended 10Man: 2135236 , 25Man: 2135237
local specWarnFinishAdd		= mod:NewSpecialWarning("SpecWarnFinishAdd")
local specWarnVoidSpawn		= mod:NewSpecialWarning("SpecWarnVoidSpawn")

-- local timer
local timerNextFireL        = mod:NewNextTimer(10,2135230)
local timerNextFireS		= mod:NewNextTimer(10,2135234)
local timerAdds				= mod:NewTimer(15,"TimerAdds","Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp")
local timerNextLunar		= mod:NewNextTimer(15,2135278)
local timerNextSolar		= mod:NewNextTimer(15,2135292)
local timerNextLWrathPop	= mod:NewNextTimer(10,"TimerNextLWrathPop",2135278)
local timerNextSWrathPop	= mod:NewNextTimer(10,"TimerNextSWrathPop",2135292)
local timerNextVoidSpawn	= mod:NewNextTimer(20)

-- local variables
local lastPriestDied = ""

-- local options
mod:AddBoolOption(L.WrathYellOpt)


function mod:OnCombatStart(delay)
	self.vb.phase = 1
	timerNextFireS:Start(-delay)
	timerAdds:Start(-delay)

end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.SolarianYellAddPhase or msg:find(L.SolarianYellAddPhase) then
		timerNextFireL:Stop()
		timerNextFireS:Stop()
		self.vb.phase = 2
		if lastPriestDied ~= "" then
			if lastPriestDied == "Solarian Priest" then
				if DBM.GetRaidRank() == 2 then
					SetRaidTarget("Lunarian Priest", 8)
				end
				specWarnAdds:Show("Lunarian Priest")
			elseif lastPriestDied == "Lunarian Priest" then
				if DBM.GetRaidRank() == 2 then
					SetRaidTarget("Solarian Priest", 8)
				end
				specWarnAdds:Show("Solarian Priest")
			end
		else specWarnAdds:Show("Whichever Priest")
		end
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2135278, 2135279, 2135280, 2135281) then
		timerNextLunar:Start()
		timerNextLWrathPop:Start()
		if args:IsPlayer() then
			 if self.Options.WrathYellOpt then
				SendChatMessage(L.LunarWrathYell, "YELL")
			end
		else specWarnLunar:Show()
		end
	elseif args:IsSpellID(2135292, 2135293, 2135294, 2135295) then
		timerNextSolar:Start()
		timerNextSWrathPop:Start()
		if args:IsPlayer() then
			if self.Options.WrathYellOpt then
				SendChatMessage(L.SolarWrathYell, "Yell")
			end
		else specWarnSolar:Show()
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(2135230, 2135231, 2135232, 2135233) then
		timerNextFireL:Start()
		specWarnFireL:Show(args.amount)
		if args.amount == 3 then
			specWarnFinishAdd:Show()
		end
	elseif args:IsSpellID(2135234, 2135235, 2135236, 2135237) then
		timerNextFireS:Start()
		specWarnFireS:Show(args.amount)
		if args.amount == 3 then
			specWarnFinishAdd:Show()
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2135264) then
		specWarnHeal:Show()
	elseif args:IsSpellID(2135260) then
		self.vb.phase = 3
		timerNextFireL:Stop()
		timerNextFireS:Stop()
		timerNextSolar:Stop()
		timerNextLunar:Stop()
		timerNextLWrathPop:Stop()
		timerNextSWrathPop:Stop()
		self:ScheduleMethod(20,"SolarianVoidspawn")
		timerNextVoidSpawn:Start()
	end
	
end

function mod:SPELL_CAST_SUCCESS(args)
	
end

function mod:UNIT_DIED(unit)
    local name = UnitName(unit);
    if name == "Solarian Priest" and self.vb.phase == 2 then
		lastPriestDied = name
		self.vb.phase = 1
		timerNextLunar:Start()
		timerNextFireL:Start()
	elseif name == "Lunarian Priest" and self.vb.phase == 2 then
		lastPriestDied = name
		self.vb.phase = 1
		timerNextSolar:Start()
		timerNextFireS:Start()
	end
end


function mod:OnCombatEnd()

end

function mod:SolarianVoidspawn()
	specWarnVoidSpawn:Show()
	if DBM:GetRaidRank() == 2 then
		SetRaidTarget("Solarian Voidspawn", 8)
	end
	timerNextVoidSpawn:Start()
	self:ScheduleMethod(20,"SolarianVoidspawn")
end

-- Old Solarian DBM Code


-- local warnPhase = false;
-- local split = false

-- Solarian:RegisterEvents(
-- 	"SPELL_CAST_START",
-- 	"SPELL_AURA_APPLIED",
-- 	"CHAT_MSG_MONSTER_YELL"
-- );

-- Solarian:SetCreatureID(18805)
-- Solarian:RegisterCombat("combat")

-- Solarian:AddOption("WarnWrath", true, DBM_SOLARIAN_OPTION_WARN_WRATH);
-- Solarian:AddOption("IconWrath", true, DBM_SOLARIAN_OPTION_ICON_WRATH);
-- Solarian:AddOption("SpecWrath", true, DBM_SOLARIAN_OPTION_SPECWARN_WRATH);
-- Solarian:AddOption("SoundWarning", false, DBM_SOLARIAN_OPTION_SOUND);
-- Solarian:AddOption("WhisperWrath", true, DBM_SOLARIAN_OPTION_WHISPER_WRATH);
-- Solarian:AddOption("WarnPhase", true, DBM_SOLARIAN_OPTION_WARN_PHASE);

-- Solarian:AddBarOption("Wrath: (.*)")
-- Solarian:AddBarOption("Split")
-- Solarian:AddBarOption("Agents")
-- Solarian:AddBarOption("Priests & Solarian")

-- function Solarian:OnCombatStart(delay)	
-- 	warnPhase = false;
-- 	split = false
-- 	self:ScheduleSelf(15, "CheckBack"); -- to prevent bugs if you are using an unsupported client language...
	
-- 	self:StartStatusBarTimer(50 - delay, "Split", "Interface\\Icons\\Spell_Holy_SummonLightwell");
-- 	if self.Options.WarnPhase then
-- 		self:ScheduleSelf(45 - delay, "SplitWarn");
-- 	end
-- end

-- function Solarian:OnCombatEnd()
-- 	split = false
-- end

-- local splitIds = {
-- 	[33189] = true,
-- 	[33281] = true,
-- 	[33282] = true,
-- 	[33347] = true,
-- 	[33348] = true,
-- 	[33349] = true,
-- 	[33350] = true,
-- 	[33351] = true,
-- 	[33352] = true,
-- 	[33353] = true,
-- 	[33354] = true,
-- 	[33355] = true,
-- }

-- function Solarian:OnEvent(event, arg1)
-- 	if event == "SPELL_AURA_APPLIED" then
-- 		if arg1.spellId == 42783 then
-- 			self:SendSync("Wrath"..tostring(arg1.destName));
-- 		end
-- 	elseif event == "SPELL_CAST_START" then
-- 		if arg1.spellId and splitIds[arg1.spellId] then -- wtf?
-- 			self:SendSync("Split");
-- 		end
-- 	elseif event == "CHAT_MSG_MONSTER_YELL" and arg1 then
-- 		if string.find(arg1, DBM_SOLARIAN_YELL_ENRAGE) then
-- 			self:Announce(DBM_SOLARIAN_ANNOUNCE_ENRAGE_PHASE, 3);
-- 			warnPhase = false;
-- 			self:EndStatusBarTimer("Split");
-- 			self:UnScheduleSelf("SplitWarn");
-- 			self:UnScheduleSelf("CheckBack");
-- 		end
-- 	elseif event == "SplitWarn" then
-- 		self:Announce(DBM_SOLARIAN_ANNOUNCE_SPLIT_SOON, 2);
-- 	elseif event == "PriestsWarn" then
-- 		self:Announce(DBM_SOLARIAN_ANNOUNCE_PRIESTS_SOON, 2);
-- 	elseif event == "PriestsNow" then
-- 		self:Announce(DBM_SOLARIAN_ANNOUNCE_PRIESTS_NOW, 3);
-- 	elseif event == "AgentsNow" then
-- 		self:Announce(DBM_SOLARIAN_ANNOUNCE_AGENTS_NOW, 2);
-- 	elseif event == "CheckBack" then
-- 		for i = 1, GetNumRaidMembers() do
-- 			if UnitName("raid"..i.."target") == DBM_SOLARIAN_NAME and UnitAffectingCombat("raid"..i.."target") then -- to prevent false positives after wipes
-- 				warnPhase = true;
-- 				break;
-- 			end
-- 		end
-- 	elseif event == "ResetSplit" then
-- 		split = false
-- 	end
-- end


-- function Solarian:OnSync(msg)
-- 	if string.sub(msg, 1, 5) == "Wrath" then
-- 		local target = string.sub(msg, 6);
-- 		if target then
-- 			if target == UnitName("player") then
-- 			   if self.Options.SpecWrath then 
-- 				  self:AddSpecialWarning(DBM_SOLARIAN_SPECWARN_WRATH); 
-- 			   end 
-- 			   if self.Options.SoundWarning then 
-- 				  PlaySoundFile("Sound\\Spells\\PVPFlagTaken.wav"); 
-- 				  PlaySoundFile("Sound\\Creature\\HoodWolf\\HoodWolfTransformPlayer01.wav");
-- 			   end 
-- 			end
-- 			if self.Options.WarnWrath then
-- 				self:Announce(string.format(DBM_SOLARIAN_ANNOUNCE_WRATH, target), 1);
-- 			end
-- 			if self.Options.IconWrath then
-- 				self:SetIcon(target, 6);
-- 			end
-- 			if self.Options.WhisperWrath then
-- 				self:SendHiddenWhisper(DBM_SOLARIAN_SPECWARN_WRATH, target)
-- 			end
-- 			self:StartStatusBarTimer(6, "Wrath: "..target, "Interface\\Icons\\Spell_Arcane_ArcaneTorrent")
-- 		end
		
-- 	elseif msg == "Split" then
-- 		split = true
-- 		if self.Options.WarnPhase then
-- 			self:Announce(DBM_SOLARIAN_ANNOUNCE_SPLIT, 3);
-- 			self:ScheduleSelf(6, "AgentsNow");
-- 			self:ScheduleSelf(17, "PriestsWarn");
-- 			self:ScheduleSelf(22, "PriestsNow");
-- 			self:ScheduleSelf(85, "SplitWarn");
-- 		end		
-- 		self:StartStatusBarTimer(90, "Split", "Interface\\Icons\\Spell_Holy_SummonLightwell");
-- 		self:StartStatusBarTimer(22.5, "Priests & Solarian", "Interface\\Icons\\Spell_Holy_Renew");
-- 		self:StartStatusBarTimer(6.5, "Agents", "Interface\\Icons\\Spell_Holy_AuraMastery");
-- 		self:ScheduleEvent(50, "ResetSplit")
-- 	end
-- end

-- function Solarian:OnUpdate(elapsed) -- this can be used to detect the phase if nobody was in range after her teleport
-- 	if not split and self.InCombat then
-- 		local foundIt;
-- 		for i = 1, GetNumRaidMembers() do
-- 			if UnitName("raid"..i.."target") == DBM_SOLARIAN_NAME then
-- 				foundIt = true;
-- 				break;
-- 			end
-- 		end
-- 		if not foundIt and warnPhase then
-- 			self:SendSync("Split");
-- 			warnPhase = false;
-- 			self:ScheduleSelf(45, "CheckBack");
-- 		end
-- 	end
-- end
