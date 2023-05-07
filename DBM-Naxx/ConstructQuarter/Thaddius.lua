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
	"SPELL_AURA_REMOVED"
)
-----POLARITY SHIFT-----
local timerShiftCast		= mod:NewCastTimer(4, 2124201)
local timerNextShift		= mod:NewNextTimer(34, 2124201)
local warnShiftCasting		= mod:NewCastAnnounce(2124201, 3)
local specWarnNegative		= mod:NewSpecialWarning("Negative Charge", 2, "Interface\\Icons\\Spell_ChargeNegative")
local specWarnPositive		= mod:NewSpecialWarning("Positive Charge", 2, "Interface\\Icons\\Spell_ChargePositive")
local specWarnMagnetic		= mod:NewSpecialWarningYou("Warning Magnetic Reversal",2124245)
local warnMagnetic			= mod:NewAnnounce("Magnetic Reversal", 2, 2124245, nil, "Show warning for Magnetic Reversal")
local warnChargeChanged		= mod:NewSpecialWarning("WarningChargeChanged")
local warnChargeNotChanged	= mod:NewSpecialWarning("WarningChargeNotChanged", false)
local timerMagnetic			= mod:NewTimer(15, 2124245)
local warnTankOvercharged	= mod:NewAnnounce("Tank is Overcharged", 1, 2124222, nil, "Show warning for Overcharged")
-----THROW-----
local warnThrow				= mod:NewSpellAnnounce(2124244, 2)
local warnThrowSoon			= mod:NewSoonAnnounce(2124244, 1)
local timerThrow			= mod:NewNextTimer(20.6, 2124244)
-----MISC-----

local enrageTimer			= mod:NewBerserkTimer(365)

mod:AddBoolOption("HealthFrame", true)
mod:SetBossHealthInfo(
15930, L.Boss1,
15929, L.Boss2
)
local currentCharge
local phase2
local i


-- Polarity shift (2124201)
-- Overcharged (2124222)
-- Magnetic Reversal (2124245)



-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	phase2 = false
	self.vb.phase = 1
	currentCharge = nil
	i = 8
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
		self:ScheduleMethod("ShiftingPolarity")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2124245) then
		if args:IsPlayer() then
			specWarnMagnetic:Show();
		else
			warnMagnetic:Show();
		end
			timerMagnetic:Start()
			mod:SetIcon(args.DestName, i, 15)
			i = i-1
	end
	if args:IsSpellID(2124222) then
		warnTankOvercharged:Show(args.DestName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(2124245) then
		i = 8
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
	local Name = UnitName(unit)
    while UnitDebuff(unit,"Negative Charge") and Name == UnitName("player") do
		specWarnNegative:Show()
	end
	while UnitDebuff(unit,"Positive Charge") and Name == UnitName("player") do
		specWarnPositive:Show()
	end
end

function mod:ShiftingPolarity()
	self:UnscheduleMethod("ShiftingPolarity")
	timerNextShift:Start()
	timerShiftCast:Start()
	warnShiftCasting:Show()
	self:ScheduleMethod(34,"ShiftingPolarity")
end

--local negativePolarity = CreateFrame("Frame", nil, UIParent)
--negativePolarity:Hide()
--local negativePolarity = NegativePolarity:CreateTexture(nil, "BACKGROUND")
--negativeTexture:SetTexture("Interface\\Icons\\Spell_ChargeNegative")
--negativeTexture:SetPoint("CENTER", negativePolarity, "CENTER")
--negativePolarity:SetHeight(1)
--negativePolarity:SetWidth(1)
--negativePolarity:SetPoint("CENTER", UIParent, "CENTER", -150, -30)
--negativePolarity:SetScript("OnShow", PolarityOnShow)
--negativePolarity:SetScript("OnUpdate", PolarityOnUpdate)

--local positivePolarity = CreateFrame("Frame", nil, UIParent)
--positivePolarity:Hide()
--local positivePolarity = positivePolarity:CreateTexture(nil, "BACKGROUND")
--positiveTexture:SetTexture("Interface\\Icons\\Spell_ChargePositive")
--positiveTexture:SetPoint("CENTER", positivePolarity, "CENTER")
--positivePolarity:SetHeight(1)
--positivePolarity:SetWidth(1)
--positivePolarity:SetPoint("CENTER", UIParent, "CENTER", -150, -30)
--positivePolarity:SetScript("OnShow", PolarityOnShow)
--positivePolarity:SetScript("OnUpdate", PolarityOnUpdate)


--local function PolarityOnUpdate(self, elapsed)
--	self.elapsed = (self.elapsed or 0) + elapsed
--	if self.elapsed >= 3.5 and self.elapsed < 4.5 then
--		self:SetAlpha(4.5 - self.elapsed)
--	elseif self.elapsed >= 4.5 then
--		self:Hide()
--	end
--end

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
