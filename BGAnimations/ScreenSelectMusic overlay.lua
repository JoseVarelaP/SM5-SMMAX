local t = Def.ActorFrame{}

t[#t+1] = loadfile( THEME:GetPathB("ScreenWithMenuElements","overlay") )()


local BnFrame = Def.ActorFrame{
	OnCommand=function(self)
		self:addx( -400 ):bounceend(0.5):addx(400)
	end
}

BnFrame[#BnFrame+1] = Def.Sprite{
	Texture=THEME:GetPathG("ScreenSelectMusic/banner","frame"),
	InitCommand=function(self)
		self:xy( SCREEN_CENTER_X + 160 - 320, SCREEN_CENTER_Y + 162 - 240 )
	end
}


-- Stage Number
local CalcStage = function()
	local s = GAMESTATE:GetCurrentStage()
	if s == "Stage_Final" then return "Stage_Final" end
	return s
end
BnFrame[#BnFrame+1] = Def.Sprite{
	OnCommand=function(self)
		self:Load( THEME:GetPathG("","ScreenSelectMusic/"..CalcStage()) )
		self:xy( SCREEN_CENTER_X + 40 - 320 , SCREEN_CENTER_Y + 121 - 240 )
	end
}

-- BPM Display
BnFrame[#BnFrame+1] = Def.ActorFrame{
	InitCommand=function(self)
		self:halign(1):xy( SCREEN_CENTER_X + 160 - 320 , SCREEN_CENTER_Y + 121 - 240 )
	end,
	OnCommand=function(self)
		self.DrawFunction = function(self)
			local bpm = self:GetChild("BPMDisplay")
			bpm:Draw()

			self:GetChild("Label"):diffuse( bpm:GetDiffuse() ):Draw()
		end

		self:SetDrawFunction(self.DrawFunction)
	end,
	Def.BPMDisplay{
		Name="BPMDisplay",
		Font="BPMDisplay",
		OnCommand=function(self)
			self:SetFromGameState()
			self:halign(1)
		end,
		CurrentSongChangedMessageCommand=function(self)
			self:SetFromSong( GAMESTATE:GetCurrentSong() or nil )
		end
	},

	Def.Sprite{
		Name="Label",
		Texture=THEME:GetPathG("BPMDisplay","label"),
		OnCommand=function(self)
			self:halign(0)
		end
	}
}

for i=0,4 do
	BnFrame[#BnFrame+1] = Def.Sprite{
		Texture=THEME:GetPathG("DifficultyDisplay","bar"),
		InitCommand=function(self)
			self:xy( SCREEN_CENTER_X + 305 - 320, SCREEN_CENTER_Y + 140 - 240 + (16 * i)  )
			:animate(0):setstate(i)
		end,
		OnCommand=function(self) self:playcommand("Set") end,
		CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end,
		SetCommand=function(self)
			local show = false
			if GAMESTATE:GetCurrentSong() then
				local step = GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber())
				if step then
					if GAMESTATE:GetCurrentSong():HasStepsTypeAndDifficulty(step:GetStepsType(), i) then
						show = true
					end
				end
			end
			self:stoptweening():linear(0.1):diffusealpha( show and 1 or 0 )
		end
	}
end
t[#t+1] = BnFrame

local pos = { 60, 260 }

for i,pn in pairs( GAMESTATE:GetHumanPlayers() ) do

	local diffPlacement = Def.ActorFrame{
		["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(self)
			local steps = GAMESTATE:GetCurrentSteps(pn)
			if not steps then return end

			local cd = GetCustomDifficulty(steps:GetStepsType(), steps:GetDifficulty())
			self:playcommand("UpdateVal",{Value=steps:GetMeter(),Col=CustomDifficultyToColor(cd)})
		end
	}

	for i = 1,10 do
		diffPlacement[#diffPlacement+1] = Def.Sprite{
			Texture=THEME:GetPathG("DifficultyMeter","bar"),
			InitCommand=function (self)
				self:x( 10 * (i-1) ):animate(false):shadowlength(2)
			end,
			UpdateValCommand=function (self,params)
				self:diffuse( (i <= params.Value) and params.Col or BoostColor(ColorDarkTone(params.Col), 0.5) )
				:stopeffect()
				if params.Value > 10 then
					self:glowshift()
				end
			end
		}
	end

	t[#t+1] = Def.ActorFrame{
		Def.Sprite{
			Texture=THEME:GetPathG("ScreenSelectMusic/difficulty frame", ToEnumShortString(pn) ),
			OnCommand=function(self)
				self:xy( SCREEN_CENTER_X + pos[i] - 320, SCREEN_CENTER_Y + 248 - 240 )
			end
		},

		Def.Sprite{
			Texture=THEME:GetPathG("ScreenSelectMusic/difficulty", "icons" ),
			OnCommand=function(self)
				self:xy( SCREEN_CENTER_X + pos[i] + (pn == PLAYER_1 and -12 or 12) - 320, SCREEN_CENTER_Y + 248 - 240 )
				:animate(0)
			end,
			["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(self)
				self:visible( false )
				-- Time to set the difficulty.
				local diffs = {
					["Difficulty_Beginner"] = 0,
					["Difficulty_Easy"] = 1,
					["Difficulty_Medium"] = 2,
					["Difficulty_Hard"] = 3,
					["Difficulty_Challenge"] = 4,
				}

				if GAMESTATE:GetCurrentSteps(pn) then
					if GAMESTATE:GetCurrentSteps(pn):GetDifficulty() ~= "Difficulty_Edit" then
						self:visible( true )
						local srt = diffs[GAMESTATE:GetCurrentSteps(pn):GetDifficulty()]
						self:setstate( srt )
					end
				end
			end
		},

		Def.ActorFrame{
			OnCommand=function(self)
				self:xy( SCREEN_CENTER_X + pos[i] + 22 - 320, SCREEN_CENTER_Y + 432 - 240 )
			end,
			Def.Sprite{
				Texture=THEME:GetPathG("ScreenSelectMusic/meter frame", ToEnumShortString(pn) ),
				OnCommand=function(self)
				end
			},
	
			diffPlacement .. {
				InitCommand=function (self)
					self:xy( -40,0 )
				end,
			}
		}

	}
end


-- Long/Marathon Song indicator
t[#t+1] = Def.ActorFrame{
	InitCommand=function (self)
		self:xy( SCREEN_CENTER_X + (392-320), SCREEN_CENTER_Y + (140-240) )
	end,
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if not song then
			self:playcommand("Hide")
			return
		end

		if song:IsLong() or song:IsMarathon() then
			self:playcommand("Show")
		else
			self:playcommand("Hide")
		end

		self:GetChild("Long"):visible( song:IsLong() )
		self:GetChild("Marathon"):visible( song:IsMarathon() )
	end,
	OnCommand=function (self)
		self:linear(0.2):zoomy(1):bob():effectmagnitude(0,10,0)
	end,
	ShowCommand=function (self)
		self:stoptweening():linear(0.22):zoomy(1)
	end,
	HideCommand=function (self)
		self:stoptweening():linear(0.2):zoomy(0)
	end,

	Def.Sprite{
		Name="Long",
		Texture=THEME:GetPathG("ScreenSelectMusic/balloon","long"),
	},
	Def.Sprite{
		Name="Marathon",
		Texture=THEME:GetPathG("ScreenSelectMusic/balloon","marathon"),
	},
}

t[#t+1] = Def.Quad{
	InitCommand=function(self)
		self:stretchto( 0,0, SCREEN_WIDTH, SCREEN_HEIGHT ):diffuse( Alpha(Color.Black,0) )
	end,
	ShowPressStartForOptionsCommand=function(self)
		self:linear(0.25):diffusealpha(1)
	end
}

t[#t+1] = Def.Sprite{
	Texture=THEME:GetPathG("ScreenPlayerOptions","Options"),
	InitCommand=function(self)
		self:Center():pause():zoomy(0)
	end;
	ShowPressStartForOptionsCommand=function(self)
		self:linear(0.25):zoomy(1):sleep(1):linear(0.25):zoomy(0)
	end;
	ShowEnteringOptionsCommand=function(self)
		self:stoptweening():setstate(1):sleep(0.25):linear(0.25):zoomy(0)
	end;
	HidePressStartForOptionsCommandCommand=function(self)
		self:linear(0.25):zoomy(0)
	end;
}

return t
