local mod	= DBM:NewMod("Prince", "DBM-Karazhan")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 172 $"):sub(12, -3))
mod:SetCreatureID(15690)
--mod:RegisterCombat("yell", L.DBM_PRINCE_YELL_PULL)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"CHAT_MSG_MONSTER_YELL",
	"SPELL_INSTAKILL",
	"SPELL_CAST_SUCCESS"
)

local warnPhase2				= mod:NewPhaseAnnounce(2)
local warnPhase3				= mod:NewPhaseAnnounce(3)
local warningNovaCast			= mod:NewCastAnnounce(30852, 3)
local warningInfernalSoon		= mod:NewSoonAnnounce(37277, 2)
local warningInfernal			= mod:NewSpellAnnounce(37277, 3)
local warningEnfeeble			= mod:NewTargetAnnounce(30843, 4)
local warningAmpMagic			= mod:NewSpellAnnounce(39095, 3)
local warningSWP				= mod:NewTargetAnnounce(30898, 2, nil, false)
local warningDoom				= mod:NewSpellAnnounce(85069, 1)
local warningShadowRealm		= mod:NewTargetAnnounce(85077, 3)

local specWarnEnfeeble			= mod:NewSpecialWarningYou(30843)
local specWarnNova				= mod:NewSpecialWarningRun(30852)
local specWarnSWP				= mod:NewSpecialWarningYou(30898)	
local specWarnSRealm			= mod:NewSpecialWarningYou(85077)

local timerNovaCast				= mod:NewCastTimer(2, 30852)
local timerNextInfernal			= mod:NewNextTimer(18, 37277)
local timerEnfeeble				= mod:NewCDTimer(30, 30843)
local timerDoom					= mod:NewCDTimer(24, 85069)
local timerShadowRealm			= mod:NewCDTimer(45, 85077)
local timerAmpDmg				= mod:NewTimer(25, "Amplify Damage #%s", 85207)

local miscCrystalKill1			= mod:NewAnnounce("Shadow Crystals Destroyed (1/3)", 3, 85078)
local miscCrystalKill2			= mod:NewAnnounce("Shadow Crystals Destroyed (2/3)", 3, 85078)
local miscCrystalKill3			= mod:NewAnnounce("Shadow Crystals Destroyed (3/3)", 3, 85078)


local phase	= 0
local ampDmg = 1
local enfeebleTargets = {}
local firstInfernal = false
local CrystalsKilled = 0

local function showEnfeebleWarning()
	warningEnfeeble:Show(table.concat(enfeebleTargets, "<, >"))
	table.wipe(enfeebleTargets)
end

function mod:OnCombatStart(delay)
	phase = 1
	CrystalsKilled = 0
	ampDmg = 1
	timerDoom:Start(30-delay)
	table.wipe(enfeebleTargets)
	firstInfernal = false
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(30852) then
		warningNovaCast:Show()
		timerNovaCast:Start()
		specWarnNova:Show()
	end
end

function mod:SPELL_INSTAKILL(args)
	if args:IsSpellID(85078) and CrystalsKilled == 0 and args:IsPlayerSource() then
		CrystalsKilled = CrystalsKilled + 1
		miscCrystalKill1:Show()
	elseif args:IsSpellID(85078) and CrystalsKilled == 1 and args:IsPlayerSource() then
		CrystalsKilled = CrystalsKilled + 1
		miscCrystalKill2:Show()
	elseif args:IsSpellID(85078) and CrystalsKilled == 2 and args:IsPlayerSource() then
		CrystalsKilled = 0
		miscCrystalKill3:Show()
	end
end	
		

function mod:Infernals()
	warningInfernal:Show()
	if Phase == 3 then
		timerNextInfernal:Start(9)
	else		
		timerNextInfernal:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(30854, 30898) then
		warningSWP:Show(args.destName)
		if args:IsPlayer() then
			specWarnSWP:Show()
		end	
	elseif args:IsSpellID(85207) then
		ampDmg = ampDmg + 1;
		warningAmpMagic:Show()
		timerAmpDmg:Start(tostring(ampDmg))
	elseif args:IsSpellID(30843) then
		enfeebleTargets[#enfeebleTargets + 1] = args.destName
		timerEnfeeble:Start()
		if args:IsPlayer() then
			specWarnEnfeeble:Show()
		end
		self:Unschedule(showEnfeebleWarning)
		self:Schedule(0.3, showEnfeebleWarning)
	end	
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(85069) then
		warningDoom:Show()
			if Phase == 3 then
				timerDoom:Start(12)
			else
				timerDoom:Start()
			end
	elseif args:IsSpellID(85077) then
		warningShadowRealm:Show(args.destName)
		timerShadowRealm:Start()
			if args.IsPlayer() then
				specWarnSRealm:Show()
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(85207) and args:isPlayer() then
		ampDmg = ampDmg + 1;
		warningAmpMagic:Show()
		timerAmpDmg:Start(tostring(ampDmg))
	end
end
		

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.DBM_PRINCE_YELL_INF1 or msg == L.DBM_PRINCE_YELL_INF2 then
		warningInfernalSoon:Schedule(11.5)
		self:ScheduleMethod(18.5, "Infernals")--Infernal actually spawns 18.5sec after yell.
		if not firstInfernal then
			timerNextInfernal:Start(18.5)
			firstInfernal = true
		end
--		if Phase == 3 then
--			timerNextInfernal:Update(3.5, 12.5)--we attempt to update bars to show 18.5sec left. this will more than likely error out, it's not tested.
--		else		
--			timerNextInfernal:Update(26.5, 45)--we attempt to update bars to show 18.5sec left. this will more than likely error out, it's not tested.
--		end
	elseif msg == L.DBM_PRINCE_YELL_P3 then
		phase = 3
		warnPhase3:Show()
		timerAmpDmg:Start(5, tostring(ampDmg))
	elseif msg == L.DBM_PRINCE_YELL_P2 then
		phase = 2
		warnPhase2:Show()
		timerShadowRealm:Start(15)
	end
	end
