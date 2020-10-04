return Def.Quad{
    StartTransitioningCommand=function(self)
        self:stretchto( 0,0, SCREEN_WIDTH, SCREEN_HEIGHT ):diffuse( Alpha(Color.Black,0) )
        :linear(0.3):diffusealpha(1)
    end
}