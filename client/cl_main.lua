local QBCore = exports['qb-core']:GetCoreObject()
local spawnedSigns = {}
local spawningSign = false
local spawningObject = false
local usingUi = false
local indicator = false
local PlayerData = QBCore.Functions.GetPlayerData() or {}
local hasDarrkIndicator = false

-- Functions
local function ShowUi(content)
    if content?.type and content?.text then
        SendNUIMessage({
            action = "Show",
            content = content
        })
        usingUi = true
    end
end

local function HideUI()
    SendNUIMessage({
        action = "Hide"
    })
    usingUi = false
end

local function UpdateContent(sign, index)
    local input = lib.inputDialog('Update Sign Content', {
        {type = "select", label = "Type", options = {
            {label = "Paragraph", value = "Paragraph"},
            {label = "Image", value = "Image"}
        }, required = true, default = sign.content?.type},
        {type = 'textarea', label = 'Text / Url', autosize = true, required = true, default = sign.content?.text, max = 21},
    })
    if input and input[1] and input[2] then
        local updated = lib.callback.await("darrk-signs/server/updateSignContent", false, index, input[1], input[2])
        if updated then
            QBCore.Functions.Notify("Content updated succusfully!", "success")
        else
            QBCore.Functions.Notify("Something Weird happned! Try again later", "error")
        end
    else
        QBCore.Functions.Notify("Canceled!", "error")
    end
end

local function SpawnSigns(signs)
    if usingUi then HideUI() end
    for i = 1, #signs do
        spawnedSigns[i] = {}
        local sign = signs[i]
        spawnedSigns[i].zone = lib.zones.sphere({
            coords = vec3(sign.coords.x,sign.coords.y,sign.coords.z),
            radius = 50,
            debug = false,
            onEnter = function ()
                lib.requestModel(sign.prop)
                spawnedSigns[i].prop = CreateObject(sign.prop, sign.coords.x, sign.coords.y, sign.coords.z - 1, false, true, false)
                SetEntityHeading(spawnedSigns[i].prop, sign.coords.w)
                SetEntityInvincible(spawnedSigns[i].prop, true)

                exports['qb-target']:AddTargetEntity(spawnedSigns[i].prop, {
                    options = {
                        {
                            icon = "fas fa-pen-fancy",
                            label = "Update Content",
                            action = function()
                                UpdateContent(sign, i)
                            end,
                            canInteract = function()
                                return sign.owner == PlayerData?.citizenid
                            end
                        }, { 
                            icon = "fas fa-ban",
                            label = "Remove Sign",
                            action = function()
                                local removed = lib.callback.await("darrk-signs/server/removeSign", false, i)
                                if removed then
                                    QBCore.Functions.Notify("Removed!", "success")
                                    if hasDarrkIndicator then
                                        if indicator then
                                            exports['darrk-indicator']:DestroyIndicator("darrk-signs")
                                            indicator = false
                                        end
                                    end
                                else
                                    QBCore.Functions.Notify("Sign Is removed Already!", "error")
                                    if spawnedSigns[i].prop and DoesEntityExist(spawnedSigns[i].prop) then
                                        DeleteEntity(spawnedSigns[i].prop)
                                    end
                                    spawnedSigns[i].zone:remove()
                                    spawnedSigns[i].smallzone:remove()
                                    if hasDarrkIndicator then
                                        if indicator then
                                            exports['darrk-indicator']:DestroyIndicator("darrk-signs")
                                            indicator = false
                                        end
                                    end
                                end
                            end,
                            canInteract = function()
                                return sign.owner == PlayerData?.citizenid
                            end
                        }
                    }
                })

            end,
            onExit = function ()
                if spawnedSigns[i].prop and DoesEntityExist(spawnedSigns[i].prop) then
                    DeleteEntity(spawnedSigns[i].prop)
                    spawnedSigns[i].prop = nil
                end
            end
        })

        spawnedSigns[i].smallzone = lib.zones.sphere({
            coords = vec3(sign.coords.x,sign.coords.y,sign.coords.z),
            radius = 2.5,
            debug = false,
            onEnter = function ()
                ShowUi(sign.content)
                if hasDarrkIndicator then
                    if not indicator then
                        exports['darrk-indicator']:CreateIndicator("darrk-signs", "coords", vec3(sign.coords.x,sign.coords.y,sign.coords.z - 0.5))
                        indicator = true
                    end
                end
            end,
            onExit = function ()
                HideUI()

                if hasDarrkIndicator then
                    if indicator then
                        exports['darrk-indicator']:DestroyIndicator("darrk-signs")
                        indicator = false
                    end
                end
            end
        })
    end
end

local function DestroySigns()
    for i = 1, #spawnedSigns do
        local sign = spawnedSigns[i]
        sign.zone:remove()
        sign.smallzone:remove()
        if sign.prop and DoesEntityExist(sign.prop) then
            DeleteEntity(sign.prop)
        end

        spawnedSigns[i] = nil

        lib.print.info("Sign "..i.." Destroyed")
    end
end

-- Net Events
RegisterNetEvent("darrk-signs/client/setupSign", function(item, prop, slot, zPlus)
    local playerCoords = GetEntityCoords(cache.ped)
    local hit, entityHit, endCoords
    local rotation = 0.0
    local rotationSpeed = 2.0
    spawningSign = not spawningSign
    if not spawningSign then
        if spawningObject and DoesEntityExist(spawningObject) then
            DeleteEntity(spawningObject)
            spawningObject = nil
        end
    end

    if spawningSign then
        hit, entityHit, endCoords = lib.raycast.cam(false, false, Shared.SpawnDistance)
        lib.requestModel(prop)
        spawningObject = CreateObject(prop, endCoords.x, endCoords.y, playerCoords.z - zPlus, false, true, false)
        SetEntityCollision(spawningObject, false, false)
        SetEntityAlpha(spawningObject, 500, true)
        SetEntityDrawOutline(spawningObject, true)
        SetEntityDrawOutlineColor(214, 45, 45, 10)
    end

    Citizen.CreateThread(function()
        while spawningSign do
            playerCoords = GetEntityCoords(cache.ped)
            hit, entityHit, endCoords = lib.raycast.cam(false, false, Shared.SpawnDistance)

            if IsControlPressed(0, 15) then
                rotation -= rotationSpeed 
            end
    
            if IsControlPressed(0, 43) then
                rotation += rotationSpeed
            end
    
            if rotation >= 360 then
                rotation = 0.0
            elseif rotation < 0.0 then
                rotation = 359.0
            end

            if hit == 1 then
                SetEntityCoords(spawningObject, endCoords.x, endCoords.y, playerCoords.z -  zPlus)
                SetEntityRotation(spawningObject, 0.0, 0.0, rotation, 1, true)
                SetEntityDrawOutlineColor(102, 255, 179, 10)

                
                if IsControlJustPressed(0, 38) then
                    lib.print.info("Place Sign")
                    spawningSign = false
                    DeleteEntity(spawningObject)
                    spawningObject = false
                    TriggerServerEvent('darrk-signs/server/saveSign', item, slot, prop, vector4(endCoords.x, endCoords.y, playerCoords.z, rotation))
                end
            else
                SetEntityDrawOutlineColor(214, 45, 45, 10)
            end
            Citizen.Wait(0)
        end
    end)
end)

RegisterNetEvent("darrk-signs/client/updateSigns", function (signs)
    DestroySigns()
    lib.print.info("Destroyed All Signs!")
    SpawnSigns(signs)
end)

-- Threads
CreateThread(function()
    while not LocalPlayer.state['isLoggedIn'] do
        Wait(500)
    end

    local signs = lib.callback.await("darrk-signs/server/getSigns")
    SpawnSigns(signs)

    hasDarrkIndicator = GetResourceState("darrk-indicator") == "started"
end)

-- Handlers
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(GangInfo)
    PlayerData.gang = GangInfo
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
end)

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
        DestroySigns()
        if spawningObject or spawningSign and DoesEntityExist(spawningObject) then
            DeleteEntity(spawningObject)
            spawningObject = nil
        end

        if hasDarrkIndicator then
            if indicator then
                exports['darrk-indicator']:DestroyIndicator("darrk-signs")
                indicator = false
            end
        end
   end
end)