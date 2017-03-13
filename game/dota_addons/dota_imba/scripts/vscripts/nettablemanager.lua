function talentmanager(tEntity, nameScheme, isParityNeeded, ...) 
  local values = {...}                                                                        -- Our user input
  local returnvalues = {}                                                                     -- table that will be unpacked for result                                                    
  local playerstalenttable = "player_"..tEntity:GetPlayerOwnerID().."_"..nameScheme
    for k,v in ipairs(values) do  
      local talentnumber = v[1]                                                               -- should be 1-8, but probably can be extrapolated later on to be any number
      local talentname = nameScheme..talentnumber                                             -- special_bonus_unique_bane_1 (for keyvalue txt)
      local keyname = playerstalenttable..talentnumber                                        -- player_(#)_special_bonus_unique_bane(1-8)
      if IsServer() then
        local netTableKey = netTableCmd(false,"talents",keyname)                              -- Command to grab our key set
        if tEntity:HasTalent(talentname) then                                                 -- Do we have the talent?
          local has_talent = createNetTableKey(tEntity,true,nameScheme,v)                     -- [HAVE TALENT] call function to write my net table key with flag has talent (which can be any number of arguments)
          if not netTableKey then                                                             -- [HAVE TALENT] We have talent and value isn't populated (rare)        
            netTableCmd(true,"talents",keyname,has_talent)                                    -- [HAVE TALENT] We didn't find a current kv pair, so create one 
          end
        else                                                                                  -- [NO TALENT] this should be the 'we don't have talent' else, but serverside
          local has_talent = createNetTableKey(tEntity,false,nameScheme,v)
          if not netTableKey then                                                             -- [NO TALENT] We don't have talent, and the kv pair doesn't exist so...
            if type(netTableKey) == 'boolean' then                                            -- [NO TALENT] The table exists but we only got a true/false statement that it does, it is not populated if this is true.
              netTableCmd(true,"talents",keyname,has_talent)                                  -- [NO TALENT] Write a value for clients to be able to read (which will be 0 instead of nil)
            end
          end
        end
      end
      local allkeys = netTableCmd(false,"talents",keyname)
      if allkeys[1] = 1 then
        table.insert(returnvalues, true)    
      else
        table.insert(returnvalues, false)    
      end
    end
return unpack(testtable)
end

function netTableCmd(send,readtable,key,tabletosend)
  if send == false then
    local finalresulttable = {}
    local nettabletemp = CustomNetTables:GetTableValue(readtable,key)
    if not nettabletemp then return false end
    for key,value in pairs(nettabletemp) do
      table.insert(finalresulttable,value)
    end          
    if #finalresulttable > 0 then 
      return finalresulttable
    else
      return true
    end
  else
    CustomNetTables:SetTableValue(readtable, key, tabletosend)
  end
end

function createNetTableKey(tEntity, talentrequest,nameScheme,v)
  local valuePair = {}
  if talentrequest == true then                                           -- Single values only, only difference is it just returns the first talentvalue
    table.insert(valuePair,1)                                             -- true
  else 
    table.insert(valuePair,0)                                                -- talent check failed, so set our value pair to 0 
  end
  return valuePair  
end
