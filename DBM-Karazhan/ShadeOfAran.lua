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
local specWarnBossShield	= mod:NewSpecialWarning("Shade of Aran is vulnerable!")
local specWarnPoly			= mod:NewSpecialWarning("Volatile Polymorph!")
local specWarnFull			= mod:NewSpecialWarning("Full Room Cover!")

local timerSpecial			= mod:NewTimer(35, "timerSpecial", "Interface\\Icons\\INV_Enchant_EssenceMagicLarge")
local timerFlameCast		= mod:NewCastTimer(5, 30004)
local timerArcaneExplosion	= mod:NewCastTimer(10, 29973)
-- local timerBlizzadCast		= mod:NewCastTimer(3.7, 29969)
local timerFlame			= mod:NewBuffActiveTimer(20.5, 29946)
local timerBlizzad			= mod:NewBuffActiveTimer(30, 29951)
-- local timerElementals		= mod:NewBuffActiveTimer(90, 37053)
local timerChains			= mod:NewTargetTimer(10, 29991)
local timerShield			= mod:NewBuffActiveTimer(60, 85182)
local timerPoly				= mod:NewTargetTimer(30, 85273)	

local berserkTimer			= mod:NewBerserkTimer(900)


mod:AddBoolOption("WreathIcons", false)
mod:AddBoolOption("ElementalIcons", false)

local WreathTargets = {}
local flameWreathIcon = 8

local function warnFlameWreathTargets()
	warningFlameTargets:Show(table.concat(WreathTargets, "<, >"))
	table.wipe(WreathTargets)
	flameWreathIcon = 8
end


function mod:OnCombatStart(delay)
	timerSpecial:Start(8-delay)
	berserkTimer:Start(-delay)
	flameWreathIcon = 8
	table.wipe(WreathTargets)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(30004) then
		warningFlameCast:Show()
		timerFlameCast:Start()
		timerSpecial:Start()
	elseif args:IsSpellID(29973) then
		warningArcaneCast:Show()
		timerArcaneExplosion:Start()
		specWarnArcane:Show()
		timerSpecial:Start()
	elseif args:IsSpellID(85273) then
		specWarnPoly:Show()
		timerSpecial:Start()
--	elseif args:IsSpellID(29969) then       - deprecated, Ascension's Aran doesn't use CAST_START for Blizzard.
--		warningBlizzard:Show()
--		timerBlizzadCast:Show()
--		timerBlizzad:Schedule(3.7)--may need tweaking
--		timerSpecial:Start()
	end
end

--function mod:SPELL_CAST_SUCCESS(args)      - trolled by Bigbigman and his Blizzards on logs.
--	if args:IsSpellID(27085) then
--		warningBlizzard:Show()
--		timerSpecial:Start()
--	end
--end

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
	elseif args:IsSpellID(85273) then
		warningPoly:Show(args.destName)
		timerPoly:Start(args.destName)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(29991) then
		timerChains:Cancel(args.destName)
	end
end

function mod:CHAT_MSG_MONSTER_WHISPER(msg)
	if msg == L.DBM_ARAN_FULL then
		specWarnFull:Show()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.DBM_ARAN_BLIZZARD_1 then
		warningBlizzard:Show()
		timerBlizzad:Start()
		timerSpecial:Start()
	elseif msg == L.DBM_ARAN_BLIZZARD_2 then
		warningBlizzard:Show()
		timerBlizzad:Start()
		timerSpecial:Start()
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
		if args:IsSpellID(29951) and args:IsPlayer() and GetTime() - lastBlizzard > 2 then
			specWarnBlizzard:Show()
			lastBlizzard = GetTime()
		end
	end
end
