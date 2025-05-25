-- Utils 모듈
local M = {}

-- 리스너 관리
local listeners = {}

-- 리스너 등록
function M.register_listener(id)
	print("register_listener: ", id)
	listeners[id] = true
end

-- 리스너 제거
function M.unregister_listener(id)
	print("unregister_listener: ", id)
	listeners[id] = nil
end

-- 등록된 모든 리스너에게 브로드캐스트
function M.broadcast(msg_id, message)
	for id in pairs(listeners) do
		msg.post(id, msg_id, message or {})
	end
end

-- 등록된 리스너 목록 확인
function M.get_listeners()
	return listeners
end

-- 등록된 리스너 수 확인
function M.get_listener_count()
	local count = 0
	for _ in pairs(listeners) do
		count = count + 1
	end
	return count
end

-- 테이블 디버깅 함수들
function M.print_table(t, indent)
	indent = indent or 0
	local prefix = string.rep("  ", indent)
	
	if type(t) ~= "table" then
		print(prefix .. tostring(t))
		return
	end
	
	for k, v in pairs(t) do
		if type(v) == "table" then
			print(prefix .. tostring(k) .. ":")
			M.print_table(v, indent + 1)
		else
			print(prefix .. tostring(k) .. ": " .. tostring(v))
		end
	end
end

function M.table_to_string(t, indent)
	indent = indent or 0
	local spaces = string.rep("  ", indent)
	
	if type(t) ~= "table" then
		if type(t) == "string" then
			return '"' .. t .. '"'
		else
			return tostring(t)
		end
	end
	
	local result = "{\n"
	for k, v in pairs(t) do
		local key = type(k) == "string" and '"' .. k .. '"' or tostring(k)
		result = result .. spaces .. "  " .. key .. ": "
		
		if type(v) == "table" then
			result = result .. M.table_to_string(v, indent + 1)
		elseif type(v) == "string" then
			result = result .. '"' .. v .. '"'
		else
			result = result .. tostring(v)
		end
		result = result .. ",\n"
	end
	result = result .. spaces .. "}"
	return result
end

function M.table_size(t)
	if type(t) ~= "table" then
		return 0
	end
	
	local count = 0
	for _ in pairs(t) do
		count = count + 1
	end
	return count
end

function M.deep_copy(t)
	if type(t) ~= "table" then
		return t
	end
	
	local copy = {}
	for k, v in pairs(t) do
		copy[k] = M.deep_copy(v)
	end
	return copy
end

function M.compare_tables(old_table, new_table)
	-- 테이블 비교 - 변경사항 찾기
	local changes = {}
	
	if not old_table or not new_table then
		return changes
	end
	
	-- 새로 추가되거나 변경된 키들
	for k, v in pairs(new_table) do
		if old_table[k] ~= v then
			table.insert(changes, {
				key = k,
				old_value = old_table[k],
				new_value = v,
				change_type = old_table[k] == nil and "added" or "changed"
			})
		end
	end
	
	-- 삭제된 키들
	for k, v in pairs(old_table) do
		if new_table[k] == nil then
			table.insert(changes, {
				key = k,
				old_value = v,
				new_value = nil,
				change_type = "removed"
			})
		end
	end
	
	return changes
end

-- 두 테이블이 동일한지 확인
function M.tables_equal(t1, t2)
	if type(t1) ~= type(t2) then
		return false
	end
	
	if type(t1) ~= "table" then
		return t1 == t2
	end
	
	for k, v in pairs(t1) do
		if not M.tables_equal(v, t2[k]) then
			return false
		end
	end
	
	for k, v in pairs(t2) do
		if not M.tables_equal(v, t1[k]) then
			return false
		end
	end
	
	return true
end

function M.table_summary(t)
	if type(t) ~= "table" then
		return tostring(t)
	end
	
	local size = M.table_size(t)
	local keys = {}
	local count = 0
	
	for k, _ in pairs(t) do
		count = count + 1
		if count <= 3 then
			table.insert(keys, tostring(k))
		end
	end
	
	local key_list = table.concat(keys, ", ")
	if size > 3 then
		key_list = key_list .. ", ..."
	end
	
	return string.format("table[%d] {%s}", size, key_list)
end

-- 변경사항을 출력
function M.print_changes(changes)
	if #changes == 0 then
		print("변경사항 없음")
		return
	end
	
	for _, change in ipairs(changes) do
		if change.change_type == "added" then
			print("추가된 키:", change.key, "값:", tostring(change.new_value))
		elseif change.change_type == "removed" then
			print("삭제된 키:", change.key, "이전 값:", tostring(change.old_value))
		elseif change.change_type == "changed" then
			print("변경된 키:", change.key, "이전:", tostring(change.old_value), "현재:", tostring(change.new_value))
		end
	end
end

-- 테이블을 얕은 복사
function M.shallow_copy(t)
	if type(t) ~= "table" then
		return t
	end
	
	local copy = {}
	for k, v in pairs(t) do
		copy[k] = v
	end
	return copy
end

-- 모든 키와 타입 정보 출력
function M.print_keys_and_types(t, title)
	if type(t) ~= "table" then
		print(title or "값:", tostring(t), "타입:", type(t))
		return
	end
	
	local size = M.table_size(t)
	print((title or "테이블") .. " (" .. size .. "개):")
	
	for k, v in pairs(t) do
		print("  키:", k, "타입:", type(v), "값:", M.table_summary(v))
	end
end

-- 특정 키들만 출력
function M.print_specific_keys(t, keys, title)
	if type(t) ~= "table" then
		return
	end
	
	print(title or "--- 특정 키들 ---")
	for _, key in ipairs(keys) do
		if t[key] then
			print(key .. " (타입: " .. type(t[key]) .. "):")
			if type(t[key]) == "table" then
				local count = M.table_size(t[key])
				if count <= 5 then
					M.print_table(t[key], 1)
				else
					print("  (테이블 크기: " .. count .. " - 출력 생략)")
				end
			else
				print("  " .. tostring(t[key]))
			end
		end
	end
end

-- 디버그 출력 (간단한 경우만 JSON, 복잡한 경우는 리스트)
function M.debug_print(t, title)
	title = title or "Debug Table"
	print("=== " .. title .. " ===")
	print("타입:", type(t))
	print("시간:", os.date("%H:%M:%S"))
	
	if type(t) ~= "table" then
		print("값:", tostring(t))
		print("========================")
		return
	end
	
	local size = M.table_size(t)
	
	-- 리스트 형태 출력
	print("내용 (리스트 형태):")
	M.print_table(t)
	
	-- JSON 형태 출력 (작은 테이블만)
	if size <= 10 then
		print("\n내용 (JSON 형태):")
		print(M.table_to_string(t))
	else
		print("\n테이블이 너무 큽니다. JSON 출력 생략.")
	end
	
	print("========================")
end


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

function M.get_username()
	if html5 then
		local username = html5.run("new URLSearchParams(window.location.search).get('username')")
		if username and username ~= "" and username ~= "null" then
			return username
		end
	end
	return nil
end

function M.hex_to_v4(hex)
	if not hex or #hex < 6 then
		return vmath.vector4(1, 1, 1, 1) -- 기본값: 흰색
	end
	hex = hex:gsub("#", "")
	local r = tonumber(hex:sub(1, 2), 16)
	local g = tonumber(hex:sub(3, 4), 16)
	local b = tonumber(hex:sub(5, 6), 16)
	if not r or not g or not b then
		return vmath.vector4(1, 1, 1, 1)
	end
	return vmath.vector4(r/255, g/255, b/255, 1)
end

return M
