local mod	= DBM:NewMod("Council", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5019 $"):sub(12, -3))
mod:SetCreatureID(22949)
mod:RegisterCombat("yell", DBM_COUNCIL_YELL_PULL1, DBM_COUNCIL_YELL_PULL2, DBM_COUNCIL_YELL_PULL3, DBM_COUNCIL_YELL_PULL4)

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_HEAL",
	"SPELL_INTERRUPT",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED"
)

--Lady Malande
local warnPaintoPleasure			= mod:NewTargetAnnounce(2144463, 3)
local timerNextPaintoPleasure		= mod:NewNextTimer(30, 2144463)
local warnSadism					= mod:NewSpellAnnounce(2144464, 3)
local timerNextSadism				= mod:NewNextTimer(60, 2144464)

--Veras Darkshadow
local warnSmokeBomb					= mod:NewTargetAnnounce(2144560, 3)
local timerNextSmokeBomb			= mod:NewNextTimer(60, 2144560)

--Gathios the Shatterer
local timerNextDeathSentence		= mod:NewNextTimer(60, 2144260)
local timerDeathSentence			= mod:NewBuffActiveTimer(10, 2144260, nil, false)
local timerNextConsecrate			= mod:NewNextTimer(15, 2144256, nil, false)

--High Nethermancer Zerevor
local timerNextRuneofPower			= mod:NewNextTimer(60, 2144368)
local warnNetherprotection			= mod:NewSpellAnnounce(2144351, 3)
local timerNextNetherProtection		= mod:NewNextTimer(30, 2144351)


function mod:OnCombatStart(delay)
	timerNextPaintoPleasure:Start(25-delay)
	timerNextSmokeBomb:Start(33-delay)
	timerNextDeathSentence:Start(15-delay)
	timerNextConsecrate:Start(10-delay)
	timerNextRuneofPower:Start(45-delay)
	timerNextSadism:Start(60-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2144560, 2144610) and DBM:AntiSpam(20, 1) then
		warnSmokeBomb:Show()
		timerNextSmokeBomb:Start()
	elseif args:IsSpellID(2144560, 2144261, 2144262, 2144263) or
		args:IsSpellID(2144264, 2144265, 2144266, 2144267) or
		args:IsSpellID(2144268, 2144310, 2144311, 2144313) or
		args:IsSpellID(2144315, 2144316, 2144317, 2144318) then
		timerNextDeathSentence:Start()
		timerDeathSentence:Start()
	elseif args:IsSpellID(2144256) then
		timerNextConsecrate:Start()
	elseif args:IsSpellID(2144368, 2144418) and DBM:AntiSpam(20, 1) then
		timerNextRuneofPower:Start()
	elseif args:IsSpellID(2144351, 2144401) then
		warnNetherprotection:Show()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(2144351, 2144401) then
		timerNextNetherProtection:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2144462, 2144463, 2144512, 2144513) then
		warnPaintoPleasure:Show()
		timerNextPaintoPleasure:Start()
		--when rogue splits, 22951 is fake 22952 is real.
	elseif args:IsSpellID(2144464, 2144465, 2144466, 2144467) or args:IsSpellID(2144514, 2144515, 2144516, 2144517) then
		warnSadism:Show()
		timerNextSadism:Start()
	end
end

--Council:AddOption("WarnCoH", true, DBM_COUNCIL_OPTION_COH)
--Council:AddOption("WarnDP", true, DBM_COUNCIL_OPTION_DP)
--Council:AddOption("WarnDW", false, DBM_COUNCIL_OPTION_DW)
--Council:AddOption("WarnVanish", true, DBM_COUNCIL_OPTION_VANISH)
--Council:AddOption("WarnVanishFade", true, DBM_COUNCIL_OPTION_VANISHFADED)
--Council:AddOption("WarnVanishFadeSoon", true, DBM_COUNCIL_OPTION_VANISHFADESOON)
--Council:AddOption("WarnShieldNormal", true, DBM_COUNCIL_OPTION_SN)
--Council:AddOption("WarnShieldSpell", true, DBM_COUNCIL_OPTION_SS)
--Council:AddOption("WarnShieldMelee", true, DBM_COUNCIL_OPTION_SM)
--Council:AddOption("WarnDevAura", true, DBM_COUNCIL_OPTION_DEVAURA)
--Council:AddOption("WarnResAura", true, DBM_COUNCIL_OPTION_RESAURA)

--Council:AddBarOption("Enrage")
--Council:AddBarOption("Circle of Healing")
--Council:AddBarOption("Next Circle of Healing")
--Council:AddBarOption("Divine Wrath") 
--Council:AddBarOption("Reflective Shield")
--Council:AddBarOption("Vanish")
--Council:AddBarOption("Devotion Aura")
--Council:AddBarOption("Resistance Aura")
--Council:AddBarOption("Spell Shield: (.*)")
--Council:AddBarOption("Melee Shield: (.*)")

-- self:StartStatusBarTimer(900 - delay, "Enrage", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")	
-- self:ScheduleAnnounce(300 - delay, DBM_GENERIC_ENRAGE_WARN:format(10, DBM_MIN), 1)
-- self:ScheduleAnnounce(600 - delay, DBM_GENERIC_ENRAGE_WARN:format(5, DBM_MIN), 1)
-- self:ScheduleAnnounce(720 - delay, DBM_GENERIC_ENRAGE_WARN:format(3, DBM_MIN), 1)
-- self:ScheduleAnnounce(840 - delay, DBM_GENERIC_ENRAGE_WARN:format(1, DBM_MIN), 2)
-- self:ScheduleAnnounce(870 - delay, DBM_GENERIC_ENRAGE_WARN:format(30, DBM_SEC), 3)
-- self:ScheduleAnnounce(890 - delay, DBM_GENERIC_ENRAGE_WARN:format(10, DBM_SEC), 4)


-- function Council:OnEvent(event, args)
-- 	if event == "SPELL_CAST_START" then
-- 		if args.spellId == 41455 then
-- 			self:SendSync("CoHCast")
-- 		elseif args.spellId == 41472 then
-- 			self:SendSync("DWCast")
-- 		end
-- 	elseif event == "SPELL_HEAL" then
-- 		if args.spellId == 41455 then
-- 			self:SendSync("CoHHeal")
-- 		end
-- 	elseif event == "SPELL_INTERRUPT" then
-- 		if args.extraSpellId == 41455 then
-- 			self:SendSync("CoHInterrupt")
-- 		end
-- 	elseif event == "SPELL_AURA_APPLIED" then
-- 		if args.spellId == 41485 then
-- 			self:SendSync("DP"..tostring(args.destName))
-- 		elseif args.spellId == 41472 then
-- 			self:SendSync("DW"..tostring(args.destName))
-- 		elseif args.spellId == 41476 then
-- 			self:SendSync("Vanish")
-- 		elseif args.spellId == 41475 then
-- 			self:SendSync("ShieldNormal")
-- 		elseif args.spellId == 41452 then
-- 			self:SendSync("DevAura")
-- 		elseif args.spellId == 41453 then
-- 			self:SendSync("ResAura")
-- 		elseif args.spellId == 41451 then
-- 			local target = args.destName
-- 			if target == DBM_COUNCIL_MOB_GATHIOS then
-- 				target = DBM_COUNCIL_MOB_GATHIOS_EN
-- 			elseif target == DBM_COUNCIL_MOB_MALANDE then
-- 				target = DBM_COUNCIL_MOB_MALANDE_EN
-- 			elseif target == DBM_COUNCIL_MOB_ZEREVOR then
-- 				target = DBM_COUNCIL_MOB_ZEREVOR_EN
-- 			elseif target == DBM_COUNCIL_MOB_VERAS then
-- 				target = DBM_COUNCIL_MOB_VERAS_EN
-- 			else
-- 				return
-- 			end
-- 			self:SendSync("Spellward"..target)
-- 		elseif args.spellId == 41450 then
-- 			local target = args.destName
-- 			if target == DBM_COUNCIL_MOB_GATHIOS then
-- 				target = DBM_COUNCIL_MOB_GATHIOS_EN
-- 			elseif target == DBM_COUNCIL_MOB_MALANDE then
-- 				target = DBM_COUNCIL_MOB_MALANDE_EN
-- 			elseif target == DBM_COUNCIL_MOB_ZEREVOR then
-- 				target = DBM_COUNCIL_MOB_ZEREVOR_EN
-- 			elseif target == DBM_COUNCIL_MOB_VERAS then
-- 				target = DBM_COUNCIL_MOB_VERAS_EN
-- 			else
-- 				return
-- 			end
-- 			self:SendSync("Protection"..target)
-- 		end
-- 	elseif event == "SPELL_AURA_REMOVED" then
-- 		if args.spellId == 41476 then
-- 			self:SendSync("FadeVanish")
-- 		end
-- 	elseif event == "VanishFadeSoon" then
-- 		if self.Options.WarnVanishFadeSoon then
-- 			self:Announce(DBM_COUNCIL_WARN_VANISHFADE_SOON, 3)
-- 		end
-- 	end
-- end

-- function Council:OnSync(msg)
-- 	if msg:sub(0, 9) == "Spellward" then
-- 		msg = msg:sub(10)
-- 		self:StartStatusBarTimer(15, "Spell Shield: "..msg, "Interface\\Icons\\Spell_Holy_SealOfRighteousness")
		
-- 		if self.Options.WarnShieldSpell then
-- 			if GetLocale():sub(0, 2) ~= "en" then
-- 				if msg == DBM_COUNCIL_MOB_GATHIOS_EN then
-- 					msg = DBM_COUNCIL_MOB_GATHIOS
-- 				elseif msg == DBM_COUNCIL_MOB_MALANDE_EN then
-- 					msg = DBM_COUNCIL_MOB_MALANDE
-- 				elseif msg == DBM_COUNCIL_MOB_ZEREVOR_EN then
-- 					msg = DBM_COUNCIL_MOB_ZEREVOR
-- 				elseif msg == DBM_COUNCIL_MOB_VERAS_EN then
-- 					msg = DBM_COUNCIL_MOB_VERAS
-- 				end
-- 			end
-- 			self:Announce(DBM_COUNCIL_WARN_SHIELD_SPELL:format(msg), 2)
-- 		end
		
-- 	elseif msg == "DWCast" then
-- 		self:StartStatusBarTimer(2, "Divine Wrath", "Interface\\Icons\\Spell_Holy_SearingLight")

-- 	elseif msg:sub(0, 10) == "Protection" and self.InCombat then
-- 		msg = msg:sub(11)
-- 		self:StartStatusBarTimer(15, "Melee Shield: "..msg, "Interface\\Icons\\Spell_Holy_SealOfProtection")
-- 		if self.Options.WarnShieldMelee then
-- 			if GetLocale():sub(0, 2) ~= "en" then
-- 				if msg == DBM_COUNCIL_MOB_GATHIOS_EN then
-- 					msg = DBM_COUNCIL_MOB_GATHIOS
-- 				elseif msg == DBM_COUNCIL_MOB_MALANDE_EN then
-- 					msg = DBM_COUNCIL_MOB_MALANDE
-- 				elseif msg == DBM_COUNCIL_MOB_ZEREVOR_EN then
-- 					msg = DBM_COUNCIL_MOB_ZEREVOR
-- 				elseif msg == DBM_COUNCIL_MOB_VERAS_EN then
-- 					msg = DBM_COUNCIL_MOB_VERAS
-- 				end
-- 			end
-- 			self:Announce(DBM_COUNCIL_WARN_SHIELD_MELEE:format(msg), 2)
-- 		end
-- 	elseif msg == "CoHCast" then
-- 		if self.Options.WarnCoH then
-- 			self:Announce(DBM_COUNCIL_WARN_CAST_COH, 4)
-- 		end
-- 		self:StartStatusBarTimer(2.5, "Circle of Healing", "Interface\\Icons\\Spell_Holy_CircleOfRenewal")
-- 	elseif msg == "CoHHeal" then
-- 		self:StartStatusBarTimer(19.5, "Next Circle of Healing", "Interface\\Icons\\Spell_Holy_CircleOfRenewal")
-- 	elseif msg == "CoHInterrupt" then
-- 		self:StartStatusBarTimer(14.5, "Next Circle of Healing", "Interface\\Icons\\Spell_Holy_CircleOfRenewal")
-- 	elseif msg:sub(0, 2) == "DP" and self.InCombat then
-- 		msg = msg:sub(3)
-- 		if self.Options.WarnDP then
-- 			self:Announce(DBM_COUNCIL_WARN_POISON:format(msg), 2)
-- 		end
-- 		self:SetIcon(msg, 8)
-- 	elseif msg:sub(0, 2) == "DW" then
-- 		msg = msg:sub(3)
-- 		if self.Options.WarnDW then
-- 			self:Announce(DBM_COUNCIL_WARN_WRATH:format(msg), 1)
-- 		end
-- 	elseif msg == "ShieldNormal" then
-- 		if self.Options.WarnShieldNormal then
-- 			self:Announce(DBM_COUNCIL_WARN_SHIELD_NORMAL, 3)
-- 		end
-- 		self:StartStatusBarTimer(20, "Reflective Shield", "Interface\\Icons\\Spell_Holy_PowerWordShield")

-- 	elseif msg == "Vanish" and self.Options.WarnVanish then
-- 		self:Announce(DBM_COUNCIL_WARN_VANISH, 1)
-- 		self:StartStatusBarTimer(31, "Vanish", "Interface\\Icons\\Ability_Vanish")
-- 		self:ScheduleEvent(26, "VanishFadeSoon")
-- 	elseif msg == "FadeVanish" and self.Options.WarnVanishFade then
-- 		self:Announce(DBM_COUNCIL_WARN_VANISH_FADED, 4)
-- 	elseif msg == "DevAura" then
-- 		if self.Options.WarnDevAura then
-- 			self:Announce(DBM_COUNCIL_WARN_AURA_DEV, 1)
-- 		end
-- 		self:StartStatusBarTimer(30, "Devotion Aura", "Interface\\Icons\\Spell_Holy_SealOfProtection")
-- 	elseif msg == "ResAura" then
-- 		if self.Options.WarnResAura then
-- 			self:Announce(DBM_COUNCIL_WARN_AURA_RES, 1)
-- 		end
-- 		self:StartStatusBarTimer(30, "Resistance Aura", "Interface\\Icons\\Spell_Frost_WizardMark")
-- 	end
-- end


