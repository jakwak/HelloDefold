local M = {}

-- URL 디코딩 함수
local function url_decode(str)
	str = str:gsub('+', ' ')
	str = str:gsub('%%(%x%x)', function(h)
		return string.char(tonumber(h, 16))
	end)
	return str
end

-- URL 파라미터 파싱
function M.get_query_parameters()
	if not html5 then
		return {}
	end
	
	local url = html5.run("window.location.search")
	if not url or url == "" then
		return {}
	end
	
	-- Remove the leading '?' from the query string
	url = url:sub(2)
	
	local params = {}
	-- iterate over all key value pairs
	for kvp in url:gmatch("([^&]+)") do
		local key, value = kvp:match("(.+)=(.+)")
		if key and value then
			-- URL 디코딩 (한글 지원)
			value = url_decode(value)
			params[key] = value
			print('key, value---->', key, value)
		end
	end
	return params
end

-- 랜덤 4자리 숫자 생성
function M.generate_random_number()
	return string.format("%04d", math.random(0, 9999))
end

-- 사용자 이름 포맷팅 (게스트 처리 포함)
function M.format_username(username)
	if username == "Guest" then
		return username .. "#" .. M.generate_random_number()
	end
	return username
end

-- 위치를 화면 안으로 제한
function M.clamp_position(position, bounds)
	position.x = math.max(bounds.left, math.min(bounds.right, position.x))
	position.y = math.max(bounds.bottom, math.min(bounds.top, position.y))
	return position
end

return M 