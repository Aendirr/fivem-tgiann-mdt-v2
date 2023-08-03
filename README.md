## INTERGRATION

**qb-core/server/player.lua**;

Add code below

```lua

    PlayerData.metadata['illegal'] = PlayerData.metadata['illegal'] or false
    PlayerData.metadata['ehliyetceza'] = PlayerData.metadata['ehliyetceza'] or 0

```

Then edit this code like this:

```lua

    function self.Functions.UpdatePlayerData(dontUpdateChat)
        TriggerClientEvent('QBCore:Player:SetPlayerData', self.PlayerData.source, self.PlayerData)
        if not dontUpdateChat then
            QBCore.Commands.Refresh(self.PlayerData.source)
        end
    end

    function self.Functions.SetAranma(durum, neden, saat)
        if durum == false then
            PlayerData.aranma = PlayerData.aranma or { durum = false, sebep = "", suansaat = "", saat = "" }
        else
            PlayerData.aranma = PlayerData.aranma or { durum = true, sebep = neden, suansaat = os.time(), saat = saat}
        end
    end

```

After that edit this code like this:

```lua

function QBCore.Player.Save(source)
    local ped = GetPlayerPed(source)
    local pcoords = GetEntityCoords(ped)
    local PlayerData = QBCore.Players[source].PlayerData
    if PlayerData then
        MySQL.insert('INSERT INTO players (citizenid, cid, license, name, money, charinfo, job, gang, position, metadata, aranma) VALUES (:citizenid, :cid, :license, :name, :money, :charinfo, :job, :gang, :position, :metadata, :aranma) ON DUPLICATE KEY UPDATE cid = :cid, name = :name, money = :money, charinfo = :charinfo, job = :job, gang = :gang, position = :position, metadata = :metadata, aranma = :aranma', {
            citizenid = PlayerData.citizenid,
            cid = tonumber(PlayerData.cid),
            license = PlayerData.license,
            name = PlayerData.name,
            money = json.encode(PlayerData.money),
            charinfo = json.encode(PlayerData.charinfo),
            job = json.encode(PlayerData.job),
            gang = json.encode(PlayerData.gang),
            position = json.encode(pcoords),
            metadata = json.encode(PlayerData.metadata),
            aranma = json.encode(PlayerData.aranma)
        })
        if GetResourceState('lj-inventory') ~= 'missing' then exports['lj-inventory']:SaveInventory(source) end
        QBCore.ShowSuccess(GetCurrentResourceName(), PlayerData.name .. ' PLAYER SAVED!')
    else
        QBCore.ShowError(GetCurrentResourceName(), 'ERROR QBCORE.PLAYER.SAVE - PLAYERDATA IS EMPTY!')
    end
end

```

After doing all of this you can use this MDT without any problem.