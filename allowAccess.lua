os.loadAPI("api/redString")
os.loadAPI("api/sec")
os.loadAPI("api/sovietProtocol")

local drive = "left"
local PROTOCOL_CHANNEL = 1

sovietProtocol.init(PROTOCOL_CHANNEL, os.getComputerID())

args = {...}
doorID = tonumber(args[1])
terminalID = tonumber(os.getComputerID())

userName, token = sec.readIDDisk()

sovietProtocol.send(PROTOCOL_CHANNEL, os.getComputerID(), "allow_access", doorID, token)

local replyChannel, response = sovietProtocol.listen()

if response.action == "error" then
	error(response.body)
end