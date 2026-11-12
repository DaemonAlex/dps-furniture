-- dps-furniture (server). Registers the streamed furniture packs in the qs-housing furniture shop.
--
-- How: at boot, read the studio's photo table (dps_studio_thumbs, filled by the Studio photo booth, pictures on
-- Fivemanage), then for every style set in data/models.lua build one shop item and hand it to qs-housing through
-- exports['qs-housing']:AddFurniture(category, item), into one of qs-housing's own categories. A set whose pieces have no
-- photo yet is skipped (the shop never shows a blank picture); run the photo booth and restart and it appears.
-- Categories, labels and prices come from the rules below. Nothing inside qs-housing is edited.
-- 2026-11-10, Damon: "lets get these in the housing scripts so people can use them".

local PACKS = {
    -- pack folder                 shop label           room default category, label prefix dropped from model names
    ['AEG_PROPS_livingroom-dubai']  = { label = 'Dubai Living',    default = 'couchtable', strip = 'dubai_' },
    ['AEG_props_PetzAmsterda']      = { label = 'Petz Amsterdam',  default = 'plant',      strip = 'petz_amsterda_' },
    ['AEG_props_PetzDublin']        = { label = 'Petz Dublin',     default = 'plant',      strip = 'petz_dublin_' },
    ['AEG_props_PetzLondon']        = { label = 'Petz London',     default = 'plant',      strip = 'petz_london_' },
    ['BohoBathroom']                = { label = 'Boho Bathroom',   default = 'handtowel',  strip = 'boho_' },
    ['BedroomSet']                  = { label = 'Bedroom Set',     default = 'bedsidetable', strip = '' },
    ['Coffee']                      = { label = 'Coffee Corner',   default = 'decals',     strip = '' },
    ['LunaticStudio_VanGogh']       = { label = 'Van Gogh',        default = 'painting',   strip = 'vangogh_' },
    ['lunaticstudio23_bathroom_1']  = { label = 'Spa Bathroom',    default = 'handtowel',  strip = 'ls_b[th][th]1_' },
    ['lunaticstudio23_kitchen_1']   = { label = 'Kitchen One',     default = 'table',      strip = 'ls_kitcol1_' },
    ['lunaticstudio23_kitchen_2']   = { label = 'Kitchen Two',     default = 'table',      strip = 'ls_kitcol2_' },
    ['lunaticstudio23_kitchen_3']   = { label = 'Kitchen Three',   default = 'table',      strip = 'ls_kitcol3_' },
    ['lunaticstudio23_office_1']    = { label = 'Home Office',     default = 'table',      strip = 'ls_furoff1_' },
    ['ate_furniture_hall1']         = { label = 'Hallway',         default = 'couchtable', strip = 'ate_hall1_' },
}

-- First word of the model name (after the pack prefix) decides the qs-housing category. Keys are qs-housing's own
-- category names (config/furniture.lua): kitchen = chair cooker dishwasher fridge hangingcaninets hotplate kitchenetteleft
-- kitchenetteright knifeblockset microwave oven sink table; bathroom = washingmachine toilet toiletpaper toiletbrush shower
-- mirror handtowel; bedroom = bed bedsidetable carpet painting decals laptop wardrobe; living = climate couch couchtable
-- cleaning lamp plant tv; garden = sofa camera light bush tree doors.
local CATEGORY = {
    sit = 'couch', cftable = 'couchtable', endtable = 'couchtable', decor = 'plant', fireplace = 'climate', shelf = 'hangingcaninets',
    bed = 'bed', cf = 'plant', food = 'decals', toy = 'decals',
    carpet = 'carpet', luxbed = 'bed', nightstand = 'bedsidetable',
    chair = 'chair', table = 'table', coffebag = 'decals', ground = 'decals',
    cabinet = 'hangingcaninets', cabint = 'hangingcaninets', cabin = 'hangingcaninets', wcase = 'hangingcaninets', bookcase = 'wardrobe',
    counter = 'kitchenetteleft', island = 'kitchenetteright', islaco = 'kitchenetteright', refrig = 'fridge',
    stove = 'cooker', stovehood = 'cooker', shood = 'cooker', stoveh = 'cooker',
    stool = 'chair', barstool = 'chair', bstool = 'chair',
    ddrainer = 'knifeblockset', ktools = 'knifeblockset', waldec = 'knifeblockset', wholder = 'knifeblockset',
    desk = 'table', drawde = 'table', drawun = 'wardrobe', dlamp = 'lamp', tlamp = 'lamp', lamp = 'lamp',
    painting = 'painting', sculpture = 'plant', sideboard = 'couchtable', vase = 'plant', plant = 'plant', mats = 'carpet',
}

-- Plain words for the shop label.
local WORD = {
    sit = 'Sofa', cftable = 'Coffee table', endtable = 'End table', decor = 'Decor', fireplace = 'Fireplace', shelf = 'Shelf',
    bed = 'Pet bed', cf = 'Cat tree', food = 'Food bowl', toy = 'Pet toy',
    carpet = 'Carpet', luxbed = 'Luxury bed', nightstand = 'Nightstand',
    chair = 'Chair', table = 'Table', coffebag = 'Coffee bag', ground = 'Ground coffee',
    cabinet = 'Cabinet', cabint = 'Cabinet', cabin = 'Cabinet', wcase = 'Wine case', bookcase = 'Bookcase',
    counter = 'Counter', island = 'Island', islaco = 'Island', refrig = 'Fridge',
    stove = 'Stove', stovehood = 'Stove hood', shood = 'Stove hood', stoveh = 'Stove hood',
    stool = 'Stool', barstool = 'Bar stool', bstool = 'Bar stool',
    ddrainer = 'Dish drainer', ktools = 'Kitchen tools', waldec = 'Wall decor', wholder = 'Wine holder',
    desk = 'Desk', drawde = 'Drawer desk', drawun = 'Drawer unit', dlamp = 'Desk lamp', tlamp = 'Table lamp', lamp = 'Lamp',
    painting = 'Painting', sculpture = 'Sculpture', sideboard = 'Sideboard', vase = 'Vase', plant = 'Plant',
    soap = 'Soap', bbomb = 'Bath bombs', cloth = 'Cloths', feetb = 'Foot bath', gtf = 'Bath set', mats = 'Bath mat',
    prod = 'Products', salt = 'Bath salt', scale = 'Scale', scrub = 'Scrub', tow = 'Towels', tray = 'Tray', bathroom = 'Piece',
    amendoeira = 'Almond Blossom', byvangogh = 'Self-portrait', flowers = 'Flowers', lirios = 'Irises', nightst = 'Starry Night',
    nightstar = 'Starry Night (large)', oleanders = 'Oleanders', rose = 'Roses', sunflower = 'Sunflowers', terraco = 'Café Terrace', trigo = 'Wheat Field',
}

-- Flat prices until Damon sets his own. Big furniture 500, paintings 300, small decor 150.
local BIG = { couch = true, bed = true, table = true, wardrobe = true, fridge = true, kitchenetteleft = true, kitchenetteright = true,
    hangingcaninets = true, cooker = true, tv = true, climate = true, couchtable = true }
local function priceFor(category) if category == 'painting' then return 300 elseif BIG[category] then return 500 end return 150 end

local STYLE = { a = 'Style A', b = 'Style B', c = 'Style C', d = 'Style D', e = 'Style E', f = 'Style F', g = 'Style G', h = 'Style H', i = 'Style I', j = 'Style J' }

-- 'ls_kitcol1_counter1a' with strip 'ls_kitcol1_' -> word 'counter', tail '1a'; 'dubai_1sita' -> word 'sit', tail '1a';
-- 'boho_bathroom_12' -> word 'bathroom', tail '12'. The word is the longest known word the name starts with.
local function parse(model, strip)
    local base = model:gsub('_[a-j]$', '')
    if strip ~= '' then base = base:gsub('^' .. strip, '') end
    local num, rest = base:match('^(%d*)(.*)$')
    local word
    for len = #rest, 1, -1 do
        local candidate = rest:sub(1, len)
        if WORD[candidate] or CATEGORY[candidate] then word = candidate break end
    end
    word = word or rest:match('^(%a+)') or rest
    local tail = rest:sub(#word + 1):gsub('^_', '')
    return word, (num or '') .. tail
end

local function labelFor(pack, model)
    local word, tail = parse(model, pack.strip)
    local nice = WORD[word] or (word:sub(1, 1):upper() .. word:sub(2))
    tail = tail:gsub('_', ' ')
    if tail ~= '' then nice = nice .. ' ' .. tail:upper() end
    return pack.label .. ' ' .. nice
end

local function categoryFor(pack, model)
    local word = parse(model, pack.strip)
    return CATEGORY[word] or pack.default
end

local function register()
    -- only the models we sell (the photo table holds 16000+ rows, asking for all of them trips oxmysql's size warning)
    local wanted = {}
    for _, sets in pairs(DPSFurnitureModels) do
        for _, set in ipairs(sets) do
            for _, model in ipairs(set) do wanted[#wanted + 1] = model end
        end
    end
    local photo = {}
    for i = 1, #wanted, 200 do
        local slice = {}
        for j = i, math.min(i + 199, #wanted) do slice[#slice + 1] = wanted[j] end
        local marks = string.rep('?,', #slice):sub(1, -2)
        local rows = MySQL.query.await('SELECT model, url FROM dps_studio_thumbs WHERE model IN (' .. marks .. ')', slice) or {}
        for _, r in ipairs(rows) do photo[r.model:lower()] = r.url end
    end

    local added, skipped, failed = 0, 0, 0
    local perCategory = {}
    for packName, sets in pairs(DPSFurnitureModels) do
        local pack = PACKS[packName]
        if pack and GetResourceState(packName) == 'started' then
            for _, set in ipairs(sets) do
                -- main piece = first model with a photo; the rest with photos become its style choices
                local main, variants = nil, {}
                for _, model in ipairs(set) do
                    if photo[model] then
                        if not main then main = model else variants[#variants + 1] = model end
                    end
                end
                if not main then
                    skipped = skipped + 1
                else
                    local category = categoryFor(pack, main)
                    local price = priceFor(category)
                    local item = {
                        object = main,
                        label = labelFor(pack, main),
                        price = price,
                        description = pack.label .. ' collection.',
                        img = photo[main],
                        colorlabel = STYLE[main:match('_([a-j])$') or ''] or 'Standard',
                        colors = {},
                    }
                    for _, v in ipairs(variants) do
                        item.colors[#item.colors + 1] = { label = STYLE[v:match('_([a-j])$') or ''] or v, object = v, price = price }
                    end
                    local ok, err = pcall(function() return exports['qs-housing']:AddFurniture(category, item) end)
                    if ok then
                        added = added + 1
                        perCategory[category] = (perCategory[category] or 0) + 1
                    else
                        failed = failed + 1
                        print(('[dps-furniture] %s -> %s failed: %s'):format(main, category, tostring(err)))
                    end
                end
            end
        elseif pack then
            print(('[dps-furniture] pack %s is not started, its pieces are left out'):format(packName))
        end
    end
    local parts = {}
    for c, n in pairs(perCategory) do parts[#parts + 1] = c .. ' ' .. n end
    table.sort(parts)
    print(('[dps-furniture] %d items in the shop (%d sets without a photo skipped, %d failed). %s'):format(added, skipped, failed, table.concat(parts, ', ')))
end

CreateThread(function()
    while GetResourceState('qs-housing') ~= 'started' do Wait(500) end
    Wait(2000) -- qs-housing fills its catalogue first (Killstorex waits the same way)
    register()
end)
