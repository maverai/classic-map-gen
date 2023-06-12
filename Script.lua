--very outdated but still usable (just kinda ugly)
wait()
local groupid = -- enter group id for admin purposes 
local RankReq = -- rank requirment to use script
local Delimiter = "!" 
local Ting = false 

local Maps = {
	["da map"] 			= true, -- map ex
}

function TweenBlock(Part,CF,TweenTime,Construct)
	local oldCanCollide = Part.CanCollide
	if TweenTime == 0 then
		Part.CFrame = CF
	else
		local OldCF = Part.CFrame
		local NewCF = CF
		local Tick = 0
		if Construct then
			Part.CanCollide = false
		end
		
		repeat
			Tick = Tick + wait()
			local Sin = math.sin(((Tick/TweenTime)/57.295779513082)*90) 
			local Formula = CFrame.new(OldCF.p:Lerp(NewCF.p, Sin), OldCF.p:Lerp(NewCF.p, Sin) + OldCF.lookVector:Lerp(CF.lookVector, Sin)) 
			Part.CFrame = Formula
			if Construct then
				Part.Transparency = 1 - Tick / TweenTime
			else
				Part.Transparency = Tick / TweenTime
			end
		until Tick > TweenTime
		Part.CFrame = CF
		if Construct then
			Part.Transparency = 0
			if Part.Name == "ghost" or Part.Name == "DecalPart" or Part.Name == "Spawn" then --ghost = part with a light, DecalPart = part with a decal, Spawn = a spawn point
				Part.Transparency = 1
			end
			Part.CanCollide = oldCanCollide
		else
			if #Part.Parent:GetChildren() == 1 and Part.Parent:IsA("Model") then
				Part.Parent:Destroy()
			else
				Part:Destroy()
			end
		end
	end
end

function Construct(MODEL)
	for i,v in pairs(MODEL:GetChildren()) do
		if v:IsA("BasePart") then
			v.Transparency = 1
		end
	end
	
	for i,v in pairs(MODEL:GetChildren()) do
		if v:IsA("BasePart") then
			wait()
			v.Anchored = true
			local OldCFrame = v.CFrame
			v.CFrame = v.CFrame + Vector3.new(math.random(-20, 20), math.random(-20, 20), math.random(-20, 20))
			v.CFrame = v.CFrame * CFrame.Angles(math.random(-20, 20), math.random(-20, 20), math.random(-20, 20))
			spawn(function()
				TweenBlock(v, OldCFrame, 0.5, true)
			end)
		end
	end
end

function Destruct(MODEL)
	for i,v in pairs(MODEL:GetChildren()) do
		if v:IsA("BasePart") then
			wait()
			v.Anchored = true
			local NewCFrame = v.CFrame 
			NewCFrame = NewCFrame + Vector3.new(math.random(-20, 20), math.random(-20, 20), math.random(-20, 20))
			NewCFrame = NewCFrame * CFrame.Angles(math.random(-20, 20), math.random(-20, 20), math.random(-20, 20))
			spawn(function()
				TweenBlock(v, NewCFrame, 0.5, false)
			end)
		end
	end 
end

game.Players.PlayerAdded:connect(function(Player)
	if Player:GetRankInGroup(groupid) >= RankReq or Player.Name:lower() == "HardCoreRecon" then
		Player.Chatted:connect(function(msg)
			if msg:sub(1,1)==Delimiter and Ting == false then
				Ting = true
				msg=msg:sub(2)
			
				local Seperates={}
				for match in string.gmatch(msg, "%w+") do
					Seperates[#Seperates+1]=match
				end
			
				if type(Seperates[1]) == "string" and type(Seperates[2]) == "string" and type(Seperates[3]) == "string" then
					if Seperates[1]:lower() == "pls" or Seperates[1]:lower() == "computer" then
						if Seperates[2]:lower() == "load" or Seperates[2]:lower() == "start" then
							if game.ServerStorage:FindFirstChild(Seperates[3]) and Maps[tostring(Seperates[3])] then
								if #workspace.CurrentMap:GetChildren() ~= 0 then
									Destruct(workspace.CurrentMap:GetChildren()[1])
									repeat wait(1) until #workspace.CurrentMap:GetChildren() == 0
									workspace.CurrentMap:ClearAllChildren()
								end
								
								local newMapClone = game.ServerStorage[Seperates[3]]:Clone()
								for _, Obj in pairs(newMapClone:GetChildren()) do
									if Obj:IsA("Part") then
										Obj.Transparency = 1
									end
								end
								
								newMapClone.Parent = workspace.CurrentMap
								Construct(newMapClone)		
							end	
						end			
						if Seperates[2]:lower() == "end" or Seperates[2]:lower() == "destabilize"then
							if #workspace.CurrentMap:GetChildren() == 1 then
								Destruct(workspace.CurrentMap:GetChildren()[1])
								repeat wait(1) until #workspace.CurrentMap:GetChildren() == 0
								workspace.CurrentMap:ClearAllChildren()
							end
						end
					end
				end
				wait(0)
				Ting = false
			end
		end)
	end
end)
