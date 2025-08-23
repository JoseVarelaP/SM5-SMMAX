local curChoice = 1
local groupNames = {"ALL MUSIC"}
local AFManager

for _,v in ipairs(SONGMAN:GetSongGroupNames()) do
    groupNames[#groupNames+1] = v
end

local function myCustomInput(event)
    if event.type == "InputEventType_FirstPress" or event.type == "InputEventType_Repeat" then
        if event.GameButton == "MenuRight" or event.GameButton == "MenuDown" then
            curChoice = curChoice + 1
            if curChoice > #groupNames then curChoice = #groupNames end
            AFManager:GetChild("Change"):play()
        end
        if event.GameButton == "MenuLeft" or event.GameButton == "MenuUp" then
            curChoice = curChoice - 1
            if curChoice < 1 then curChoice = 1 end
            AFManager:GetChild("Change"):play()
        end

        if event.GameButton == "Start" then
            if curChoice > 1 then
                GAMESTATE:SetPreferredSongGroup(groupNames[curChoice])
                SOUND:PlayAnnouncer("select group comment general")
            else
                SOUND:PlayAnnouncer("select group comment all music")
            end
            SCREENMAN:GetTopScreen():StartTransitioningScreen( "SM_GoToNextScreen", 0 )
        end

        AFManager:playcommand("UpdateBanner",{pack = groupNames[curChoice], choice = curChoice})
    end
end

local t = Def.ActorFrame{
    InitCommand=function(self)
        AFManager = self
    end,
    OnCommand=function(self)
        SOUND:PlayAnnouncer("select group intro")
        SCREENMAN:GetTopScreen():AddInputCallback(myCustomInput)
        AFManager:playcommand("UpdateBanner",{pack = groupNames[curChoice], choice = curChoice})
    end
}

t[#t+1] = loadfile( THEME:GetPathB("ScreenWithMenuElements","overlay") )()

t[#t+1] = Def.ActorFrame{
    InitCommand=function(self)
        self:xy( SCREEN_CENTER_X + (182-320), SCREEN_CENTER_Y + (160-240) ):zoom(2)
    end,
    OnCommand=function(self)
        self:GetChild("LowRes"):LoadFallback()
        self:addx(-SCREEN_WIDTH):bounceend(0.5):addx(SCREEN_WIDTH)
        -- self:GetChild("HiRes"):LoadFallback()
        -- self:playcommand("UpdateBanner",{pack="In The Groove Rebirth"})
    end,
    UpdateBannerCommand=function(self,params)
        self:GetChild("Fallback"):stoptweening():linear(0.2):diffusealpha( params.choice == 1 and 1 or 0 )
        self:GetChild("LowRes"):LoadFromSongGroup(params.pack)
    end,
    Def.FadingBanner {
        Name="LowRes",
        OnCommand=function(self) self:scaletoclipped(140,50) end
    },
    Def.Sprite{
        Texture=THEME:GetPathG("Banner","all music"),
        Name="Fallback",
        InitCommand=function(self)
            self:scaletoclipped(160,50):cropleft(0.06):cropright(0.06)
        end
    }
}

t[#t+1] = Def.Sprite{
    Name="Frame",
    Texture=THEME:GetPathG("ScreenSelectGroup/ScreenSelectGroup","frame"),
    InitCommand=function(self)
        self:xy( SCREEN_CENTER_X + (180-320), SCREEN_CENTER_Y + (160-240) )
    end,
    OnCommand=function(self)
        self:addx(-SCREEN_WIDTH):bounceend(0.5):addx(SCREEN_WIDTH)
    end
}

t[#t+1] = Def.Sprite{
    Name="Contents",
    Texture=THEME:GetPathG("ScreenSelectGroup/ScreenSelectGroup","contents"),
    InitCommand=function(self)
        self:xy( SCREEN_CENTER_X , SCREEN_CENTER_Y + (260-240) )
    end,
    OnCommand=function(self)
        self:diffusealpha(0):linear(0.5):diffusealpha(1)
    end
}

t[#t+1] = Def.DynamicActorScroller{
    Name="Scroller",
    NumItemsToDraw = 7,
    SecondsPerItem = 0.2,
    InitCommand=function(self)
        self:xy( SCREEN_CENTER_X + (504-320), SCREEN_CENTER_Y + (200-240 ) - 54 )
        self:SetCurrentAndDestinationItem(3)
        self:SetFastCatchup(true)
    end,
    TransformFunction = function(self, offset, itemIndex, numItems)
        self:y(28*offset):x(0):diffusealpha(1)
        if offset < -3 then
            self:x(50):diffusealpha(0)
        end
        if offset > 3 then
            self:x(50):diffusealpha(0)
        end
    end,
    UpdateBannerCommand=function(self,params)
        if params.choice then
            if params.choice > 3 and params.choice < #groupNames -2 then
                self:SetDestinationItem(params.choice-1)
            end
        end
    end,
    LoadFunction = function(self, itemIndex)
        if self then
            local grp = groupNames[itemIndex+1]
            self:name(itemIndex+1)
            self:GetChild("Text"):rainbowscroll(itemIndex == 0)
            self:GetChild("Text"):settext( grp )
            if itemIndex > 1 then
                self:GetChild("Text"):diffuse( SONGMAN:GetSongGroupColor(grp) )

                -- check width
                self:GetChild("Text"):maxwidth(150)
            end
        end
        return #groupNames
    end,
    Subdivisions = 4,
    UseMask = false,
    MaskWidth = 30,
    MaskHeight = 50,
    LoopScroller = false,
    WrapScroller = false,
    Def.ActorFrame{
        UpdateBannerCommand=function(self,params)
            if tonumber(params.choice) == tonumber(self:GetName()) then
                self:playcommand("GainFocus")
            else
                self:playcommand("LoseFocus")
            end
        end,
        Def.Sprite{
            Texture=THEME:GetPathG("ScreenSelectGroup/GroupList","bar"),
            Name="Bar",
            InitCommand=function(self)
                self:shadowlength(2)
            end,
            GainFocusCommand=function(self)
                self:stoptweening():linear(0.2):x(-40):glowshift():effectperiod(0.5)
            end,
            LoseFocusCommand=function(self)
                self:stoptweening():linear(0.2):x(-0):stopeffect()
            end
        },
        Def.BitmapText{
            Font="Common Normal",
            Name="Text",
            InitCommand=function(self)
                self:shadowlength(2)
            end,
            GainFocusCommand=function(self)
                self:stoptweening():linear(0.2):x(-40):glowshift():effectperiod(0.5)
            end,
            LoseFocusCommand=function(self)
                self:stoptweening():stopeffect():linear(0.2):x(0)
            end
        }
    }
}

local numColumns = 4
local numRows = 10

local MusicList = Def.ActorFrame{
    InitCommand=function(self)
        self:xy( SCREEN_CENTER_X + (20-320), SCREEN_CENTER_Y + (276-240) )
        -- self:playcommand("UpdateBanner")
    end,
    UpdateBannerCommand=function(self,params)
        local songsInGroup = {}

        if curChoice == 1 then
            songsInGroup = SONGMAN:GetAllSongs()
        else
            songsInGroup = SONGMAN:GetSongsInGroup(params.pack)
        end

        for column=0,numColumns do
            for row=0,numRows do
                local index = column * numRows + row
                local item = self:GetChild(index)

                if index < #songsInGroup then
                    local title = songsInGroup[index+1]:GetDisplayFullTitle()
                    if title:len() > 24 then
                        title = title:sub(0,21) .. "...";
                    end
    
                    if item then
                        item:settext(title)
                    end

                    if column == numColumns-1 and row == numRows-1 and (#songsInGroup ~= (numColumns*numRows)) then
                        if item then
                            item:settext(("%i more....."):format(#songsInGroup - (numColumns * numRows)))
                        end
                    end
                else
                    if item then
                        item:settext("")
                    end
                end
            end
        end
    end,
}

local songIndex=1 
for column=0,numColumns-1 do
    for row=0,numRows-1 do
        local index = column * numRows + row
        MusicList[#MusicList+1] = Def.BitmapText{
            Font="MusicList titles",
            Text="Hellow!",
            Name=index,
            InitCommand=function(self)
                self:xy( 150 * column, 15 * row )
                :align(0,0):shadowlength(2):zoom(0.5)
            end
        }
        songIndex = songIndex + 1
    end
end

t[#t+1] = Def.BitmapText{
    Font="_numbers2",
    Name="Number",
    InitCommand=function(self)
        self:xy( SCREEN_CENTER_X + (120-320), SCREEN_CENTER_Y - 20 )
        :halign(1)
    end,
    OnCommand=function(self)
        self:addx(-SCREEN_WIDTH):bounceend(0.5):addx(SCREEN_WIDTH)
    end,
    OffCommand=function(self)
        self:bouncebegin(0.5):addx(-SCREEN_WIDTH)
    end,
    UpdateBannerCommand=function(self,params)
        local songsInGroup = {}

        if curChoice == 1 then
            songsInGroup = SONGMAN:GetAllSongs()
        else
            songsInGroup = SONGMAN:GetSongsInGroup(params.pack)
        end

        self:settext(#songsInGroup)
    end
}

t[#t+1] = MusicList

t[#t+1] = Def.Sound{
    File=THEME:GetPathS("ScreenSelectGroup","change"),
    Name="Change",
}

return t