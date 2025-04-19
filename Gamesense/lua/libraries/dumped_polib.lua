slot0 = require("gamesense/http")

return {
	new = function (slot0, slot1, slot2)
		uv0.request("POST", "https://api.pushover.net/1/users/validate.json", {
			params = {
				token = slot0,
				user = slot1,
				html = slot2 and 1 or nil
			}
		}, function (slot0, slot1)
			if json.parse(slot1.body) and slot2.status ~= 1 then
				error("[POLIB] Invalid token or user, please redefine.")

				uv0.invalid = true
			end
		end)

		return {
			send = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8, slot9, slot10, slot11)
				if uv0.invalid then
					error("cannot send to a invalidated token and user")
				end

				uv1.message = slot1
				uv1.title = slot2
				uv1.device = slot3
				uv1.url = slot4
				uv1.url_title = slot5
				uv1.sound = slot6
				uv1.timestamp = slot7
				uv1.priority = slot8
				uv1.retry = uv1.priority == 2 and math.min(slot9, 30)
				uv1.expire = uv1.priority == 2 and math.max(slot10, 10800)

				uv2.request("POST", "https://api.pushover.net/1/messages.json", {
					params = uv1
				}, function (slot0, slot1)
					slot2 = ""
					slot3 = json.parse(slot1.body)

					if slot1.status ~= 200 then
						slot2 = "Error while sending request. Status code: " .. tostring(slot1.status) .. ", Body: " .. tostring(slot1.body)
					elseif slot3.status ~= 1 then
						slot2 = "Error from pushover: " .. tostring(slot1.body)
					end

					if slot2 ~= "" then
						error("[POLIB] " .. slot2)
					end

					if slot3.receipt and uv0 == 2 and type(uv1) == "function" then
						slot4 = nil

						function ()
							uv2.get(("https://api.pushover.net/1/receipts/%s.json?token=%s"):format(uv0.receipt, uv1), function (slot0, slot1)
								if json.parse(slot1.body).status == 1 and slot2.acknowledged == 1 then
									uv0(slot2)
								else
									client.delay_call(5, uv1)
								end
							end)
						end()
					end
				end)
			end
		}
	end
}
