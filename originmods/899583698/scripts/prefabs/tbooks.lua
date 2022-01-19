local assets = {}
local prefabs = {}
local book_defs =
{
    "book_gardening",
    "book_birds",
    "book_horticulture",
    "book_silviculture",
    "book_sleep",
    "book_brimstone",
    "book_tentacles",
}

local function MakeBook(name)
    local function fn()
        local inst = CreateEntity()
        if not TheWorld.ismastersim then
            return inst
        end
        inst:DoTaskInTime(5, function()
            inst:Remove()
        end)
    end
    return Prefab(name, fn, assets, prefabs)
end

local books = {}
for k, v in pairs(book_defs) do
    table.insert(books, MakeBook("t"..v))
end
book_defs = nil
return unpack(books)
