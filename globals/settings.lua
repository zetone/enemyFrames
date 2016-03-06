
_G = getfenv(0)

print = function(m) DEFAULT_CHAT_FRAME:AddMessage(m) end

tlength = function(t)	local i = 0 for k, j in ipairs(t) do i = i + 1 end return i end

ENEMYFRAMESPLAYERDATA = 
{
	['defaultIcon'] 		= 'rank',
	['scale']				= 1,
	['groupsize']			= 5,
	['layout']				= 'block',
	['frameMovable'] 		= true,
	['displayNames']		= true,
	['displayManabar']		= false,
	['displayOnlyNearby']	= false,
	['mouseOver']			= false,
	['enableOutdoors']		= false,
	['incomingSpells']		= false,
	
	['offX']				= 0,
	['offY']				= 0,
	
	['nameplatesdebuffs'] 	= true,
}


local playerFaction
------------ UI ELEMENTS ------------------
local enemyFactionColor
local checkBoxFeaturesN, checkBoxFeatures  = 3, { 	[1] = {['id'] = 'enableOutdoors', 		['label'] = 'Enable outside of BattleGrounds'},
													[2] = {['id'] = 'mouseOver', 			['label'] = 'Mouseover cast on frames'},	
													[3] = {['id'] = 'incomingSpells', 		['label'] = 'Display Incoming Spells (BGs only)'},
													}
local checkBoxOptionalsN, checkBoxOptionals  = 4, { [1] = {['id'] = 'displayNames', 		['label'] = 'Display names'}, 
													[2] = {['id'] = 'displayManabar', 		['label'] = 'Display mana bar'},
													[3] = {['id'] = 'displayOnlyNearby', 	['label'] = 'Display nearby units only'},
													[4] = {['id'] = 'nameplatesdebuffs', 	['label'] = 'Display nameplates debuffs'},
													}
local enemyFramesDisplayShow = false

local settings = CreateFrame('Frame', 'enemyFramesSettings', UIParent)
settings:ClearAllPoints()
settings:SetWidth(290) settings:SetHeight(320)
--settings:SetFrameLevel(6)
settings:SetPoint('CENTER', UIParent, -UIParent:GetWidth()/3, 0)
settings:SetBackdrop({bgFile   = [[Interface\Tooltips\UI-Tooltip-Background]],
				  edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
				  insets   = {left = 11, right = 12, top = 12, bottom = 11}})
settings:SetBackdropColor(0, 0, 0, 1)
settings:SetBackdropBorderColor(.2, .2, .2)
settings:SetMovable(true) settings:SetUserPlaced(true)
settings:SetClampedToScreen(true)
settings:RegisterForDrag'LeftButton' settings:EnableMouse(true)
settings:SetScript('OnDragStart', function() settings:StartMoving() end)
settings:SetScript('OnDragStop', function() settings:StopMovingOrSizing() end)
--tinsert(UISpecialFrames, 'enemyFramesSettings')
settings:Hide()

settings.x = CreateFrame('Button', 'enemyFramesSettingsCloseButton', settings, 'UIPanelCloseButton')
settings.x:SetPoint('TOPRIGHT',  -6, -6)
settings.x:SetScript('OnClick', function() settings:Hide() if not enemyFramesDisplayShow then _G['enemyFrameDisplay']:Hide() end INCOMINGSPELLSsettings(false) end)

settings.header = settings:CreateTexture(nil, 'ARTWORK')
settings.header:SetWidth(320) settings.header:SetHeight(64)
settings.header:SetPoint('TOP', settings, 0, 12)
settings.header:SetTexture[[Interface\DialogFrame\UI-DialogBox-Header]]
settings.header:SetVertexColor(.2, .2, .2)

settings.header.t = settings:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
settings.header.t:SetPoint('TOP', settings.header, 0, -14)
settings.header.t:SetText'enemyFrames Settings'

-- container

settings.containerScrollframe = CreateFrame('ScrollFrame', 'enemyFramesSettingsScrollframe', settings, 'UIPanelScrollFrameTemplate')
settings.containerScrollframe:SetFrameLevel(3)
settings.containerScrollframe:SetPoint('TOPLEFT', settings, -7, -36)
settings.containerScrollframe:SetPoint('BOTTOMRIGHT', settings, -37, 18)
settings.containerScrollframe:Raise()
settings.containerScrollframe:SetToplevel()

settings.container = CreateFrame('Frame', nil, settings.containerScrollframe)
settings.container:SetWidth(settings:GetWidth()) settings.container:SetHeight(settings:GetHeight())
settings.container:SetPoint('CENTER', settings)
settings.container:EnableMouse(true)
settings.container:EnableMouseWheel(true)

settings.containerScrollframe.content = settings.container
settings.containerScrollframe:SetScrollChild(settings.container)

-- scale

settings.container.scale = settings.container:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
settings.container.scale:SetPoint('LEFT', settings.container, 'TOPLEFT', 40, -30)
settings.container.scale:SetText'scale'

settings.container.scaleSlider = CreateFrame('Slider', 'enemyFramesScaleSlider', settings.container, 'OptionsSliderTemplate')
settings.container.scaleSlider:SetWidth(205) 	settings.container.scaleSlider:SetHeight(14)
settings.container.scaleSlider:SetPoint('LEFT', settings.container.scale, 'LEFT', 0, -30)
settings.container.scaleSlider:SetMinMaxValues(0.8, 1.4)
settings.container.scaleSlider:SetValueStep(.05)
_G[settings.container.scaleSlider:GetName()..'Low']:SetText'0.8'
_G[settings.container.scaleSlider:GetName()..'High']:SetText'1.4'


settings.container.scaleSlider:SetScript('OnValueChanged', function() 
	ENEMYFRAMESPLAYERDATA['scale'] = this:GetValue() 
	_G['enemyFrameDisplay']:SetScale(ENEMYFRAMESPLAYERDATA['scale'])
end)


-- layout

settings.container.layout = settings.container:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
settings.container.layout:SetPoint('LEFT', settings.container.scaleSlider, 'LEFT', 0, -40)
settings.container.layout:SetText'layout'

settings.container.layoutSlider = CreateFrame('Slider', 'enemyFramesLayoutSlider', settings.container, 'OptionsSliderTemplate')
settings.container.layoutSlider:SetWidth(205) 	settings.container.layoutSlider:SetHeight(14)
settings.container.layoutSlider:SetPoint('LEFT', settings.container.layout, 'LEFT', 0, -30)
settings.container.layoutSlider:SetMinMaxValues(0, 4)
settings.container.layoutSlider:SetValueStep(1)
_G[settings.container.layoutSlider:GetName()..'Low']:SetText'horizontal'
_G[settings.container.layoutSlider:GetName()..'High']:SetText'vertical'


settings.container.layoutSlider:SetScript('OnValueChanged', function() 
	local v = this:GetValue()
	local a = v == 0 and 'horizontal' or v == 1 and 'hblock' or v == 2 and 'block' or v == 3 and 'vblock' or 'vertical'
	local g = v == 0 and 1 or (v == 1 or v == 2) and 5 or v == 3 and 2 or 15
	ENEMYFRAMESPLAYERDATA['layout'] 	= a
	ENEMYFRAMESPLAYERDATA['groupsize']  = g
	ENEMYFRAMESsettings()
end)
	
	
-- features

settings.container.features = settings.container:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
settings.container.features:SetPoint('LEFT', settings.container.layoutSlider, 'LEFT', 0, -50)
settings.container.features:SetText'features'

settings.container.featuresList = {}
for i = 1, checkBoxFeaturesN, 1 do
	settings.container.featuresList[i] = CreateFrame('CheckButton', 'enemyFramesFeaturesCheckButton'..i, settings.container, 'UICheckButtonTemplate')
	settings.container.featuresList[i]:SetHeight(20) 	settings.container.featuresList[i]:SetWidth(20)
	settings.container.featuresList[i]:SetPoint('LEFT', i == 1 and settings.container.features or settings.container.featuresList[i-1], 'LEFT', 0, i == 1 and -30 or -20)
	_G[settings.container.featuresList[i]:GetName()..'Text']:SetText(checkBoxFeatures[i]['label'])
	_G[settings.container.featuresList[i]:GetName()..'Text']:SetPoint('LEFT', settings.container.featuresList[i], 'RIGHT', 4, 0)
	settings.container.featuresList[i].i = i
	settings.container.featuresList[i]:SetScript('OnClick', function()
		if this:GetChecked() then
			ENEMYFRAMESPLAYERDATA[checkBoxFeatures[this.i]['id']]	= true
		else
			ENEMYFRAMESPLAYERDATA[checkBoxFeatures[this.i]['id']]	= false
		end
		ENEMYFRAMESsettings()
		INCOMINGSPELLSsettings(ENEMYFRAMESPLAYERDATA['incomingSpells'])
	end)
end

-- optionals

settings.container.optionals = settings.container:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
settings.container.optionals:SetPoint('LEFT', settings.container.featuresList[checkBoxFeaturesN], 'LEFT', 0, -30)
settings.container.optionals:SetText'optional'

settings.container.optinalsList = {}
for i = 1, checkBoxOptionalsN, 1 do
	settings.container.optinalsList[i] = CreateFrame('CheckButton', 'enemyFramesOptionalsCheckButton'..i, settings.container, 'UICheckButtonTemplate')
	settings.container.optinalsList[i]:SetHeight(20) 	settings.container.optinalsList[i]:SetWidth(20)
	settings.container.optinalsList[i]:SetPoint('LEFT', i == 1 and settings.container.optionals or settings.container.optinalsList[i-1], 'LEFT', 0, i == 1 and -30 or -20)
	_G[settings.container.optinalsList[i]:GetName()..'Text']:SetText(checkBoxOptionals[i]['label'])
	_G[settings.container.optinalsList[i]:GetName()..'Text']:SetPoint('LEFT', settings.container.optinalsList[i], 'RIGHT', 4, 0)
	settings.container.optinalsList[i].i = i
	settings.container.optinalsList[i]:SetScript('OnClick', function()
		if this:GetChecked() then
			ENEMYFRAMESPLAYERDATA[checkBoxOptionals[this.i]['id']]	= true
		else
			ENEMYFRAMESPLAYERDATA[checkBoxOptionals[this.i]['id']]	= false
		end
		ENEMYFRAMESsettings()
	end)
end


-------------------------------------------


function setupSettings()
	playerFaction = UnitFactionGroup'player'
	if playerFaction == 'Alliance' then 
		enemyFactionColor = RGB_FACTION_COLORS['Horde']
	else 
		enemyFactionColor = RGB_FACTION_COLORS['Alliance']	
	end
	settings.header.t:SetTextColor(enemyFactionColor['r'], enemyFactionColor['g'], enemyFactionColor['b'], .9)
	_G[settings.container.scaleSlider:GetName()..'Low']:SetTextColor(enemyFactionColor['r'], enemyFactionColor['g'], enemyFactionColor['b'], .9)
	_G[settings.container.scaleSlider:GetName()..'High']:SetTextColor(enemyFactionColor['r'], enemyFactionColor['g'], enemyFactionColor['b'], .9)
	_G[settings.container.layoutSlider:GetName()..'Low']:SetTextColor(enemyFactionColor['r'], enemyFactionColor['g'], enemyFactionColor['b'], .9)
	_G[settings.container.layoutSlider:GetName()..'High']:SetTextColor(enemyFactionColor['r'], enemyFactionColor['g'], enemyFactionColor['b'], .9)
	
	--optionals
	for i = 1, checkBoxFeaturesN do
		_G[settings.container.featuresList[i]:GetName()..'Text']:SetTextColor(enemyFactionColor['r'], enemyFactionColor['g'], enemyFactionColor['b'], .9)
		settings.container.featuresList[i]:SetChecked(ENEMYFRAMESPLAYERDATA[checkBoxFeatures[i]['id']])
	end
	
	--optionals
	for i = 1, checkBoxOptionalsN do
		_G[settings.container.optinalsList[i]:GetName()..'Text']:SetTextColor(enemyFactionColor['r'], enemyFactionColor['g'], enemyFactionColor['b'], .9)
		settings.container.optinalsList[i]:SetChecked(ENEMYFRAMESPLAYERDATA[checkBoxOptionals[i]['id']])
	end

	settings.container.scaleSlider:SetValue(ENEMYFRAMESPLAYERDATA['scale'])
	settings.container.layoutSlider:SetValue(ENEMYFRAMESPLAYERDATA['layout'] == 'horizontal' and 0 or ENEMYFRAMESPLAYERDATA['layout'] == 'hblock' and 1 or ENEMYFRAMESPLAYERDATA['layout'] == 'block' and 2 or ENEMYFRAMESPLAYERDATA['layout'] == 'vblock' and 3 or 4)
		
	settings:Show()
	
	if _G['enemyFrameDisplay']:IsShown() then
		enemyFramesDisplayShow = true
	else
		enemyFramesDisplayShow = false
		_G['enemyFrameDisplay']:Show()
		--tinsert(UISpecialFrames, 'enemyFrameDisplay')
	end
	
	ENEMYFRAMESsettings()
	INCOMINGSPELLSsettings(ENEMYFRAMESPLAYERDATA['incomingSpells'])
end

local function eventHandler()
	if event == 'PLAYER_LOGIN' then
		playerFaction = UnitFactionGroup'player'
		local tc = playerFaction == 'Alliance' and 'FF1A1A' or '00ADF0'
		print('|cff' ..tc.. '[enemyFrames] loaded. |cffffffff/efs|cff' ..tc.. ' for menu settings.')
		_G['enemyFrameDisplay']:SetScale(ENEMYFRAMESPLAYERDATA['scale'])
		_G['enemyFrameDisplay']:SetPoint('CENTER', UIParent, ENEMYFRAMESPLAYERDATA['offX'], ENEMYFRAMESPLAYERDATA['offY'])
	elseif event == 'PLAYER_LOGOUT' then
		local point, relativeTo, relativePoint, xOfs, yOfs = _G['enemyFrameDisplay']:GetPoint()
		ENEMYFRAMESPLAYERDATA['offX'] = xOfs
		ENEMYFRAMESPLAYERDATA['offY'] = yOfs
	end
end

local f = CreateFrame'Frame'
f:RegisterEvent'PLAYER_LOGIN'
f:RegisterEvent'PLAYER_LOGOUT'
f:SetScript('OnEvent', eventHandler)

SLASH_ENEMYFRAMESSETTINGS1 = '/efs'
SlashCmdList["ENEMYFRAMESSETTINGS"] = function(msg)
	setupSettings()
	
end