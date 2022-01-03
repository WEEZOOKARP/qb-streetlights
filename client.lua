local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    while true do
        Wait(3000)
        local objects = QBCore.Functions.GetObjects()
        for k,v in pairs(objects) do
            local health = GetEntityHealth(v)

            if health < 1000 then
                if IsEntityAnObject(v) then
                    SetEntityAsMissionEntity(v, true, true)
                    DeleteEntity(v)
                end
            end
        end
    end
end)