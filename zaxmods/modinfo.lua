-- 名称
name = "Zax Mods"
-- 描述
description = "Items that do not affect balance!"
-- 作者
author = "Zax"
-- 版本
version = "0.0.1"
-- klei官方论坛地址，为空则默认是工坊的地址
forumthread = ""
-- modicon 下一篇再介绍怎么创建的
-- icon_atlas = "images/modicon.xml"
-- icon = "images/modicon.tex"
icon_atlas = "modicon.xml"
icon = "modicon.tex"
-- dst兼容
dst_compatible = true
-- 是否是客户端mod
client_only_mod = false
-- 是否是所有客户端都需要安装
all_clients_require_mod = true
-- 饥荒api版本，固定填10
api_version = 10

-- mod的配置项，后面介绍
configuration_options = {
	{
		name = "EnableZaxHat",
		label = "是否启用牛牛帽",
		hover = "愉快的升级自己的帽子吧！"
		options = {
			{ description = "否", data = false, hover = "" },
			{ description = "是", data = true, hover = ""},
		}

	},
}