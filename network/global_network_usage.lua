-- global_network.script 사용법 예시

--[[
global_network.script를 사용하기 위해서는:

1. game.project에 global_network.script를 게임 오브젝트로 추가
2. 전역 변수들을 통해 네트워크 상태에 액세스

전역 변수들:
- _G.network_room: Colyseus 룸 객체
- _G.network_connected: 연결 상태 (boolean)
- _G.my_session_id: 내 세션 ID
- _G.players: 모든 플레이어 데이터 테이블

전역 헬퍼 함수들:
- _G.send_to_server(message_type, data): 서버에 메시지 전송
- _G.is_network_connected(): 연결 상태 확인
- _G.get_my_session_id(): 내 세션 ID 반환
- _G.get_players(): 플레이어 데이터 반환
- _G.get_network_room(): 룸 객체 반환
]]

-- 예시 1: 다른 스크립트에서 네트워크 상태 확인
function check_network_status()
    if _G.is_network_connected() then
        print("네트워크 연결됨! 세션 ID:", _G.get_my_session_id())
        print("플레이어 수:", table_length(_G.get_players()))
    else
        print("네트워크 연결 안됨")
    end
end

-- 예시 2: 서버에 이동 명령 전송
function send_move_command(x, y)
    local success = _G.send_to_server("move", {
        x = x,
        y = y,
        timestamp = os.time()
    })
    
    if success then
        print("이동 명령 전송 성공:", x, y)
    else
        print("이동 명령 전송 실패 - 네트워크 연결 없음")
    end
end

-- 예시 3: 직접 룸 객체 사용
function send_custom_message()
    local room = _G.get_network_room()
    if room then
        room:send("custom_action", {
            action_type = "jump",
            power = 100
        })
        print("커스텀 메시지 전송")
    else
        print("룸 객체 없음")
    end
end

-- 예시 4: 플레이어 데이터 조회
function print_all_players()
    local players = _G.get_players()
    print("=== 플레이어 목록 ===")
    for session_id, player_data in pairs(players) do
        print(string.format("세션 ID: %s, X: %s, Y: %s, 이름: %s", 
            session_id, 
            player_data.x or "없음",
            player_data.y or "없음", 
            player_data.name or "없음"
        ))
    end
end

-- 예시 5: 네트워크 메시지 수신 (다른 스크립트에서)
function on_message(self, message_id, message, sender)
    if message_id == hash("network_connected") then
        print("네트워크 연결 알림 수신! 룸 ID:", message.room_id)
        
    elseif message_id == hash("player_position_update") then
        print("플레이어 위치 업데이트:", message.session_id, message.x, message.y)
        
        if message.is_my_player then
            print("내 플레이어 위치 업데이트")
        else
            print("다른 플레이어 위치 업데이트")
        end
        
    elseif message_id == hash("player_name_update") then
        print("플레이어 이름 업데이트:", message.session_id, message.name)
        
    elseif message_id == hash("player_removed") then
        print("플레이어 제거됨:", message.session_id)
        
    elseif message_id == hash("debug_bodies_update") then
        print("디버그 바디 업데이트 수신, 바디 수:", #message.bodies)
        
    elseif message_id == hash("server_message") then
        print("서버 메시지 수신:", message.type)
    end
end

-- 예시 6: 네트워크 관리자에게 메시지 전송
function request_debug_info()
    msg.post("/global_network#global_network", "request_debug_bodies", {})
end

function disconnect_from_server()
    msg.post("/global_network#global_network", "disconnect", {})
end

function reconnect_to_server()
    msg.post("/global_network#global_network", "reconnect", {})
end

-- 유틸리티 함수
function table_length(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

-- 예시 7: 게임 오브젝트 초기화에서 네트워크 상태 확인
function init_with_network_check(self)
    -- 네트워크 연결 상태 확인
    if _G.is_network_connected() then
        print("초기화 시점에 이미 네트워크 연결됨")
        -- 즉시 네트워크 관련 초기화 진행
        initialize_networked_features(self)
    else
        print("초기화 시점에 네트워크 연결 안됨, 연결 대기 중...")
        -- 네트워크 연결을 기다림
        self.waiting_for_network = true
    end
end

function initialize_networked_features(self)
    print("네트워크 기능 초기화")
    -- 여기에 네트워크 연결 후 실행할 코드 작성
end

-- 예시 8: 플레이어별 색상 관리
function get_player_color(session_id)
    local colors = {
        [1] = vmath.vector4(1, 0, 0, 1), -- 빨강
        [2] = vmath.vector4(0, 1, 0, 1), -- 초록
        [3] = vmath.vector4(0, 0, 1, 1), -- 파랑
        [4] = vmath.vector4(1, 1, 0, 1), -- 노랑
    }
    
    local players = _G.get_players()
    local player_list = {}
    for sid, _ in pairs(players) do
        table.insert(player_list, sid)
    end
    table.sort(player_list)
    
    for i, sid in ipairs(player_list) do
        if sid == session_id then
            return colors[i] or vmath.vector4(0.5, 0.5, 0.5, 1) -- 회색 기본값
        end
    end
    
    return vmath.vector4(0.5, 0.5, 0.5, 1) -- 기본 회색
end

return {
    check_network_status = check_network_status,
    send_move_command = send_move_command,
    send_custom_message = send_custom_message,
    print_all_players = print_all_players,
    request_debug_info = request_debug_info,
    disconnect_from_server = disconnect_from_server,
    reconnect_to_server = reconnect_to_server,
    init_with_network_check = init_with_network_check,
    get_player_color = get_player_color
} 