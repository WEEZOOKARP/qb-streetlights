local QBCore = exports['qb-core']:GetCoreObject()

whitelistItems = whitelistItems or {}

whitelistItems = {
    `prop_traffic_01a`,
    `prop_traffic_01b`,
    `prop_traffic_01d`,
    `prop_traffic_02a`,
    `prop_traffic_02b`,
    `prop_traffic_03a`,
    `prop_traffic_lightset_01`,
    `prop_streetlight_03`,
    `prop_streetlight_03b`,
    `prop_streetlight_03c`,
    `prop_streetlight_03d`,
    `prop_streetlight_04`,
    `prop_streetlight_11c`
}

local item = "light_controller"

local trafficLights = {
    `prop_traffic_01a`,
    `prop_traffic_01b`,
    `prop_traffic_01d`,
    `prop_traffic_02a`,
    `prop_traffic_02b`,
    `prop_traffic_03a`,
    `prop_traffic_lightset_01`
}

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

CreateThread(function()
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
end)

local function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

local function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
	return b, c, e
end

local color = {r = 255, g = 255, b = 255, a = 200}


CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        local class = GetVehicleClass(vehicle)
        local position = GetEntityCoords(ped)
        local speed = GetEntitySpeed(vehicle)
        if class == 18 and (speed < 2) and PlayerJob.name == "police" and IsControlPressed(0, 47) then
            local hit, coords, entity = RayCastGamePlayCamera(300.0)
            DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
            if hit and IsEntityAnObject(entity) then
                for k,v in pairs(trafficLights) do
                    if v == GetEntityModel(entity) then
                        local health = GetEntityHealth(entity)
                        if health == 1000 then
                            SetEntityTrafficlightOverride(entity, 0)
                            Wait(10000)
                            SetEntityTrafficlightOverride(entity, 3)
                        end
                    end
                end
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(2000)
        local objects = QBCore.Functions.GetObjects()

        for k,v in pairs(objects) do
            local health = GetEntityHealth(v)

            if health < 1000 then
                for _,item in pairs(whitelistItems) do
                    local model = GetEntityModel(v)
                    if model == item then
                        SetEntityAsMissionEntity(v, true, true)
                        DeleteEntity(v)
                    end
                end
            end
        end
    end
end)
