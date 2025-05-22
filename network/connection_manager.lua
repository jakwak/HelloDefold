local colyseus = require "colyseus.sdk"

local M = {}

M.client = nil
M.url = nil
M.connection_callbacks = {}

-- 접속 상태 콜백 등록
function M.on_connect(callback)
    table.insert(M.connection_callbacks, callback)
end

-- 서버에 접속
function M.connect(url, on_success, on_error)
    M.url = url
    M.client = colyseus.Client(url)
    
    print("Connecting to server:", url)
    
    -- 접속 성공시 콜백들 호출
    if on_success then
        on_success(M.client)
    end
    
    -- 등록된 접속 콜백들 호출
    for _, callback in ipairs(M.connection_callbacks) do
        callback(M.client)
    end
end

-- 접속 해제
function M.disconnect()
    if M.client then
        print("Disconnecting from server")
        M.client = nil
    end
end

-- 접속 상태 확인
function M.is_connected()
    return M.client ~= nil
end

-- 클라이언트 인스턴스 반환
function M.get_client()
    return M.client
end

return M 