local t = Def.ActorFrame{}

-- Load Life Frame
t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("ScreenGameplay/life","frame"),
    OnCommand=function(self)
        self:xy( SCREEN_CENTER_X, 36 ):addy(-100):sleep(0.5):linear(1):addy(100)
    end
}

-- Stage Number
local CalcStage = function()
    local s = GAMESTATE:GetCurrentStage()
    if s == "Stage_Final" then return "Stage_Final" end
    return s
end
t[#t+1] = Def.Sprite{
    OnCommand=function(self)
        self:Load( THEME:GetPathG("","ScreenSelectMusic/"..CalcStage()) )
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
            local mods = GAMESTATE:GetPlayerState(pn):GetPlayerOptionsArray("ModsLevel_Preferred")
            local allowedmods = {}
            -- OutFox displays all modifiers, which 3.9 didn't do, so we need to filter out stuff like
            -- FailImmediate and Overhead, since those were defaults.
            for i,v in ipairs(mods) do
                if v ~= "FailImmediate" and v ~= "FailImmediateContinue" and v ~= "Overhead" then
                    allowedmods[#allowedmods+1] = v
                end
            end

            local str = table.concat(allowedmods, ', ')
            self:settext(str):maxwidth( 360 )
        end,
    }
end

t[#t+1] = ScoreFrame

for k,pn in pairs( GAMESTATE:GetHumanPlayers() ) do
    t[#t+1] = Def.Sprite{
        Texture=THEME:GetPathG("ScreenGameplay/difficulty","icons"),
        OnCommand=function(self)
            self:x( SCREEN_CENTER_X + (pn == PLAYER_1 and 60 or 580) - 320 ):animate(0)
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

            local ypos = { SCREEN_BOTTOM - 70, 58 }

            -- Check for reverse
            local isReverse = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):Reverse()
            self:y( isReverse ~= 0 and ypos[2] or ypos[1] )
            self:addx( pn == PLAYER_1 and -200 or 200 ):sleep(0.5):linear(1):addx( pn == PLAYER_1 and 200 or -200 )
        end
    }
end

return t