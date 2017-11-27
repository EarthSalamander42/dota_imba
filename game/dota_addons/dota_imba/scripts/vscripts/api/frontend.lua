---
--- Simple syncronous API frontend. UNSAFE
---

require("api/api")

local api_preloaded = {}

--- Call this function at the start of the server
function preload_api()
    imba_api():meta_donators(function (donors)
       api_preloaded.donators = donors
    end)
    
    imba_api():meta_developers(function (devs)
        api_preloaded.developers = devs
    end)
end

--- Not guaranteed to return non-nil value
function get_donators()
    return api_preloaded.donators
end

--- Not guaranteed to return non-nil value
function get_developers()
    return api_preloaded.developers
end
