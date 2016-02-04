
_G = getfenv(0)

print = function(m) DEFAULT_CHAT_FRAME:AddMessage(m) end


ENEMYFRAMESPLAYERDATA = 
{
	['defaultIcon'] = 'rank',
	['scale']		= 1,
	['groupsize']	= 5,
	['layout']		= 'block'
}


local playerFaction
------------ UI ELEMENTS ------------------
local enemyFactionColor


local menu = CreateFrame('Frame', 'enemyFramesSettings', UIParent)
menu:SetWidth(280) menu:SetHeight(260)
menu:SetPoint('CENTER', UIParent)
menu:SetBackdrop({bgFile   = [[Interface\Tooltips\UI-Tooltip-Background]],
				  edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
				  insets   = {left = 11, right = 12, top = 12, bottom = 11}})
menu:SetBackdropColor(0, 0, 0, 1)
menu:SetBackdropBorderColor(.2, .2, .2)
menu:SetMovable(true) menu:SetUserPlaced(true)
menu:RegisterForDrag'LeftButton' menu:EnableMouse(true)
menu:SetScript('OnDragStart', function() menu:StartMoving() end)
menu:SetScript('OnDragStop', function() menu:StopMovingOrSizing() end)
menu:Hide()

menu.x = CreateFrame('Button', 'enemyFramesSettingsCloseButton', menu, 'UIPanelCloseButton')
menu.x:SetPoint('TOPRIGHT', -6, -6)
menu.x:SetScript('OnClick', function() menu:Hide() _G['enemyFrameDisplay']:Hide() end)

menu.header = menu:CreateTexture(nil, 'ARTWORK')
menu.header:SetWidth(320) menu.header:SetHeight(64)
menu.header:SetPoint('TOP', menu, 0, 12)
menu.header:SetTexture[[Interface\DialogFrame\UI-DialogBox-Header]]
menu.header:SetVertexColor(.2, .2, .2)

menu.header.t = menu:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
menu.header.t:SetPoint('TOP', menu.header, 0, -14)
menu.header.t:SetText'enemyFrames Settings'


-- scale

menu.scale = menu:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
menu.scale:SetPoint('LEFT', menu, 'TOPLEFT', 40, -50)
menu.scale:SetText'scale'

menu.scaleSlider = CreateFrame('Slider', 'enemyFramesScaleSlider', menu, 'OptionsSliderTemplate')
menu.scaleSlider:SetWidth(200) 	menu.scaleSlider:SetHeight(14)
menu.scaleSlider:SetPoint('LEFT', menu.scale, 'LEFT', 0, -30)
menu.scaleSlider:SetMinMaxValues(0.8, 1.4)
menu.scaleSlider:SetValueStep(.1)
_G[menu.scaleSlider:GetName()..'Low']:SetText'0.8'
_G[menu.scaleSlider:GetName()..'High']:SetText'1.4'


menu.scaleSlider:SetScript('OnValueChanged', function() 
	ENEMYFRAMESPLAYERDATA['scale'] = this:GetValue() 
	_G['enemyFrameDisplay']:SetScale(ENEMYFRAMESPLAYERDATA['scale'])
end)


-- layout

menu.layout = menu:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
menu.layout:SetPoint('LEFT', menu.scaleSlider, 'LEFT', 0, -40)
menu.layout:SetText'layout'

menu.layoutSlider = CreateFrame('Slider', 'enemyFramesLayoutSlider', menu, 'OptionsSliderTemplate')
menu.layoutSlider:SetWidth(200) 	menu.layoutSlider:SetHeight(14)
menu.layoutSlider:SetPoint('LEFT', menu.layout, 'LEFT', 0, -30)
menu.layoutSlider:SetMinMaxValues(0, 2)
menu.layoutSlider:SetValueStep(1)
_G[menu.layoutSlider:GetName()..'Low']:SetText'horizontal'
_G[menu.layoutSlider:GetName()..'High']:SetText'vertical'


menu.layoutSlider:SetScript('OnValueChanged', function() 
	local a = this:GetValue() == 0 and 'horizontal' or this:GetValue() == 1 and 'block' or this:GetValue() == 2 and 'vertical'
	local g = this:GetValue() == 0 and 1 or this:GetValue() == 1 and 5 or this:GetValue() == 2 and 15
	ENEMYFRAMESPLAYERDATA['layout'] 	= a
	ENEMYFRAMESPLAYERDATA['groupsize']  = g
	ENEMYFRAMESsettings()
end)
	
-------------------------------------------


function setupSettings()
	playerFaction = UnitFactionGroup'player'
	if playerFaction == 'Alliance' then 
		enemyFactionColor = RGB_FACTION_COLORS['Horde']
	else 
		enemyFactionColor = RGB_FACTION_COLORS['Alliance']	
	end
	menu.header.t:SetTextColor(enemyFactionColor['r'], enemyFactionColor['g'], enemyFactionColor['b'], .9)
	_G[menu.scaleSlider:GetName()..'Low']:SetTextColor(enemyFactionColor['r'], enemyFactionColor['g'], enemyFactionColor['b'], .9)
	_G[menu.scaleSlider:GetName()..'High']:SetTextColor(enemyFactionColor['r'], enemyFactionColor['g'], enemyFactionColor['b'], .9)
	_G[menu.layoutSlider:GetName()..'Low']:SetTextColor(enemyFactionColor['r'], enemyFactionColor['g'], enemyFactionColor['b'], .9)
	_G[menu.layoutSlider:GetName()..'High']:SetTextColor(enemyFactionColor['r'], enemyFactionColor['g'], enemyFactionColor['b'], .9)

	menu.scaleSlider:SetValue(ENEMYFRAMESPLAYERDATA['scale'])
	menu.layoutSlider:SetValue(ENEMYFRAMESPLAYERDATA['layout'] == 'horizontal' and 0 or ENEMYFRAMESPLAYERDATA['layout'] == 'block' and 1 or 2)
	menu:Show()
end

SLASH_ENEMYFRAMESSETTINGS1 = '/efs'
SlashCmdList["ENEMYFRAMESSETTINGS"] = function(msg)
	setupSettings()
	_G['enemyFrameDisplay']:Show()
end