local message_handler = require "network.message_handler"

local M = {}

-- 동기화 콜백들
M.sync_callbacks = {
    player_update = {},
    pad_update = {},
    debug_update = {},
    game_state = {}
}

-- 초기화 함수
function M.init()
    -- 플레이어 업데이트 핸들러
    message_handler.register_handler("player_update", function(message)
        M._handle_player_update(message)
    end)
    
    -- 패드 업데이트 핸들러
    message_handler.register_handler("pad_update", function(message)
        M._handle_pad_update(message)
    end)
    
    -- 디버그 정보 핸들러
    message_handler.register_handler("debug_update", function(message)
        M._handle_debug_update(message)
    end)
    
    -- 게임 상태 변경 핸들러
    message_handler.on_state_change(function(state)
        M._handle_state_change(state)
    end)
    
    print("Sync manager initialized")
end

-- 플레이어 동기화 콜백 등록
function M.on_player_update(callback)
    table.insert(M.sync_callbacks.player_update, callback)
end

-- 패드 동기화 콜백 등록
function M.on_pad_update(callback)
    table.insert(M.sync_callbacks.pad_update, callback)
end

-- 디버그 정보 동기화 콜백 등록
function M.on_debug_update(callback)
    table.insert(M.sync_callbacks.debug_update, callback)
end

-- 게임 상태 변경 콜백 등록
function M.on_game_state_change(callback)
    table.insert(M.sync_callbacks.game_state, callback)
end

-- 플레이어 정보 전송
function M.send_player_update(player_data)
    message_handler.send_message("player_update", player_data)
end

-- 패드 정보 전송
function M.send_pad_update(pad_data)
    message_handler.send_message("pad_update", pad_data)
end

-- 디버그 정보 전송
function M.send_debug_update(debug_data)
    message_handler.send_message("debug_update", debug_data)
end

-- 내부 핸들러 함수들
function M._handle_player_update(message)
    for _, callback in ipairs(M.sync_callbacks.player_update) do
        callback(message)
    end
end

function M._handle_pad_update(message)
    for _, callback in ipairs(M.sync_callbacks.pad_update) do
        callback(message)
    end
end

function M._handle_debug_update(message)
    for _, callback in ipairs(M.sync_callbacks.debug_update) do
        callback(message)
    end
end

function M._handle_state_change(state)
    for _, callback in ipairs(M.sync_callbacks.game_state) do
        callback(state)
    end
end

-- 동기화 정보 일괄 전송 (최적화된 방식)
function M.send_bulk_update(data)
    if data.player then
        M.send_player_update(data.player)
    end
    if data.pad then
        M.send_pad_update(data.pad)
    end
    if data.debug then
        M.send_debug_update(data.debug)
    end
end

-- 특정 타입의 콜백 제거
function M.remove_callback(callback_type, callback)
    if M.sync_callbacks[callback_type] then
        for i, cb in ipairs(M.sync_callbacks[callback_type]) do
            if cb == callback then
                table.remove(M.sync_callbacks[callback_type], i)
                break
            end
        end
    end
end

-- 모든 콜백 초기화
function M.clear_callbacks()
    for callback_type, _ in pairs(M.sync_callbacks) do
        M.sync_callbacks[callback_type] = {}
    end
end

return M 