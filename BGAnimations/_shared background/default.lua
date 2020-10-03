return Def.Sprite{
    Texture=THEME:GetPathG("","SharedBackground"),
    OnCommand=function(self)
        self:stretchto(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)
    end
}