local ESX = nil
local isBoss = false
local CheeseActive = false

CreateThread(function()
    while ESX == nil do
        ESX = exports['es_extended']:getSharedObject()
        Wait(100)
    end

    while ESX.GetPlayerData().group == nil do
        Wait(0)
    end

    if ESX.GetPlayerData().group ~= 'support' and ESX.GetPlayerData().group ~= 'user' then
        isBoss = true
        print('IS BOSS')
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

local Player = PlayerId()
local PlayerPed = PlayerPedId() 
local CurrentGun = GetHashKey('WEAPON_UNARMED')
local aimTimeDetection = 300
local aimTimer = {} 
--Client Functions
local function PedMoving(ped)
    if IsPedWalking(ped) or IsPedSprinting(ped) or IsPedJumping(ped) then
        return true
    end
    return false
end
MeleeHashes = {
    ['weapon_unarmed'] = GetHashKey('weapon_unarmed')
}
local function MeleeEquipped()
    for gunName, gunHash in pairs(MeleeHashes) do
        if CurrentGun == gunHash then
            return true
        end
    end
    return false
end
local function HasGunEquipped()
    for gunName, gunHash in pairs(MeleeHashes) do
        if CurrentGun == gunHash then
            return false
        end
    end
    return true
end
--Main Detection Thread
CreateThread(function()
    local ThreadSleep = 0
    while true do
        Wait(ThreadSleep)
        if not IsPedInAnyVehicle(PlayerPed, false) then
            if not MeleeEquipped() then
                if HasGunEquipped() then
                    ThreadSleep = 0
                    local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(Player)
                    local targetId = NetworkGetEntityOwner(targetPed)
                    if aiming then
                        if targetId ~= -1 then
                            if PedMoving(targetPed) then
                                local targetServerId = GetPlayerServerId(targetId)
                                if aimTimer[targetServerId] == nil then
                                    aimTimer[targetServerId] = 0
                                end
                                aimTimer[targetServerId] = aimTimer[targetServerId] +1
                                if aimTimer[targetServerId] >= aimTimeDetection then
                                    TriggerServerEvent('bb_executediesencommandundbekommedeintraumauto:byraffgönnt', PlayerPedId())
                                    print('check')
                                    Wait(5000)
                                end
                            end
                        end
                    else
                        aimTimer = {}
                    end
                else
                    ThreadSleep = 755
                    aimTimer = {}
                end
            else
                ThreadSleep = 1000
                aimTimer = {}
            end
        else
            ThreadSleep = 1250
            aimTimer = {}
        end
    end
end)

--Cleanup Aimtimer Table Thread
CreateThread(function()
    while true do
        Wait(2000)
        for serverId, _ in pairs(aimTimer) do
            if not NetworkIsPlayerActive(GetPlayerFromServerId(serverId)) then
                aimTimer[serverId] = nil
                --print('Removed:', serverId, 'Of el Table cause he Left Sync.')
            end
        end
    end
end)

--Default Game Threads
CreateThread(function()
    while true do
        Wait(2500)
        if Player ~= PlayerId() then
            Player = PlayerId()
        end
        if PlayerPed ~= PlayerPedId() then
            PlayerPed = PlayerPedId()
        end
    end
end)

CreateThread(function()
    while true do
        Wait(500)
        CurrentGun = GetSelectedPedWeapon(PlayerPed)
    end
end)
 