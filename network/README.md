# Network Module 사용법

개선된 Colyseus 클라이언트는 기능별로 모듈화되어 있습니다.

## 파일 구조

- `colyseus_client.lua` - 메인 인터페이스
- `connection_manager.lua` - 서버 접속 관리
- `room_manager.lua` - 룸 조인/생성 관리
- `message_handler.lua` - 메시지/콜백 관리
- `sync_manager.lua` - 동기화 통합 관리

## 기본 사용법

### 1. 초기화 (메인 스크립트에서)

```lua
local colyseus_client = require "network.colyseus_client"

function init(self)
    -- 가장 먼저 초기화
    colyseus_client.init()
    
    -- 서버 접속 및 룸 조인
    colyseus_client.connect_and_join(
        "ws://localhost:2567",
        "my_room",
        {},  -- 옵션
        function(room)
            print("Successfully joined room!")
        end,
        function(error)
            print("Connection failed:", error)
        end
    )
end
```

### 2. 플레이어 동기화 (player.lua에서)

```lua
local sync_manager = require "network.sync_manager"

local M = {}

function M.init()
    -- 다른 플레이어 업데이트 수신
    sync_manager.on_player_update(function(player_data)
        M.update_remote_player(player_data)
    end)
end

function M.send_position(x, y)
    -- 내 위치 전송
    sync_manager.send_player_update({
        id = M.player_id,
        x = x,
        y = y,
        timestamp = socket.gettime()
    })
end

function M.update_remote_player(player_data)
    -- 다른 플레이어 위치 업데이트
    if player_data.id ~= M.player_id then
        -- 위치 적용 로직
    end
end

return M
```

### 3. 패드 동기화 (input 파일에서)

```lua
local sync_manager = require "network.sync_manager"

local M = {}

function M.init()
    -- 패드 상태 변경 수신
    sync_manager.on_pad_update(function(pad_data)
        M.update_pad_state(pad_data)
    end)
end

function M.send_pad_input(action, pressed)
    sync_manager.send_pad_update({
        player_id = M.player_id,
        action = action,
        pressed = pressed,
        timestamp = socket.gettime()
    })
end

function M.update_pad_state(pad_data)
    -- 다른 플레이어의 입력 상태 반영
end

return M
```

### 4. 디버그 정보 동기화

```lua
local sync_manager = require "network.sync_manager"

local M = {}

function M.init()
    -- 디버그 정보 수신
    sync_manager.on_debug_update(function(debug_data)
        M.update_debug_display(debug_data)
    end)
end

function M.send_debug_info(info)
    sync_manager.send_debug_update({
        player_id = M.player_id,
        physics_bodies = info.bodies,
        collision_data = info.collisions,
        performance = info.performance
    })
end

return M
```

### 5. 게임 상태 동기화

```lua
local sync_manager = require "network.sync_manager"

local M = {}

function M.init()
    -- 전체 게임 상태 변경 수신
    sync_manager.on_game_state_change(function(state)
        M.update_game_state(state)
    end)
end

function M.update_game_state(state)
    -- 게임 상태 전체 업데이트
    for player_id, player_data in pairs(state.players) do
        -- 플레이어 상태 업데이트
    end
    
    for pad_id, pad_data in pairs(state.pads) do
        -- 패드 상태 업데이트
    end
end

return M
```

## 고급 사용법

### 직접 메시지 핸들러 사용

```lua
local message_handler = require "network.message_handler"

-- 커스텀 메시지 타입 등록
message_handler.register_handler("custom_event", function(data)
    print("Custom event received:", data)
end)

-- 메시지 전송
message_handler.send_message("custom_event", { msg = "Hello!" })
```

### 연결 상태 관리

```lua
local connection_manager = require "network.connection_manager"
local room_manager = require "network.room_manager"

-- 연결 상태 확인
if connection_manager.is_connected() then
    print("Connected to server")
end

if room_manager.is_in_room() then
    print("In room")
end
```

## 일괄 업데이트 (성능 최적화)

```lua
local sync_manager = require "network.sync_manager"

-- 여러 정보를 한번에 전송
sync_manager.send_bulk_update({
    player = { x = 100, y = 200 },
    pad = { action = "jump", pressed = true },
    debug = { fps = 60, physics_step = 0.016 }
})
``` 