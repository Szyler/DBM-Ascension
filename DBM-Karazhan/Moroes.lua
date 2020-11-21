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
	"CHAT_MSG_MONSTER_YELL"
)

local warningVanishSoon		= mod:NewSoonAnnounce(29448, 2)
local warningVanish			= mod:NewSpellAnnounce(29448, 3)
local warningGarrote		= mod:NewTargetAnnounce(37066, 4)
local warningGouge			= mod:NewTargetAnnounce(29425, 4)
local warningBlind			= mod:NewTargetAnnounce(34694, 3)
local warningMortalStrike	= mod:NewTargetAnnounce(29572, 2)
local warningManaBurn		= mod:NewCastAnnounce(29405, 3, nil, false)
local warningGreaterHeal	= mod:NewCastAnnounce(35096, 3, nil, false)
local warningHolyLight		= mod:NewCastAnnounce(29562, 3, nil, false)
local warningPain			= mod:NewTargetAnnounce(85174, 3)
local warningWall			= mod:NewTargetAnnounce(29390, 3)
local warningDispel			= mod:NewTargetAnnounce(15090, 3)
local warningHFire			= mod:NewTargetAnnounce(29563, 3)
local warningHoJ			= mod:NewTargetAnnounce(13005, 3)
local warningDShield		= mod:NewTargetAnnounce(29382, 3)

local specWarnDinner		= mod:NewSpecialWarning("Dinner is Served!")

local timerVanishCD			= mod:NewCDTimer(23, 29448)
local timerGouge			= mod:NewTargetTimer(6, 29425)
local timerBlind			= mod:NewTargetTimer(10, 34694)
local timerMortalStrike		= mod:NewTargetTimer(5, 29572)
local timerHoJ				= mod:NewCDTimer(50, 13005)
local timerDinner			= mod:NewCDTimer(24, 85090)

local lastVanish = 0

--Ascension Specific
local warningDinner		= mod:NewSpellAnnounce(85090, 3)
--local warningFood		= mod:NewTargetTimer(30, 85090, "%s");

local timerDance		= mod:NewTimer(27, "Dance (%s)", 85089);
local danceType = {[0] = "Circle", [1] = "Star", [2] = "Line"};
local danceCount = 0;

function mod:OnCombatStart(delay)
	timerVanishCD:Start(-delay)
	warningVanishSoon:Schedule(31-delay)
	lastVanish = 0
	lastDinner = GetTime()
	danceCount = 0;
	mod:DanceTimer(22-delay,true);
end

function mod:DanceTimer(t,noInc)
	danceCount = danceCount + (noInc and 0 or 1);
	timerDance:Start(t,danceType[(danceCount % 3)]);
	self:ScheduleMethod(t,"DanceTimer",27);
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(29405) then
		warningManaBurn:Show()
	elseif args:IsSpellID(35096) then
		warningGreaterHeal:Show()
	elseif args:IsSpellID(29562) then
		warningHolyLight:Show()
	elseif args:IsSpellID(29563) then
		warningHFire:Show(args.destName)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(15090) then
		warningDispel:Show(args.destName)
	elseif args:IsSpellID(85174) then
		warningPain:Show(args.destName)
	end
end
	

local foodData = {
	[85090] = {name = "Apple", yell = "YellApple"}, -- Sweet / Apple
	[85091] = {name = "Wine", yell = "YellWine"}, -- Thirst / Wine
	[85092] = {name = "Fruit", yell = "YellFruit"}, -- Tart / Fruit
	[85093] = {name = "Boar", yell = "YellBoar"}, -- Savory / Boar
	[85094] = {name = "Fish", yell = "YellFish"}, -- Fishy / Fish
};

function mod:YellFood()
	if self.food then
		SendChatMessage(L[self.food.name], "YELL");
		self:ScheduleMethod(2,"YellFood");
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(29448) then
		warningVanish:Show()
		lastVanish = GetTime()
	elseif args:IsSpellID(29425) then
		warningGouge:Show(args.destName)
		timerGouge:Show(args.destName)
	elseif args:IsSpellID(34694) then
		warningBlind:Show(args.destName)
		timerBlind:Show(args.destName)
	elseif args:IsSpellID(29382) then
		warningDShield:Show(args.destName)
	elseif args:IsSpellID(13005) then
		warningHoJ:Show(args.destName)
	elseif args:IsSpellID(29390) then
		warningWall:Show(args.destName)
	elseif args:IsSpellID(29572) then
		warningMortalStrike:Show(args.destName)
		timerMortalStrike:Show(args.destName)
	elseif args:IsSpellID(37066, 85223) then
		warningGarrote:Show(args.destName)
		if (GetTime() - lastVanish) < 20 then
			timerVanishCD:Start()
--			warningVanishSoon:Schedule(23)
		end
	elseif args:IsSpellID(85089) then -- Soul Burst Debuff
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
			self:ScheduleMethod(2,"YellFood");
			timerDinner:Start()
			warningDinner:Show()
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.DBM_MOROES_DINNER then
		timerDinner:Start()
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

-----DBM GLOBAL FUNCTIONS-----
function mod:OnCombatEnd(wipe)
	self.food = nil;
	self:Stop();
end