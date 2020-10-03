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

return t