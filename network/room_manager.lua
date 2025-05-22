local connection_manager = require "network.connection_manager"

local M = {}

M.room = nil
M.room_callbacks = {}

-- 룸 조인 상태 콜백 등록
function M.on_join(callback)
    table.insert(M.room_callbacks, callback)
end

-- 룸 조인 또는 생성
function M.join_or_create(room_name, options, on_success, on_error)
    local client = connection_manager.get_client()
    if not client then
        print("Error: Not connected to server")
        if on_error then on_error("Not connected") end
        return
    end
    
    options = options or {}
    
    client:join_or_create(room_name, options, function(err, room)
        if err then
            print("Join room error:", err)
            if on_error then on_error(err) end
            return
        end
        
        M.room = room
        print("Successfully joined room:", room.session_id)
        
        -- 성공 콜백 호출
        if on_success then
            on_success(room)
        end
        
        -- 등록된 룸 콜백들 호출
        for _, callback in ipairs(M.room_callbacks) do
            callback(room)
        end
    end)
end

-- 특정 룸 조인
function M.join(room_id, on_success, on_error)
    local client = connection_manager.get_client()
    if not client then
        print("Error: Not connected to server")
        if on_error then on_error("Not connected") end
        return
    end
    
    client:join(room_id, function(err, room)
        if err then
            print("Join room error:", err)
            if on_error then on_error(err) end
            return
        end
        
        M.room = room
        print("Successfully joined room:", room.session_id)
        
        if on_success then
            on_success(room)
        end
        
        for _, callback in ipairs(M.room_callbacks) do
            callback(room)
        end
    end)
end

-- 룸 나가기
function M.leave()
    if M.room then
        print("Leaving room:", M.room.session_id)
        M.room:leave()
        M.room = nil
    end
end

-- 룸 인스턴스 반환
function M.get_room()
    return M.room
end

-- 룸 연결 상태 확인
function M.is_in_room()
    return M.room ~= nil
end

return M 