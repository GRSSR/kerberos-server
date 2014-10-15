os.loadAPI("api/redString")
os.loadAPI("api/sec")
os.loadAPI("api/sovietProtocol")

local drive = "left"
local PROTOCOL_CHANNEL = 1

local laika = sovietProtocol.Protocol:new("laika", PROTOCOL_CHANNEL, os.getComputerID())

args = {...}
doorID = tonumber(args[1])
terminalID = tonumber(os.getComputerID())

userName, token = sec.readIDDisk()

laika:send("allow_access", doorID, token)

local replyChannel, response = laika:listen()

if response.action == "error" then
	error(response.body)
end