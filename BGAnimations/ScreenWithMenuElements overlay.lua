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
        Texture=THEME:GetPathG("_shared","footer"),
        OnCommand=function(self)
            self:align(0,1):y(SCREEN_BOTTOM)
        end
    },
    Def.Sprite{
        Texture=DetermineHeader(),
        OnCommand=function(self)
            self:align(0,0)
        end
    },
    loadfile( THEME:GetPathB("","SharedItems/HelpDisplay.lua") )()
}