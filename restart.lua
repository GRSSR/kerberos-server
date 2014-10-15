local peripherals = peripheral.getNames()

for key, periph in pairs(peripherals) do
	if peripheral.getType(periph) == "computer" then
		print("Rebooting "..periph)
		peripheral.call(periph, "reboot")
	end
end