name = "Firefighter Auto Fuel / 灭火器自动添加燃料"

description =
	[[
Firefighter has a container in which you can store fuel, it will automatically add fuel from the container when its fuel level drops to 0%.

给灭火器增加一个储物栏，里面可以放燃料，当燃料值降低到0%时，灭火器会自动从储物栏添加燃料。
]]

author = "asingingbird"

version = "1.1"

dst_compatible = true

all_clients_require_mod = true

api_version = 6

api_version_dst = 10

forumthread = ""

icon_atlas = "modicon.xml"

icon = "modicon.tex"

configuration_options = {
	{
		name = "enable_auto_fuel",
		label = "Auto Fuel / 自动加燃料",
		hover = "Auto Fuel / 自动加燃料",
		options = {
			{description = "Disable / 关闭", data = false},
			{description = "Enable / 开启", data = true}
		},
		default = false
	}
}
