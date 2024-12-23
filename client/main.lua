local options = {}
local options2 = {}
local duty = false
lib.locale()


CreateThread(function()
  SpawnProps()
  SpawnDist()
  for i, data in pairs(Config.Picking) do
    exports.ox_target:addSphereZone({
      coords = data.pos,
      radius = data.radius,
      name = i,
      debug = data.debug,
      options = {
        label = locale("pickup"),
        icon = data.icon,
        onSelect = function(td)
          if Config.Duty.EnableDuty then
            if not duty then
              Notify(locale("notify_title"), locale("not_on_duty"), "error", 3000)
            else
              if Minigame() then
                lib.requestAnimDict(data.animation.dict)
                TaskPlayAnim(cache.ped, data.animation.dict, data.animation.set, 1.0,-1.0, -1, 1, 1, true, true, true)
                if ProgressBar(locale("picking"), data.animation.duration) then
                  ClearPedTasks(cache.ped)
                  for k, reward in pairs(data.rewards) do
                    addItem(reward.item, reward.amount, td)
                  end
                else
                  ClearPedTasks(cache.ped)
                  Notify(locale("notify_title"), locale("canceled_progress"), "error", 3000)
                end
              else
                Notify(locale("notify_title"), locale("failed_pickup"), "error", 3000)
              end
            end
          else
            if Minigame() then
              lib.requestAnimDict(data.animation.dict)
              TaskPlayAnim(cache.ped, data.animation.dict, data.animation.set, 1.0,-1.0, -1, 1, 1, true, true, true)
              if ProgressBar(locale("picking"), data.animation.duration) then
                ClearPedTasks(cache.ped)
                for k, reward in pairs(data.rewards) do
                  addItem(reward.item, reward.amount, td)
                end
              else
                ClearPedTasks(cache.ped)
                Notify(locale("notify_title"), locale("canceled_progress"), "error", 3000)
              end
            else
              Notify(locale("notify_title"), locale("failed_pickup"), "error", 3000)
            end
          end
        end
      },
      distance = 3
    })
  end
end)


CreateThread(function()
  for p, d in pairs(Config.Duty.Zones) do
    lib.requestModel(d.model)
    dutyPed = CreatePed(4, d.model, d.pos.x, d.pos.y, d.pos.z, d.pos.w, false, true)
    SetEntityAsMissionEntity(dutyPed, true, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)

    exports.ox_target:addLocalEntity(dutyPed,{
      label = locale("target_duty"),
      name = "spf_vineyard:duty",
      icon = d.targetIcon,
      onSelect = function()
        if Config.Duty.EnableDuty then
          if not duty then
            lib.registerContext({
              id = 'spf_vineyard:dutym',
              title = locale("duty_title"),
              options = {
                {
                  title = locale("go_on_duty"),
                  icon = d.menuIcon,
                  onSelect = function()
                    Notify(locale("notify_title"), locale("you_are_on_duty"), "success", 3000)
                    duty = true
                  end,
                },
              }
            })
            lib.showContext("spf_vineyard:dutym")
          else
            lib.registerContext({
              id = 'spf_vineyard:dutyoff',
              title = locale("duty_title"),
              options = {
                {
                  title = locale("go_off_duty"),
                  icon = d.menuIcon,
                  onSelect = function()
                    Notify(locale("notify_title"), locale("you_are_off_duty"), "error", 3000)
                    duty = false
                  end,
                },
              }
            })
            lib.showContext("spf_vineyard:dutyoff")
          end
        else
          -- ked neni duty enabled
        end
      end
    })
  end
end)



function SpawnDist()
  for i, ferm in pairs(Config.Fermentation) do
    if ferm.enableModel then
      lib.requestModel(ferm.model)
      prop = CreateObject(ferm.model, ferm.modelCoords.x, ferm.modelCoords.y, ferm.modelCoords.z, false, true, false)
      SetEntityHeading(prop, ferm.modelCoords.w)
      FreezeEntityPosition(prop, true)
      exports.ox_target:addLocalEntity(prop, {
        label = locale("fermentation"),
        icon = "fas fa-wine-bottle",
        onSelect = function()
          for k, ajtems in pairs(ferm.items) do
            table.insert(options2, {
              title = ajtems.label,
              icon = "fas fa-wine-glass",
              args = {
                  item = ajtems.item,
              },
              description = "You need "..ajtems.requiredMust.." "..ajtems.requiredItemLabel,
              onSelect = function()
                lib.callback('spf_vineyard:hasItem', false, function(has)
                  if has then
                    if ProgressBar(locale("treading"), ferm.duration) then
                      local td = { coords = vec3(ferm.modelCoords.x, ferm.modelCoords.y, ferm.modelCoords.z)}
                      lib.callback('spf_vineyard:removeItem', false, function(bool)
                        if bool then
                        end
                      end, ajtems.requiredItem, ajtems.requiredMust)
                      addItem(ajtems.item, ajtems.rewardAmount, td)
                    else
                      Notify(locale("notify_title"), locale("canceled_progress"), "error", 3000)
                    end
                  else
                    Notify(locale("notify_title"), locale("no_required_items"), "error", 4000)
                  end
                end, ajtems.requiredItem, ajtems.requiredMust)
              end
          }) 
          lib.registerContext({
            id = 'ferm',
            title = locale("ferm_menu"),
            options = options2
          })
          lib.showContext("ferm")
          options2 = {}
          end
        end
      })
    end
  end
end


function SpawnProps()
  for i, data in pairs(Config.Processing) do
    lib.requestModel(data.model)
    props = CreateObject(data.model, data.modelCoords.x, data.modelCoords.y, data.modelCoords.z, false, true, false)
    SetEntityHeading(props, data.modelCoords.w)
    FreezeEntityPosition(props, true)
    exports.ox_target:addLocalEntity(props, {
      label = locale("tread_grapes"),
      icon = "fas fa-shoe-prints",
      name = "spf_vineyard:process",
      onSelect = function()
        if Config.Duty.EnableDuty then
          if not duty then
            Notify(locale("notify_title"), locale("not_on_duty"), "error", 3000)
          else  
        for _, grape in pairs(Config.Items) do

          table.insert(options, {
            title = grape.treadItems.label,
            icon = "fas fa-wine-glass",
            args = {
                item = grape.item,
            },
            description = "You need "..grape.treadItems.requiredGrapes.." "..grape.label,
            onSelect = function()
              lib.callback('spf_vineyard:hasItem', false, function(has)
                if has then
                  Tread(data.modelCoords, data.animation, grape.item, grape.treadItems.requiredGrapes, grape.treadItems.item, grape.treadItems.rewardAmount)
                else
                  Notify(locale("notify_title"), locale("no_required_items"), "error", 4000)
                end
              end, grape.item, grape.treadItems.requiredGrapes)
            end
        }) 
        lib.registerContext({
          id = 'processmenui',
          title = locale("tread_menu"),
          options = options
      })
      end
      lib.showContext("processmenui")
      options = {}
          end
        else
        for _, grape in pairs(Config.Items) do

          table.insert(options, {
            title = grape.treadItems.label,
            icon = "fas fa-wine-glass",
            args = {
                item = grape.item,
            },
            description = "You need "..grape.treadItems.requiredGrapes.." "..grape.label,
            onSelect = function()
              lib.callback('spf_vineyard:hasItem', false, function(has)
                if has then
                  Tread(data.modelCoords, data.animation, grape.item, grape.treadItems.requiredGrapes, grape.treadItems.item, grape.treadItems.rewardAmount)
                else
                  Notify(locale("notify_title"), locale("no_required_items"), "error", 4000)
                end
              end, grape.item, grape.treadItems.requiredGrapes)
            end
        }) 
        lib.registerContext({
          id = 'processmenui',
          title = locale("tread_menu"),
          options = options
      })
      end
      lib.showContext("processmenui")
      options = {}
        end
      end
    })
  end
end

function Tread(coords, animation, item,requiredGrapes, rewardItem, rewardAmount)
  local grapes = "prop_grapes_01"
  local grapesProp = CreateObject(grapes, coords.x, coords.y, coords.z + 0.02, false, true, false)
  FreezeEntityPosition(grapesProp, true)
  SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, true, false, false, false)
  SetEntityHeading(cache.ped, coords.w)
  lib.requestAnimDict(animation.dict)
  TaskPlayAnim(cache.ped, animation.dict, animation.set, 1.0,-1.0, -1, 1, 1, true, true, true)
  if ProgressBar(locale("treading"), animation.duration) then
    ClearPedTasks(cache.ped)
    local td = { coords = vec3(coords.x, coords.y, coords.z)}
    lib.callback('spf_vineyard:removeItem', false, function(bool)
      if bool then
      end
    end, item, requiredGrapes)
    addItem(rewardItem, rewardAmount, td)
    DeleteObject(grapesProp)
  else
    ClearPedTasks(cache.ped)
    Notify(locale("notify_title"), locale("canceled_progress"), "error", 3000)
    DeleteObject(grapesProp)
  end
end


function addItem(item, amount, td)
  lib.callback('spf_vineyard:addItem', false, function(bool)
    if bool then
    end
  end, item, amount, td)
end