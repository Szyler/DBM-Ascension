local mod	= DBM:NewMod("Kazrogal", "DBM-Hyjal")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(17888)
mod:RegisterCombat("combat", 17888)

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"CHAT_MSG_MONSTER_YELL",
	"SPELL_MISSED"
)


-- Pillar of Suffering (2141019) 200% increased Swing timer + can't dodge
-- Pillar of Cataclysm (2141018) Fire splash damage

-- 1st Pillar (10 seconds)

-- Mark of Kaz
local warnMark					= mod:NewSpellAnnounce(2141001, 3)
local timerMark					= mod:NewNextTimer(55, 2141000)

-- Warstomp
local warnStomp					= mod:NewSpellAnnounce(2141009, 2)
local timerStomp				= mod:NewNextTimer(55, 2141009)

-- Pillars
local timerPillar1				= mod:NewTimer(10, "First Pillar", 10408)
local timerPSuffering			= mod:NewTimer(40, "Pillar of Suffering duration", 2141030)
local warnPSuffering			= mod:NewAnnounce("The Pillar of Suffering has hit the ground", 2, 2141030)
local timerNextPSuffering		= mod:NewNextTimer(10,2141030)
local timerPCataclysm			= mod:NewTimer(40, "Pillar of Cataclysm duration", 2141026)
local warnPCataclysm			= mod:NewAnnounce("The Pillar of Cataclysm has hit the ground", 2, 2141026)
local timerNextPCataclysm		= mod:NewNextTimer(10, 2141026)
local pillar

-- Physical attacks
local timerNextMalevolent		= mod:NewNextTimer(51, 2141008)
local timerMalevolentSwing		= mod:NewCastTimer(4, 2141008)
local warnMalevolent			= mod:NewSpellAnnounce(2141008)

-- Scars & Debuffs  
local warnCataclysmic			= mod:NewAnnounce("You have %s stacks of Cataclysmic Scar", 2141040)
local warnTormenting			= mod:NewAnnounce("You have %s stacks of Tormenting Scar", 2141041)

-- fight
local warnChallenged			= mod:NewAnnounce("Kaz'rogal fixates on %s!",2141039)
local warnManaTotem				= mod:NewAnnounce("Thrall is summoning a Mana Stream Totem! Click it to replenish your mana!", 2140261)


function mod:OnCombatStart(delay)
	pillar = 0
	timerPillar1:Start(-delay)
	timerStomp:Start(-delay)
	timerMark:Start(14-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2141001) and args:IsPlayer() and DBM:AntiSpam(5,1) then
	timerMark:Start()
	warnMark:Show(args.amount)
	end
	if args:IsSpellID(2141039) then
		warnChallenged:Show(args.destName)
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(2141040) and args:IsPlayer() and args.amount >= 4 and DBM:AntiSpam(3,2) then
		warnCataclysmic:Show(args.amount)
	end
	if args:IsSpellID(2141041) and args:IsPlayer() and args.amount >= 4 and DBM:AntiSpam(3,3) then
		warnTormenting:Show(args.amount)
	end
end

function mod:SPELL_MISSED(args)
	if args:IsSpellID(2141009) and DBM:AntiSpam(1,1) then
		if pillar == 1 then
			timerNextPCataclysm:Start()
			pillar = 2
		elseif pillar == 2 then
			timerNextPSuffering:Start()
			pillar = 1
		end
		timerStomp:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2141027,2141028,2141029,2141030) and DBM:AntiSpam(40,3) then
		warnPSuffering:Show()
		timerPSuffering:Start()
		if pillar == 0 then
			pillar = 1
		end
	elseif args:IsSpellID(2141023,2141024,2141025,2141026) and DBM:AntiSpam(40,4) then
		warnPCataclysm:Show()
		timerPCataclysm:Start()
		if pillar == 0 then
			pillar = 2
		end
	end
	if args:IsSpellID(2141008) and DBM:AntiSpam(6, 5) then
		timerNextMalevolent:Start()
		timerMalevolentSwing:Start()
		warnMalevolent:Show()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
if msg == "I am summoning a Mana Stream Totem near us. Use it to replenish!" then
	warnManaTotem:Show()
end
end