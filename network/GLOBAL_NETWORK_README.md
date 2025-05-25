# Global Network Manager 사용 가이드

기존 `client.script`를 참고하여 만든 간단하고 전역적인 네트워크 관리 시스템입니다.

## 주요 특징

- **전역 변수로 room 객체 관리**: `_G.network_room`으로 어디서든 접근 가능
- **간단한 API**: 복잡한 모듈 시스템 없이 직관적인 사용법
- **자동 재접속**: 연결이 끊어지면 자동으로 재접속 시도
- **브로드캐스트 메시지**: 모든 게임 오브젝트에게 네트워크 이벤트 전파

## 설정 방법

### 1. 게임 오브젝트 추가

1. Defold 에디터에서 새 Game Object 생성
2. 이름을 `global_network`로 설정
3. `global_network.script`를 컴포넌트로 추가

### 2. 게임 컬렉션에 추가

`main.collection` 또는 메인 씬에 `global_network` 게임 오브젝트를 추가합니다.

```
/global_network (Game Object)
  └── global_network.script (Script Component)
```

### 3. 서버 설정 확인

`global_network.script` 파일에서 서버 URL 확인:

```lua
local SERVER_URL = "ws://localhost:2567"
local ROOM_NAME = "matter_room"
```

## 전역 변수들

스크립트가 실행되면 다음 전역 변수들이 사용 가능해집니다:

- `_G.network_room`: Colyseus 룸 객체
- `_G.network_connected`: 연결 상태 (boolean)
- `_G.my_session_id`: 내 세션 ID (string)
- `_G.players`: 모든 플레이어 데이터 (table)

## 전역 헬퍼 함수들

- `_G.send_to_server(message_type, data)`: 서버에 메시지 전송
- `_G.is_network_connected()`: 연결 상태 확인
- `_G.get_my_session_id()`: 내 세션 ID 반환
- `_G.get_players()`: 플레이어 데이터 반환
- `_G.get_network_room()`: 룸 객체 반환

## 기본 사용법

### 네트워크 상태 확인

```lua
function init(self)
    if _G.is_network_connected() then
        print("네트워크 연결됨! 세션 ID:", _G.get_my_session_id())
    else
        print("네트워크 연결 안됨")
    end
end
```

### 서버에 메시지 전송

```lua
-- 방법 1: 헬퍼 함수 사용
_G.send_to_server("move", { x = 100, y = 200 })

-- 방법 2: 직접 룸 객체 사용
if _G.network_room then
    _G.network_room:send("custom_action", { action = "jump" })
end

-- 방법 3: 메시지 시스템 사용
msg.post("/global_network#global_network", "send_move", { x = 100, y = 200 })
```

### 네트워크 이벤트 수신

```lua
function on_message(self, message_id, message, sender)
    if message_id == hash("network_connected") then
        print("네트워크 연결됨!")
        
    elseif message_id == hash("player_position_update") then
        if message.is_my_player then
            -- 내 플레이어 위치 업데이트
            update_my_player_position(message.x, message.y)
        else
            -- 다른 플레이어 위치 업데이트
            update_other_player_position(message.session_id, message.x, message.y)
        end
        
    elseif message_id == hash("player_removed") then
        print("플레이어 제거됨:", message.session_id)
    end
end
```

## 지원하는 메시지들

### 전송 (Global Network Manager에게)

- `send_move`: 이동 명령 전송
- `send_position`: 위치 동기화 전송
- `request_debug_bodies`: 디버그 바디 정보 요청
- `update_pad_position`: 패드 위치 업데이트
- `send_custom_message`: 커스텀 메시지 전송
- `disconnect`: 연결 해제
- `reconnect`: 재접속
- `get_network_state`: 네트워크 상태 요청

### 수신 (다른 스크립트들이 받는 메시지)

- `network_connected`: 네트워크 연결 성공
- `player_position_update`: 플레이어 위치 업데이트
- `player_name_update`: 플레이어 이름 업데이트
- `player_removed`: 플레이어 제거
- `debug_bodies_update`: 디버그 바디 정보 업데이트
- `move_response`: 이동 명령 응답
- `pad_position_update`: 패드 위치 업데이트
- `server_message`: 기타 서버 메시지

## 디버그 바디 관리

기존 `debug_server_bodies.script`와 연동됩니다:

```lua
-- 디버그 바디 정보 요청
msg.post("/global_network#global_network", "request_debug_bodies", {})

-- 디버그 바디 업데이트 수신
function on_message(self, message_id, message, sender)
    if message_id == hash("debug_bodies_update") then
        -- debug_server_bodies.script에서 자동으로 처리됨
        print("디버그 바디 수:", #message.bodies)
    end
end
```

## 플레이어 데이터 관리

```lua
-- 모든 플레이어 정보 조회
local players = _G.get_players()
for session_id, player_data in pairs(players) do
    print("플레이어:", session_id, "위치:", player_data.x, player_data.y)
end

-- 특정 플레이어 정보 조회
local my_id = _G.get_my_session_id()
local my_player = _G.get_players()[my_id]
if my_player then
    print("내 위치:", my_player.x, my_player.y)
end
```

## 에러 처리 및 재접속

시스템이 자동으로 처리하지만, 수동 제어도 가능합니다:

```lua
-- 수동 연결 해제
msg.post("/global_network#global_network", "disconnect", {})

-- 수동 재접속
msg.post("/global_network#global_network", "reconnect", {})

-- 연결 상태 확인
if not _G.is_network_connected() then
    print("네트워크 연결이 끊어져 있습니다.")
end
```

## 기존 client.script와의 차이점

| 기능 | client.script | global_network.script |
|------|---------------|----------------------|
| 복잡도 | 높음 (여러 모듈) | 낮음 (단일 파일) |
| room 접근 | 제한적 | 전역 변수로 자유 접근 |
| 모듈 의존성 | 많음 | 최소한 |
| 사용법 | 복잡 | 간단 |
| 메시지 시스템 | 큐 기반 | 직접 브로드캐스트 |

## 주의사항

1. **전역 변수 사용**: `_G` 네임스페이스를 사용하므로 이름 충돌 주의
2. **단일 룸**: 현재는 하나의 룸만 지원
3. **메모리 관리**: 플레이어가 많아지면 메모리 사용량 증가
4. **동기화**: 모든 변경사항이 즉시 전파되므로 성능 고려 필요

## 트러블슈팅

### 연결이 안 될 때
1. 서버 URL과 포트 확인
2. 서버가 실행 중인지 확인  
3. 콘솔 로그에서 에러 메시지 확인

### 메시지가 안 받아질 때
1. `on_message` 함수에서 hash() 사용 확인
2. 메시지 이름 철자 확인
3. 전역 변수 초기화 상태 확인

### 재접속이 안 될 때
1. 수동으로 `reconnect` 메시지 전송
2. 서버 상태 확인
3. 타이머 설정 확인 