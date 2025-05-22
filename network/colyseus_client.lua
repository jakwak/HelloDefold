local colyseus = require "colyseus.sdk"

local M = {}

M.client = nil
M.room = nil

function M.connect(url, room_name, on_join, on_message_map)
    M.client = colyseus.Client(url)
    M.client:join_or_create(room_name, {}, function(err, _room)
        if err then
            print("Join error:", err)
            return
        end
        M.room = _room
        print("Joined room:", M.room.session_id)
        if on_join then
            on_join(M.room)
        end
        -- 메시지 타입별 콜백 등록
        if on_message_map then
            for msg_type, callback in pairs(on_message_map) do
                M.room:on_message(msg_type, callback)
            end
        end
    end)
end

return M 