-- Network Client 사용 예제들

--[[ 
=== 기본 사용법 ===

1. client.script는 자동으로 네트워크 접속과 룸 관리를 담당합니다.
2. 다른 스크립트들은 메시지를 통해 client.script와 통신합니다.

=== 메시지 API ===

-- 네트워크로 데이터 전송
msg.post("/network#client", "send_move", { x = 1, y = 0 })
msg.post("/network#client", "send_position_sync", { x = 100, y = 200 })
msg.post("/network#client", "request_debug_bodies", {})

-- 네트워크 상태 요청
msg.post("/network#client", "get_network_state", {})

-- 네트워크 제어
msg.post("/network#client", "disconnect", {})
msg.post("/network#client", "reconnect", {})

=== 수신 메시지들 ===

-- 네트워크 접속 완료
function on_message(self, message_id, message, sender)
    if message_id == hash("network_connected") then
        print("Connected! Player ID:", message.player_id)
        -- 접속 완료 후 처리
    end
end

-- 네트워크 상태 응답
elseif message_id == hash("network_state_response") then
    self.connected = message.connected
    self.my_player_id = message.my_player_id
    self.players = message.players
    self.debug_bodies = message.debug_bodies
end

-- 내 플레이어 상태 업데이트
elseif message_id == hash("my_player_update") then
    -- message.x, message.y, message.isControllable, message.session_id
    update_my_player_position(message)
end

-- 다른 플레이어 상태 업데이트
elseif message_id == hash("other_player_update") then
    -- message.x, message.y, message.session_id
    update_other_player_position(message)
end

-- 디버그 바디 정보 업데이트
elseif message_id == hash("debug_bodies_update") then
    -- message.bodies (배열)
    update_debug_display(message.bodies)
end

-- 전체 게임 상태 업데이트
elseif message_id == hash("game_state_update") then
    -- message.players, message.my_player_id
    update_all_players(message.players)
end

-- 플레이어 입장/퇴장
elseif message_id == hash("player_joined") then
    print("Player joined:", message.sessionId)
end

elseif message_id == hash("player_left") then
    print("Player left:", message.sessionId)
end

=== 예제 스크립트 ===
--]]

-- 예제 1: 플레이어 스크립트
--[[
function init(self)
    -- 네트워크 상태 요청
    msg.post("/network#client", "get_network_state", {})
end

function update(self, dt)
    -- 이동 입력이 있을 때 서버로 전송
    if self.move_vector and (self.move_vector.x ~= 0 or self.move_vector.y ~= 0) then
        msg.post("/network#client", "send_move", self.move_vector)
    end
end

function on_message(self, message_id, message, sender)
    if message_id == hash("network_connected") then
        self.my_player_id = message.player_id
        print("Player connected with ID:", self.my_player_id)
        
    elseif message_id == hash("my_player_update") then
        -- 서버에서 온 내 위치 업데이트
        msg.post("#movement", "update_position", {
            x = message.x,
            y = message.y,
            is_controllable = message.isControllable
        })
        
    elseif message_id == hash("other_player_update") then
        -- 다른 플레이어 위치 업데이트
        if message.session_id ~= self.my_player_id then
            msg.post("#other_players", "update_player", message)
        end
    end
end
--]]

-- 예제 2: 입력 관리 스크립트
--[[
function on_input(self, action_id, action)
    if action_id == hash("up") and action.pressed then
        msg.post("/network#client", "send_move", { x = 0, y = -1 })
    elseif action_id == hash("up") and action.released then
        msg.post("/network#client", "send_move", { x = 0, y = 0 })
    end
end
--]]

-- 예제 3: 디버그 시스템 스크립트
--[[
function init(self)
    self.debug_bodies = {}
    timer.delay(0.5, true, function()
        msg.post("/network#client", "request_debug_bodies", {})
    end)
end

function on_message(self, message_id, message, sender)
    if message_id == hash("debug_bodies_update") then
        self.debug_bodies = message.bodies
        -- 디버그 렌더링 업데이트
        render_debug_bodies(self.debug_bodies)
    end
end
--]]

return {} 