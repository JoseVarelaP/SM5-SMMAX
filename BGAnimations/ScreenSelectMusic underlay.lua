local t = Def.ActorFrame{}

local function radarSet(self,pn)
	local selection = nil
	if GAMESTATE:GetCurrentSong() then
		selection = GAMESTATE:GetCurrentSteps(pn)
	end
	if selection then
		self:SetFromRadarValues(pn, selection:GetRadarValues(pn))
	else
		self:SetEmpty(pn)
	end
end

t[#t+1] = Def.GrooveRadar{
	InitCommand=function(self)
		self:xy( SCREEN_CENTER_X + 160 - 320, SCREEN_CENTER_Y + 334 - 240 )
	end,
	CurrentSongChangedMessageCommand=function (self)
		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			radarSet(self, pn)
		end
	end,
	CurrentStepsP1ChangedMessageCommand=function(self) radarSet(self, PLAYER_1) end,
	CurrentStepsP2ChangedMessageCommand=function(self) radarSet(self, PLAYER_2) end,
	CurrentTrailP1ChangedMessageCommand=function(self) radarSet(self, PLAYER_1) end,
	CurrentTrailP2ChangedMessageCommand=function(self) radarSet(self, PLAYER_2) end
}

return t
