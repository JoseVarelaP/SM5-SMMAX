local t = Def.ActorFrame{}

t[#t+1] = loadfile( THEME:GetPathB("ScreenWithMenuElements","overlay") )()

t[#t+1] = Def.Quad{
    InitCommand=function(self)
        self:stretchto( 0,0, SCREEN_WIDTH, SCREEN_HEIGHT ):diffuse( Alpha(Color.Black,0) )
    end,
    ShowPressStartForOptionsCommand=function(self)
        self:linear(0.25):diffusealpha(1)
    end
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("ScreenPlayerOptions","Options"),
    InitCommand=function(self)
        self:Center():pause():zoomy(0)
    end;
    ShowPressStartForOptionsCommand=function(self)
        self:linear(0.25):zoomy(1):sleep(1):linear(0.25):zoomy(0)
    end;
    ShowEnteringOptionsCommand=function(self)
        self:stoptweening():setstate(1):sleep(0.25):linear(0.25):zoomy(0)
    end;
    HidePressStartForOptionsCommandCommand=function(self)
        self:linear(0.25):zoomy(0)
    end;
}

return t