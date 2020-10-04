local t = Def.ActorFrame{}

-- Load Life Frame
t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("ScreenGameplay/life","frame"),
    OnCommand=function(self)
        self:xy( SCREEN_CENTER_X, 36 ):addy(-100):sleep(0.5):linear(1):addy(100)
    end
}

-- Stage Number
t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("ScreenSelectMusic/stage",ToEnumShortString( GAMESTATE:GetCurrentStage() )),
    OnCommand=function(self)
        self:xy( SCREEN_CENTER_X, 54 ):addy(-100):sleep(0.5):linear(1):addy(100)
    end
}

-- Load Score Frame
local ScoreFrame = Def.ActorFrame{
    OnCommand=function(self)
        self:y( SCREEN_BOTTOM-32 ):addy(100):sleep(0.5):linear(1):addy(-100)
    end
}
ScoreFrame[#ScoreFrame+1] = Def.Sprite{
    Texture=THEME:GetPathG("ScreenGameplay/score","frame"),
    OnCommand=function(self) self:x( SCREEN_CENTER_X ) end
}

for k,pn in pairs( GAMESTATE:GetHumanPlayers() ) do
    ScoreFrame[#ScoreFrame+1] = Def.Sprite{
        Texture=THEME:GetPathG("ScreenGameplay/difficulty","icons"),
        OnCommand=function(self)
            self:xy( SCREEN_CENTER_X + (pn == PLAYER_1 and 60 or 580) - 320, -36 ):animate(0)
            self:visible( false )
            -- Time to set the difficulty.
            local diffs = {
                ["Difficulty_Beginner"] = 0,
                ["Difficulty_Easy"] = 2,
                ["Difficulty_Medium"] = 4,
                ["Difficulty_Hard"] = 6,
                ["Difficulty_Challenge"] = 8,
            }

            if GAMESTATE:GetCurrentSteps(pn):GetDifficulty() ~= "Difficulty_Edit" then
                self:visible( true )
                local srt = diffs[GAMESTATE:GetCurrentSteps(pn):GetDifficulty()]
                if pn == PLAYER_2 then
                    srt = srt + 1
                end
                self:setstate( srt )
            end
        end
    }

    ScoreFrame[#ScoreFrame+1] = Def.RollingNumbers{
        File = THEME:GetPathF("", "_numbers2"),
        InitCommand=function(s)
            s:Load("RollingNumbers"):targetnumber(0)
            :xy( SCREEN_CENTER_X + (pn == PLAYER_1 and 106 or 534) - 320, -4 )
            :diffuse( PlayerColor(pn) )
        end,
        StepMessageCommand=function(s) s:queuecommand("Set") end;
		SetCommand = function (s)
			local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
			s:finishtweening():targetnumber( stats:GetScore() )
		end
    }

    ScoreFrame[#ScoreFrame+1] = Def.BitmapText{
        File = "Common Normal",
        InitCommand=function(self)
            self:xy( SCREEN_CENTER_X, pn == PLAYER_1 and -14 or 2 ):zoom(0.5)
            local str = GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString("ModsLevel_Preferred")
            self:settext(str):maxwidth( 360 )
        end,
    }
end

t[#t+1] = ScoreFrame
return t