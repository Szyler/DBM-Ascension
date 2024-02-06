local mod	= DBM:NewMod("Maexxna", "DBM-Naxx", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2943 $"):sub(12, -3))
mod:SetCreatureID(15952)
mod:RegisterCombat("combat")
mod:EnableModel()
mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_SUCCESS",
	"PLAYER_ALIVE",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_HEALTH",
	"UNIT_DIED"
)

-----Necrotic Poison-----
local warnNecrotic				= mod:NewAnnounce("%s on >%s< (%d)",3 ,2123201)
local specWarnNecrotic			= mod:NewSpecialWarningStack(2123201, 3)
----DIGESTIVE ACID----
local warnDigestive				= mod:NewAnnounce("%s on >%s< (%d)",3 ,2123202)
local specWarnDigestive			= mod:NewSpecialWarningStack(2123202, 1)
-----WEB WRAP-----
local warnWebWrap				= mod:NewTargetAnnounce(2123211, 2)
local timerWebWrap				= mod:NewNextTimer(40, 2123211)
-----WEB SPRAY-----
local warnWebSpraySoon			= mod:NewSoonAnnounce(2123206, 1)
local warnWebSprayNow			= mod:NewSpecialWarningSpell(2123206, 3)
local timerWebSpray				= mod:NewNextTimer(50, 2123206)
local timerWebStunSoon			= mod:NewTimer(4,"Stun incoming!", 2123210)
local timerWebStun 				= mod:NewTimer(4, "WRAPPED!", 2123210)
-----SPIDERLINGS-----
local timerSpider				= mod:NewNextTimer(16, 43134)
-----SOFT ENRAGE-----
local warnSoftEnrageSoon		= mod:NewSpellAnnounce(54123, 3)
local warnSoftEnrageNow			= mod:NewSoonAnnounce(54123, 2)
local phase
local webSpam	= 0
local necroticSpam	= 0
-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	webSpam = 0
	necroticSpam = 0
	warnWebSpraySoon:Schedule(35 - delay)
	timerWebSpray:Start(40 - delay)
	timerWebWrap:Start(20-delay)
	timerSpider:Start(8 - delay)
	self:ScheduleMethod(8-delay, "Spiders")
end

-- "Kel'Thuzad strikes!"


function mod:Spiders()
	timerSpider:Start()
	self:ScheduleMethod(16, "Spiders")
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2123201) then
		warnNecrotic:Show(args.spellName, args.destName, args.amount or 1)
	elseif args:IsSpellID(2123206, 2123207, 2123208, 2123209) and DBM:AntiSpam() then
		warnWebSprayNow:Show()
		timerWebStunSoon:Start()
		timerWebSpray:Start()
	elseif args:IsSpellID(2123211,2123212,2123216,2123217) and (GetTime() - webSpam) > 5 then -- Web Wrap
		webSpam = GetTime()
		warnWebWrap:Show(args.destName)
		timerWebWrap:Start()
		if args:IsPlayer() then
			SendChatMessage(L.YellWebWrap, "YELL")
		end
	elseif args:IsSpellID(2123210) then
		timerWebStun:Start()
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(2123201) then
		if args:IsPlayer() and args.amount >= 1 and (GetTime() - necroticSpam) > 5 then
			necroticSpam = GetTime()
			specWarnNecrotic:Show(args.amount)
		elseif args:IsPlayer() == false and args.amount >= 5 and (GetTime() - necroticSpam) > 5 then
			necroticSpam = GetTime()
			warnNecrotic:Show(args.spellName, args.destName, args.amount or 1)
		end
	elseif args:IsSpellID(2123202) then
		if args:IsPlayer() and args.amount >= 1 then
			specWarnDigestive:Show(args.amount)
		elseif args:IsPlayer() == false and args.amount >= 4 and args.amount <=10 then
			warnDigestive:Show(args.spellName, args.destName, args.amount or 1)
		end
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 15952 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.25 and phase == 1 then
		phase = 2
		warnSoftEnrageSoon:Show()
	elseif self:GetUnitCreatureId(uId) == 15952 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.20 and phase == 2 then
		phase = 3
		warnSoftEnrageNow:Show()
	end
end

function mod:OnCombatEnd()
	timerWebSpray:Stop()
	warnWebSpraySoon:Cancel()
	timerSpider:Stop()
	timerWebWrap:Stop()
	self:UnscheduleMethod("Spiders")
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 15952 or cid == 26616 then
		timerWebSpray:Stop()
		warnWebSpraySoon:Cancel()
		timerSpider:Stop()
		timerWebWrap:Stop()
		self:UnscheduleMethod("Spiders")
	end
end