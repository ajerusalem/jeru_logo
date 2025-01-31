local displayLogo = true -- Logo varsayılan olarak görünsün.
local allowToggle = true -- ESC tuşu ile açıp kapatmaya izin verilmiyor.

RegisterCommand("togglelogo", function()
    allowToggle = not allowToggle -- ESC tuşu ile açıp kapatmaya izin ver.
    displayLogo = allowToggle -- Komut kullanıldığında logoyu aç/kapat.
    SendNUIMessage({
        type = "toggle",
        status = displayLogo,
        action = displayLogo and "show" or "hide"
    })
end, false)

-- ESC tuşuna basıldığında logoyu kapat
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if allowToggle and IsControlJustPressed(0, 322) then -- 322 = ESC tuşu
            displayLogo = false
            SendNUIMessage({
                type = "toggle",
                status = displayLogo,
                action = "hide"
            })
        end
    end
end)

-- ESC menüsü kapandığında logoyu aç
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if allowToggle and not IsPauseMenuActive() and not displayLogo then
            Citizen.Wait(500) -- Küçük bir gecikme ekleyelim
            if not IsPauseMenuActive() then -- Menü hala kapalıysa
                displayLogo = true
                SendNUIMessage({
                    type = "toggle",
                    status = displayLogo,
                    action = "show"
                })
            end
        end
    end
end)