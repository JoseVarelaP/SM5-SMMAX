return Def.Sprite{
    Texture=THEME:GetPathG("OptionIcon","frame"),
    InitCommand=function(self)
        self:animate(0):setstate(2)
    end
}