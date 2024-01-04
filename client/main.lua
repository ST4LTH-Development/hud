local currentValues = {
	["health"] = 0,
	["hunger"] = 0,
	["thirst"] = 0,
    ["stress"] = 0,
    ["stamina"] = 0,
    ["armor"] = 0,

    ["isInVehicle"] = false,
    ["gamePaused"] = false,

    ["vehicleSpeed"] = 0,
    ["currentGear"] = 0,
    ["currentRpm"] = 0,
    ["carHealth"] = 0,
    ["carFuel"] = 0,
    ["nitro"] = 0,

    ["hudToogle"] = true,
}

QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function ()
    while true do
        SendNUIMessage({
            type = "minimap",
            minimap = getMapPosition()
        })
        Wait(2000)
    end
end)

Citizen.CreateThread(function ()
    while true do
        time = 500
        if currentValues["hudToogle"] then
            time = 250
            local pid = PlayerId()
            local ped = PlayerPedId()

            local percentHP = GetEntityHealth(ped) / GetPedMaxHealth(ped) * 100


            currentValues["health"] = percentHP
            currentValues["armor"] = GetPedArmour(ped)
            currentValues["stamina"] = 100 - GetPlayerSprintStaminaRemaining(pid) 
            currentValues["isInVehicle"] = IsPedInAnyVehicle(ped, true)
            currentValues["gamePaused"] = ThefeedIsPaused()

            if currentValues["isInVehicle"] then
                time = 100
                local veh = GetVehiclePedIsIn(ped, true)
                currentValues["carFuel"] = GetVehicleFuelLevel(veh)
                currentValues["vehicleSpeed"] = math.floor(GetEntitySpeed(ped)*3.6)
                currentValues["currentGear"] = GetVehicleCurrentGear(veh)
                currentValues["currentRpm"] = GetVehicleCurrentRpm(veh)
                currentValues["carHealth"] = GetVehicleBodyHealth(veh)
            end

            SendNUIMessage({
                type = "Update",
                data = {
                    status = {
                        mic = NetworkIsPlayerTalking(pid),
                        health = currentValues["health"],
                        armor = currentValues["armor"],
                        hunger = currentValues["hunger"],
                        thirst = currentValues["thirst"],
                        stress = currentValues["stress"],
                        stamina = currentValues["stamina"],
                    },
                    car = {
                        speed = currentValues["vehicleSpeed"],
                        fuel = currentValues["carFuel"],
                        gear = currentValues["currentGear"],
                        rpm = currentValues["currentRpm"],
                        health = currentValues["carHealth"],
                        nitro = currentValues["nitro"],
                    },
                }
            })
        end
        Wait(time)
    end
end)

RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst)
    currentValues["hunger"] = newHunger
    currentValues["thirst"] = newThirst
end)

RegisterNetEvent('hud:client:UpdateStress', function(newStress)
    currentValues["stress"] = newStress
end)

RegisterNetEvent('hud:client:UpdateNitrous', function(_, nitroLevel, bool)
    currentValues["nitro"] = nitroLevel
end)

CreateThread(function() -- Speeding
    local speed = 3.6
    while true do
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                local speed = GetEntitySpeed(GetVehiclePedIsIn(ped, false)) * speed
                local stressSpeed = Config.MinimumSpeed
                if speed >= stressSpeed then
                    TriggerServerEvent('hud:server:GainStress', math.random(1, 1))
                end
            end
        end
        Wait(10000)
    end
end)

function IsWhitelistedWeaponStress(weapon)
    if weapon then
        for _, v in pairs(Config.WhitelistedWeaponStress) do
            if weapon == v then
                return true
            end
        end
    end
    return false
end

CreateThread(function() -- Shooting
    while true do
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)
            if weapon ~= `WEAPON_UNARMED` then
                if IsPedShooting(ped) and not IsWhitelistedWeaponStress(weapon) then
                    if math.random() < Config.StressChance then
                        TriggerServerEvent('hud:server:GainStress', math.random(1, 3))
                    end
                end
            else
                Wait(1000)
            end
        end
        Wait(8)
    end
end)

local function GetBlurIntensity(stresslevel)
    for _, v in pairs(Config.Intensity['blur']) do
        if stresslevel >= v.min and stresslevel <= v.max then
            return v.intensity
        end
    end
    return 1500
end

local function GetEffectInterval(stresslevel)
    for _, v in pairs(Config.EffectInterval) do
        if stresslevel >= v.min and stresslevel <= v.max then
            return v.timeout
        end
    end
    return 60000
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local effectInterval = GetEffectInterval(currentValues["stress"])
        if currentValues["stress"] >= 100 then
            local BlurIntensity = GetBlurIntensity(currentValues["stress"])
            local FallRepeat = math.random(2, 4)
            local RagdollTimeout = FallRepeat * 1750
            TriggerScreenblurFadeIn(1000.0)
            Wait(BlurIntensity)
            TriggerScreenblurFadeOut(1000.0)

            if not IsPedRagdoll(ped) and IsPedOnFoot(ped) and not IsPedSwimming(ped) then
                SetPedToRagdollWithFall(ped, RagdollTimeout, RagdollTimeout, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
            end

            Wait(1000)
            for _ = 1, FallRepeat, 1 do
                Wait(750)
                DoScreenFadeOut(200)
                Wait(1000)
                DoScreenFadeIn(200)
                TriggerScreenblurFadeIn(1000.0)
                Wait(BlurIntensity)
                TriggerScreenblurFadeOut(1000.0)
            end
        elseif currentValues["stress"] >= Config.MinimumStress then
            local BlurIntensity = GetBlurIntensity(currentValues["stress"])
            TriggerScreenblurFadeIn(1000.0)
            Wait(BlurIntensity)
            TriggerScreenblurFadeOut(1000.0)
        end
        Wait(effectInterval)
    end
end)

local UIHidden = false
local UIRadar = false

Citizen.CreateThread(
    function()
        while true do

            Citizen.Wait(500)
            
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped)

            if vehicle ~= 0 and UIRadar then
                SendNUIMessage(
                    {
                        type = "toggleCar",
                        toggle = true,
                    }
                )
                DisplayRadar(true)
                UIRadar = false
            elseif not UIRadar and vehicle == 0 then
                SendNUIMessage(
                    {
                        type = "toggleCar",
                        toggle = false,
                    }
                )
                UIRadar = true
                DisplayRadar(false)
            end

            
        end
    end
)

RegisterCommand(Config.Command, function ()
    OpenSettings()
end, false)

RegisterNuiCallback('close', function ()
    SetNuiFocus(false, false)
end)

RegisterNuiCallback('save', function (data)
    print(0)
    SetNuiFocus(false, false)
    SaveSettings(data)
end)

OpenSettings = function ()
    SendNUIMessage({
        type = 'Open',
    })
    SetNuiFocus(true, true)
end

LoadSettings = function ()
    local Settings = GetResourceKvpString('UIData')
    if Settings ~= nil then
        local data = json.decode(Settings)
        SendNUIMessage({
            type = 'Load',
            settings = data
        })
    end
    local defaultAspectRatio = 1920/1080 -- Don't change this.
    local resolutionX, resolutionY = GetActiveScreenResolution()
    local aspectRatio = resolutionX/resolutionY
    local minimapOffset = 0
    if aspectRatio > defaultAspectRatio then
        minimapOffset = ((defaultAspectRatio-aspectRatio)/3.6)-0.008
    end
    RequestStreamedTextureDict("squaremap", false)
    if not HasStreamedTextureDictLoaded("squaremap") then
        Wait(150)
    end
    SetMinimapClipType(0)
    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "squaremap", "radarmasksm")
    AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "squaremap", "radarmasksm")
    SetMinimapComponentPosition("minimap", "L", "B", 0.0 + minimapOffset, -0.047, 0.1638, 0.183)
    SetMinimapComponentPosition("minimap_mask", "L", "B", 0.0 + minimapOffset, 0.0, 0.128, 0.20)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.01 + minimapOffset, 0.025, 0.262, 0.300)
    SetBlipAlpha(GetNorthRadarBlip(), 0)
    SetRadarBigmapEnabled(true, false)
    SetMinimapClipType(0)
    Wait(500)
    SetRadarBigmapEnabled(false, false)
end

SaveSettings = function(data)
    SetResourceKvp('UIData', json.encode(data))
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    LoadSettings()
    SendNUIMessage(
        {
            type = "show",
        }
    )
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        Wait(5000)
        LoadSettings()
    end
end)  

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    SendNUIMessage(
        {
            type = "hide"
        }
    )
end)

function getMapPosition()
	local minimap = {}
	local resX, resY = GetActiveScreenResolution()
	local aspectRatio = GetAspectRatio()
	local scaleX = 1/resX
	local scaleY = 1/resY
	local minimapRawX, minimapRawY
	SetScriptGfxAlign(string.byte('L'), string.byte('B'))
	if IsBigmapActive() then
		minimapRawX, minimapRawY = GetScriptGfxPosition(-0.003975, 0.022 + (-0.460416666))
		minimap.width = scaleX*(resX/(2.52*aspectRatio))
		minimap.height = scaleY*(resY/(2.3374))
	else
		minimapRawX, minimapRawY = GetScriptGfxPosition(-0.0045, 0.002 + (-0.188888))
		minimap.width = scaleX*(resX/(4*aspectRatio))
		minimap.height = scaleY*(resY/(5.674))
	end
	ResetScriptGfxAlign()
	minimap.leftX = minimapRawX
	minimap.rightX = minimapRawX+minimap.width
	minimap.topY = minimapRawY
	minimap.bottomY = minimapRawY+minimap.height
	minimap.X = minimapRawX+(minimap.width/2)
	minimap.Y = minimapRawY+(minimap.height/2)
	return minimap
end