local t = Def.ActorFrame{}

-- Background set.
t[#t+1] = Def.Quad{
    InitCommand=function(self)
        self:stretchto( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT):diffuse(Color.Black)
    end
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","ScreenStage/"..ToEnumShortString( GAMESTATE:GetCurrentStage() )),
    OnCommand=function(self)
        self:xy( SCREEN_CENTER_X, SCREEN_CENTER_Y+90 ):sleep(0.1):decelerate(0.6):y( SCREEN_CENTER_Y )
    end
}

-- Mask the stage text.
t[#t+1] = Def.Quad{
    InitCommand=function(self)
        self:zoomto( 640, 80 ):diffuse(Color.Black):xy( SCREEN_CENTER_X, SCREEN_CENTER_Y+90 )
    end
}

-- Mask the bottom half of the screen
t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","_underline"),
    OnCommand=function(self)
        self:xy( SCREEN_CENTER_X, SCREEN_CENTER_Y+50 ):zoomx(0.5):diffusealpha(0.5)
        :linear(0.1):zoomx(1):diffusealpha(1):sleep(0.1):accelerate(0.2):zoomx(0)
        :diffusealpha(0)
    end
}

return t