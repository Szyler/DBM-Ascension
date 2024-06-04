local mod	= DBM:NewMod("Souls", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5019 $"):sub(12, -3))
mod:SetCreatureID(23418)
mod:RegisterCombat("yell", L.DBM_SOULS_YELL_PULL, 23420)


mod:RegisterEvents(
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"CHAT_MSG_MONSTER_YELL",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_DAMAGE",
	"UNIT_HEALTH"
)


local intermissionSummonEssenceOfSuffering = mod:NewCastTimer(35, 2143967)
local intermissionSummonEssenceOfDesire = mod:NewCastTimer(35, 2143968)
local intermissionSummonEssenceOfAnger = mod:NewCastTimer(35, 2143969)

local warnSpiritShock = mod:NewSpellAnnounce(2143804, 2)
local timerTargetSpiritShock = mod:NewTargetTimer(5, 2143804)

local warnSoulBlast = mod:NewSpellAnnounce(2143961, 2)
local warnSoulDrain = mod:NewSpellAnnounce(2143760, 2)
local timerNextSoulDrain = mod:NewNextTimer(30, 2143760)

local warnVengenace = mod:NewSpellAnnounce(2143764, 2)
local timerNextVengenace = mod:NewNextTimer(30, 2143764)

local warnRuneShield = mod:NewSpellAnnounce(2143808, 2)
local timerRuneShield = mod:NewTargetTimer(15, 2143808)
local timerNextRuneShield = mod:NewNextTimer(15, 2143808)

local warnTease = mod:NewSpellAnnounce(2143808, 2)
local timerTease = mod:NewBuffActiveTimer(15, 2143808)
local timerNextTease = mod:NewNextTimer(30, 2143808)

local warnSeethe = mod:NewSpellAnnounce(2143861, 2)
local timerSeethe = mod:NewTargetTimer(15, 2143861)
local timerNextSeethe = mod:NewNextTimer(15, 2143861)

local warnSoulScream = mod:NewSpellAnnounce(2143853, 2)
local timerSoulScream = mod:NewCastTimer(2, 2143853)
local timerNextSoulScream = mod:NewNextTimer(12, 2143853)


local warnAuraOfSuffering = mod:NewSpellAnnounce(2143751, 2)
local warnAuraOfDesire = mod:NewSpellAnnounce(2143800, 2)
local warnAuraOfAnger = mod:NewSpellAnnounce(2143850, 2)

--local
-- local isSuffer
-- local isDesire
-- local isAnger

function mod:OnCombatStart(delay)
	self.vb.phase = 1
	timerNextSoulDrain:Start(20-delay)
	timerNextVengenace:Start(32-delay)
	-- isSuffer = true
	-- isDesire = false
	-- isAnger = false
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2143804) then
		warnSpiritShock:Show()
		timerTargetSpiritShock:Start(args.destName)
	elseif args:IsSpellID(2143961) and args.amount and args.amount >= 20 and args.amount % 5 == 0 then
		warnSoulBlast:Show()
	elseif args:IsSpellID(2143760, 2143761, 2143762, 2143763) and DBM:AntiSpam() then
		warnSoulDrain:Show()
		timerNextSoulDrain:Start()
	elseif args:IsSpellID(2143808) and self:GetCIDFromGUID(args.destGUID) == 23418 then
		warnRuneShield:Show()
		timerRuneShield:Start(args.destName)
	elseif args:IsSpellID(2143808) then
		warnTease:Show()
		timerTease:Start()
		timerNextTease:Start()
	elseif args:IsSpellID(2143861) then
		if DBM:AntiSpam() then
			warnSeethe:Show()
			timerNextSeethe:Start()
		end
		timerSeethe:Start(args.destName)
	elseif args:IsSpellID(2143800, 2143803) and DBM:AntiSpam(60) then
		self.vb.phase = 2
		-- isDesire = true
		warnAuraOfDesire:Show()
		timerNextRuneShield:Start(20)
		timerNextTease:Start(25)
	elseif args:IsSpellID(2143850, 2143852) and DBM:AntiSpam(60) then
		self.vb.phase = 3
		-- isAnger = true
		warnAuraOfAnger:Show()
		timerNextSoulScream:Start(10)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(2143808) and self:GetCIDFromGUID(args.destGUID) == 23418 then
		-- warnRuneShield:Hide()
		timerRuneShield:Stop()
	end
end


function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2143853, 2143854, 2143855, 2143856) or args:IsSpellID(2143857) then
		warnSoulScream:Show()
		timerSoulScream:Start()
		timerNextSoulScream:Start()
	elseif args:IsSpellID(2143764) then
		warnVengenace:Show()
	end
end

function mod:UNIT_HEALTH(unit)
	--Essence of Suffering
	if (mod:GetUnitCreatureId(unit) == 23418) then
		local hp = (math.max(0,UnitHealth(unit)) / math.max(1, UnitHealthMax(unit))) * 100;
		if (hp <= 2) then
			intermissionSummonEssenceOfSuffering:Start()
        end
	--Essence of Desire
	elseif (mod:GetUnitCreatureId(unit) == 23419) then
		local hp = (math.max(0,UnitHealth(unit)) / math.max(1, UnitHealthMax(unit))) * 100;
		if (hp <= 2) then
			intermissionSummonEssenceOfDesire:Start()
			self.vb.phase = 2
		end
	--Essence of Anger
	-- elseif isAnger and (mod:GetUnitCreatureId(unit) == 23420) then
	-- 	local hp = (math.max(0,UnitHealth(unit)) / math.max(1, UnitHealthMax(unit))) * 100;
	-- 	if (hp <= 2) then
	-- 		intermissionSummonEssenceOfAnger:Start()
	-- 	end
    end
end

-- Souls.MinVersionToSync = 3.00


-- local drainTargets = {}
-- local spiteTargets = {}
-- local lastFixate
-- local lastSpite = 0
-- local phase = 1

--Souls:AddOption("WarnDrain", true, DBM_SOULS_OPTION_DRAIN)
--Souls:AddOption("WarnDrainCast", false, DBM_SOULS_OPTION_DRAIN_CAST)
--Souls:AddOption("WarnFixate", false, DBM_SOULS_OPTION_FIXATE)
--Souls:AddOption("WarnScream", false, DBM_SOULS_OPTION_SCREAM)
--Souls:AddOption("WarnSpite", true, DBM_SOULS_OPTION_SPITE)
--Souls:AddOption("SpecWarnSpite", true, DBM_SOULS_OPTION_SPECWARN_SPITE)
--Souls:AddOption("SpiteWhisper", false, DBM_SOULS_OPTION_WHISPER_SPITE)

--Souls:AddBarOption("Enrage")
--Souls:AddBarOption("Next Enrage")
--Souls:AddBarOption("Fixate: (.*)")
--Souls:AddBarOption("Mana Drain")
--Souls:AddBarOption("Rune Shield")
--Souls:AddBarOption("Deaden")
--Souls:AddBarOption("Soul Scream")

-- drainTargets = {}
-- spiteTargets = {}
-- lastFixate = nil
-- self:StartStatusBarTimer(47 - delay, "Next Enrage", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
-- self:ScheduleSelf(42 - delay, "EnrageWarn")
-- phase = 1

-- function Souls:OnEvent(event, arg1)
-- 	if event == "CHAT_MSG_RAID_BOSS_EMOTE" then
-- 		if arg1 == DBM_SOULS_EMOTE_ENRAGE and self.InCombat then
-- 			self:Announce(DBM_SOULS_WARN_ENRAGE, 3)
-- 			self:StartStatusBarTimer(15, "Enrage", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
-- 			self:ScheduleSelf(15, "NextEnrage")
-- 		end
-- 	elseif event == "NextEnrage" then
-- 		self:Announce(DBM_SOULS_WARN_ENRAGE_OVER, 2)
-- 		self:StartStatusBarTimer(32, "Next Enrage", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
-- 		self:ScheduleSelf(27, "EnrageWarn")
-- 	elseif event == "EnrageWarn" then
-- 		self:Announce(DBM_SOULS_WARN_ENRAGE_SOON, 2)
	
-- 	elseif event == "SPELL_AURA_APPLIED" then
-- 		if arg1.spellId == 41431 and bit.band(arg1.destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) == 0 then
-- 			self:SendSync("Runeshield")
-- 		elseif arg1.spellId == 41376 then
-- 			self:SendSync("Spite"..tostring(arg1.destName))
-- 		elseif arg1.spellId == 41303 then
-- 			self:SendSync("SoulDrain"..tostring(arg1.destName))
-- 		elseif arg1.spellId == 41294 then
-- 			self:SendSync("Fixate"..tostring(arg1.destName))
-- 		end
-- 	elseif event == "RuneShieldWarn" then
-- 		self:Announce(DBM_SOULS_WARN_RUNESHIELD_SOON, 2)

-- 	elseif event == "SPELL_CAST_START" then
-- 		if arg1.spellId == 41410 then
-- 			self:SendSync("Deaden")
-- 		elseif arg1.spellId == 41303 then
-- 			self:SendSync("DrainCast")
-- 		end
	
-- 	elseif event == "SPELL_DAMAGE" then
-- 		if arg1.spellId == 41545 then
-- 			self:SendSync("SoulScream")
-- 		end
	
-- 	elseif event == "DeadenWarn" then
-- 		self:Announce(DBM_SOULS_WARN_DEADEN_SOON, 1)
	
-- 	elseif event == "CHAT_MSG_MONSTER_YELL" and arg1 then
-- 		if arg1 == DBM_SOULS_YELL_DESIRE or arg1:find(DBM_SOULS_YELL_DESIRE_DEMONIC) then
-- 			phase = 2
-- 			self:Announce(DBM_SOULS_WARN_DESIRE_INC, 1)
-- 			self:StartStatusBarTimer(160, "Mana Drain", "Interface\\Icons\\Spell_Shadow_SiphonMana")
-- 			self:ScheduleSelf(140, "ManaDrainWarn")
			
-- 			self:StartStatusBarTimer(13.5, "Rune Shield", "Interface\\Icons\\Spell_Arcane_Blast")
-- 			self:ScheduleSelf(10.5, "RuneShieldWarn")
-- 			self:StartStatusBarTimer(28, "Deaden", "Interface\\Icons\\Spell_Shadow_SoulLeech_1")
-- 			self:ScheduleSelf(23, "DeadenWarn")
-- 		elseif arg1 == DBM_SOULS_YELL_ANGER_INC then
-- 			phase = 3
-- 			self:Announce(DBM_SOULS_WARN_ANGER_INC, 1)
-- 		end
-- 	elseif event == "ManaDrainWarn" then
-- 		self:Announce(DBM_SOULS_WARN_MANADRAIN, 1)

-- 	elseif event == "WarnDrain" then
-- 		local msg = ""
-- 		for i, v in ipairs(drainTargets) do
-- 			msg = msg..">"..v.."<"..", "
-- 		end
-- 		msg = msg:sub(0, -3)
-- 		drainTargets = {}
-- 		self:Announce(DBM_SOULS_WARN_SOULDRAIN:format(msg), 1)
-- 	elseif event == "WarnSpite" then
-- 		if (GetTime() - lastSpite) > 12 then
-- 			lastSpite = GetTime()
-- 			local msg = ""
-- 			for i, v in ipairs(spiteTargets) do
-- 				msg = msg..">"..v.."<"..", "
-- 				if v == UnitName("player") then
-- 					if self.Options.SpecWarnSpite then
-- 						self:AddSpecialWarning(DBM_SOULS_SPECWARN_SPITE)
-- 					end
-- 				end
-- 				if self.Options.SpiteWhisper and self.Options.Announce and DBM.Rank >= 1 then
-- 					self:SendHiddenWhisper(DBM_SOULS_WHISPER_SPITE, v)
-- 				end
-- 			end
-- 			msg = msg:sub(0, -3)
-- 			spiteTargets = {}
-- 			self:Announce(DBM_SOULS_WARN_SPITE:format(msg), 2)
-- 		else
-- 			spiteTargets = {}
-- 		end
-- 	end
-- end

-- function Souls:GetBossHP()
-- 	if phase == 1 then
-- 		return DBM_SOULS_BOSS_SUFFERING..": "..DBM.GetHPByName(DBM_SOULS_BOSS_SUFFERING)
-- 	elseif phase == 2 then
-- 		return DBM_SOULS_BOSS_DESIRE..": "..DBM.GetHPByName(DBM_SOULS_BOSS_DESIRE)
-- 	elseif phase == 3 then
-- 		return DBM_SOULS_BOSS_KILL_NAME..": "..DBM.GetHPByName(DBM_SOULS_BOSS_KILL_NAME)
-- 	end
-- end

-- function Souls:OnSync(msg)
-- 	if msg == "Runeshield" then
-- 		self:Announce(DBM_SOULS_WARN_RUNESHIELD, 3)
-- 		self:StartStatusBarTimer(15.4, "Rune Shield", "Interface\\Icons\\Spell_Arcane_Blast") -- the timer between 2 runeshields is always about 15.5 seconds in my combatlog...this could be due to delay/lag/whatever, but this timer seems to be quite accurate
-- 		self:ScheduleSelf(12.4, "RuneShieldWarn")
-- 	elseif msg == "Deaden" then
-- 		self:Announce(DBM_SOULS_WARN_DEADEN, 2)
-- 		self:StartStatusBarTimer(31.5, "Deaden", "Interface\\Icons\\Spell_Shadow_SoulLeech_1")
-- 		self:ScheduleSelf(26.5, "DeadenWarn")
-- 	elseif msg:sub(0, 5) == "Spite" and self.Options.WarnSpite then
-- 		msg = msg:sub(6)
-- 		table.insert(spiteTargets, msg)
-- 		self:UnScheduleSelf("WarnSpite")
-- 		if #spiteTargets == 3 then
-- 			self:OnEvent("WarnSpite")
-- 		else
-- 			self:ScheduleSelf(1.3, "WarnSpite")
-- 		end
-- 	elseif msg:sub(0, 9) == "SoulDrain" and self.Options.WarnDrain then
-- 		msg = msg:sub(10)
-- 		table.insert(drainTargets, msg)
-- 		self:UnScheduleSelf("WarnDrain")
-- 		if #drainTargets == 5 then
-- 			self:OnEvent("WarnDrain")
-- 		else
-- 			self:ScheduleSelf(1.5, "WarnDrain")
-- 		end
-- 	elseif msg == "DrainCast" then
-- 		if self.Options.WarnDrainCast then
-- 			self:Announce(DBM_SOULS_WARN_SOULDRAIN_CAST, 1)
-- 		end
-- 	elseif msg:sub(0, 6) == "Fixate" and self.InCombat then
-- 		msg = msg:sub(7)
-- 		if lastFixate then
-- 			self:EndStatusBarTimer(lastFixate)
-- 		end
-- 		self:StartStatusBarTimer(5.5, "Fixate: "..msg, "Interface\\Icons\\Spell_Shadow_SpectralSight")
-- 		lastFixate = "Fixate: "..msg
-- 		if msg == UnitName("player") then
-- 			self:AddSpecialWarning(DBM_SOULS_SPECWARN_FIXATE)
-- 		end
-- 		if self.Options.WarnFixate then
-- 			self:Announce(DBM_SOULS_WARN_FIXATE:format(msg), 2)
-- 		end
-- 	elseif msg == "SoulScream" then
-- 		self:StartStatusBarTimer(10, "Soul Scream", "Interface\\Icons\\Spell_Shadow_SoulLeech")
-- 		if self.Options.WarnScream then
-- 			self:Announce(DBM_SOULS_WARN_SCREAM, 1)
-- 		end
-- 	end
-- end

