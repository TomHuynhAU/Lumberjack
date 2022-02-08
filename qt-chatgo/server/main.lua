ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function CountCops()

	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'realestateagent' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
end

CountCops()

RegisterServerEvent('esx_taglialegnasdr:pickedUpTree')
AddEventHandler('esx_taglialegnasdr:pickedUpTree', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.canCarryItem('wood', math.random(1, 3)) then
		xPlayer.addInventoryItem('wood', math.random(1, 3))
		TriggerEvent('reward_event:additem', xPlayer.source, 'wood', '1')
	else 
		TriggerClientEvent('qt-notify:Alert', _source, "ERROR", "Bạn đã đủ gỗ trong túi", 5000, 'error')
	end
	--TriggerEvent("api:randomItemSv", _source, 30, {"nhom", "chi","cat","resin","sat","thanda"}, math.random(1, 3))
end)

RegisterServerEvent('esx_taglialegnasdr:segatura')
AddEventHandler('esx_taglialegnasdr:segatura', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
		if xPlayer.canCarryItem('cutted_wood', 5) then 
			xPlayer.addInventoryItem('cutted_wood', 5)
			--TriggerEvent("api:randomItemSv", _source, 40, {"nhom", "chi","cat","resin","sat","thanda"}, math.random(1, 3))
			xPlayer.removeInventoryItem('wood', 5)
		else 
			TriggerClientEvent('qt-notify:Alert', _source, "ERROR", "Túi đồ đầy", 5000, 'error')
		end	
	end
end)


RegisterServerEvent('esx_taglialegnasdr:tavole')
AddEventHandler('esx_taglialegnasdr:tavole', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.canCarryItem('packaged_plank', 5) then 
		xPlayer.addInventoryItem('packaged_plank', 5)
	--TriggerEvent("api:randomItemSv", _source, 50, {"nhom", "chi","cat","resin","sat","thanda"}, math.random(1, 3))
		xPlayer.removeInventoryItem('cutted_wood', 5)
		TriggerEvent('reward_event:additem', xPlayer.source, 'packaged_plank', '5')
	else 
		TriggerClientEvent('qt-notify:Alert', _source, "ERROR", "Túi đồ đầy hoặc không có gỗ", 5000, 'error')
	end
end)

------------------------------------------------------------------------------------ BLIP

--ESX.RegisterServerCallback('esx_taglialegnasdr:conteggioporcodio', function(source, cb)
	--local xPlayer = ESX.GetPlayerFromId(source)

	--cb(CopsConnected)
--end)

-- RegisterServerEvent('esx_taglialegnasdr:venditablip')
-- AddEventHandler('esx_taglialegnasdr:venditablip', function(quantity, count)

-- 	local _source = source
-- 	local xPlayer = ESX.GetPlayerFromId(_source)
-- 	local fattura  = math.floor(quantity * 18)

-- 	if xPlayer.getInventoryItem('packaged_plank').count >= 5 then
-- 		xPlayer.removeInventoryItem('packaged_plank', 5)
-- 		xPlayer.addAccountMoney('money', 100)
-- 	else
-- 		TriggerClientEvent('esx:showNotification', _source, '<FONT FACE = "Helvetica">Bạn cần 5 đá bẩn')
-- 	end

-- 	--TriggerEvent('esx_addonaccount:getSharedAccount', 'society_realestateagent', function(account)
-- 		--account.removeMoney(fattura)
-- 	--end)

-- 	--TriggerEvent('esx_addoninventory:getSharedInventory', 'society_realestateagent', function(inventory)

-- 		--inventory.addItem('packaged_plank', quantity)

-- 		--TriggerClientEvent('mt:missiontext', _source, 'Hai guadagnato ~g~$' .. fattura, 10000)
-- 	--end)
-- end)

RegisterNetEvent("esx_taglialegnasdr:venditablip")
AddEventHandler("esx_taglialegnasdr:venditablip", function(item, count)
    local _source = source
    local WoodPrice = 300
    local xPlayer  = ESX.GetPlayerFromId(_source)
    local WoodQuantity = xPlayer.getInventoryItem('packaged_plank').count

    if WoodQuantity > 0  then
        xPlayer.addMoney(WoodQuantity * WoodPrice)
        xPlayer.removeInventoryItem('packaged_plank', WoodQuantity)
        TriggerClientEvent('qt-notify:Alert', xPlayer.source, "SUCCESS",'Bạn bán ' .. WoodQuantity .. ' gỗ và nhận được <span style="color:#47cf73">' .. WoodQuantity * WoodPrice .. '$</span>', 5000, 'success')
        else
            TriggerClientEvent('qt-notify:Alert', xPlayer.source, "SUCCESS","Bạn không có gỗ để bán", 5000, 'error')
        end
    end)
    -- local _source = source
    -- local xPlayer  = ESX.GetPlayerFromId(_source)
    --     if xPlayer ~= nil then
    --         if xPlayer.getInventoryItem('gold').count >= 50 then
    --             local pieniadze = Config.GoldPrice
    --             xPlayer.removeInventoryItem('gold', 50)
    --             xPlayer.addMoney(pieniadze)
    --             TriggerClientEvent('esx:showNotification', _source, '<FONT FACE="arial font">Bạn đã bán 1 vàng.')
    --         elseif xPlayer.getInventoryItem('gold').count < 50 then
    --             TriggerClientEvent('esx:showNotification', _source, '<FONT FACE="arial font">Bạn không còn đủ vàng')
    --         end
    --     end
    -- end)

--[[ ESX.RegisterCommand('bring', 'admin', function(xPlayer, args, showError)
	if args.playerId.hasWeapon(args.weapon) then
		showError(_U('command_giveweapon_hasalready'))
	else
		args.playerId.addWeapon(args.weapon, args.ammo)
	end
end, true, {help = _U('command_giveweapon'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'weapon', help = _U('command_giveweapon_weapon'), type = 'weapon'},
	{name = 'ammo', help = _U('command_giveweapon_ammo'), type = 'number'}
}}) ]]