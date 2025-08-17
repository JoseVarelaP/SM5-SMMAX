local t = Def.ActorFrame{}
t[#t+1] = loadfile( THEME:GetPathB("ScreenGameplay","overlay") )()

t[#t+1] = Def.Quad{
    Texture=THEME:GetPathG("","ScreenDemonstration/demonstration"),
    InitCommand=function(self)
        self:Center():diffuse(Alpha(Color.Black,0.7)):zoomto(SCREEN_WIDTH, 100)
    end
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","ScreenDemonstration/demonstration"),
    InitCommand=function(self)
        self:zbuffer(true):Center():diffuseblink():effectperiod(1)
    end
}
return t