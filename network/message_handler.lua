local room_manager = require "network.room_manager"

local M = {}

M.message_handlers = {}

-- 메시지 핸들러 등록
function M.register_handler(msg_type, callback)
    if not M.message_handlers[msg_type] then
        M.message_handlers[msg_type] = {}
    end
    table.insert(M.message_handlers[msg_type], callback)
    
    -- 룸이 이미 있다면 즉시 등록
    local room = room_manager.get_room()
    if room then
        room:on_message(msg_type, callback)
    end
end

-- 여러 핸들러 한번에 등록
function M.register_handlers(handler_map)
    for msg_type, callback in pairs(handler_map) do
        M.register_handler(msg_type, callback)
    end
end

-- 룸 조인시 등록된 모든 핸들러들을 룸에 연결
function M.setup_room_handlers(room)
    for msg_type, handlers in pairs(M.message_handlers) do
        for _, callback in ipairs(handlers) do
            room:on_message(msg_type, callback)
        end
    end
end

-- 특정 타입의 핸들러 제거
function M.unregister_handler(msg_type, callback)
    if M.message_handlers[msg_type] then
        for i, handler in ipairs(M.message_handlers[msg_type]) do
            if handler == callback then
                table.remove(M.message_handlers[msg_type], i)
                break
            end
        end
    end
end

-- 모든 핸들러 초기화
function M.clear_handlers()
    M.message_handlers = {}
end

-- 메시지 전송
function M.send_message(msg_type, data)
    local room = room_manager.get_room()
    if room then
        room:send(msg_type, data)
    else
        print("Error: No room connected to send message")
    end
end

-- 상태 변경 핸들러 등록
function M.on_state_change(callback)
    local room = room_manager.get_room()
    if room then
        room:on("statechange", callback)
    else
        -- 룸 조인시 등록하도록 저장
        room_manager.on_join(function(room)
            room:on("statechange", callback)
        end)
    end
end

-- 룸 매니저에 콜백 등록 (룸 조인시 핸들러 자동 설정)
room_manager.on_join(M.setup_room_handlers)

return M 