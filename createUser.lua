os.loadAPI("api/redString")
os.loadAPI("api/sovietProtocol")

local drive = "left"
local PROTOCOL_CHANNEL = 1

local krb = sovietProtocol.Protocol:new("kerberos", PROTOCOL_CHANNEL, os.getComputerID())

local args = {...}

if not disk.isPresent(drive) then
	error("no disk present")
end

local userName = args[1]

if not userName then
	error("usage: createUser [userName]")
end

krb:send("create_user", userName)

local replyChannel, response = krb:listen()

if response.method == "error" then
	error(response.body)
end

local diskRoot = disk.getMountPath(drive)
local idFile = fs.combine(diskRoot, "ID")

f = io.open(idFile, "w")
f:write(response.body)
f:close()

disk.setLabel(drive, userName.."'s ID")