local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["-"] = 84,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }
  
CreateThread(function()
    while true do
	Wait(0);
        local ped = PlayerPedId();
        if (IsControlJustReleased(0, Keys["F9"])) then
            if (IsPedInAnyVehicle(ped)) then
                ESX.TriggerServerCallback('DM_SoundMenu:GetJob', function(job)
                    for u = 1, #CONFIG.Jobs do
                        for o = 1, #CONFIG.Vehicles do
                            if (job == CONFIG.Jobs[u]) then
                                if (IsVehicleModel(GetVehiclePedIsIn(ped),GetHashKey(CONFIG.Vehicles[o]))) then
                                    OpenSoundMenu(job);
                                else
                                   ESX.ShowNotification('~r~In Mashin Dar List Mashin Haye Bolandgu Dar Nist!')
                                end;
                            end;
                        end;
                    end;
		        end);
            end;
        end;
    end;
end);


OpenSoundMenu = function(job)
    ESX.UI.Menu.CloseAll();
    local menus = CONFIG.SoundMenu;
    local dm = {};
    for m = 1, #menus do
        table.insert(dm,{label = menus[m].name, value = menus[m].soundFile});
        ESX.UI.Menu.Open('default',GetCurrentResourceName(),'sound_menu',{
            title = 'Warning Sounds',
            align = 'top-left',
            elements = dm,
        },function(d,m)
            TriggerServerEvent('DM_SoundMenu:StartSoundInDistance',100,d.current.value,6.0);
        end,function(d,m)
            m.close();
        end);
    end;
end;

RegisterNetEvent('DM_SoundMenu:StatringClientSound')
AddEventHandler('DM_SoundMenu:StatringClientSound', function(playerNetId, maxDistance, soundFile, soundVolume)
    local lCoords = GetEntityCoords(GetPlayerPed(-1));
    local eCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerNetId)));
    local distIs  = Vdist(lCoords.x, lCoords.y, lCoords.z, eCoords.x, eCoords.y, eCoords.z);
    if (distIs <= maxDistance) then
        SendNUIMessage({
            transactionType     = 'playSound',
            transactionFile     = soundFile,
            transactionVolume   = soundVolume
        });
    end
end)