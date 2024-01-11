function ServerDisplayNotification(src, msg, type)
    TriggerClientEvent('okokNotify:Alert', src, msg, '', 5000, type)
end