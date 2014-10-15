-- protocol action door other
os.loadAPI("api/redString")
os.loadAPI("api/sec")
os.loadAPI("api/sovietProtocol")

local drive = "left"
local PROTOCOL_CHANNEL = 1

local laika = sovietProtocol.Protocol:new("laika", PROTOCOL_CHANNEL, PROTOCOL_CHANNEL, "back")
sovietProtocol.setDebugLevel(9)
sec.loadUsers("/database/users")

function checkDoorAccess(doorID, user)
	accessList = sec.loadAccessList(fs.combine("database", doorID))
	if accessList[user] == true then
		return true
	end
	return false
end

function can_open(origin, doorID, userToken)
	user = sec.mapUser(userToken)
	if user and checkDoorAccess(doorID, user)then
		laika:send("door_open", doorID, "true", origin)
		print("sent door_open "..doorID.." true")
	else
		laika:send("door_open", doorID, "false", origin)
	end
end

function create_user(origin, userName, none)
	userToken = sec.generateKey(50)
	sec.addUser(userName, userToken)
	sec.saveUsers("/database/users")
	print("sending: ".."user_key "..userName.." "..userToken)
	laika:send("user_key", userName, userToken, origin)
end

function register_user(origin, userName, userToken)
	sec.addUser(userName, userToken)
	sec.saveUsers("/database/users")
	laika:send("user_key", userName, userToken, origin)
end

function allow_access(origin, doorID, userToken)
	userName = sec.mapUser(userToken)
	accessList = sec.loadAccessList(fs.combine("database", doorID))
	accessList[userName] = true
	sec.saveAccessList(fs.combine("database", doorID), accessList)
	laika:send("access_granted", userName, doorID, origin)
end

function register_door(origin, doorID, none)
end

methods = {
	["can_open"] = can_open,
	["create_user"] = create_user,
	["register_user"] = register_user,
	["allow_access"] = allow_access
}

function handleRequest(origin, request)
	if request.method and request.id then
		if methods[request.method] then
			methods[request.method](origin, request.id, request.body)
		else
			print("invalid method "..request.method)
			return false
		end
	else
		print("incomplete request")
		return false
	end
	print("request handled")
	return true
end

print("Starting DoorSecServer")

while true do
	local replyChannel, response = laika:listen()
	if not handleRequest(replyChannel, response) then
		laika:send("error", nil, nil, replyChannel)
	end
end
