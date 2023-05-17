local mod	= DBM:NewMod("Thaddius", "DBM-Naxx", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2869 $"):sub(12, -3))
mod:SetCreatureID(15928)
mod:RegisterCombat("yell", L.Yell)
mod:EnableModel()
mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_AURA",
	"PLAYER_ALIVE",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"UNIT_DIED"
)
-----POLARITY SHIFT-----
local timerShiftCast			= mod:NewCastTimer(4, 2124201)
local timerNextShift			= mod:NewNextTimer(34, 2124201)
local warnShiftCasting			= mod:NewCastAnnounce(2124201, 2)
local specWarnNegative			= mod:NewSpecialWarningMove(2124203, 2)
local specWarnPositive			= mod:NewSpecialWarningMove(2124202, 2)
local warnMagnetic				= mod:NewAnnounce("Magnetic Reversal", 2, 2124245, nil, "Show warning for Magnetic Reversal")
local timerMagnetic				= mod:NewTimer(16, "Magnetic Reversal duration", 2124245)
local warnTankOvercharged		= mod:NewTargetAnnounce(2124222, 2)
local specWarnTankOvercharged	= mod:NewSpecialWarningYou(2124222, 2)
-----THROW-----
local warnThrow					= mod:NewSpellAnnounce(2124244, 2)
local warnThrowSoon				= mod:NewSoonAnnounce(2124244, 2)
local timerThrow				= mod:NewNextTimer(20.6, 2124244)
-----MISC-----

local enrageTimer			= mod:NewBerserkTimer(365)

mod:AddBoolOption("HealthFrame", true)
mod:SetBossHealthInfo(
15930, L.Boss1,
15929, L.Boss2
)
local currentCharge
local phase2
local i = 7

-- Polarity shift (2124201)
-- Overcharged (2124222)
-- Magnetic Reversal (2124245)
--TEST REALM--
local negativePolarity = CreateFrame("Frame", nil, UIParent)
negativePolarity:Hide()
local negativeTexture = negativePolarity:CreateTexture(nil, "BACKGROUND")
negativeTexture:SetTexture("Interface\\Icons\\Spell_ChargeNegative")
negativeTexture:SetPoint("CENTER", negativePolarity, "CENTER")
negativePolarity:SetHeight(0.8)
negativePolarity:SetWidth(0.8)
negativePolarity:SetPoint("CENTER", UIParent, "CENTER", 0, 445)

local positivePolarity = CreateFrame("Frame", nil, UIParent)
positivePolarity:Hide()
local positiveTexture = positivePolarity:CreateTexture(nil, "BACKGROUND")
positiveTexture:SetTexture("Interface\\Icons\\Spell_ChargePositive")
positiveTexture:SetPoint("CENTER", positivePolarity, "CENTER")
positivePolarity:SetHeight(0.8)
positivePolarity:SetWidth(0.8)
positivePolarity:SetPoint("CENTER", UIParent, "CENTER", 0, 445)

-- Polarity Positive (2124202)
-- Polarity Negative (2124203)

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	phase2 = false
	self.vb.phase = 1
	currentCharge = 0
	i = 7
	down = 0
	self:ScheduleMethod(20.6 - delay, "TankThrow")
	timerThrow:Start(-delay)
	warnThrowSoon:Schedule(17.6 - delay)
end

function mod:TankThrow()
	if not self:IsInCombat() or phase2 then
		DBM.BossHealth:Hide()
		return
	end
	timerThrow:Start()
	warnThrowSoon:Schedule(17.6)
	self:ScheduleMethod(20.6, "TankThrow")
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2124201) then
		phase2 = true
		self.vb.phase = 2
		self:ScheduleMethod(0, "ShiftingPolarity")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2124245) and DBM:AntiSpam(2, 6) then
		if args:IsPlayer() then
			SendChatMessage("Magnetic Reversal on "..UnitName("PLAYER").."!", "Say")
		end
		warnMagnetic:Show(args.destName)
		timerMagnetic:Start()
		mod:SetIcon(args.destName, i, 15)
		i = i-1
	elseif args:IsSpellID(2124222) then
		local tanktarget = args.destName
		if args:IsPlayer() then
			specWarnTankOvercharged:Show()
		else
			warnTankOvercharged:Show(tanktarget)
		end
		mod:SetIcon(tanktarget, 8, 15)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(2124245) then
		i = 7
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L.Emote or msg == L.Emote2 then
		self:UnscheduleMethod("TankThrow")
		timerThrow:Cancel()
		warnThrowSoon:Cancel()
		DBM.BossHealth:Hide()
		enrageTimer:Start()
	end
end

function mod:UNIT_AURA(unit)
	if UnitDebuff("Player","Polarity: Negative") then
		if currentCharge == 1 or currentCharge == 0 then
			specWarnNegative:Show()
		end
		currentCharge = 2
		negativePolarity:Show()
		positivePolarity:Hide()
	elseif UnitDebuff("Player","Polarity: Positive") then
		if currentCharge == 2 or currentCharge == 0 then
			specWarnPositive:Show()
		end
		currentCharge = 1
		negativePolarity:Hide()
		positivePolarity:Show()
	end
end

function mod:ShiftingPolarity()
	timerNextShift:Start()
	timerShiftCast:Start()
	warnShiftCasting:Show()
	self:ScheduleMethod(34,"ShiftingPolarity")
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 15928 or cid == 26629 then
	positivePolarity:Hide()
	negativePolarity:Hide()
	timerShiftCast:Stop()
	timerMagnetic:Stop()
	self:UnscheduleMethod("ShiftingPolarity")
	end
end

function mod:OnCombatEnd()
	negativePolarity:Hide()
	positivePolarity:Hide()
	self:UnscheduleMethod("ShiftingPolarity")
end
--local function PolarityOnShow(self)
--	self.elapsed = 0
--	self:SetAlpha(1)
--end


--function mod:ShowNegativePolarity()
--	negativePolarity:Show()
--end

--function mod:ShowPositivePolarity()
	--	positivePolarity:Show()
	--end






-----------------------CURRENTLY DEPRECATED-----------------------
--mod:AddBoolOption("ArrowsEnabled", false, "Arrows")
--mod:AddBoolOption("ArrowsRightLeft", false, "Arrows")
--mod:AddBoolOption("ArrowsInverse", false, "Arrows")




--function mod:UNIT_AURA(elapsed)
--	if not phase2 then return end
--	local charge
--	local i = 1
--	while UnitDebuff("player", i) do
--		local _, _, icon, count = UnitDebuff("player", i)
--		if icon == "Interface\\Icons\\Spell_ChargeNegative" then
--			if count > 1 then return end
--			charge = L.Charge1
--		elseif icon == "Interface\\Icons\\Spell_ChargePositive" then
--			if count > 1 then return end
--			charge = L.Charge2
--		end
--		i = i + 1
--	end
--	if charge then
--		lastShift = 0
--		if charge == currentCharge then
--			warnChargeNotChanged:Show()
--			if self.Options.ArrowsEnabled and self.Options.ArrowsRightLeft then
--				if self.Options.ArrowsInverse then
--					self:ShowLeftArrow()
--			else
--					self:ShowRightArrow()
--				end
--			end
--		else
--			warnChargeChanged:Show(charge)
--			if self.Options.ArrowsEnabled then
--				if self.Options.ArrowsRightLeft and self.Options.ArrowsInverse then
--					self:ShowRightArrow()
--				elseif self.Options.ArrowsRightLeft then
--					self:ShowLeftArrow()
--				elseif currentCharge then
--					self:ShowUpArrow()
--				end
--			end
--		end
--		currentCharge = charge
--	end
--end





--local function arrowOnUpdate(self, elapsed)
--	self.elapsed = (self.elapsed or 0) + elapsed
--	if self.elapsed >= 3.5 and self.elapsed < 4.5 then
--		self:SetAlpha(4.5 - self.elapsed)
--	elseif self.elapsed >= 4.5 then
--		self:Hide()
--	end
--end

--local function arrowOnShow(self)
--	self.elapsed = 0
--	self:SetAlpha(1)
--end

-- this file uses the texture Textures/arrow.tga. This image was created by Everaldo Coelho and is licensed under the GNU Lesser General Public License. See Textures/lgpl.txt.
--local arrowLeft = CreateFrame("Frame", nil, UIParent)
--arrowLeft:Hide()
--local arrowLeftTexture = arrowLeft:CreateTexture(nil, "BACKGROUND")
--arrowLeftTexture:SetTexture("Interface\\AddOns\\DBM-Naxx\\ConstructQuarter\\Textures\\arrow")
--arrowLeftTexture:SetPoint("CENTER", arrowLeft, "CENTER")
--arrowLeft:SetHeight(1)
--arrowLeft:SetWidth(1)
--arrowLeft:SetPoint("CENTER", UIParent, "CENTER", -150, -30)
--arrowLeft:SetScript("OnShow", arrowOnShow)
--arrowLeft:SetScript("OnUpdate", arrowOnUpdate)

--local arrowRight = CreateFrame("Frame", nil, UIParent)
--arrowRight:Hide()
--local arrowRightTexture = arrowRight:CreateTexture(nil, "BACKGROUND")
--arrowRightTexture:SetTexture("Interface\\AddOns\\DBM-Naxx\\ConstructQuarter\\Textures\\arrow")
--arrowRightTexture:SetPoint("CENTER", arrowRight, "CENTER")
----arrowRightTexture:SetTexCoord(1, 0, 0, 1)
--arrowRight:SetHeight(1)
--arrowRight:SetWidth(1)
--arrowRight:SetPoint("CENTER", UIParent, "CENTER", 150, -30)
--arrowRight:SetScript("OnShow", arrowOnShow)
--arrowRight:SetScript("OnUpdate", arrowOnUpdate)

--local arrowUp = CreateFrame("Frame", nil, UIParent)
--arrowUp:Hide()
--local arrowUpTexture = arrowUp:CreateTexture(nil, "BACKGROUND")
--arrowUpTexture:SetTexture("Interface\\AddOns\\DBM-Naxx\\ConstructQuarter\\Textures\\arrow")
--arrowUpTexture:SetRotation(math.pi * 3 / 2)
--arrowUpTexture:SetPoint("CENTER", arrowUp, "CENTER")
--arrowUp:SetHeight(1)
--arrowUp:SetWidth(1)
--arrowUp:SetPoint("CENTER", UIParent, "CENTER", 0, 40)
--arrowUp:SetScript("OnShow", arrowOnShow)
--arrowUp:SetScript("OnUpdate", arrowOnUpdate)

--function mod:ShowRightArrow()
--	arrowRight:Show()
--end

--function mod:ShowLeftArrow()
--	arrowLeft:Show()
--end
--
--function mod:ShowUpArrow()
--	arrowUp:Show()
--end
