return Def.Sprite{
    Texture=THEME:GetPathG("","ScreenHowToPlay/bgtile"),
    InitCommand=function(self)
        self:Center():FullScreen()
        :zoomto(SCREEN_WIDTH*1.4,SCREEN_HEIGHT+190*1.4)
        :customtexturerect(0,0,SCREEN_WIDTH*4/512,SCREEN_HEIGHT*4/512)
        :texcoordvelocity(-0.5,-0.5)
    end
}