return Def.ActorFrame{
    Def.Quad{
        InitCommand=function(self) self:FullScreen() end
    },

    Def.Sprite{
        Texture="shadow",
        OnCommand=function(self)
            self:diffuse(color("0,0,0,1")):xy( SCREEN_CENTER_X + (340-320), SCREEN_CENTER_Y + (246-240) ):linear(8)
            :x( SCREEN_CENTER_X + (300-320) )
        end
    },

    Def.Sprite{
        Texture="stepmania",
        OnCommand=function(self)
            self:Center()
        end
    }
}
--[[
[BGAnimation]
LengthSeconds=8

[Layer1]
File=white.png
Type=1		// 0=sprite, 1=stretch, 2=particles, 3=tiles
Command=

[Layer2]
File=shadow (32bpp).png
Type=0		// 0=sprite, 1=stretch, 2=particles, 3=tiles
Command=diffuse,0,0,0,1;x,340;y,246;linear,8;x,300

[Layer3]
File=stepmania (dither).png
Type=0		// 0=sprite, 1=stretch, 2=particles, 3=tiles
Command=x,320;y,240;
]]