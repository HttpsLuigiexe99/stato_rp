
local ColorDo = Config.ColorDo
local bgcolorme = Config.BgColorMe
local bgcolordo	= Config.BgColorDo
local bgdo = Config.BackgroundDo
local ChatOn = Config.ChatMsg
local time = Config.ChatDelay

local nbrDisplaying = 1
local dropShadow = false


local lastCommandTime = 0
local cooldownTime = 180000 -- 180 secondi di cooldown (3 minuti)

RegisterCommand('stato', function(source, args)
   
    TriggerEvent('pnpNotify:send', '<b><span style="color: #33ff00;">Notifica</span></b> </br>Hai impostato lo stato aspetta 3m per ricambiarlo nuovamente')
    local isme = false
    local text = '['
    for i = 1, #args do
        text = text .. 'stato: ' .. args[i]
    end
    text = text .. ' ]'
    print 'Tiger Development on top'

    local currentTime = GetGameTimer()

    if currentTime - lastCommandTime >= cooldownTime then
        lastCommandTime = currentTime
        isme = false
        TriggerServerEvent('TIGER:shareDisplay', text, isme)
    end
       
end)

RegisterNetEvent('TIGER:triggerDisplay')
AddEventHandler('TIGER:triggerDisplay', function(text, source, isme)
    local offset = 1 + (nbrDisplaying*0.14)
    Display(GetPlayerFromServerId(source), text, offset, isme)
end)

function Display(mePlayer, text, offset, isme)
	local displaying = true

	Citizen.CreateThread(function()
		Wait(time)
		displaying = false
    end)
	
	Citizen.CreateThread(function()
        nbrDisplaying = nbrDisplaying + 1
        print(nbrDisplaying)
        while displaying do
            Wait(0)
            local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist2(coordsMe, coords)
            if dist < 2500 then
                DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z'], text, isme, -0.12) 
            end
        end
        nbrDisplaying = nbrDisplaying - 1
    end)
	
end

function DrawText3D(x,y,z, text, isme)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = ((1/dist)*2)*(1/GetGameplayCamFov())*100

    if onScreen then

		if isme then
		SetTextColour(ColorMe.r, ColorMe.g, ColorMe.b, ColorMe.a)
		else
		SetTextColour(ColorDo.r, ColorDo.g, ColorDo.b, ColorDo.a)
		end
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextCentre(true)
        if dropShadow then
            SetTextDropshadow(10, 100, 100, 100, 255)
        end

       
        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local height = GetTextScaleHeight(0.55*scale, font)
        local width = EndTextCommandGetWidth(font)

        
        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)
         
        if bgme and isme then
            DrawRect(_x, _y+scale/45, width, height, bgcolorme.r, bgcolorme.g, bgcolorme.b , bgcolorme.a)
        end
		if bgdo and not isme then
            DrawRect(_x, _y+scale/45, width, height, bgcolordo.r, bgcolordo.g, bgcolordo.b , bgcolordo.a)
        end
    end
end

