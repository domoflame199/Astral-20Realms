-- Net: Simple RemoteEvent/RemoteFunction registry
-- Place in ReplicatedStorage/AstralFramework/Shared
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = {}
Net.__index = Net

local ROOT_NAME = "AstralFramework"
local REMOTES_NAME = "Remotes"

local function getFolder(parent, name)
	local f = parent:FindFirstChild(name)
	if not f then
		f = Instance.new("Folder")
		f.Name = name
		f.Parent = parent
	end
	return f
end

local root = getFolder(ReplicatedStorage, ROOT_NAME)
local remotes = getFolder(root, REMOTES_NAME)
local events = getFolder(remotes, "Events")
local functions = getFolder(remotes, "Functions")

function Net.GetEvent(name)
	local ev = events:FindFirstChild(name)
	if not ev then
		ev = Instance.new("RemoteEvent")
		ev.Name = name
		ev.Parent = events
	end
	return ev
end

function Net.GetFunction(name)
	local fn = functions:FindFirstChild(name)
	if not fn then
		fn = Instance.new("RemoteFunction")
		fn.Name = name
		fn.Parent = functions
	end
	return fn
end

return Net
