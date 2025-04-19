
local computer = require("computer")
local color = require("color")
local unicode = require("unicode")
local fs = require("filesystem")
local gpu = require("component").gpu

-------------------------------------------------------------------------------

local image = {formatModules = {}}

-------------------------------------------------------------------------------

function image.getIndex(x, y, width)
	return width * (y - 1) + x
end

function image.group(picture, compressColors)
	local groupedPicture, x, y, background, foreground = {}, 1, 1

	for i = 1, #picture[3] do
		if compressColors then
			background, foreground = color.to8Bit(picture[3][i]), color.to8Bit(picture[4][i])
			if i % 603 == 0 then
				computer.pullSignal(0)
			end
		else
			background, foreground = picture[3][i], picture[4][i]
		end

		groupedPicture[picture[5][i]] = groupedPicture[picture[5][i]] or {}
		groupedPicture[picture[5][i]][picture[6][i]] = groupedPicture[picture[5][i]][picture[6][i]] or {}
		groupedPicture[picture[5][i]][picture[6][i]][background] = groupedPicture[picture[5][i]][picture[6][i]][background] or {}
		groupedPicture[picture[5][i]][picture[6][i]][background][foreground] = groupedPicture[picture[5][i]][picture[6][i]][background][foreground] or {}
		groupedPicture[picture[5][i]][picture[6][i]][background][foreground][y] = groupedPicture[picture[5][i]][picture[6][i]][background][foreground][y] or {}

		table.insert(groupedPicture[picture[5][i]][picture[6][i]][background][foreground][y], x)

		x = x + 1
		if x > picture[1] then
			x, y = 1, y + 1
		end
	end

	return groupedPicture
end

function image.draw(x, y, picture)
	local groupedPicture = image.group(picture)
	local _, _, currentBackground, currentForeground, gpuGetBackground, imageX, imageY

	for alpha in pairs(groupedPicture) do
		for symbol in pairs(groupedPicture[alpha]) do
			
			if not (symbol == " " and alpha == 1) then
				for background in pairs(groupedPicture[alpha][symbol]) do
					
					if background ~= currentBackground then
						currentBackground = background
						gpu.setBackground(background)
					end

					for foreground in pairs(groupedPicture[alpha][symbol][background]) do
						
						if foreground ~= currentForeground and symbol ~= " " then
							currentForeground = foreground
							gpu.setForeground(foreground)
						end
						
						for yPos in pairs(groupedPicture[alpha][symbol][background][foreground]) do
							for xPos = 1, #groupedPicture[alpha][symbol][background][foreground][yPos] do
								imageX, imageY = x + groupedPicture[alpha][symbol][background][foreground][yPos][xPos] - 1, y + yPos - 1

								if alpha > 0 then
									_, _, gpuGetBackground = gpu.get(imageX, imageY)
									
									if alpha == 1 then
										currentBackground = gpuGetBackground
										gpu.setBackground(currentBackground)
									else
										currentBackground = color.blend(gpuGetBackground, background, alpha)
										gpu.setBackground(currentBackground)
									end
								end

								gpu.set(imageX, imageY, symbol)
							end
						end
					end
				end
			end
		end
	end
end

function image.create(width, height, background, foreground, alpha, symbol, random)
	local picture = {width, height, {}, {}, {}, {}}

	for i = 1, width * height do
		table.insert(picture[3], random and math.random(0x0, 0xFFFFFF) or (background or 0x0))
		table.insert(picture[4], random and math.random(0x0, 0xFFFFFF) or (foreground or 0x0))
		table.insert(picture[5], alpha or 0x0)
		table.insert(picture[6], random and string.char(math.random(65, 90)) or (symbol or " "))
	end

	return picture
end

function image.copy(picture)
	local newPicture = {picture[1], picture[2], {}, {}, {}, {}}
	
	for i = 1, #picture[3] do
		newPicture[3][i] = picture[3][i]
		newPicture[4][i] = picture[4][i]
		newPicture[5][i] = picture[5][i]
		newPicture[6][i] = picture[6][i]
	end

	return newPicture
end

-------------------------------------------------------------------------------

function image.loadFormatModule(path, extension)
	local success, result = loadfile(path)
	if success then
		success, result = pcall(success, image)
		if success then
			image.formatModules[extension] = result
		else
			error("Failed to execute image format module: " .. tostring(result))
		end
	else
		error("Failed to load image format module: " .. tostring(result))
	end
end

local function loadOrSave(methodName, path, ...)
	local extension = fs.extension(path)
	if image.formatModules[extension] then
		local success, result = pcall(image.formatModules[extension][methodName], path, ...)
		if success then
			return result
		else
			return false, "Failed to " .. methodName .. " image file: " .. tostring(result)
		end
	else
		return false, "Failed to " .. methodName .. " image file: format module for extension \"" .. tostring(extension) .. "\" is not loaded"
	end
end

function image.save(path, picture, encodingMethod)
	return loadOrSave("save", path, picture, encodingMethod)
end

function image.load(path)
	return loadOrSave("load", path)
end

-------------------------------------------------------------------------------

function image.toString(picture)
	local charArray = {
		string.format("%02X", picture[1]),
		string.format("%02X", picture[2])
	}
	
	for i = 1, #picture[3] do
		table.insert(charArray, string.format("%02X", color.to8Bit(picture[3][i])))
		table.insert(charArray, string.format("%02X", color.to8Bit(picture[4][i])))
		table.insert(charArray, string.format("%02X", math.floor(picture[5][i] * 255)))
		table.insert(charArray, picture[6][i])

		if i % 603 == 0 then
			computer.pullSignal(0)
		end
	end

	return table.concat(charArray)
end

function image.fromString(pictureString)
	local picture = {
		tonumber("0x" .. unicode.sub(pictureString, 1, 2)),
		tonumber("0x" .. unicode.sub(pictureString, 3, 4)),
		{}, {}, {}, {}
	}

	for i = 5, unicode.len(pictureString), 7 do
		table.insert(picture[3], color.to24Bit(tonumber("0x" .. unicode.sub(pictureString, i, i + 1))))
		table.insert(picture[4], color.to24Bit(tonumber("0x" .. unicode.sub(pictureString, i + 2, i + 3))))
		table.insert(picture[5], tonumber("0x" .. unicode.sub(pictureString, i + 4, i + 5)) / 255)
		table.insert(picture[6], unicode.sub(pictureString, i + 6, i + 6))
	end

	return picture
end

-------------------------------------------------------------------------------

function image.set(picture, x, y, background, foreground, alpha, symbol)
	local index = image.getIndex(x, y, picture[1])
	picture[3][index], picture[4][index], picture[5][index], picture[6][index] = background, foreground, alpha, symbol

	return picture
end

function image.get(picture, x, y)
	local index = image.getIndex(x, y, picture[1])
	return picture[3][index], picture[4][index], picture[5][index], picture[6][index]
end

function image.getSize(picture)
	return picture[1], picture[2]
end

function image.getWidth(picture)
	return picture[1]
end

function image.getHeight(picture)
	return picture[2]
end

function image.transform(picture, newWidth, newHeight)
	local newPicture, stepWidth, stepHeight, background, foreground, alpha, symbol = {newWidth, newHeight, {}, {}, {}, {}}, picture[1] / newWidth, picture[2] / newHeight
	
	local x, y = 1, 1
	for j = 1, newHeight do
		for i = 1, newWidth do
			background, foreground, alpha, symbol = image.get(picture, math.floor(x), math.floor(y))
			table.insert(newPicture[3], background)
			table.insert(newPicture[4], foreground)
			table.insert(newPicture[5], alpha)
			table.insert(newPicture[6], symbol)

			x = x + stepWidth
		end

		x, y = 1, y + stepHeight
	end

	return newPicture
end

function image.crop(picture, fromX, fromY, width, height)
	if fromX >= 1 and fromY >= 1 and fromX + width - 1 <= picture[1] and fromY + height - 1 <= picture[2] then
		local newPicture, background, foreground, alpha, symbol = {width, height, {}, {}, {}, {}}
		
		for y = fromY, fromY + height - 1 do
			for x = fromX, fromX + width - 1 do
				background, foreground, alpha, symbol = image.get(picture, x, y)
				table.insert(newPicture[3], background)
				table.insert(newPicture[4], foreground)
				table.insert(newPicture[5], alpha)
				table.insert(newPicture[6], symbol)
			end
		end

		return newPicture
	else
		return false, "Failed to crop image: target coordinates are out of source range"
	end
end

function image.flipHorizontally(picture)
	local newPicture, background, foreground, alpha, symbol = {picture[1], picture[2], {}, {}, {}, {}}
	
	for y = 1, picture[2] do
		for x = picture[1], 1, -1 do
			background, foreground, alpha, symbol = image.get(picture, x, y)
			table.insert(newPicture[3], background)
			table.insert(newPicture[4], foreground)
			table.insert(newPicture[5], alpha)
			table.insert(newPicture[6], symbol)
		end
	end

	return newPicture
end

function image.flipVertically(picture)
	local newPicture, background, foreground, alpha, symbol = {picture[1], picture[2], {}, {}, {}, {}}
	
	for y = picture[2], 1, -1 do
		for x = 1, picture[1] do
			background, foreground, alpha, symbol = image.get(picture, x, y)
			table.insert(newPicture[3], background)
			table.insert(newPicture[4], foreground)
			table.insert(newPicture[5], alpha)
			table.insert(newPicture[6], symbol)
		end
	end

	return newPicture
end

function image.expand(picture, fromTop, fromBottom, fromLeft, fromRight, background, foreground, alpha, symbol)
	local newPicture = image.create(picture[1] + fromRight + fromLeft, picture[2] + fromTop + fromBottom, background, foreground, alpha, symbol)

	for y = 1, picture[2] do
		for x = 1, picture[1] do
			image.set(newPicture, x + fromLeft, y + fromTop, image.get(picture, x, y))
		end
	end

	return newPicture
end

function image.blend(picture, blendColor, transparency)
	local newPicture = {picture[1], picture[2], {}, {}, {}, {}}

	for i = 1, #picture[3] do
		table.insert(newPicture[3], color.blend(picture[3][i], blendColor, transparency))
		table.insert(newPicture[4], color.blend(picture[4][i], blendColor, transparency))
		table.insert(newPicture[5], picture[5][i])
		table.insert(newPicture[6], picture[6][i])
	end

	return newPicture
end

function image.rotate(picture, angle)
	local radAngle = math.rad(angle)
	local sin, cos = math.sin(radAngle), math.cos(radAngle)
	local pixMap = {}

	local xCenter, yCenter = picture[1] / 2, picture[2] / 2
	local xMin, xMax, yMin, yMax = math.huge, -math.huge, math.huge, -math.huge
	for y = 1, picture[2] do
		for x = 1, picture[1] do
			local xNew = math.round(xCenter + (x - xCenter) * cos - (y - yCenter) * sin)
			local yNew = math.round(yCenter + (y - yCenter) * cos + (x - xCenter) * sin)

			xMin, xMax, yMin, yMax = math.min(xMin, xNew), math.max(xMax, xNew), math.min(yMin, yNew), math.max(yMax, yNew)

			pixMap[yNew] = pixMap[yNew] or {}
			pixMap[yNew][xNew] = {image.get(picture, x, y)}
		end
	end

	local newPicture = image.create(xMax - xMin + 1, yMax - yMin + 1, 0xFF0000, 0x0, 0x0, "#")
	for y in pairs(pixMap) do
		for x in pairs(pixMap[y]) do
			image.set(newPicture, x - xMin + 1, y - yMin + 1, pixMap[y][x][1], pixMap[y][x][2], pixMap[y][x][3], pixMap[y][x][4])
		end
	end

	return newPicture
end

-------------------------------------------------------------------------------

image.loadFormatModule("/lib/FormatModules/OCIF.lua", ".pic")

-------------------------------------------------------------------------------

return image