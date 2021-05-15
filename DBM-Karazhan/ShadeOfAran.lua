local mod	= DBM:NewMod("Aran", "DBM-Karazhan")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 166 $"):sub(12, -3))
mod:SetCreatureID(16524)
mod:RegisterCombat("combat")
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_SUCCESS",
	"SPELL_SUMMON",
	"CHAT_MSG_MONSTER_YELL",
	"SPELL_PERIODIC_DAMAGE",
	"CHAT_MSG_MONSTER_WHISPER"
)

local warningFlameCast		= mod:NewCastAnnounce(30004, 4)
local warningArcaneCast		= mod:NewCastAnnounce(29973, 4)
local warningBlizzard		= mod:NewSpellAnnounce(29969, 3)
local warningElementals		= mod:NewSpellAnnounce(37053, 3)
local warningChains			= mod:NewTargetAnnounce(29991, 2)
local warningFlameTargets	= mod:NewTargetAnnounce(29946, 4)
local warningSheepTargets	= mod:NewTargetAnnounce(85273, 3)
local warningPoly			= mod:NewSpellAnnounce(85273, 3)

local specWarnDontMove		= mod:NewSpecialWarning("DBM_ARAN_DO_NOT_MOVE")
local specWarnArcane		= mod:NewSpecialWarningRun(29973)
local specWarnBlizzard		= mod:NewSpecialWarningMove(29951)
local specWarnBossShield	= mod:NewSpecialWarning(L.DBM_ARAN_VULNERABLE)
local specWarnPoly			= mod:NewSpecialWarning(L.VolatilePoly)
local specWarnFull			= mod:NewSpecialWarning(L.ArcaneSpiral)
--local specWarnDoubleCast	= mod:NewSpecialWarning(L.DoubleCast);

local timerSpecial			= mod:NewTimer(30, L.timerSpecial, "Interface\\Icons\\INV_Enchant_EssenceMagicLarge")
local timerFlameCast		= mod:NewCastTimer(4, 30004)
local timerArcaneExplosion	= mod:NewCastTimer(10, 29973)
-- local timerBlizzadCast		= mod:NewCastTimer(3.7, 29969)
local timerFlame			= mod:NewBuffActiveTimer(20.5, 29946)
local timerBlizzad			= mod:NewBuffActiveTimer(30, 29951)
-- local timerElementals		= mod:NewBuffActiveTimer(90, 37053)
local timerChains			= mod:NewTargetTimer(10, 29991)
local timerShield			= mod:NewBuffActiveTimer(60, 85182)
local timerPoly				= mod:NewTargetTimer(30, 85273)
local timerBoom				= mod:NewTimer(5, L.ArcaneSpiralTimer, "Interface\\Icons\\spell_nature_wispsplode")

local berserkTimer			= mod:NewBerserkTimer(900)

mod:AddBoolOption("WreathIcons", false)
mod:AddBoolOption("ElementalIcons", false)
mod:AddBoolOption("SheepIcons", false)
mod:AddBoolOption("MarkCurrentTarget", false)

local WreathTargets = {}
local flameWreathIcon = 7
local SheepTargets = {};
local sheepIcon = 7;
local lastTarget;
local specialAbilities = {};

local function warnFlameWreathTargets()
	warningFlameTargets:Show(table.concat(WreathTargets, "<, >"))
	table.wipe(WreathTargets)
	flameWreathIcon = 7
end

local function warnSheepTargets()
	warningSheepTargets:Show(table.concat(SheepTargets, "<, >"));
	table.wipe(SheepTargets);
	sheepIcon = 7;
end

function mod:UpdateSpecials(spell)
	if (spell == true) then
		wipe(specialAbilities);
	elseif spell then
		for k,v in ipairs(specialAbilities) do
			if v == spell then
				table.remove(specialAbilities,k);
				break;
			end
		end
	end
	if (#specialAbilities == 0) then
		specialAbilities = {"Blizzard","Wreath","Explosion"};
		if mod:IsDifficulty("heroic10","heroic25") then
			table.insert(specialAbilities,"Poly");
		end
	end
	return table.concat(specialAbilities,"/");
end

function mod:OnCombatStart(delay)
	timerSpecial:Start(11-delay,self:UpdateSpecials(true));
	berserkTimer:Start(-delay)
	flameWreathIcon = 7
	sheepIcon = 7;
	lastTarget = nil;
	table.wipe(WreathTargets)
	table.wipe(SheepTargets);
	self.vb.phase = 1
end

function mod:SPELL_CAST_START(args)
--	if args:IsSpellID(85255, 85251, 85253) then -- Arcane Missiles, Fireball, Frostbolt
--		local destName = self:GetBossTarget();
--		if destName then
--			if self.Options.MarkCurrentTarget then
--				self:SetIcon(destName, 8);
--			end
--			if lastTarget and (destName == lastTarget) then
--				specWarnDoubleCast:Show(args.spellName);
--			end
--			lastTarget = destName;
--		end
	if args:IsSpellID(30004) then
		warningFlameCast:Show()
		timerFlameCast:Start()
		timerSpecial:Start(35,self:UpdateSpecials("Wreath"))
	elseif args:IsSpellID(29973, 85436) then
		warningArcaneCast:Show()
		timerArcaneExplosion:Start()
		specWarnArcane:Show()
		timerSpecial:Start(35,self:UpdateSpecials("Explosion"))
	elseif args:IsSpellID(85273) then
		specWarnPoly:Show()
		timerSpecial:Start(35,self:UpdateSpecials("Poly"))
--	elseif args:IsSpellID(29969) then       - deprecated, Ascension's Aran doesn't use CAST_START for Blizzard.
--		warningBlizzard:Show()
--		timerBlizzadCast:Show()
--		timerBlizzad:Schedule(3.7)--may need tweaking
--		timerSpecial:Start()
	end
end


function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(29991) then
		warningChains:Show(args.destName)
		timerChains:Start(args.destName)
	elseif args:IsSpellID(29946) then
		WreathTargets[#WreathTargets + 1] = args.destName
		timerFlame:Start()
		if args:IsPlayer() then
			specWarnDontMove:Show()
		end
		if self.Options.WreathIcons then
			self:SetIcon(args.destName, flameWreathIcon, 20)
			flameWreathIcon = flameWreathIcon - 1
		end
		self:Unschedule(warnFlameWreathTargets)
		self:Schedule(0.3, warnFlameWreathTargets)
	elseif args:IsSpellID(85182) then
		timerShield:Start()
		specWarnBossShield:Schedule(60)
		timerSpecial:Cancel()
		self.vb.phase = 2
	elseif args:IsSpellID(85273) then -- Volatile Polymorph
		--warningPoly:Show(args.destName)
		SheepTargets[#SheepTargets + 1] = args.destName;
		timerPoly:Start(args.destName);
		if self.Options.SheepIcons then
			self:SetIcon(args.destName, sheepIcon, 12);
			sheepIcon = sheepIcon - 1;		
		end
		self:Unschedule(warnSheepTargets);
		if (self:IsDifficulty("heroic10") and (#SheepTargets >= 5)) then
			self:Schedule(0, warnSheepTargets);
		else
			self:Schedule(0.3, warnSheepTargets);
		end
	elseif args:IsSpellID(29963)  then
		if args:IsPlayer() then
			local elapsed, total = timerSpecial:GetTime(self:UpdateSpecials());
			timerSpecial:Update(elapsed, total+10, self:UpdateSpecials());
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(29991) then
		timerChains:Cancel(args.destName)
	elseif args:IsSpellID(85273) then  -- Volatile Polymorph
		timerPoly:Cancel(args.destName);
		if self.Options.SheepIcons then
			self:RemoveIcon(args.destName);
		end
	end
end

function mod:CHAT_MSG_MONSTER_WHISPER(msg)
	if msg == L.DBM_ARAN_FULL then
		specWarnFull:Show()
		timerBoom:Start()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if (msg == L.DBM_ARAN_BLIZZARD_1) or (msg == L.DBM_ARAN_BLIZZARD_2) then
		warningBlizzard:Show()
		timerBlizzad:Start()
		timerSpecial:Start(35,self:UpdateSpecials("Blizzard"))
	end
end

do
	local elementalIcon = {}
	local currentIcon = 1
	local iconsSet = 0
	local function resetElementalIconState()
		table.wipe(elementalIcon)
		currentIcon = 1
		iconsSet = 0
	end
	
	local lastElemental = 0
	function mod:SPELL_SUMMON(args)
		if args:IsSpellID(29962, 37051, 37052, 37053) then -- Summon Water elementals
			if time() - lastElemental > 5 then
				warningElementals:Show()
			--  timerElementals:Show()
				lastElemental = time()
				if self.Options.ElementalIcons then
					resetElementalIconState()
				end
			end
			if self.Options.ElementalIcons then
				elementalIcon[args.destGUID] = currentIcon
				currentIcon = currentIcon + 1
			end
		end
	end
	
	mod:RegisterOnUpdateHandler(function(self)
		if self.Options.ElementalIcons and (DBM:GetRaidRank() > 0 and not iconsSet == 4) then
			for i = 1, GetNumRaidMembers() do
				local uId = "raid"..i.."target"
				local guid = UnitGUID(uId)
				if beastIcon[guid] then
					SetRaidTarget(uId, elementalIcon[guid])
					iconsSet = iconsSet + 1
					elementalIcon[guid] = nil
				end
			end
		end
	end, 1)
end

do 
	local lastBlizzard = 0
	function mod:SPELL_PERIODIC_DAMAGE(args)
		if args:IsSpellID(29951, 85250) and args:IsPlayer() and GetTime() - lastBlizzard > 2 then
			specWarnBlizzard:Show()
			lastBlizzard = GetTime()
		end
	end
end
