local function myCustomInput(event)
    if event.type == "InputEventType_FirstPress" then
        if event.GameButton == "Start" then
            SCREENMAN:GetTopScreen():StartTransitioningScreen( "SM_GoToNextScreen", 0.2 )
        end
    end
end

local t = Def.ActorFrame{
    OnCommand=function(self)
        SCREENMAN:GetTopScreen():AddInputCallback(myCustomInput)
    end
}

t[#t+1] = loadfile( THEME:GetPathB("ScreenWithMenuElements","overlay") )()

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","_moveon"),
    InitCommand=function(self)
        self:Center()
    end
}
-- Check for the style.
local pm = ToLower(ToEnumShortString(GAMESTATE:GetPlayMode()))
t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("ScreenInstructions/ScreenInstructions",pm),
    InitCommand=function(self)
        self:Center():zoom(1)
    end,
    OnCommand=function(self)
        self:addx(SCREEN_WIDTH):decelerate(0.25):addx(-SCREEN_WIDTH)
    end
}

return t