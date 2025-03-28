local mod	= DBM:NewMod("Moroes", "DBM-Karazhan")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(15687)--Moroes
--19875, 19874, 19872, 17007, 19876, 19873--all the adds, for future use
mod:RegisterCombat("yell", L.DBM_MOROES_YELL_START)
--mod:RegisterCombat("combat", 15687)

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_AURA_APPLIED_DOSE",
	"UNIT_HEALTH",
	"CHAT_MSG_MONSTER_YELL"
)

local warnPhase2Soon		= mod:NewAnnounce("WarnPhase2Soon")
local warningVanishSoon		= mod:NewSoonAnnounce(2130600, 2)
local warningVanish			= mod:NewSpellAnnounce(2130600, 3)
local warningGarrote		= mod:NewAnnounce(L.DBM_MOROES_GARROTE, 3, 2130601)
-- local warningGouge			= mod:NewTargetAnnounce(29425, 4)
local warningBlind			= mod:NewTargetAnnounce(34694, 3)
local warningMortalStrike	= mod:NewTargetAnnounce(2130630, 2)
local warningManaBurn		= mod:NewCastAnnounce(2130608, 3, nil, false)
local warningGreaterHeal	= mod:NewCastAnnounce(2130620, 3, nil, false)
local warningHolyLight		= mod:NewCastAnnounce(29562, 3, nil, false)
local warningPWS			= mod:NewTargetAnnounce(85217, 3)
local warningPain			= mod:NewTargetAnnounce(2130616, 3)
local warningWall			= mod:NewTargetAnnounce(29390, 3)
local warningDispel			= mod:NewTargetAnnounce(15090, 3)
local warningHFire			= mod:NewTargetAnnounce(2130625, 3)
local warningHoJ			= mod:NewTargetAnnounce(2130632, 3)
local warningDShield		= mod:NewTargetAnnounce(2130637, 3)

local specWarnDinner		= mod:NewSpecialWarning(L.DinnerServed)

local timerVanish			= mod:NewNextTimer(30, 2130600)
-- local timerGouge			= mod:NewTargetTimer(6, 29425)
local timerBlind			= mod:NewTargetTimer(10, 34694)
local timerMortalStrike		= mod:NewTargetTimer(5, 2130630)
local timerHoJ				= mod:NewCDTimer(50, 2130632)
local timerDinner			= mod:NewCDTimer(24, 2130649)
local timerDinner25m		= mod:NewCDTimer(36, 2130649)
local timerMoroesEnrage		= mod:NewTimer(720, "Frenzy", 351007)

-- local lastVanish = 0

--Ascension Specific
local warningDinner		= mod:NewSpellAnnounce(2130649, 3)
--local warningFood		= mod:NewTargetTimer(30, 2130649, "%s");

local timerDance		= mod:NewTimer(27, L.DBM_MOROES_SOULBURST, 2130645, 2130646, 2130647, 2130648);
local danceType = {[0] = "Circle", [1] = "Star", [2] = "Line"};
local danceCount = 0;

mod:AddBoolOption(L.FoodYell, false)
mod.vb.warned_preP2 = false

function mod:OnCombatStart(delay)
	timerMoroesEnrage:Start(-delay)
	self.vb.warned_preP2 = false
	timerVanish:Start(-delay)
	warningVanishSoon:Schedule(20-delay)
	-- lastVanish = 0
	-- lastDinner = GetTime()
	danceCount = 0;
	mod:DanceTimer(22-delay,true);
	self.vb.phase = 1
end

function mod:DanceTimer(t,noInc)
	danceCount = danceCount + (noInc and 0 or 1);
	timerDance:Start(t,danceType[(danceCount % 3)]);
	self:ScheduleMethod(t,"DanceTimer",28);
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2130608) then
		warningManaBurn:Show()
	elseif args:IsSpellID(2130620) then
		warningGreaterHeal:Show()
	elseif args:IsSpellID(29562) then
		warningHolyLight:Show()
	elseif args:IsSpellID(2130625,2130626, 2130627, 2130628) then
		warningHFire:Show(args.destName)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(15090) then
		warningDispel:Show(args.destName)
	elseif args:IsSpellID(2130616, 2130617, 2130618, 2130619) then
		warningPain:Show(args.destName)
	end
end
	

local foodData = {
	[2130649] = {name = "Apple", yell = "YellApple"}, -- Sweet / Apple
	[2130650] = {name = "Wine", yell = "YellWine"}, -- Thirst / Wine
	[2130651] = {name = "Oranges", yell = "YellFruit"}, -- Tart / Oranges
	[2130652] = {name = "Boar", yell = "YellBoar"}, -- Savory / Boar
	[2130653] = {name = "Fish", yell = "YellFish"}, -- Fishy / Fish
};

function mod:YellFood()
	if self.food then
		SendChatMessage(L[self.food.name], "YELL");
		self:ScheduleMethod(2,"YellFood");
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2130600) then
		warningVanish:Show()
		-- lastVanish = GetTime()
	-- elseif args:IsSpellID(29425) then
	-- 	warningGouge:Show(args.destName)
	-- 	timerGouge:Show(args.destName)
	elseif args:IsSpellID(34694) then
		warningBlind:Show(args.destName)
		timerBlind:Show(args.destName)
	elseif args:IsSpellID(2130637) then
		warningDShield:Show(args.destName)
	elseif args:IsSpellID(2130632) then
		warningHoJ:Show(args.destName)
	elseif args:IsSpellID(29390) then
		warningWall:Show(args.destName)
	elseif args:IsSpellID(2130630) then
		warningMortalStrike:Show(args.destName)
		timerMortalStrike:Show(args.destName)
	elseif args:IsSpellID(85217) then
		warningPWS:Show(args.destName)
	elseif args:IsSpellID(2130601, 2130602, 2130603, 2130604) then         -- Garrote has 3 different IDs for 3 difficulties. Why Ascension?
		warningGarrote:Show(args.spellName, args.destName, args.amount or 1)
		-- if (GetTime() - lastVanish) < 20 then
		timerVanish:Start()
--			warningVanishSoon:Schedule(23)
		-- end
	elseif args:IsSpellID(2130645, 2130646, 2130647, 2130648) then -- Soul Burst Debuff
		local elapsed, total = timerDance:GetTime(danceType[(danceCount % 3)]);
		if elapsed > 10 then
			self:UnscheduleMethod("DanceTimer");
			self:DanceTimer(27-2,true);
		end
	elseif foodData[args.spellId] then
		if args.destName and args:IsPlayer() then
			local food = foodData[args.spellId];
			--warningFood:Show(args.destName);
			self.food = food;
			if self.Options.FoodYell then
				self:ScheduleMethod(2,"YellFood");
			end
			if mod:IsDifficulty("heroic25") then
				timerDinner25m:Start()				
			else
				timerDinner:Start()				
			end
			warningDinner:Show()
			self.vb.phase = 2
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(2130601, 2130602, 2130603, 2130604) then
		warningGarrote:Show(args.spellName, args.destName, args.amount or 1)
		-- if (GetTime() - lastVanish) < 20 then
		timerVanish:Start()
		-- end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.DBM_MOROES_DINNER then
		if mod:IsDifficulty("heroic25") then
			timerDinner25m:Start()				
		else
			timerDinner:Start()				
		end
		specWarnDinner:Show()
	end
end


function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(34694) then
		timerBlind:Cancel(args.destName)
	elseif foodData[args.spellId] then
		if args.destName and args:IsPlayer() then
			local food = foodData[args.spellId];
			--warningFood:Cancel(args.destName);
			self.food = nil;
			self:UnscheduleMethod("YellFood");
		end
	end
end

function mod:UNIT_HEALTH(uId)
	if not self.vb.warned_preP2 and self:GetUnitCreatureId(uId) == 15687 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.80 then
		self.vb.warned_preP2 = true
		warnPhase2Soon:Show()
	end
end

-----DBM GLOBAL FUNCTIONS-----
function mod:OnCombatEnd(wipe)
	self.food = nil;
	self:Stop();
end