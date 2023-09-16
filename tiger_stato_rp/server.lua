RegisterServerEvent('TIGER:shareDisplay')
AddEventHandler('TIGER:shareDisplay', function(text, isme)
	TriggerClientEvent('TIGER:triggerDisplay', -1, text, source, isme)
end)