ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'unicorn', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'unicorn', _U('unicorn_customer'), true, true)
TriggerEvent('esx_society:registerSociety', 'unicorn', 'Unicorn', 'society_unicorn', 'society_unicorn', 'society_unicorn', {type = 'private'})



RegisterServerEvent('esx_unicornjob:getStockItem')
AddEventHandler('esx_unicornjob:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_unicorn', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_removed') .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_unicornjob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_unicorn', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_unicornjob:putStockItems')
AddEventHandler('esx_unicornjob:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_unicorn', function(inventory)

    local item = inventory.getItem(itemName)
    local playerItemCount = xPlayer.getInventoryItem(itemName).count

    if item.count >= 0 and count <= playerItemCount then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_added') .. count .. ' ' .. item.label)

  end)

end)


RegisterServerEvent('esx_unicornjob:getFridgeStockItem')
AddEventHandler('esx_unicornjob:getFridgeStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_unicorn_fridge', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_removed') .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_unicornjob:getFridgeStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_unicorn_fridge', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_unicornjob:putFridgeStockItems')
AddEventHandler('esx_unicornjob:putFridgeStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_unicorn_fridge', function(inventory)

    local item = inventory.getItem(itemName)
    local playerItemCount = xPlayer.getInventoryItem(itemName).count

    if item.count >= 0 and count <= playerItemCount then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_added') .. count .. ' ' .. item.label)

  end)

end)


RegisterServerEvent('esx_unicornjob:buyItem')
AddEventHandler('esx_unicornjob:buyItem', function(itemName, price, itemLabel)

    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    local limit = xPlayer.getInventoryItem(itemName).limit
    local qtty = xPlayer.getInventoryItem(itemName).count
    local societyAccount = nil

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_unicorn', function(account)
        societyAccount = account
      end)
    
    if societyAccount ~= nil and societyAccount.money >= price then
        if qtty < limit then
            societyAccount.removeMoney(price)
            xPlayer.addInventoryItem(itemName, 1)
            TriggerClientEvent('esx:showNotification', _source, _U('bought') .. itemLabel)
        else
            TriggerClientEvent('esx:showNotification', _source, _U('max_item'))
        end
    else
        TriggerClientEvent('esx:showNotification', _source, _U('not_enough'))
    end

end)


RegisterServerEvent('esx_unicornjob:craftingCoktails')
AddEventHandler('esx_unicornjob:craftingCoktails', function(itemValue)

    local _source = source
    local _itemValue = itemValue
    TriggerClientEvent('esx:showNotification', _source, _U('assembling_cocktail'))
    --[[
    if _itemValue == 'jagerbomb' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('energy').count
            local bethQuantity      = xPlayer.getInventoryItem('jager').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('energy') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('jager') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('energy', 2)
                    xPlayer.removeInventoryItem('jager', 2)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('jagerbomb') .. ' ~w~!')
                    xPlayer.removeInventoryItem('energy', 2)
                    xPlayer.removeInventoryItem('jager', 2)
                    xPlayer.addInventoryItem('jagerbomb', 1)
                end
            end

        end)
    end
    --]]
    --[[
    if _itemValue == 'golem' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('limonade').count
            local bethQuantity      = xPlayer.getInventoryItem('vodka').count
            local gimelQuantity     = xPlayer.getInventoryItem('ice').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('limonade') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('vodka') .. '~w~')
            elseif gimelQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('limonade', 2)
                    xPlayer.removeInventoryItem('vodka', 2)
                    xPlayer.removeInventoryItem('ice', 1)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('golem') .. ' ~w~!')
                    xPlayer.removeInventoryItem('limonade', 2)
                    xPlayer.removeInventoryItem('vodka', 2)
                    xPlayer.removeInventoryItem('ice', 1)
                    xPlayer.addInventoryItem('golem', 1)
                end
            end

        end)
    end
    --]]
    if _itemValue == 'whiskycoca' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('soda').count
            local bethQuantity      = xPlayer.getInventoryItem('whisky').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('soda') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('whisky') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('soda', 2)
                    xPlayer.removeInventoryItem('whisky', 2)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('whiskycoca') .. ' ~w~!')
                    xPlayer.removeInventoryItem('soda', 2)
                    xPlayer.removeInventoryItem('whisky', 2)
                    xPlayer.addInventoryItem('whiskycoca', 1)
                end
            end

        end)
    end

    if _itemValue == 'rhumcoca' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('soda').count
            local bethQuantity      = xPlayer.getInventoryItem('rhum').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('soda') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('rhum') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('soda', 2)
                    xPlayer.removeInventoryItem('rhum', 2)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('rhumcoca') .. ' ~w~!')
                    xPlayer.removeInventoryItem('soda', 2)
                    xPlayer.removeInventoryItem('rhum', 2)
                    xPlayer.addInventoryItem('rhumcoca', 1)
                end
            end

        end)
    end
    --[[
    if _itemValue == 'vodkaenergy' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('energy').count
            local bethQuantity      = xPlayer.getInventoryItem('vodka').count
            local gimelQuantity     = xPlayer.getInventoryItem('ice').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('energy') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('vodka') .. '~w~')
            elseif gimelQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('energy', 2)
                    xPlayer.removeInventoryItem('vodka', 2)
                    xPlayer.removeInventoryItem('ice', 1)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('vodkaenergy') .. ' ~w~!')
                    xPlayer.removeInventoryItem('energy', 2)
                    xPlayer.removeInventoryItem('vodka', 2)
                    xPlayer.removeInventoryItem('ice', 1)
                    xPlayer.addInventoryItem('vodkaenergy', 1)
                end
            end

        end)
    end
    --]]
    if _itemValue == 'vodkafruit' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('jusfruit').count
            local bethQuantity      = xPlayer.getInventoryItem('vodka').count
            local gimelQuantity     = xPlayer.getInventoryItem('ice').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('jusfruit') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('vodka') .. '~w~')
            elseif gimelQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('jusfruit', 2)
                    xPlayer.removeInventoryItem('vodka', 2)
                    xPlayer.removeInventoryItem('ice', 1)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('vodkafruit') .. ' ~w~!')
                    xPlayer.removeInventoryItem('jusfruit', 2)
                    xPlayer.removeInventoryItem('vodka', 2)
                    xPlayer.removeInventoryItem('ice', 1)
                    xPlayer.addInventoryItem('vodkafruit', 1) 
                end
            end

        end)
    end

    if _itemValue == 'rhumfruit' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('jusfruit').count
            local bethQuantity      = xPlayer.getInventoryItem('rhum').count
            local gimelQuantity     = xPlayer.getInventoryItem('ice').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('jusfruit') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('rhum') .. '~w~')
            elseif gimelQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('jusfruit', 2)
                    xPlayer.removeInventoryItem('rhum', 2)
                    xPlayer.removeInventoryItem('ice', 1)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('rhumfruit') .. ' ~w~!')
                    xPlayer.removeInventoryItem('jusfruit', 2)
                    xPlayer.removeInventoryItem('rhum', 2)
                    xPlayer.removeInventoryItem('ice', 1)
                    xPlayer.addInventoryItem('rhumfruit', 1)
                end
            end

        end)
    end
    --[[
    if _itemValue == 'teqpaf' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('limonade').count
            local bethQuantity      = xPlayer.getInventoryItem('tequila').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('limonade') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('tequila') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('limonade', 2)
                    xPlayer.removeInventoryItem('tequila', 2)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('teqpaf') .. ' ~w~!')
                    xPlayer.removeInventoryItem('limonade', 2)
                    xPlayer.removeInventoryItem('tequila', 2)
                    xPlayer.addInventoryItem('teqpaf', 1)
                end
            end

        end)
    end
    --]]
    if _itemValue == 'mojito' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('rhum').count
            local bethQuantity      = xPlayer.getInventoryItem('limonade').count
            local gimelQuantity     = xPlayer.getInventoryItem('menthe').count
            local daletQuantity      = xPlayer.getInventoryItem('ice').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('rhum') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('limonade') .. '~w~')
            elseif gimelQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('menthe') .. '~w~')
            elseif daletQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('rhum', 2)
                    xPlayer.removeInventoryItem('limonade', 2)
                    xPlayer.removeInventoryItem('menthe', 2)
                    xPlayer.removeInventoryItem('ice', 1)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('mojito') .. ' ~w~!')
                    xPlayer.removeInventoryItem('rhum', 2)
                    xPlayer.removeInventoryItem('limonade', 2)
                    xPlayer.removeInventoryItem('menthe', 2)
                    xPlayer.removeInventoryItem('ice', 1)
                    xPlayer.addInventoryItem('mojito', 1)
                end
            end

        end)
    end

    if _itemValue == 'sexonthebeach' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('vodka').count
            local bethQuantity      = xPlayer.getInventoryItem('jusorange').count
            local gimelQuantity     = xPlayer.getInventoryItem('grenadine').count
            local daletQuantity      = xPlayer.getInventoryItem('ice').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('vodka') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('jusorange') .. '~w~')
            elseif gimelQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('grenadine') .. '~w~')
            elseif daletQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('vodka', 2)
                    xPlayer.removeInventoryItem('jusorange', 2)
                    xPlayer.removeInventoryItem('grenadine', 1)
                    xPlayer.removeInventoryItem('ice', 1)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('sexonthebeach') .. ' ~w~!')
                    xPlayer.removeInventoryItem('vodka', 2)
                    xPlayer.removeInventoryItem('jusorange', 2)
                    xPlayer.removeInventoryItem('grenadine', 1)
                    xPlayer.removeInventoryItem('ice', 1)
                    xPlayer.addInventoryItem('sexonthebeach', 1)
                end
            end

        end)
    end

    if _itemValue == 'monaco' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('biere').count
            local bethQuantity      = xPlayer.getInventoryItem('grenadine').count
            local gimelQuantity     = xPlayer.getInventoryItem('limonade').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('biere') .. '~w~')
            elseif bethQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('grenadine') .. '~w~')
            elseif gimelQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('limonade') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('biere', 2)
                    xPlayer.removeInventoryItem('grenadine', 1)
                    xPlayer.removeInventoryItem('limonade', 1)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('monaco') .. ' ~w~!')
                    xPlayer.removeInventoryItem('biere', 2)
                    xPlayer.removeInventoryItem('grenadine', 1)
                    xPlayer.removeInventoryItem('limonade', 1)
                    xPlayer.addInventoryItem('monaco', 1)
                end
            end

        end)
    end

    if _itemValue == 'oiseaujaune' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('rhum').count
            local bethQuantity      = xPlayer.getInventoryItem('jusorange').count
            local gimelQuantity     = xPlayer.getInventoryItem('menthe').count
            local daletQuantity      = xPlayer.getInventoryItem('ice').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('rhum') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('jusorange') .. '~w~')
            elseif gimelQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('menthe') .. '~w~')
            elseif daletQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('rhum', 2)
                    xPlayer.removeInventoryItem('jusorange', 2)
                    xPlayer.removeInventoryItem('menthe', 1)
                    xPlayer.removeInventoryItem('ice', 1)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('oiseaujaune') .. ' ~w~!')
                    xPlayer.removeInventoryItem('rhum', 2)
                    xPlayer.removeInventoryItem('jusorange', 2)
                    xPlayer.removeInventoryItem('menthe', 1)
                    xPlayer.removeInventoryItem('ice', 1)
                    xPlayer.addInventoryItem('oiseaujaune', 1)
                end
            end

        end)
    end

    if _itemValue == 'tequilasunrise' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('tequila').count
            local bethQuantity      = xPlayer.getInventoryItem('jusorange').count
            local gimelQuantity     = xPlayer.getInventoryItem('grenadine').count
            local daletQuantity      = xPlayer.getInventoryItem('ice').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('tequila') .. '~w~')
            elseif bethQuantity < 3 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('jusorange') .. '~w~')
            elseif gimelQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('grenadine') .. '~w~')
            elseif daletQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('tequila', 2)
                    xPlayer.removeInventoryItem('jusorange', 3)
                    xPlayer.removeInventoryItem('grenadine', 1)
                    xPlayer.removeInventoryItem('ice', 1)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('tequilasunrise') .. ' ~w~!')
                    xPlayer.removeInventoryItem('tequila', 2)
                    xPlayer.removeInventoryItem('jusorange', 3)
                    xPlayer.removeInventoryItem('grenadine', 1)
                    xPlayer.removeInventoryItem('ice', 1)
                    xPlayer.addInventoryItem('tequilasunrise', 1)
                end
            end

        end)
    end

    if _itemValue == 'rosedelanuit' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('lu_chiew').count
            local bethQuantity      = xPlayer.getInventoryItem('grenadine').count
            local gimelQuantity     = xPlayer.getInventoryItem('juscitron').count
            local daletQuantity      = xPlayer.getInventoryItem('ice').count

            if alephQuantity < 3 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('lu_chiew') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('grenadine') .. '~w~')
            elseif gimelQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('juscitron') .. '~w~')
            elseif daletQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('lu_chiew', 3)
                    xPlayer.removeInventoryItem('grenadine', 2)
                    xPlayer.removeInventoryItem('juscitron', 1)
                    xPlayer.removeInventoryItem('ice', 2)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('rosedelanuit') .. ' ~w~!')
                    xPlayer.removeInventoryItem('lu_chiew', 3)
                    xPlayer.removeInventoryItem('grenadine', 2)
                    xPlayer.removeInventoryItem('juscitron', 1)
                    xPlayer.removeInventoryItem('ice', 2)
                    xPlayer.addInventoryItem('rosedelanuit', 1)
                end
            end

        end)
    end

    if _itemValue == 'mixapero' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('bolcacahuetes').count
            local bethQuantity      = xPlayer.getInventoryItem('bolnoixcajou').count
            local gimelQuantity     = xPlayer.getInventoryItem('bolpistache').count
            local daletQuantity     = xPlayer.getInventoryItem('bolchips').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('bolcacahuetes') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('bolnoixcajou') .. '~w~')
            elseif gimelQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('bolpistache') .. '~w~')
            elseif daletQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('bolchips') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('bolcacahuetes', 2)
                    xPlayer.removeInventoryItem('bolnoixcajou', 2)
                    xPlayer.removeInventoryItem('bolpistache', 2)
                    xPlayer.removeInventoryItem('bolchips', 1)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('mixapero') .. ' ~w~!')
                    xPlayer.removeInventoryItem('bolcacahuetes', 2)
                    xPlayer.removeInventoryItem('bolnoixcajou', 2)
                    xPlayer.removeInventoryItem('bolpistache', 2)
                    xPlayer.removeInventoryItem('bolchips', 2)
                    xPlayer.addInventoryItem('mixapero', 1)
                end
            end

        end)
    end
    --[[
    if _itemValue == 'metreshooter' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('jager').count
            local bethQuantity      = xPlayer.getInventoryItem('vodka').count
            local gimelQuantity     = xPlayer.getInventoryItem('whisky').count
            local daletQuantity     = xPlayer.getInventoryItem('tequila').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('jager') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('vodka') .. '~w~')
            elseif gimelQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('whisky') .. '~w~')
            elseif daletQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('tequila') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('jager', 2)
                    xPlayer.removeInventoryItem('vodka', 2)
                    xPlayer.removeInventoryItem('whisky', 2)
                    xPlayer.removeInventoryItem('tequila', 2)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('metreshooter') .. ' ~w~!')
                    xPlayer.removeInventoryItem('jager', 2)
                    xPlayer.removeInventoryItem('vodka', 2)
                    xPlayer.removeInventoryItem('whisky', 2)
                    xPlayer.removeInventoryItem('tequila', 2)
                    xPlayer.addInventoryItem('metreshooter', 1)
                end
            end

        end)
    end
    --]]
    --[[
    if _itemValue == 'jagercerbere' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('jagerbomb').count
            local bethQuantity      = xPlayer.getInventoryItem('vodka').count
            local gimelQuantity     = xPlayer.getInventoryItem('tequila').count

            if alephQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('jagerbomb') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('vodka') .. '~w~')
            elseif gimelQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('tequila') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('jagerbomb', 1)
                    xPlayer.removeInventoryItem('vodka', 2)
                    xPlayer.removeInventoryItem('tequila', 2)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('jagercerbere') .. ' ~w~!')
                    xPlayer.removeInventoryItem('jagerbomb', 1)
                    xPlayer.removeInventoryItem('vodka', 2)
                    xPlayer.removeInventoryItem('tequila', 2)
                    xPlayer.addInventoryItem('jagercerbere', 1)
                end
            end

        end)
    end
    --]]

end)


ESX.RegisterServerCallback('esx_unicornjob:getVaultWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_unicorn', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_unicornjob:addVaultWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_unicorn', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 1
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)

ESX.RegisterServerCallback('esx_unicornjob:removeVaultWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.addWeapon(weaponName, 1000)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_unicorn', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 0
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)

ESX.RegisterServerCallback('esx_unicornjob:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)


ESX.RegisterUsableItem('sexonthebeach', function(source)

    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem('sexonthebeach', 1)

    TriggerClientEvent('esx_status:add', source, 'drunk', 180000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 100000)
    TriggerClientEvent('esx_basicneeds:onDrink', source)
    TriggerClientEvent('esx:showNotification', source, _U('used_sexonthebeach'))

end)

ESX.RegisterUsableItem('monaco', function(source)

    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem('monaco', 1)

    TriggerClientEvent('esx_status:add', source, 'drunk', 60000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 100000)
    TriggerClientEvent('esx_basicneeds:onDrink', source)
    TriggerClientEvent('esx:showNotification', source, _U('used_monaco'))

end)

ESX.RegisterUsableItem('oiseaujaune', function(source)

    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem('oiseaujaune', 1)

    TriggerClientEvent('esx_status:add', source, 'drunk', 180000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 100000)
    TriggerClientEvent('esx_basicneeds:onDrink', source)
    TriggerClientEvent('esx:showNotification', source, _U('used_oiseaujaune'))

end)

ESX.RegisterUsableItem('tequilasunrise', function(source)

    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem('tequilasunrise', 1)

    TriggerClientEvent('esx_status:add', source, 'drunk', 180000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 100000)
    TriggerClientEvent('esx_basicneeds:onDrink', source)
    TriggerClientEvent('esx:showNotification', source, _U('used_tequilasunrise'))

end)

ESX.RegisterUsableItem('rosedelanuit', function(source)

    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem('tequilasunrise', 1)

    TriggerClientEvent('esx_status:add', source, 'drunk', 300000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 100000)
    TriggerClientEvent('esx_basicneeds:onDrink', source)
    TriggerClientEvent('esx:showNotification', source, _U('used_rosedelanuit'))

end)