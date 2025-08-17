local GameModeGraphic = function()
    -- Get the current name, it will always be lowercase (dance,pump,ez2)
    local gamemode = GAMESTATE:GetCurrentGame():GetName()
    -- Now check if it's available, and we can use it.
    if FILEMAN:DoesFileExist( THEME:GetPathG("","ScreenLogo/"..gamemode) ) then
        return THEME:GetPathG("","ScreenLogo/"..gamemode)
    end
    -- If there's none available, then just return SMMAX.
    return THEME:GetPathG("","ScreenLogo/dance")
end

return Def.ActorFrame{
    Def.Sprite{
        Texture="1.png",
        OnCommand=function(self)
            self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
        end
    },
    Def.Sprite{ Texture=GameModeGraphic(),
        OnCommand=function(self)
            self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoomy(0):sleep(0.5)
            :bounceend(0.5):zoomy(1):glowshift():effectperiod(2.5)
            :effectcolor1( color("1,1,1,0.1") ):effectcolor2( color("1,1,1,0.3") )
        end
    }
}