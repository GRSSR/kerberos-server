os.loadAPI("api/redString")
os.loadAPI("api/sec")
os.loadAPI("api/sovietProtocol")

local drive = "right"
local PROTOCOL_CHANNEL = 1

local krb = sovietProtocol.Protocol:new("kerberos", PROTOCOL_CHANNEL, os.getComputerID(), "left")

args = {...}
doorID = tonumber(args[1])
terminalID = tonumber(os.getComputerID())

userName, token = sec.readIDDisk()

krb:send("allow_access", doorID, token)

local replyChannel, response = krb:listen()

if response.action == "error" then
	error(response.body)
end