
ESX.RegisterServerCallback('DM_SoundMenu:GetJob', function(src, callback)
    local dXp = ESX.GetPlayerFromId(src);
    callback(dXp.job.name);
end);

RegisterServerEvent('DM_SoundMenu:StartSoundInDistance')
AddEventHandler('DM_SoundMenu:StartSoundInDistance', function(maxDistance, soundFile, soundVolume)
    TriggerClientEvent('DM_SoundMenu:StatringClientSound', -1, source, maxDistance, soundFile, soundVolume);
end);
