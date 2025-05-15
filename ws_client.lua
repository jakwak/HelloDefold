-- ws_client.lua
-- WebSocket을 초기화하고 메시지를 보내고 받는 간단한 모듈

local M = {}

M.is_connected = false

function M.connect(url)
	socket:connect(url, "echo-protocol")  -- echo-protocol은 임의로 지정 가능
	M.is_connected = true
end

function M.send(table_msg)
	if M.is_connected then
		local msg = json.encode(table_msg)
		socket:send(msg)
	end
end

function M.receive()
	if M.is_connected and socket:peek() then
		local msg = socket:receive()
		if msg then
			return json.decode(msg)
		end
	end
	return nil
end

return M
