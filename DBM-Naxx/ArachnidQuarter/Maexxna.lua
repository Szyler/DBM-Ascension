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
	"UNIT_HEALTH"
)

-----Necrotic Poison-----
local timerNecrotic				= mod:NewNextTimer(60, 28798)
local warnNecrotic				= mod:NewAnnounce(L.MaexxnaNecrotic, 2, 28798)
-----WEB WRAP-----
local warnWebWrap			= mod:NewTargetAnnounce(28622, 2)
local timerWebWrap			= mod:NewNextTimer(40, 28622)
-----WEB SPRAY-----
local warnWebSpraySoon		= mod:NewSoonAnnounce(29484, 1)
local warnWebSprayNow		= mod:NewSpellAnnounce(29484, 3)
local timerWebSpray			= mod:NewNextTimer(40, 29484)
-----SPIDERLINGS-----
local timerSpider			= mod:NewNextTimer(16, 43134)
-----SOFT ENRAGE-----
local warnSoftEnrageSoon	= mod:NewSpellAnnounce(54123, 3)
local warnSoftEnrageNow		= mod:NewSoonAnnounce(54123, 2)
local maexxnaHealth
local phase

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	warnWebSpraySoon:Schedule(35 - delay)
	timerWebSpray:Start(40 - delay)
	timerWebWrap:Start(20-delay)
	timerSpider:Start(8 - delay)
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg:find(L.Spiderlings) then
		timer = 16
		timerSpider:Start(timer)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(28622) then -- Web Wrap
		warnWebWrap:Show(args.destName)
		timerWebWrap:Start()
		if args.destName == UnitName("player") then
			SendChatMessage(L.YellWebWrap, "YELL")
		end
	elseif args:IsSpellID(29484, 54125, 350287) then -- Web Spray
		timer = 40
		warnWebSprayNow:Show()
		warnWebSpraySoon:Schedule(timer-5)
		timerWebSpray:Start(timer)
	elseif args:IsSpellID(28776) then
		warnNecrotic:Show(args.spellName, args.destName, args.amount or 1)
		timerNecrotic:Start()
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(28776) then
		warnNecrotic:Show(args.spellName, args.destName, args.amount or 1)
	end
end

function mod:UNIT_HEALTH(args)
    maexxnaHealth = math.max(0, UnitHealth("boss1")) / math.max(1, UnitHealthMax("boss1")) * 100;
	
	if maexxnaHealth < 25 and phase == 1 then
		phase = 2
		warnSoftEnrageSoon:Show()
	elseif maexxnaHealth < 20 and phase == 2 then
		phase = 3
		warnSoftEnrageNow:Show()
	end
end
