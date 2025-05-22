-- 메인 Colyseus 클라이언트 인터페이스
local connection_manager = require "network.connection_manager"
local room_manager = require "network.room_manager"
local message_handler = require "network.message_handler"
local sync_manager = require "network.sync_manager"

local M = {}

-- 초기화 (가장 먼저 호출)
function M.init()
    sync_manager.init()
    print("Colyseus client initialized")
end

-- 서버 접속 및 룸 조인 (간편 함수)
function M.connect_and_join(url, room_name, options, on_success, on_error)
    connection_manager.connect(url, function(client)
        room_manager.join_or_create(room_name, options, on_success, on_error)
    end, on_error)
end

-- 개별 모듈 접근 (고급 사용자용)
function M.get_connection_manager()
    return connection_manager
end

function M.get_room_manager()
    return room_manager
end

function M.get_message_handler()
    return message_handler
end

function M.get_sync_manager()
    return sync_manager
end

-- 호환성을 위한 기존 함수 (deprecated)
function M.connect(url, room_name, on_join, on_message_map)
    print("Warning: M.connect is deprecated. Use M.connect_and_join instead")
    
    -- 메시지 핸들러들 등록
    if on_message_map then
        message_handler.register_handlers(on_message_map)
    end
    
    -- 접속 및 조인
    M.connect_and_join(url, room_name, {}, on_join)
end

-- 빠른 접근을 위한 속성들
M.client = connection_manager.client
M.room = room_manager.room

return M 