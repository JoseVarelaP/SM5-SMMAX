local t = Def.ActorFrame{}

-- Version Number
t[#t+1] = Def.BitmapText{
    Font="Common Normal",
    Text=ProductVersion(),
    OnCommand=function(self)
        -- Position first.
        self:halign(1):xy( SCREEN_RIGHT-20, 20 ):diffuse( color("0.6,0.6,0.6,1") ):zoom(0.5):shadowlength(2)
    end
}

-- Songs information
local SongCount = function()
    local stringset = string.format( "%d songs in %d groups, %d courses", SONGMAN:GetNumSongs(), #SONGMAN:GetSongGroupNames(), SONGMAN:GetNumCourses() )
    if PREFSMAN:GetPreference("UseUnlockSystem") then
        stringset = stringset .. string.format( ", %d unlocks", UNLOCKMAN:GetNumUnlocks() )
    end
    return stringset
end
t[#t+1] = Def.BitmapText{
    Font="Common Normal",
    Text=SongCount(),
    OnCommand=function(self)
        -- Position first.
        self:halign(0):xy( 20, 20 ):diffuse( color("0.6,0.6,0.6,1") ):zoom(0.5):shadowlength(2)
    end
}

t[#t+1] = Def.HelpDisplay {
    File="Common normal",
    OnCommand=function(self)
        self:zoom(0.5):zoomy(0):linear(0.5):zoomy(0.5):diffuseblink()
    end,
    InitCommand=function(self)
        self:SetSecsBetweenSwitches( THEME:GetMetric("HelpDisplay","TipSwitchTime") )
        local screenname = Var "LoadingScreen"
        local UseSpecialText = function()
            -- Title Menu uses special types based on the coin mode.
            if screenname == "ScreenTitleMenu" then
                local CoinMode = GAMESTATE:GetCoinMode()
                return "HelpText".. ToEnumShortString( CoinMode )
            end
            return "HelpText"
        end
        self:SetTipsColonSeparated( THEME:GetString( Var "LoadingScreen" ,UseSpecialText()) )
        self:xy( THEME:GetMetric( Var "LoadingScreen", "HelpX" ), THEME:GetMetric( Var "LoadingScreen", "HelpY" ) )
    end,
    OffCommand=function(self)
        self:linear(0.5):zoomy(0)
    end
}

return t