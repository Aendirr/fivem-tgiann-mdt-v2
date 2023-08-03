local QBCore = exports['qb-core']:GetCoreObject()

local players = {}

QBCore.Functions.CreateCallback("tgiann-mdtv2:ilk-data", function(source, cb)
    cb(players)
end)

Citizen.CreateThread(function()
    exports.oxmysql:execute("SELECT charinfo, job FROM players ", {
    }, function (result)
        players.police = {}
        players.user = {}
        for i=1, #result do
            local charinfo = json.decode(result[i].charinfo)
            if result[i].job.name == "police" then
                table.insert(players.police, charinfo.firstname .. " " .. charinfo.lastname)
            else
                table.insert(players.user, charinfo.firstname .. " " .. charinfo.lastname)
            end
        end
    end)
end)

QBCore.Commands.Add("tablet", "EMS/Polis Tabletini Aç", {}, false, function(source, args) -- name, help, arguments, argsrequired,  end sonuna persmission
	TriggerClientEvent('tgiann-mdtv2:open', source)
    TriggerClientEvent("tgiann-emstab:open", source)
end)

QBCore.Functions.CreateUseableItem("pmdt", function(source, item)
    TriggerClientEvent("tgiann-mdtv2:open", source)
end)

QBCore.Functions.CreateUseableItem("emdt", function(source, item)
    TriggerClientEvent("tgiann-emstab:open", source)
end)

QBCore.Commands.Add("tabletzoom", 'Tabletin Boyutunu Ayarlar.', {{ name="Tablet Boyutu", help="50 İle 100 Arası Bir Değer"}}, false, function(source, args) -- name, help, arguments, argsrequired,  end sonuna persmission
	TriggerClientEvent('tgiann-mdtv2:zoom', source, args[1])
    TriggerClientEvent("tgiann-emstab:zoom", source, args[1])
end)

QBCore.Functions.CreateCallback("tgiann-mdtv2:sorgula", function(source, cb, data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if data.tip == "isim" then
        local foundPlayers = {}
        exports.oxmysql:execute("SELECT * FROM players", {}, function (result)
            if result[1] then
                for k, v in pairs(result) do
                    v.charinfo = json.decode(v.charinfo)
                    v.ehliyetceza = json.decode(v.metadata).ehliyetceza
                    v.money = json.decode(v.money)
                    v.aranma = json.decode(v.aranma)
                    if string.find(v.charinfo.firstname, data.data) or string.find(v.charinfo.lastname, data.data) then
                        table.insert(foundPlayers, v)
                    end
                end

                cb(foundPlayers)
            end
        end)
    elseif data.tip == "arac" then
        exports.oxmysql:execute("SELECT * FROM player_vehicles WHERE citizenid = @citizenid", {
            ['@citizenid'] = data.data
        }, function (result)
            if result then
                cb(result)
            end
        end) 
    elseif data.tip == "numara" then
        exports.oxmysql:execute("SELECT * FROM players WHERE phone LIKE @search LIMIT 30", {
            ['@search'] = '%'..data.data..'%'
        }, function (result)
            local foundPlayers = {}
            if result[1] then
                for k, v in pairs(result) do
                    v.charinfo = json.decode(v.charinfo)
                    v.ehliyetceza = json.decode(v.metadata).ehliyetceza
                    v.money = json.decode(v.money)
                    v.aranma = json.decode(v.aranma)
                    table.insert(foundPlayers, v)
                end
                cb(foundPlayers)
            end
        end) 
    elseif data.tip == "plaka" then
        exports.oxmysql:execute("SELECT * FROM player_vehicles LEFT JOIN players ON player_vehicles.citizenid = players.citizenid WHERE player_vehicles.plate LIKE @plate LIMIT 30", {
            ['@plate'] = '%'..data.data..'%'
        }, function (result)
            local foundPlayers = {}
            if result then
                for k, v in pairs(result) do
                    v.charinfo = json.decode(v.charinfo)
                    v.ehliyetceza = json.decode(v.metadata).ehliyetceza
                    v.money = json.decode(v.money)
                    v.aranma = json.decode(v.aranma)
                    table.insert(foundPlayers, v)
                end

                cb(foundPlayers)
            end
        end) 
    end
end)

QBCore.Functions.CreateCallback('tgiann-mdtv2:ev', function(source, cb, citizenid)
    -- exports.oxmysql:execute("SELECT * FROM tgiann_ev WHERE (id = @id OR anahtar1 = @id OR anahtar2 = @id OR anahtar3 = @id OR anahtar4 = @id OR anahtar5 = @id)", {
    --     ['@id'] = citizenid
    -- }, function(result)
    --     if result[1] then
    --         cb(result[1].id)
    --     else
    --         cb("Ev Bilgisi Yok!")
    --     end
    -- end)

    cb("Ev Bilgisi Yok!")
end)

RegisterServerEvent('tgiann-mdtv2:ceza-kaydet')
AddEventHandler('tgiann-mdtv2:ceza-kaydet', function(data)
    local src = source

    exports.oxmysql:execute("INSERT INTO tgiann_mdt_olaylar SET aciklama = @aciklama, polis = @polis, zanli = @zanli, esyalar = @esyalar", {
        ["@aciklama"] = data.aciklama,
        ["@polis"] = json.encode(data.polis),
        ["@zanli"] = json.encode(data.zanli),
        ["@esyalar"] = json.encode(data.esyalar),
     }, function(result1)
        for i=1, #data.zanli do
            exports.oxmysql:execute("SELECT * FROM players", {}, function(result)
                if result[1] then
                    for k, v in pairs(result) do
                        v.charinfo = json.decode(v.charinfo)
                        if v.charinfo.firstname ..' '.. v.charinfo.lastname == data.zanli[i] then
                            if data.illegal then
                                local tPlayer = QBCore.Functions.GetPlayerByCitizenId(v.citizenid)
                                if tPlayer and not tPlayer.PlayerData.metadata.illegal then
                                    tPlayer.Functions.SetMetaData("illegal", true)
                                    TriggerClientEvent("tgiann-base:set-illegal", tPlayer.PlayerData.source, QBCore.Key)
                                end
                            end 
        
                            if data.ceza.tceza > 0 then
                                local tPlayer = QBCore.Functions.GetPlayerByCitizenId(v.citizenid)
                                if tPlayer and tPlayer.PlayerData.metadata.ehliyetceza < 0 then
                                    local newValue = tPlayer.PlayerData.metadata.ehliyetceza+data.ceza.tceza
                                    tPlayer.Functions.SetMetaData("ehliyetceza", newValue)
                                    if newValue > 9 then
                                        TriggerClientEvent("QBCore:Notify", tPlayer.PlayerData.source, "Ehliyetine Polis Tarafından El Konuldu", "error", 15000)
                                        TriggerClientEvent("QBCore:Notify", src, tPlayer.PlayerData.charinfo.firstname.. " " ..tPlayer.PlayerData.charinfo.lastname.." İsimli Kişinin Ehliyetine El Konuldu", "success", 15000)
                                    end
                                end
                            end
                            
                            exports.oxmysql:execute("INSERT INTO tgiann_mdt_cezalar SET citizenid = @citizenid, aciklama = @aciklama, ceza = @ceza, polis = @polis, cezalar = @cezalar, zanli = @zanli, olayid = @id", {
                                ["@citizenid"] = v.citizenid,
                                ["@aciklama"] = data.aciklama,
                                ["@ceza"] = json.encode(data.ceza),
                                ["@polis"] = json.encode(data.polis),
                                ["@zanli"] = json.encode(data.zanli),
                                ["@cezalar"] = data.cezaisim,
                                ["@id"] = result1.insertId
                            })     
                        end
                    end
                end
            end)
        end
    end)
end)

QBCore.Functions.CreateCallback("tgiann-mdtv2:olaylardata", function(source, cb, data)
    local data = {}
    exports.oxmysql:execute("SELECT * FROM tgiann_mdt_olaylar ORDER BY id DESC LIMIT 100", {
    }, function (result)
        if result[1] then
            for k, v in pairs(result) do
                v.ceza = json.decode(v.ceza)
                v.polis = json.decode(v.polis)
                v.zanli = json.decode(v.zanli)
                v.esyalar = json.decode(v.esyalar)

                table.insert(data, v)
            end

            cb((data))
        end
        
    end) 
end)

QBCore.Functions.CreateCallback("tgiann-mdtv2:sabikadata", function(source, cb, data)
    local found = {}
    exports.oxmysql:execute("SELECT * FROM tgiann_mdt_cezalar WHERE citizenid = @citizenid ORDER BY id DESC ", {
        ["@citizenid"] = data
    }, function (result)
        if result[1] then
            for k, v in pairs(result) do
                v.ceza = json.decode(v.ceza)
                v.polis = json.decode(v.polis)
                v.zanli = json.decode(v.zanli)
                v.esyalar = json.decode(v.esyalar)

                table.insert(found, v)
            end

            cb((found))
        end
    end) 
end)

RegisterServerEvent('tgiann-mdtv2:sabikasil')
AddEventHandler('tgiann-mdtv2:sabikasil', function(data)
    exports.oxmysql:execute("DELETE FROM tgiann_mdt_cezalar WHERE id = @id", {
        ['@id'] = data
    })
end)

RegisterServerEvent('tgiann-mdtv2:setavatar')
AddEventHandler('tgiann-mdtv2:setavatar', function(url, id)
    local xPlayer = QBCore.Functions.GetPlayerByCitizenId(id)
    if xPlayer then
        xPlayer.Functions.SetCharInfo("photo", url)
        xPlayer.Functions.Save()
    end
end)

RegisterServerEvent('tgiann-mdtv2:olaysil')
AddEventHandler('tgiann-mdtv2:olaysil', function(id)
    exports.oxmysql:execute("DELETE FROM tgiann_mdt_olaylar WHERE id = @id", {
        ['@id'] = id
    })
    exports.oxmysql:execute("DELETE FROM tgiann_mdt_cezalar WHERE olayid = @olayid", {
        ['@olayid'] = id
    })
end)

RegisterServerEvent('tgiann-mdtv2:aranma')
AddEventHandler('tgiann-mdtv2:aranma', function(data, durum)
    local xPlayer = QBCore.Functions.GetPlayerByCitizenId(data.id)
    if durum then
        local saat = os.time() + data.saat * 86400
        if xPlayer then
            xPlayer.Functions.SetAranma(true, data.neden, saat)
            xPlayer.Functions.Save()
        else
            exports.oxmysql:execute("UPDATE players SET aranma=@aranma WHERE citizenid = @citizenid", {
                ['@citizenid'] = data.id,
                ['@aranma'] = json.encode({durum = true, sebep=data.neden, suansaat=os.time(), saat=saat})
            })
        end
        exports.oxmysql:execute("INSERT INTO tgiann_mdt_arananlar SET citizenid = @citizenid, sebep = @sebep, baslangic = @baslangic, bitis = @bitis, isim = @isim", {
            ["@citizenid"] = data.id,
            ["@sebep"] = data.neden,
            ["@baslangic"] = os.time(),
            ["@bitis"] = saat,
            ["@isim"] = data.isim
        })
    else
        if xPlayer then
            xPlayer.Functions.SetAranma(false)
            xPlayer.Functions.Save()
        else
            exports.oxmysql:execute("UPDATE players SET aranma=@aranma WHERE citizenid = @citizenid", {
                ['@citizenid'] = data.id,
                ['@aranma'] = json.encode({durum = false, sebep="", suansaat="", saat=""})
            })
        end
        exports.oxmysql:execute("DELETE FROM tgiann_mdt_arananlar WHERE citizenid = @citizenid", {
            ['@citizenid'] = data.id
        })
    end
end)

QBCore.Functions.CreateCallback("tgiann-mdtv2:arananlar", function(source, cb, data)
    exports.oxmysql:execute("SELECT * FROM tgiann_mdt_arananlar", {
    }, function (result)
        cb(result)
    end) 
end)

QBCore.Functions.CreateCallback("tgiann-mdtv2:olayara", function(source, cb, data)
    local found = {}
    exports.oxmysql:execute("SELECT * FROM tgiann_mdt_olaylar WHERE id = @id", {
        ["@id"] = tonumber(data)
    }, function (result)
        if result[1] then
            for k, v in pairs(result) do
                v.ceza = json.decode(v.ceza)
                v.polis = json.decode(v.polis)
                v.zanli = json.decode(v.zanli)
                v.esyalar = json.decode(v.esyalar)

                table.insert(found, v)
            end

            cb((found))
        end
    end) 
end)