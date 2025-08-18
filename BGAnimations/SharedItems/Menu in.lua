--[[
[BGAnimation]
LengthSeconds=0.5
Sound=../_swoosh.ogg

[Layer1]
File=../_moveon.png
Type=0		// 0=sprite, 1=stretch, 2=particles, 3=tiles
Command=x,320;y,240;zoomy,0;diffuse,0,0,0,0;linear,0.5;diffuse,1,1,1,1;zoomy,1
]]
return Def.ActorFrame{
    Def.Sprite{
        Texture=THEME:GetPathG("","_moveon"),
        OnCommand=function(self)
            self:Center():zoomy(1):linear(0.5):zoomy(0):diffuse(Alpha(Color.Black,0))
        end,
    }
}