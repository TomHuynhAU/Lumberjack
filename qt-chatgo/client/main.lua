local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData              = {}
local iniziato = false
local statagliando = false
local JobBlips = {}
local assi = false
local inservizio = false
local firstspawn = false
ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	refreshBlips()
end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	refreshBlips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	deleteBlips()
	refreshBlips()
	
	Citizen.Wait(5000)
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	PlayerData.job2 = job2
	deleteBlips()
	refreshBlips()
	
	Citizen.Wait(5000)
end)

function deleteBlips()
	if JobBlips[1] ~= nil then
		for i=1, #JobBlips, 1 do
			RemoveBlip(JobBlips[i])
			JobBlips[i] = nil
		end
	end
end

function animazione()
	local ped = PlayerPedId()

	RequestAnimDict("melee@hatchet@streamed_core")
	while (not HasAnimDictLoaded("melee@hatchet@streamed_core")) do Citizen.Wait(0) end
	Wait(1500)

	TaskPlayAnim(ped, "melee@hatchet@streamed_core", "plyr_front_takedown", 8.0, -8.0, -1, 0, 0, true, true, true) 
end

function animazione2()
	local ped = PlayerPedId()

	RequestAnimDict("melee@hatchet@streamed_core")
	while (not HasAnimDictLoaded("melee@hatchet@streamed_core")) do Citizen.Wait(0) end
	Wait(1500)

	TaskPlayAnim(ped, "melee@hatchet@streamed_core", "plyr_front_takedown_b", 8.0, -8.0, -1, 0, 0, false, false, false) 
end

function animazionetavole()
	local ped = PlayerPedId()
	local prop_name = prop_name or 'prop_cs_cardbox_01'
	tavola = CreateObject(GetHashKey(prop_name), -501.38, 5280.53, 79.61, true, true, true)

	RequestAnimDict("anim@heists@box_carry@")
	while (not HasAnimDictLoaded("anim@heists@box_carry@")) do Citizen.Wait(0) end
	Wait(1500)

	TaskPlayAnim(ped, "anim@heists@box_carry@", "idle", 8.0, -8.0, -1, 0, 0, false, false, false)
	AttachEntityToEntity(tavola, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), 0.0, -0.03, 0.0, 5.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1) 
	Wait(5000)
	TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, false)
	DetachEntity(tavola, false, false)
	PlaceObjectOnGroundProperly(tavola)
	Wait(15000)
	DeleteEntity(tavola)
	ClearPedTasksImmediately(PlayerPedId())
end

tagliato = false
tagliato2 = false
tagliato3 = false
tagliato4 = false
tagliato5 = false
tagliato6 = false
tagliato7 = false
tagliato8 = false
tagliato9 = false
tagliato10 = false

function armadietto()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	{
		title    = 'Phòng Thay Đồ',
		align    = 'bottom-right',
		elements = {
			{label = 'Quần áo làm việc',     value = 'job_wear'},
			{label = 'Quần áo hàng ngày', value = 'citizen_wear'}
		}
	}, function(data, menu)
		if data.current.value == 'citizen_wear' then
			inservizio = false
			refreshBlips()
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'job_wear' then
			inservizio = true
			if PlayerData.job.name == 'lumberjack' or PlayerData.job2.name == 'lumberjack' then
				TriggerEvent('skinchanger:getSkin', function(skin)
  
					if skin.sex == 0 then
			
					  local clothesSkin = {
						['tshirt_1'] = 0, ['tshirt_2'] = 0, 
						['torso_1'] = 0, ['torso_2'] = 1,
						['decals_1'] = 0, ['decals_2'] = 0,
						['arms'] = 0,
						['pants_1'] = 47, ['pants_2'] = 1,
						['shoes_1'] = 54, ['shoes_2'] = 0
					  }
					  TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
					end
				end)
				-- TriggerEvent('lr_gang:client:notify', "info", 'Bạn đã bắt đầu ca làm việc của mình! Bây giờ bạn có thể đi xe tải của công ty.', 3000)
				refreshBlips()
			end
		end

		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

Citizen.CreateThread(function()
	while true do

		Citizen.Wait(1)

		if PlayerData.job ~= nil and (PlayerData.job.name == 'lumberjack') then

			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			
			if GetDistanceBetweenCoords(coords, -552.3, 5348.43, 74.74, true) < 15.0 then
			    DrawMarker(20, -552.3, 5348.43, 74.74, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 0, 255, 0, 100, false, true, 2, false, false, false, false)
				if GetDistanceBetweenCoords(coords, -552.3, 5348.43, 74.74, true) < 1.75 then
					drawTxt('~b~Nhấn ~g~[E]~b~ để tương tác với tủ quần áo')
					if IsControlJustReleased(1, 51) then
						armadietto()
					end
			    end
		    end
		
		end
	end
end)




Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		local pos = GetEntityCoords(playerPed, true)
		if PlayerData.job ~= nil and (PlayerData.job.name == 'lumberjack') then
			if (GetDistanceBetweenCoords(pos, -554.42, 5370.554, 70.317) < 15.0) and not statagliando and not iniziato and inservizio then
				DrawMarker(12, -554.42, 5370.554, 70.317, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 0, 255, 0, 150, 0, true, 2, 0, 0, 0, 0)
				if (GetDistanceBetweenCoords(pos, -554.42, 5370.554, 70.317) < 0.75) then
					drawTxt('~b~Nhấn ~g~[E]~b~ để chặt gỗ')
					if IsControlJustReleased(0, Keys['E']) then
						statagliando = true
						TriggerEvent("progressbar:client:progress", {
							name = "occupation",
							duration = 30000,
							label = 'đang chặt gỗ',
							useWhileDead = false,
							canCancel = true,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							},
							--[[ animation = {
								animDict = "missheistdockssetup1clipboard@idle_a",
								anim = "idle_a",
							},
							prop = {
								model = "",
							} ]]
						}, function(status)
							if not status then 
								
							end
						end)
						ESX.TriggerServerCallback('qt-ambulancejob:getItemAmount', function(quantity)
							if quantity <= 250 then
						        ESX.TriggerServerCallback('qt-ambulancejob:getItemAmount', function(quantity)
									if quantity >= 5 then
										ESX.TriggerServerCallback('qt-ambulancejob:getItemAmount', function(quantity)
											local futuroinventario2 = math.floor(quantity + 10)
											if futuroinventario2 <= 250 then
											  --statagliando = true
										      SetEntityCoords(GetPlayerPed(-1), -554.42, 5370.554, 70.317-0.95) 
							                  SetEntityHeading(GetPlayerPed(-1), 256.706)
										      GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"),0, true, true)
										      FreezeEntityPosition(playerPed, true)
										      animazione()
						                      Wait(500)
						                      animazione()
						                      Wait(500)
						                      animazione()
										      Wait(500)
										      animazione()
						                      Wait(500)
						                      animazione()
											  Wait(500)
											  animazione()
											  Wait(500)
											  animazione()
											  Wait(500)
											  animazione()
											  Wait(500)
											  animazione()
											  Wait(500)
											  animazione()
											  Wait(500)
											  animazione()
											  Wait(500)
											  animazione()
											  Wait(500)
											  animazione()
											  Wait(500)
											  animazione()
											  Wait(500)
											  animazione()
										      Wait(500)
										      FreezeEntityPosition(playerPed, false)
										      RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"), true, true)
											  TriggerServerEvent('esx_taglialegnasdr:segatura')
											  Wait(5000)
										      statagliando = false
									        else
											  ESX.ShowNotification("~r~Túi Đã Đầy")
											  Wait(5000)
										      statagliando = false
									        end
								        end, 'cutted_wood')
									else
										ESX.ShowNotification("~r~BẠN CẦN 10 MẢNH GỖ")
										Wait(5000)
										statagliando = false
									end
								end, 'wood')
					        else
							    ESX.ShowNotification("~r~Túi Đã Đầy")
							    Wait(5000)
							    statagliando = false
						    end
					    end, 'cutted_wood')
					end
				end
			end
		end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		local pos = GetEntityCoords(playerPed, true)
		if PlayerData.job ~= nil and (PlayerData.job.name == 'lumberjack') then
			if (GetDistanceBetweenCoords(pos, -501.38, 5280.53, 79.61) < 15.0) and not iniziato and not assi and inservizio then
				DrawMarker(13, -501.38, 5280.53, 80.61, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 0, 255, 0, 150, 0, true, 2, 0, 0, 0, 0)
				if (GetDistanceBetweenCoords(pos, -501.38, 5280.53, 79.61) < 0.75) then
					drawTxt('~b~Nhấn ~g~[E]~b~ để đóng hộp')
					if IsControlJustReleased(0, Keys['E']) then
						assi = true
						TriggerEvent("progressbar:client:progress", {
							name = "occupation",
							duration = 23000,
							label = 'đang đóng hộp',
							useWhileDead = false,
							canCancel = true,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							},
							--[[ animation = {
								animDict = "missheistdockssetup1clipboard@idle_a",
								anim = "idle_a",
							},
							prop = {
								model = "",
							} ]]
						}, function(status)
							if not status then 
								
							end
						end)
						ESX.TriggerServerCallback('qt-ambulancejob:getItemAmount', function(quantity)
							if quantity <= 250 then
								ESX.TriggerServerCallback('qt-ambulancejob:getItemAmount', function(quantity)
									if quantity >= 5 then
										ESX.TriggerServerCallback('qt-ambulancejob:getItemAmount', function(quantity)
											local futuroinventario3 = math.floor(quantity + 100)
											if futuroinventario3 <= 250 then
												--Wait(1000)
										        FreezeEntityPosition(playerPed, true)
										        --assi = true
										        SetEntityCoords(GetPlayerPed(-1), -502.158, 5280.791, 80.618-0.95) 
							                    SetEntityHeading(GetPlayerPed(-1), 248.593)
										        animazionetavole()
												TriggerServerEvent('esx_taglialegnasdr:tavole')
												Wait(5000)
										        assi = false
										        FreezeEntityPosition(playerPed, false)
									        else
												ESX.ShowNotification("~r~ Túi Đã Đầy")
												Wait(5000)
								                assi = false
									        end
								        end, 'packaged_plank')
									else
										ESX.ShowNotification("~r~Hành Động Đầy Đủ Túi Không Thể Thiếu")
										Wait(5000)
								        assi = false
									end
								end, 'cutted_wood')
					        else
								ESX.ShowNotification("~r~Túi Đã Đầy")
								Wait(5000)
								assi = false
						    end
					    end, 'packaged_plank')
					end
				end
			end
		end
		Citizen.Wait(0)
	end
end)

function piastacazzodemacchina()
	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'prendi_veicolo',
	  {
		  title    = 'Xe công ty',
		  elements = {
			  {label = 'Xe tải công ty', value = 'uno'},
		  }
	  },
	  function(data, menu)
		  local val = data.current.value
		  
			if val == 'uno' then
			menu.close()
			local vehicle = GetHashKey('MULE')
			RequestModel(vehicle)
			while not HasModelLoaded(vehicle) do
			Wait(1)
			end
			spawned_car = CreateVehicle(vehicle,1188.206, -1286.56, 35.201,86.187, true, false)
			--SetVehicleHasBeenOwnedByPlayer(spawned_car,true)
			--local id = NetworkGetNetworkIdFromEntity(spawned_car)
			--SetNetworkIdCanMigrate(id, true)
			--SetEntityInvincible(spawned_car, false)
			--SetVehicleOnGroundProperly(spawned_car)
			SetVehicleNumberPlateText(spawned_car,"LEGNA")
			ESX.ShowNotification("Bây giờ đi đến điểm trên bản đồ có tên là ~g~ CÂY ~w~ để làm việc.")
			--SetEntityAsMissionEntity(spawned_car, true, true)
			--SetModelAsNoLongerNeeded(vehicle)
			--Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(spawned_car))
		  end
	  end,
	  function(data, menu)
		  menu.close()
	  end
  )
  end

--[[ Citizen.CreateThread(function()
	while true do

		Citizen.Wait(1)

		if PlayerData.job ~= nil and (PlayerData.job.name == 'lumberjack' or PlayerData.job2.name == 'lumberjack2') then

			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			
			if GetDistanceBetweenCoords(coords, 1194.62, -1286.95, 34.12, true) < 15.0 and inservizio then
			    DrawMarker(39, 1194.62, -1286.95, 35.12, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.5, 2.5, 2.5, 0, 255, 0, 100, false, true, 2, false, false, false, false)
				if GetDistanceBetweenCoords(coords, 1194.62, -1286.95, 34.12, true) < 1.75 then
					drawTxt('~b~Nhấn ~g~[E]~b~ để lấy xe tải')
					if IsControlJustReleased(1, 51) then
						piastacazzodemacchina()
					end
			    end
		    end
		
		end
	end
end) ]]

--[[ Citizen.CreateThread(function()
	while true do

		Citizen.Wait(1)

		if PlayerData.job ~= nil and (PlayerData.job.name == 'lumberjack' or PlayerData.job2.name == 'lumberjack2') then

			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			
			if GetDistanceBetweenCoords(coords, 1216.89, -1229.23, 34.40, true) < 15.0 and inservizio then
			    DrawMarker(39, 1216.89, -1229.23, 35.40, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.5, 2.5, 2.5, 255, 0, 0, 100, false, true, 2, false, false, false, false)
				if GetDistanceBetweenCoords(coords, 1216.89, -1229.23, 34.40, true) < 1.75 then
					drawTxt('~b~Nhấn ~g~[E]~b~ để đỗ xe tải')
					if IsControlJustReleased(1, 51) then
						TriggerEvent('esx:deleteVehicle', "mule")
					end
			    end
		    end
		
		end
	end
end) ]]



function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function drawTxt(text)
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(0.32, 0.32)
	SetTextColour(0, 255, 255, 255)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.5, 0.93)
  end

function refreshBlips()
	for i = 1, #JobBlips, 1 do 
		RemoveBlip(JobBlips[i])
	end
	JobBlips = {}
	if inservizio == true then

        for k,v in pairs(Config.Zones) do
		  
		    for i = 1, #v.Pos, 1 do
		
			local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
		
			SetBlipSprite (blip, 237)
			SetBlipDisplay(blip, 4)
		    SetBlipScale  (blip, 0.65)
		    SetBlipColour (blip, 17)
		    SetBlipAsShortRange(blip, true)
		    BeginTextCommandSetBlipName("STRING")
		    AddTextComponentString(v.Pos[i].nome)
			EndTextCommandSetBlipName(blip)
			table.insert(JobBlips, blip)
		    end
		end
	else
		local blip = AddBlipForCoord(Config.Zones.Tabacchi.Pos[1].x, Config.Zones.Tabacchi.Pos[1].y, Config.Zones.Tabacchi.Pos[1].z)
		
		SetBlipSprite (blip, 237)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.65)
		SetBlipColour (blip, 17)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Zones.Tabacchi.Pos[1].nome)
		EndTextCommandSetBlipName(blip)
		table.insert(JobBlips, blip)
	end
end

------------------------------------------------------ BLIP LAVORI OFFLINE
-- blip = false

-- Citizen.CreateThread(function()
-- 	while true do
	
-- 		Citizen.Wait(1)
	
-- 			local playerPed = PlayerPedId()
-- 			local coords    = GetEntityCoords(playerPed)
-- 			if GetDistanceBetweenCoords(coords, -625.23608398438, -131.75848388672, 39.008560180664, true) < 10.0 and --[[ PlayerData.job ~= nil and (PlayerData.job.name == 'lumberjack' or PlayerData.job2.name == 'lumberjack2') and ]] not blip then
-- 					-- DrawMarker(20, -625.23608398438, -131.75848388672, 39.008560180664, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 100, 102, 100, false, true, 2, false, false, false, false)
-- 				if GetDistanceBetweenCoords(coords, -625.23608398438, -131.75848388672, 39.008560180664, true) < 1.0 then
-- 					ESX.ShowHelpNotification("Nhấn [E] để bán gỗ.")
-- 					if IsControlJustReleased(1, 51) then
-- 						blip = true
-- 						ESX.TriggerServerCallback('qt-ambulancejob:getItemAmount', function(quantity)
-- 							if quantity >= 2 then
-- 								--ESX.TriggerServerCallback('esx_taglialegnasdr:conteggioporcodio', function(CopsConnected)
-- 									--if CopsConnected == 0 then
-- 										FreezeEntityPosition(playerPed, true)
-- 										ESX.ShowNotification("ĐANG BÁN...")
-- 										Wait(5000)
-- 										FreezeEntityPosition(playerPed, false)
-- 										TriggerServerEvent('esx_taglialegnasdr:venditablip', quantity)
-- 										--TriggerServerEvent("balance:server:sellStock", "packaged_plank")
-- 										blip = false
-- 									--else
-- 										--blip = false
-- 										--ESX.ShowNotification("Ci sono già ~r~ ' .. CopsConnected .. ' ~w~ agenti immobiliari")
-- 									--end
-- 								--end)
-- 							else
-- 								blip = false
-- 								ESX.ShowNotification("Bạn không có 5 gỗ để bán")
-- 							end
-- 						end, 'packaged_plank')
-- 					end
-- 				end
-- 			end
-- 	end
-- end)

local trees = {}
local spawnedTrees = 0
local isPickingUp = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.TreeField.coords, true) < 50.0 then
			SpawnTreePlants()
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.TreeField.coords, true) < 100 then

			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			local nearbyObject, nearbyID
			
			for i=1, #trees, 1 do
				DrawMarker(6, GetEntityCoords(trees[i]) + vector3(0.0, 0.0, 8.0), 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 0, 0, 100, false, true, 2, nil, nil, false)		
				if GetDistanceBetweenCoords(coords, GetEntityCoords(trees[i]), false) < 1 then
					nearbyObject, nearbyID = trees[i], i
				end
			end



			if nearbyObject and IsPedOnFoot(playerPed) then
				if not isPickingUp then
					ESX.ShowHelpNotification("~b~Nhấn~g~ [E] ~b~để chặt cây")
				end

				if IsControlJustReleased(0, 38) and not isPickingUp then
					isPickingUp = true
					TriggerEvent("progressbar:client:progress", {
						name = "occupation",
						duration = 13000,
						label = 'đang chặt cây',
						useWhileDead = false,
						canCancel = true,
						controlDisables = {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						},
						--[[ animation = {
							animDict = "missheistdockssetup1clipboard@idle_a",
							anim = "idle_a",
						},
						prop = {
							model = "",
						} ]]
					}, function(status)
						if not status then 
							
						end
					end)

					ESX.TriggerServerCallback('qt-ambulancejob:getItemAmount', function(quantity)
						local randomWood = math.random(5, 5)
						if quantity + randomWood <= 250 then
							local objCoords = GetEntityCoords(nearbyObject)
							SetEntityCoords(GetPlayerPed(-1), objCoords.x - 0.9, objCoords.y, GetCoordZ(objCoords.x - 0.9, objCoords.y)) 
							SetEntityHeading(GetPlayerPed(-1), 256.945)
							FreezeEntityPosition(playerPed, true)
							GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"),0, true, true)
							tagliato10 = true 
							animazione()
							Wait(200)
							animazione()
							Wait(200)
							animazione()
							Wait(200)
							animazione()
							Wait(200)
							animazione()
							Wait(200)
							animazione2()
							Wait(2000)
							table.remove(trees, nearbyID)
							spawnedTrees = spawnedTrees - 1
							isPickingUp = false
							for i = 1, 100, 1 do 
								Wait(1)
								SetEntityRotation(nearbyObject, i/1.25, -0, 85.0, false, true)
							end
							FreezeEntityPosition(playerPed, false)
							RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"), true, true)
							ESX.Game.DeleteObject(nearbyObject)
			
							TriggerServerEvent("esx_taglialegnasdr:pickedUpTree", randomWood)
						else
							exports['qt-notify']:Alert("Hệ Thống", "Kho đồ đã đầy", 5000, 'error')
						end
					end, 'wood')
				end
			
			end
		else
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(trees) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnTreePlants()
	while spawnedTrees < 25 do
		Citizen.Wait(0)
		local weedCoords = GenerateTreeCoords()

		ESX.Game.SpawnLocalObject('Prop_Tree_Cedar_03', weedCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)
			print(json.encode(weedCoords))
			table.insert(trees, obj)
			spawnedTrees = spawnedTrees + 1
		end)
	end
end

function ValidateTreeCoord(plantCoord)
	if spawnedTrees > 0 then
		local validate = true

		for k, v in pairs(trees) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.TreeField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateTreeCoords()
	while true do
		Citizen.Wait(1)

		local weedCoordX, weedCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-90, 90)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-90, 90)

		weedCoordX = Config.CircleZones.TreeField.coords.x + modX
		weedCoordY = Config.CircleZones.TreeField.coords.y + modY

		local coordZ = GetCoordZ(weedCoordX, weedCoordY) -5.9
		local coord = vector3(weedCoordX, weedCoordY, coordZ)

		if ValidateTreeCoord(coord) then
			return coord
		end
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = { 48.0, 49.0, 50.0, 51.0, 52.0, 53.0, 54.0, 55.0, 56.0, 57.0, 58.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 43.0
end

-- Citizen.CreateThread(function()
--     local hash = GetHashKey("s_m_y_dockwork_01")

--     if not HasModelLoaded(hash) then
--         RequestModel(hash)
--         Citizen.Wait(100)
--     end

--     while not HasModelLoaded(hash) do
--         Citizen.Wait(0)
--     end

--     if firstspawn == false then
--         local npc = CreatePed(6, hash, -625.24780273438, -131.76351928711, 38.008560180664, 289.67, false, false)
--         SetEntityInvincible(npc, true)
--         FreezeEntityPosition(npc, true)
--         SetPedDiesWhenInjured(npc, false)
--         SetPedCanRagdollFromPlayerImpact(npc, false)
--         SetPedCanRagdoll(npc, false)
--         SetEntityAsMissionEntity(npc, true, true)
--         SetEntityDynamic(npc, true)
--         SetBlockingOfNonTemporaryEvents(npc, true)
--     end
-- end)

--[[ Citizen.CreateThread(function()
    Concac()
end)

function Concac()
		while true do
			Citizen.Wait(0)			
		if GetDistanceBetweenCoords( -625.24780273438, -131.76351928711, 38.008560180664, GetEntityCoords(GetPlayerPed(-1))) < 40.0 then
			Draw3DText( -625.24780273438, -131.76351928711, 38.008560180664  -0.000000200, "Người Mua Gỗ", 8, 0.1, 0.1)	
		end		
	end
end ]]

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
	local scale = (1/dist)*20
	local fov = (1/GetGameplayCamFov())*100
	local scale = scale*fov   
	SetTextScale(scaleX*scale, scaleY*scale)
	SetTextFont(fontId)
	SetTextProportional(1)
	SetTextColour(250, 250, 250, 255)		-- You can change the text color here
	SetTextDropshadow(1, 1, 1, 1, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(textInput)
	SetDrawOrigin(x,y,z+2, 0)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
   end