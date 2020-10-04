local t = Def.ActorFrame{}

local function radarSet(self,pn)
    for i,pn in pairs( GAMESTATE:GetEnabledPlayers() ) do
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
end

t[#t+1] = Def.GrooveRadar{
    InitCommand=function(self)
        self:xy( SCREEN_CENTER_X + 160 - 320, SCREEN_CENTER_Y + 334 - 240 )
    end,
    CurrentSongChangedMessageCommand=radarSet,
    CurrentStepsP1ChangedMessageCommand=radarSet,
    CurrentStepsP2ChangedMessageCommand=radarSet,
}

return t