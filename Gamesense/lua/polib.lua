local http = require "gamesense/http"

local polib = {}
function polib.new(AppToken, UserToken, AllowHTML)
    local mt = {}
    local req = {
        token = AppToken,
        user = UserToken,
        html = AllowHTML and 1 or nil
    }

    -- Initial Validation
    http.request('POST', 'https://api.pushover.net/1/users/validate.json', {params=req}, function(success, response)
        local jsonBody = json.parse(response.body)
        if ( jsonBody and jsonBody.status ~= 1 ) then
            error('[POLIB] Invalid token or user, please redefine.')
            mt.invalid = true
        end
    end)
    
    function mt:send(message, title, device, url, url_title, sound, timestamp, priority, retry, expire, callback)
        if ( mt.invalid ) then error('cannot send to a invalidated token and user') end

        req.message = message
        req.title = title
        req.device = device
        req.url = url
        req.url_title = url_title
        req.sound = sound
        req.timestamp = timestamp
        req.priority = priority
        req.retry = req.priority == 2 and math.min(retry, 30)
        req.expire = req.priority == 2 and math.max(expire, 10800)

        http.request('POST', 'https://api.pushover.net/1/messages.json', {params=req}, function(success, response)
            local errstr = ''
            local jsonBody = json.parse(response.body)
           
            if (response.status ~= 200) then
                errstr = "Error while sending request. Status code: " .. tostring(response.status) .. ", Body: " .. tostring(response.body)
            elseif (jsonBody.status ~= 1) then
                errstr = "Error from pushover: " .. tostring(response.body)
            end
            if ( errstr ~= '' ) then
                error('[POLIB] ' .. errstr)
            end

            if ( jsonBody.receipt and priority == 2 and type(callback) == 'function' ) then
                local Done
                local function CheckCallback()
                    local ReceiptConfirmURL = ('https://api.pushover.net/1/receipts/%s.json?token=%s'):format(jsonBody.receipt, AppToken)
                    http.get(ReceiptConfirmURL, function(_success, _response)
                        local receiptJson = json.parse(_response.body)
                        if ( receiptJson.status == 1 and receiptJson.acknowledged == 1 ) then
                            callback(receiptJson)
                        else
                            client.delay_call(5, CheckCallback)
                        end
                    end)
                end
                CheckCallback()
            end
        end)
    end
    
    return mt
end

return polib