local t = Def.ActorFrame{}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("music scroll","background"),
    InitCommand=function(self)
        self:FullScreen()
    end
}

local allSongs = SONGMAN:GetAllSongs()
local textZoom = 0.8
local timePerItem = 0.06

t[#t+1] = Def.DynamicActorScroller{
    LoadFunction = function(self, index)
        if self then
            self:GetChild("Text"):settext(allSongs[index+1]:GetDisplayFullTitle())
            :diffuse( SONGMAN:GetSongColor(allSongs[index+1]) )
        end
        
        return #allSongs
    end,
    InitCommand=function(self)
        self:Center()
    end,
    OnCommand=function(self)
        self:ScrollWithPadding(14, 20)

        local totalTime = ((#allSongs + 20) * timePerItem)
        self:sleep(totalTime):queuecommand("MoveOn")
    end,
    MoveOnCommand=function(self)
        SCREENMAN:GetTopScreen():StartTransitioningScreen( "SM_GoToNextScreen", 0 )
    end,
    TransformFunction = function(self, offset, itemIndex, numItems)
        self:y(28*offset)
    end,
    NumItemsToDraw = 18,
    Subdivisions = 1,
    UseMask = false,
    MaskWidth = 30,
    MaskHeight = 50,
    LoopScroller = false,
    WrapScroller = false,
    SecondsPerItem=timePerItem,
    Def.ActorFrame{
        Def.BitmapText{
            Font="ScreenMusicScroll titles",
            Name="Text",
            OnCommand=function(self)
                self:zoom(textZoom)
            end
        }
    }
}

return t