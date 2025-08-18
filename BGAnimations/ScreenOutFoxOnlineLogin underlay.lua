    local DetermineHeader = function()
    local screenName = Var "LoadingScreen"
    local SetRedirects = {
        ["ScreenPlayerOptions"] = "_shared options header"
    }

    if SetRedirects[screenName] then
        return THEME:GetPathG("","Headers/"..SetRedirects[screenName])
    else
        if string.find( screenName, "Options" ) then
            return THEME:GetPathG("","Headers/_shared options header")
        end
    end

    local pathloc = "Graphics/Headers/".. screenName..".png"
    if FILEMAN:DoesFileExist( THEME:GetCurrentThemeDirectory()..pathloc ) then
        return THEME:GetPathG("","Headers/".. screenName)
    end
    return THEME:GetPathG("Headers/_shared menu","header")
end

return Def.ActorFrame{
    Def.Sprite{
        Condition=THEME:GetMetric(Var "LoadingScreen", "ShowFooter"),
        Texture=THEME:GetPathG("_shared","footer"),
        OnCommand=function(self)
            self:valign(1):xy(SCREEN_CENTER_X,SCREEN_BOTTOM)
        end
    },

    Def.Quad{
        Condition=THEME:GetMetric(Var "LoadingScreen", "ShowHeader"),
        OnCommand=function(self)
            self:align(1,0):xy(SCREEN_RIGHT,0):diffuse(color("#0073a5")):zoomto(600,44)
            if string.find( Var "LoadingScreen", "Options" ) then
                self:visible(false)
            end
        end
    },
    Def.Sprite{
        Condition=THEME:GetMetric(Var "LoadingScreen", "ShowHeader"),
        Texture=DetermineHeader(),
        OnCommand=function(self)
            self:x(SCREEN_CENTER_X)
            self:valign(0):addx(SCREEN_WIDTH):spring(0.5):addx(-SCREEN_WIDTH)
        end,
        OffCommand=function(self)
            self:bouncebegin(0.5):addx(SCREEN_WIDTH)
        end
    },
    loadfile( THEME:GetPathB("","SharedItems/HelpDisplay.lua") )(),
}
