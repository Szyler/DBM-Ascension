local mod	= DBM:NewMod("Netherspite", "DBM-Karazhan")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 161 $"):sub(12, -3))
mod:SetCreatureID(15689)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_PERIODIC_DAMAGE",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED"
)

local warningPortalSoon		= mod:NewAnnounce("DBM_NS_WARN_PORTAL_SOON", 2, "Interface\\Icons\\Spell_Arcane_PortalIronForge")
local warningBanishSoon		= mod:NewAnnounce("DBM_NS_WARN_BANISH_SOON", 2, "Interface\\Icons\\Spell_Shadow_Cripple")
local warningPortal			= mod:NewAnnounce("warningPortal", 3, "Interface\\Icons\\Spell_Arcane_PortalIronForge")
local warningBanish			= mod:NewAnnounce("warningBanish", 3, "Interface\\Icons\\Spell_Shadow_Cripple")
local warningBreathCast		= mod:NewSpellAnnounce(38523, 2)
local warningVoid			= mod:NewSpellAnnounce(37063, 3)

local specWarnVoid			= mod:NewSpecialWarningMove(30533)
local specWarnBreath		= mod:NewSpecialWarningYou(38523)

local timerPortalPhase		= mod:NewTimer(50, "timerPortalPhase", "Interface\\Icons\\Spell_Arcane_PortalIronForge")
local timerBanishPhase		= mod:NewTimer(31, "timerBanishPhase", "Interface\\Icons\\Spell_Shadow_Cripple")
local timerBreathCast		= mod:NewCastTimer(4, 38523)

local berserkTimer			= mod:NewBerserkTimer(540)

mod:AddBoolOption(L.SaySmol, false)

function mod:SaySmol()
	if self.smol and self.Options.SaySmol then
		SendChatMessage(UnitName("PLAYER"), "SAY");
	end
end

mod:RegisterOnUpdateHandler(mod.SaySmol,2);

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	timerPortalPhase:Start(62-delay)
	warningBanishSoon:Schedule(57-delay)
	self.smol = false;
end

function mod:OnCombatEnd()
	self.smol = false;
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(38523) then
		warningBreathCast:Show()
		timerBreathCast:Start()
		if args:IsPlayer() then
			specWarnBreath:Show()
		end
	elseif args:IsSpellID(38549) then
		timerPortalPhase:Start()
		warningBanishSoon:Schedule(45)
		timerBanishPhase:Cancel()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(37014, 37063) then
		warningVoid:Show()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(38549) then
		warningBanish:Show()
		timerPortalPhase:Cancel()
		warningPortalSoon:Schedule(25)
		warningPortal:Schedule(31)
		timerBanishPhase:Start()
	elseif args:IsSpellID(30421) and args:IsPlayer() then
		self.smol = false;
	end
end

do 
	local lastVoid = 0
	function mod:SPELL_PERIODIC_DAMAGE(args)
		if args:IsSpellID(30533) and args:IsPlayer() and ((GetTime() - lastVoid) > 2) then
			specWarnVoid:Show()
			lastVoid = GetTime()
		end
	end
end

-- function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)        -- deprecated due to not working on Ascension.
--	if msg == L.DBM_NS_EMOTE_PHASE_2 then
--		timerPortalPhase:Cancel()
--		warningBanish:Show()
--		timerBanishPhase:Start()
--		warningPortalSoon:Schedule(26)
--	elseif msg == L.DBM_NS_EMOTE_PHASE_1 then
--		timerBanishPhase:Cancel()
--		warningPortal:Show()
--		timerPortalPhase:Start()
--		warningBanishSoon:Schedule(56.5)
--	end
--end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(30421) and args:IsPlayer() and (args.amount >= 35) then
		self.smol = true
	end
end