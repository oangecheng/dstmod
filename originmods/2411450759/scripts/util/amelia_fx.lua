
local fx ={
    {
        name = "conc_atk_buff_fx",
        bank = "amebuff",
        build = "amebuff",
        anim = "atk",
        -- sound = "dontstarve/characters/wendy/abigail/buff/attack",
        bloom = true,
        fn = function(inst)
		    inst.AnimState:SetFinalOffset(3)
		end,
    },
    {
        name = "conc_def_buff_fx",
        bank = "amebuff",
        build = "amebuff",
        anim = "def",
        -- sound = "dontstarve/characters/wendy/abigail/buff/shield",
        bloom = true,
        fn = function(inst)
		    inst.AnimState:SetFinalOffset(3)
		end,
    },
    {
        name = "conc_mvspd_buff_fx",
        bank = "amebuff",
        build = "amebuff",
        anim = "spd",
        -- sound = "dontstarve/characters/wendy/abigail/buff/speed",
        bloom = true,
        fn = function(inst)
		    inst.AnimState:SetFinalOffset(3)
		end,
    },
    {
        name = "conc_hp_regen_fx",
        bank = "amebuff",
        build = "amebuff",
        anim = "hp",
        -- sound = "dontstarve/characters/wendy/abigail/buff/gen",
        bloom = true,
        fn = function(inst)
		    inst.AnimState:SetFinalOffset(3)
		end,
    },
    {
        name = "conc_san_regen_fx",
        bank = "amebuff",
        build = "amebuff",
        anim = "snt",
        -- sound = "dontstarve/characters/wendy/abigail/buff/gen",
        bloom = true,
        fn = function(inst)
		    inst.AnimState:SetFinalOffset(3)
		end,
    },
}
for _, value in pairs(fx) do
    GLOBAL.table.insert(GLOBAL.require("fx"), value)
end
