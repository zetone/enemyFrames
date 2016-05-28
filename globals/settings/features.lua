	-------------------------------------------------------------------------------
	local settings = _G['enemyFramesSettings']
	
	local container = CreateFrame('Frame', 'enemyFramesSettingsfeaturesContainer', settings)
	container:SetWidth(settings:GetWidth()) container:SetHeight(settings:GetHeight())
	container:SetPoint('CENTER', settings)
	container:EnableMouse(true)
	container:EnableMouseWheel(true)
	container:Hide()
	-------------------------------------------------------------------------------
	local checkBoxFeaturesN, checkBoxFeatures  = 7, { 	[1] = {['id'] = 'enableOutdoors', 		['label'] = 'Enable outside of BattleGrounds'},
														[2] = {['id'] = 'mouseOver', 			['label'] = 'Mouseover cast on frames'},	
														[3] = {['id'] = 'incomingSpells', 		['label'] = 'Display Incoming Spells (BGs only)'},
														[4] = {['id'] = 'pvpmapblips', 			['label'] = 'Display class colored map blips'},
														[5] = {['id'] = 'targetFrameCastbar', 	['label'] = 'Display cast bar on Target Frame'},														
														[6] = {['id'] = 'targetPortraitDebuff', ['label'] = 'Display prio debuff on Target Portrait'},
														[7] = {['id'] = 'playerPortraitDebuff', ['label'] = 'Display prio debuff on Player Portrait'},
													}
	-------------------------------------------------------------------------------
	-- features
	container.features = container:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
	container.features:SetPoint('LEFT', container, 'TOPLEFT', 45, -30)
	container.features:SetText'features'

	container.featuresList = {}
	for i = 1, checkBoxFeaturesN, 1 do
		container.featuresList[i] = CreateFrame('CheckButton', 'enemyFramesFeaturesCheckButton'..i, container, 'UICheckButtonTemplate')
		container.featuresList[i]:SetHeight(20) 	container.featuresList[i]:SetWidth(20)
		container.featuresList[i]:SetPoint('LEFT', i == 1 and container.features or container.featuresList[i-1], 'LEFT', 0, i == 1 and -40 or -30)
		_G[container.featuresList[i]:GetName()..'Text']:SetText(checkBoxFeatures[i]['label'])
		_G[container.featuresList[i]:GetName()..'Text']:SetPoint('LEFT', container.featuresList[i], 'RIGHT', 4, 0)
		container.featuresList[i].i = i
		container.featuresList[i]:SetScript('OnClick', function()
			if this:GetChecked() then
				ENEMYFRAMESPLAYERDATA[checkBoxFeatures[this.i]['id']]	= true
			else
				ENEMYFRAMESPLAYERDATA[checkBoxFeatures[this.i]['id']]	= false
			end
			ENEMYFRAMESsettings()
			INCOMINGSPELLSsettings(ENEMYFRAMESPLAYERDATA['incomingSpells'])
		end)
	end
	-------------------------------------------------------------------------------
	FEATURESSETTINGSInit = function(color)
		for i = 1, checkBoxFeaturesN do
			_G[container.featuresList[i]:GetName()..'Text']:SetTextColor(color['r'], color['g'], color['b'], .9)
			container.featuresList[i]:SetChecked(ENEMYFRAMESPLAYERDATA[checkBoxFeatures[i]['id']])
		end
	end
	-------------------------------------------------------------------------------