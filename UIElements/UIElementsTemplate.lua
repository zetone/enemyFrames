	-------------------------------------------------------------------------------
	local TEXTURE = [[Interface\AddOns\enemyFrames\globals\resources\barTexture.tga]]
	local BACKDROP = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],}

	local unitWidth, unitHeight, castBarHeight, ccIconWidth, manaBarHeight = 64, 22, 8, 28, 4
	UIElementsGetDimensions = function()
		return unitWidth, unitHeight, castBarHeight, ccIconWidth, manaBarHeight
	end
	CreateEnemyUnitFrame = function(name, parentFrame)
		-- unit button
		local self = CreateFrame('Button', name, parentFrame)
		--self:SetFrameLevel(0)
		self:SetWidth(unitWidth)	self:SetHeight(unitHeight)
		self:RegisterForClicks('LeftButtonUp', 'RightButtonUp')		
		self.mo = false
			
		-- health statusbar
		self.hpbar = CreateFrame('StatusBar', nil, self)
		self.hpbar:SetFrameLevel(1)
		self.hpbar:SetStatusBarTexture(TEXTURE)
		self.hpbar:SetWidth(unitWidth)	self.hpbar:SetHeight(unitHeight)
		self.hpbar:SetMinMaxValues(0, 100)
		self.hpbar:SetPoint('TOPLEFT', self, 'TOPLEFT')
		
		self.hpbar:SetBackdrop(BACKDROP)
		self.hpbar:SetBackdropColor(0, 0, 0, .6)
			
		-- mana statusbar
		self.manabar = CreateFrame('StatusBar', nil, self)
		self.manabar:SetFrameLevel(1)
		self.manabar:SetStatusBarTexture(TEXTURE)
		self.manabar:SetHeight(manaBarHeight)
		self.manabar:SetWidth(unitWidth)		
		self.manabar:SetPoint('TOPLEFT', self.hpbar, 'BOTTOMLEFT')
		
		self.manabar:SetBackdrop(BACKDROP)
		self.manabar:SetBackdropColor(0, 0, 0)
		
		
		-- cast bar --
		self.castbar = CreateFrame('StatusBar', nil, self)
		--self.castbar:SetFrameLevel(0)
		self.castbar:SetStatusBarTexture(TEXTURE)
		self.castbar:SetHeight(castBarHeight)
		self.castbar:SetWidth((unitWidth + ccIconWidth + 4) - (self.castbar:GetHeight()))	
		self.castbar:SetStatusBarColor(1, .4, 0)
		self.castbar:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', self.castbar:GetHeight(), -3)
		
		self.castbar:SetBackdrop(BACKDROP)
		self.castbar:SetBackdropColor(0, 0, 0, .6)
		
		
		self.castbar.iconborder = CreateFrame('Frame', nil, self.castbar)
		self.castbar.iconborder:SetWidth(self.castbar:GetHeight()+1)	self.castbar.iconborder:SetHeight(self.castbar:GetHeight()+1)
		self.castbar.iconborder:SetPoint('RIGHT', self.castbar, 'LEFT')
		
		self.castbar.icon = self.castbar.iconborder:CreateTexture(nil, 'ARTWORK')
		self.castbar.icon:SetTexCoord(.078, .92, .079, .937)
		self.castbar.icon:SetAllPoints()
		self.castbar.icon:SetPoint('CENTER', self.castbar.iconborder, 'CENTER')
		
		self.castbar.text = self.castbar:CreateFontString(nil, 'OVERLAY')
		self.castbar.text:SetTextColor(1, 1, 1)
		self.castbar.text:SetFont(STANDARD_TEXT_FONT, 8, 'OUTLINE')
		--self.castbar.text:SetShadowOffset(1, -1)
		self.castbar.text:SetShadowColor(0.4, 0.4, 0.4)
		self.castbar.text:SetPoint('LEFT', self.castbar, 'LEFT', 1, 1)
		
		
		--[[
		self.castbar.timer = self.castbar:CreateFontString(nil, 'OVERLAY')
		self.castbar.timer:SetFont(STANDARD_TEXT_FONT, 8)
		self.castbar.timer:SetTextColor(1, 1, 1)
		self.castbar.timer:SetShadowOffset(1, -1)
		self.castbar.timer:SetShadowColor(0, 0, 0)
		self.castbar.timer:SetPoint('LEFT', self.castbar, 'RIGHT', 2, 1)
		self.castbar.timer:SetText('1.5s')]]--
		--------------

		self.name = self:CreateFontString(nil, 'OVERLAY')
		self.name:SetFont(STANDARD_TEXT_FONT, 11, 'OUTLINE')
		self.name:SetTextColor(.8, .8, .8, .8)
		self.name:SetPoint('CENTER', self.hpbar)	
		
		
		---- RAID TARGET
		self.raidTarget = CreateFrame('Frame', nil, self)
		self.raidTarget:SetWidth(ccIconWidth-2) self.raidTarget:SetHeight(unitHeight-2)
		self.raidTarget:SetPoint('CENTER', self,'TOPRIGHT', 0, -4)
		self.raidTarget:SetFrameLevel(6)
		
		self.raidTarget.icon = self.raidTarget:CreateTexture(nil, 'ARTWORK')
		self.raidTarget.icon:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
		self.raidTarget.icon:SetAllPoints()
		
		
		---- CC ------
		self.cc = CreateFrame('Frame', name..'CC', self)
		self.cc:SetWidth(ccIconWidth) self.cc:SetHeight(unitHeight)
		self.cc:SetPoint('TOPLEFT', self,'TOPRIGHT', 4, 0)
		
		self.cc.border = CreateFrame('Frame', nil, self.cc)
		self.cc.border:SetAllPoints()
		self.cc.border:SetFrameLevel(5)
		
		self.cc.icon = self.cc:CreateTexture(nil, 'ARTWORK')
		self.cc.icon:SetAllPoints()
		self.cc.icon:SetTexCoord(.1, .9, .25, .75)
		
		self.cc.bg = self.cc:CreateTexture(nil, 'BACKGROUND')
		self.cc.bg:SetTexture(0, 0, 0, .6)
		self.cc.bg:SetAllPoints()

		-- dummy frame lvl 5 to draw text above cooldown
		self.cc.durationFrame = CreateFrame('Frame', nil, self.cc)
		self.cc.durationFrame:SetAllPoints()
		self.cc.durationFrame:SetFrameLevel(6)
		
		self.cc.duration = self.cc.durationFrame:CreateFontString(nil, 'OVERLAY')--, 'GameFontNormalSmall')
		self.cc.duration:SetFont(STANDARD_TEXT_FONT, 10, 'OUTLINE')
		self.cc.duration:SetTextColor(.9, .9, .2, 1)
		self.cc.duration:SetShadowOffset(1, -1)
		self.cc.duration:SetShadowColor(0, 0, 0)
		self.cc.duration:SetPoint('BOTTOM', self.cc, 'BOTTOM', 0, 1)
		
		-- cooldown
		self.cc.cd = CreateCooldown(self.cc, .58, true)
		self.cc.cd:SetAlpha(1)
	
		return self
	end
	-------------------------------------------------------------------------------