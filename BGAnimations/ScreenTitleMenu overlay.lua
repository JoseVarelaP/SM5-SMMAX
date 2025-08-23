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

-- Coin Mode perks
t[#t+1] = Def.Sprite{
    Condition=GAMESTATE:GetCoinMode() ~= "CoinMode_Home",
    OnCommand=function(self)
        if GAMESTATE:GetCoinMode() == "CoinMode_Pay" then
            if GAMESTATE:GetPremium() == "Premium_DoubleFor1Credit" then
                self:Load( THEME:GetPathG("","ScreenTitleMenu/doublepremium") )
                self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y + (380-240))
                :texcoordvelocity(.3,0)
            end
            if GAMESTATE:GetPremium() == "Premium_2PlayersFor1Credit" then
                self:Load( THEME:GetPathG("","ScreenTitleMenu/jointpremium") )
                self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y + (380-240))
                :texcoordvelocity(.3,0)
            end
        end
        if GAMESTATE:GetCoinMode() == "CoinMode_Free" then
            self:Load( THEME:GetPathG("","ScreenTitleMenu/free") )
            self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y + (180-240) )
            :diffuseshift():effectcolor1(color("0.5,0.5,0.5,1"))
            :effectcolor2(Color.White)
        end
    end
}

t[#t+1] = loadfile( THEME:GetPathB("","SharedItems/HelpDisplay.lua") )()

return t