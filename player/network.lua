local M = {}

local Colyseus = require "colyseus.sdk"
local client = nil
local room = nil
local other_players = {}
local other_player_lerp_speed = 0.2

-- 선형 보간 함수
local function lerp(start, target, t)
    return start + (target - start) * t
end

function M.init(callbacks, username)
    -- Colyseus 서버에 연결
    client = Colyseus.Client("ws://localhost:2567")
    
    return client:join_or_create("my_room", {name = username}, function(err, _room)
        if err then
            print("JOIN ERROR: " .. err)
            return
        end

        room = _room
        
        local room_callbacks = Colyseus.callbacks(room)

        -- 새로운 플레이어가 참가했을 때
        room_callbacks:on_add("players", function (player, sessionId)
            if not sessionId then
                print("Warning: sessionId is nil!")
                return
            end

            if sessionId == room.session_id then
                if callbacks.on_my_player_added then
                    callbacks.on_my_player_added(player)
                end
            else
                if callbacks.on_other_player_added then
                    callbacks.on_other_player_added(player, sessionId)
                end
            end

            room_callbacks:listen(player, "name", function (curVal, prevVal)
                if sessionId ~= room.session_id then
                    if other_players[sessionId] then
                        msg.post(other_players[sessionId].id, "set_name", { name = curVal })
                    end
                end
            end)

            -- 플레이어 위치 변경 감지
            room_callbacks:listen(player, "x", function (curVal, prevVal)
                if sessionId ~= room.session_id then
                    if other_players[sessionId] then
                        if not other_players[sessionId].target_position then
                            other_players[sessionId].target_position = vmath.vector3()
                        end
                        other_players[sessionId].target_position.x = curVal
                    end
                end
            end)

            room_callbacks:listen(player, "y", function (curVal, prevVal)
                if sessionId ~= room.session_id then
                    if other_players[sessionId] then
                        if not other_players[sessionId].target_position then
                            other_players[sessionId].target_position = vmath.vector3()
                        end
                        other_players[sessionId].target_position.y = curVal
                    end
                end
            end)

            room_callbacks:listen(player, "color", function (curVal, prevVal)
                if sessionId ~= room.session_id then
                    if other_players[sessionId] then
                        msg.post(other_players[sessionId].id, "change_color", { color_index = curVal })
                    end
                end
            end)
        end)

        -- 플레이어가 나갔을 때
        room_callbacks:on_remove("players", function (player, sessionId)
            if callbacks.on_player_removed then
                callbacks.on_player_removed(sessionId)
            end
        end)
    end)
end

function M.update(dt)
    -- 다른 플레이어들의 부드러운 이동 업데이트
    for sessionId, player_data in pairs(other_players) do
        if player_data.position and player_data.target_position then
            local current_pos = go.get_position(player_data.id)
            local new_pos = vmath.vector3()
            new_pos.x = lerp(current_pos.x, player_data.target_position.x, other_player_lerp_speed)
            new_pos.y = lerp(current_pos.y, player_data.target_position.y, other_player_lerp_speed)
            new_pos.z = current_pos.z
            go.set_position(new_pos, player_data.id)
        end
    end
end

function M.send_position(x, y)
    if room then
        room:send("move", { x = x, y = y })
    end
end

function M.send_color(color_index)
    if room then
        room:send("change_color", { color_index = color_index })
    end
end

function M.get_other_players()
    return other_players
end

function M.add_other_player(sessionId, instance_id)
    other_players[sessionId] = {
        id = instance_id,
        position = vmath.vector3(),
        target_position = vmath.vector3()
    }
end

function M.remove_other_player(sessionId)
    if other_players[sessionId] then
        go.delete(other_players[sessionId].id)
        other_players[sessionId] = nil
    end
end

function M.final()
    -- 모든 다른 플레이어 정리
    for sessionId, player_data in pairs(other_players) do
        M.remove_other_player(sessionId)
    end

    if room then
        room:leave()
    end
end

return M 