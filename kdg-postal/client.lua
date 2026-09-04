local postals = {}

CreateThread(function()
    local postalData = LoadResourceFile(GetCurrentResourceName(), 'postals.json')

    if not postalData then
        print('^1[postal] ERROR: Could not load postals.json^0')
        return
    end

    local data = json.decode(postalData)

    if not data then
        print('^1[postal] ERROR: Could not decode postals.json^0')
        return
    end

    for _, postal in ipairs(data) do
        postals[tostring(postal.code)] = {
            x = postal.x,
            y = postal.y
        }
    end

    print(('^2[postal] Loaded %s postal codes^0'):format(#data))
end)

RegisterCommand('postal', function(source, args)
    local postal = args[1]

    if not postal then
        TriggerEvent('chat:addMessage', {
            args = {
                '^1Postal',
                'Usage: /postal [postal]'
            }
        })
        return
    end

    postal = tostring(postal)

    local location = postals[postal]

    if not location then
        TriggerEvent('chat:addMessage', {
            args = {
                '^1Postal',
                ('Postal %s does not exist.'):format(postal)
            }
        })
        return
    end

    SetNewWaypoint(location.x, location.y)

    TriggerEvent('chat:addMessage', {
        args = {
            '^2Postal',
            ('GPS set to postal %s.'):format(postal)
        }
    })
end, false)