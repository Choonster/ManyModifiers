-- The keys to use as "modifiers" and the spell cast by each one.
-- Format:
-- ["KEY"] = "Spell Name",
local MODIFIER_SPELLS = {
	["Q"] = "Frostbolt",
	["E"] = "Ice Lance",
	["2"] = "Frostfire Bolt",
}

-------------------
-- END OF CONFIG --
-------------------
-- Do not change anything below here.

_G["BINDING_HEADER_ManyModifiers"] = "ManyModifiers"
_G["BINDING_NAME_CLICK ManyModifiersButton"] = "Cast ManyModifiers Spell"

local ManyModifiersButton = CreateFrame("Button", "ManyModifiersButton", UIParent, "SecureActionButtonTemplate")
ManyModifiersButton:SetAttribute("type", "spell")

local Modifier_OnClick = [[ -- self, button, down
	local spell = self:GetAttribute("spell")
	local ManyModifiersButton = self:GetFrameRef("ManyModifiersButton")
	
	if down then -- On the down click, always set the main button's spell attribute to this modifier's spell
		ManyModifiersButton:SetAttribute("spell", spell)
	elseif ManyModifiersButton:GetAttribute("spell") == spell then -- On the up click, only clear the main button's spell attribute if it's this modifier's spell
		ManyModifiersButton:SetAttribute("spell", nil)
	end
]]

local function CreateModifierButton(key, spell)
	local button = CreateFrame("Button", "ManyModifiersModifier_" .. key, UIParent, "SecureHandlerClickTemplate")
	button:RegisterForClicks("AnyUp", "AnyDown")
	button:SetAttribute("spell", spell)
	button:SetFrameRef("ManyModifiersButton", ManyModifiersButton)
	button:SetAttribute("_onclick", Modifier_OnClick)	
	
	SetOverrideBindingClick(ManyModifiersButton, false, key, button:GetName()) -- We use override bindings so old bindings don't persist if the user changes their modifier keys
	
	return button
end

local ModifierButtons = {}
for key, spell in pairs(MODIFIER_SPELLS) do
	ModifierButtons[key] = CreateModifierButton(key, spell)
end
