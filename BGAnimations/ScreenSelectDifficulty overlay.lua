local ActorFrameHandler
local plrChoice = { [PLAYER_1] = 1, [PLAYER_2] = 1 }
local plrDecided = { [PLAYER_1] = false, [PLAYER_2] = false }
local curPage = 1

local options = {
    { screen="ScreenSelectGroup", pm="regular", diff="beginner", name="beginner"  },
    { screen="ScreenSelectGroup", pm="regular", diff="easy", name="easy"  },
    { screen="ScreenSelectGroup", pm="regular", diff="medium", name="medium"  },
    { screen="ScreenSelectGroup", pm="regular", diff="hard", name="hard"  },
    ----------------------------------------------------
    { screen="ScreenInstructions", pm="nonstop", name="nonstop"  },
    { screen="ScreenInstructions", pm="oni", name="oni"  },
    { screen="ScreenInstructions", pm="endless", name="endless"  },
    { screen="ScreenInstructions", pm="rave", name="rave"  },
}

local function HavePlayersDecided()
    local wereDone = true
    for ipn,pn in ipairs(GAMESTATE:GetEnabledPlayers()) do
        if not plrDecided[pn] then
            wereDone = false
        end
    end
    
    return wereDone
end

local function HighestChoice()
    local value = 1
    return plrChoice[PLAYER_1] > plrChoice[PLAYER_2] and plrChoice[PLAYER_1] or plrChoice[PLAYER_2]
end

local function myCustomInput(event)
    if event.type == "InputEventType_FirstPress" then
        local validButton = false
        -- Ok, we have pressed the button once. Time to detect what button was pressed.
        if event.GameButton == "Right" or event.GameButton == "MenuRight" then
            plrChoice[event.PlayerNumber] = plrChoice[event.PlayerNumber] + 1
            validButton = true
            if plrChoice[event.PlayerNumber] > 8 then
                plrChoice[event.PlayerNumber] = 8
                validButton = false
            end
        end
        if event.GameButton == "Left" or event.GameButton == "MenuLeft" then
            plrChoice[event.PlayerNumber] = plrChoice[event.PlayerNumber] - 1
            validButton = true
            if plrChoice[event.PlayerNumber] < 1 then
                plrChoice[event.PlayerNumber] = 1
                validButton = false
            end
        end

        if event.GameButton == "Start" then
            ActorFrameHandler:playcommand("Choose",{plr = event.PlayerNumber})
            ActorFrameHandler:GetChild("Start"):play()
            plrDecided[event.PlayerNumber] = true


            if HavePlayersDecided() then
                -- Check for the type of comment to play.
                SOUND:PlayAnnouncer("select difficulty comment " .. options[plrChoice[event.PlayerNumber]].name )
                -- SCREENMAN:SetNewScreen("ScreenTitleMenu")

                -- set master options
                local choice = options[plrChoice[GAMESTATE:GetMasterPlayerNumber()]]
                GAMESTATE:SetCurrentPlayMode( choice.pm )
                SCREENMAN:GetTopScreen():SetNextScreenName( choice.screen )

                ActorFrameHandler:sleep(0.5):queuecommand("TweenOffNow")
            end
        end

        if event.GameButton == "Back" then
            SCREENMAN:GetTopScreen():Cancel()
        end

        if validButton then
            -- If any of the players have crossed to the second page, then force
            -- them all to be on the second page.
            local lastpage = curPage
            if (plrChoice[PLAYER_1] > 4 or plrChoice[PLAYER_2] > 4) and curPage == 1 then
                plrChoice[PLAYER_1] = 5
                plrChoice[PLAYER_2] = 5
                curPage = 2
            end

            if curPage == 2 then
                plrChoice[PLAYER_2] = plrChoice[PLAYER_1] 
            end

            -- The same if going back.
            if (plrChoice[PLAYER_1] < 5 or plrChoice[PLAYER_2] < 5) and curPage == 2 then
                plrChoice[PLAYER_1] = 4
                plrChoice[PLAYER_2] = 4
                curPage = 1
            end

            if (curPage ~= lastpage) then
                MESSAGEMAN:Broadcast("PreSwitchPage")
                if curPage == 2 then
                    SOUND:PlayAnnouncer("select difficulty challenge")
                end
            end

            ActorFrameHandler:GetChild("Change"):play()

            ActorFrameHandler:playcommand("UpdatePosition")
        end
    end
end

local t = Def.ActorFrame{
    InitCommand=function(self)
        ActorFrameHandler = self
    end,
    OnCommand=function(self)
        SCREENMAN:GetTopScreen():AddInputCallback( myCustomInput )
    end,
    TweenOffNowCommand=function(self)
        SCREENMAN:GetTopScreen():StartTransitioningScreen( "SM_GoToNextScreen", 0 )
    end,
}

t[#t+1] = loadfile( THEME:GetPathB("ScreenWithMenuElements","overlay") )()

-- Process the images for the pane.
local iconHandler
local iconsActorFrame = Def.ActorFrame{
    InitCommand=function(self)
        iconHandler = self
    end,
    PreSwitchPageMessageCommand=function(self)
        self:stoptweening():linear(0.2):x(
            curPage == 1 and 0 or (-SCREEN_WIDTH - 600) )
    end
}


for index, option in ipairs(options) do
    iconsActorFrame[#iconsActorFrame+1] = Def.ActorFrame{
        Name="Item"..index,
        InitCommand=function(self)
            self:x( SCREEN_CENTER_X+(-52-320) + (149 * index) )
            :y( (index % 2) == 1 and 180 or 220 )

            -- shift page 2 a bit
            if index > 4 then
                self:x( SCREEN_WIDTH + (SCREEN_CENTER_X+(-52-320) + (149 * index)) )
                :y( (index % 2) == 1 and 220 or 180 )
            end
        end,
        Def.Sprite{
            Name="Info",
            Texture=THEME:GetPathG("ScreenSelectDifficulty/ScreenSelectDifficulty","info".. index),
            OnCommand=function (self)
                self:valign(1)
                if index < 5 then
                    self:addx(-800):sleep(0.4 + ((index-1) * 0.2)):decelerate(0.3):addx(800)
                else
                    self:addx(800):sleep(0.3 + ((index-4) * 0.2)):accelerate(0.4):addx(-800)
                end
            end,
            OffCommand=function(self)
                local offsinx = index < 5 and 1 or 5
                self:sleep(0.3 + ((index-offsinx) * 0.2) ):accelerate(0.4):addx(-800)
                if (curPage == 1 and index > 4) or (curPage == 2 and index < 5) then
                    self:visible(false)
                end
            end
        },
        Def.Sprite{
            Name="Picture",
            Texture=THEME:GetPathG("ScreenSelectDifficulty/ScreenSelectDifficulty","picture".. index),
            OnCommand=function (self)
                self:valign(0):zoomy(0):sleep(0.4 + (index * 0.2)):bouncebegin(0.3):zoomy(1)
            end,
            OffCommand=function(self)
                local offsinx = index < 5 and 1 or 5
                self:sleep(((index-offsinx) * 0.2) ):bouncebegin(0.3):zoomy(0)
            end
        }
    }
end

-- Render cursors.
for ipn,pn in ipairs(GAMESTATE:GetEnabledPlayers()) do
    iconsActorFrame[#iconsActorFrame+1] = Def.ActorFrame{
        InitCommand=function(self)
            local playerXOffset = pn == PLAYER_1 and -40 or 40
            local itempos = self:GetParent():GetChild("Item"..plrChoice[pn])
            self:xy( itempos:GetX() + playerXOffset, itempos:GetY() + 180 )
        end,
        UpdatePositionCommand=function(self)
            local playerXOffset = pn == PLAYER_1 and -40 or 40
            local itempos = self:GetParent():GetChild("Item"..plrChoice[pn])
            self:stoptweening():linear(0.1):xy( itempos:GetX() + playerXOffset, itempos:GetY() + 180 )
        end,
        Def.Sprite{
            Texture=THEME:GetPathG("ScreenSelectDifficulty/ScreenSelectDifficulty","shadow"),
            InitCommand=function(self)
                self:animate(0):setstate(0)
            end,
            ChooseCommand=function(self,params)
                if params.plr == pn then
                    self:sleep(0.2):linear(0.2):diffusealpha(0)
                end
            end,
        },
        Def.Sprite{
            Texture=THEME:GetPathG("ScreenSelectDifficulty/ScreenSelectDifficulty","cursor"),
            InitCommand=function(self)
                self:animate(0):setstate(ipn-1):xy(-10,-10)
            end,
            OnCommand=function(self)
                self:diffusealpha(0):rotationz(340):zoom(4):linear(0.3):diffusealpha(1):rotationz(0):zoom(1)
                self:glowshift():effectperiod(0.5)
            end,
            ChooseCommand=function(self,params)
                if params.plr == pn then
                    self:sleep(0.2):linear(0.2):xy(0,0)
                end
            end,
            OffCommand=function(self)
                self:sleep(0.2):linear(0.3):zoom(0)
            end
        },
        Def.Sprite{
            Texture=THEME:GetPathG("ScreenSelectDifficulty/ScreenSelectDifficulty","ok"),
            InitCommand=function(self)
                self:animate(0):setstate(0):diffusealpha(0)
            end,
            ChooseCommand=function(self,params)
                if params.plr == pn then
                    self:diffusealpha(1):zoom(2):linear(0.2):zoom(1)
                end
            end,
            OffCommand=function(self)
                self:sleep(0.2):linear(0.3):zoom(0)
            end
        }
    }
end

t[#t+1] = iconsActorFrame


-- Load sounds
t[#t+1] = Def.Sound{
    File=THEME:GetPathS("ScreenSelectMaster","change"),
    Name="Change",
}
t[#t+1] = Def.Sound{
    File=THEME:GetPathS("Common","start"),
    Name="Start",
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("ScreenSelectDifficulty/ScreenSelectDifficulty more","page1"),
    InitCommand=function(self)
        self:xy(SCREEN_CENTER_X + (580-320), SCREEN_CENTER_Y + (90-240))
    end,
    PreSwitchPageMessageCommand=function(self,params)
        self:stoptweening():linear(0.2):x( SCREEN_CENTER_X + (580-320) + (-SCREEN_WIDTH * (curPage-1)) )
    end
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("ScreenSelectDifficulty/ScreenSelectDifficulty more","page2"),
    InitCommand=function(self)
        self:xy(SCREEN_WIDTH + SCREEN_CENTER_X + (700-320), SCREEN_CENTER_Y + (90-240))
    end,
    PreSwitchPageMessageCommand=function(self,params)
        self:stoptweening():linear(0.2):x( SCREEN_CENTER_X + (700-320) + (-SCREEN_WIDTH * (curPage-1)) )
    end
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("ScreenSelectDifficulty/ScreenSelectDifficulty","explanation"),
    InitCommand=function(self)
        self:xy(SCREEN_CENTER_X + (170-320), SCREEN_CENTER_Y + (70-240)):animate(0)
    end,
    OnCommand=function(self)
        self:addx(-SCREEN_WIDTH):bounceend(0.5):addx(SCREEN_WIDTH)
    end,
    OffCommand=function(self)
        self:bouncebegin(0.5):addx(-SCREEN_WIDTH)
    end,
    PreSwitchPageMessageCommand=function(self,params)
        self:stoptweening():linear(0.2):x( SCREEN_CENTER_X + (170-320) + (-SCREEN_WIDTH * (curPage-1)) )
    end
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("ScreenSelectDifficulty/ScreenSelectDifficulty","explanation"),
    InitCommand=function(self)
        self:xy(SCREEN_CENTER_X + (1100-320), SCREEN_CENTER_Y + (70-240)):animate(0):setstate(1)
    end,
    OnCommand=function(self)
        self:addx(SCREEN_WIDTH):bounceend(0.5):addx(-SCREEN_WIDTH)
    end,
    OffCommand=function(self)
        self:bouncebegin(0.5):addx(SCREEN_WIDTH)
    end,
    PreSwitchPageMessageCommand=function(self,params)
        self:stoptweening():linear(0.2):x( SCREEN_CENTER_X + (1100-320) + (-SCREEN_WIDTH * (curPage-1)) )
    end
}
return t