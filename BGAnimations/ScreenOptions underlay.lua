return Def.ActorFrame{
    Def.Sprite{
        Texture=THEME:GetPathG("_options","page"),
        OnCommand=function(self)
            self:xy( -SCREEN_CENTER_X, SCREEN_CENTER_Y ):decelerate(0.3):addx( 640 )
        end
    }
}