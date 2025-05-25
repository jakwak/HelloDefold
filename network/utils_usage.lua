-- utils.lua 사용법 예시

local utils = require "network.utils"

-- 예시 테이블 데이터
local sample_data = {
    players = {
        player1 = { x = 100, y = 200, name = "김철수" },
        player2 = { x = 150, y = 300, name = "이영희" }
    },
    gameState = "playing",
    timestamp = 1234567890,
    config = {
        max_players = 4,
        game_mode = "battle"
    }
}

local old_data = {
    players = {
        player1 = { x = 90, y = 200, name = "김철수" },
        player2 = { x = 150, y = 300, name = "이영희" }
    },
    gameState = "waiting",
    timestamp = 1234567880
}

-- 예시 1: 기본 테이블 출력
print("=== 예시 1: 기본 테이블 출력 ===")
utils.print_table(sample_data)

-- 예시 2: JSON 스타일 출력
print("\n=== 예시 2: JSON 스타일 출력 ===")
print(utils.table_to_string(sample_data))

-- 예시 3: 테이블 크기 확인
print("\n=== 예시 3: 테이블 크기 ===")
print("sample_data 크기:", utils.table_size(sample_data))
print("players 크기:", utils.table_size(sample_data.players))

-- 예시 4: 테이블 요약 출력
print("\n=== 예시 4: 테이블 요약 ===")
print("sample_data 요약:", utils.table_summary(sample_data))
print("players 요약:", utils.table_summary(sample_data.players))

-- 예시 5: 테이블 비교
print("\n=== 예시 5: 테이블 비교 ===")
local changes = utils.compare_tables(old_data, sample_data)
utils.print_changes(changes)

-- 예시 6: 키와 타입 정보 출력
print("\n=== 예시 6: 키와 타입 정보 ===")
utils.print_keys_and_types(sample_data, "샘플 데이터")

-- 예시 7: 특정 키들만 출력
print("\n=== 예시 7: 특정 키들만 출력 ===")
local specific_keys = {"players", "gameState", "timestamp"}
utils.print_specific_keys(sample_data, specific_keys, "게임 관련 키들")

-- 예시 8: 디버그 출력 (올인원)
print("\n=== 예시 8: 디버그 출력 ===")
utils.debug_print(sample_data, "샘플 게임 데이터")

-- 예시 9: 테이블 복사
print("\n=== 예시 9: 테이블 복사 ===")
local shallow_copy = utils.shallow_copy(sample_data)
local deep_copy = utils.deep_copy(sample_data)

print("원본 수정 전:")
print("원본 player1.x:", sample_data.players.player1.x)
print("얕은 복사 player1.x:", shallow_copy.players.player1.x)
print("깊은 복사 player1.x:", deep_copy.players.player1.x)

-- 원본 수정
sample_data.players.player1.x = 999

print("\n원본 수정 후:")
print("원본 player1.x:", sample_data.players.player1.x)
print("얕은 복사 player1.x:", shallow_copy.players.player1.x)  -- 같이 변경됨 (참조 공유)
print("깊은 복사 player1.x:", deep_copy.players.player1.x)     -- 변경 안됨 (독립적 복사)

-- 예시 10: 실용적인 사용 케이스
print("\n=== 예시 10: 실용적인 사용 케이스 ===")

-- Colyseus state 처리 예시
function handle_state_change(new_state, previous_state)
    print("State 변경 감지!")
    
    -- 간단한 요약 출력
    print("State 요약:", utils.table_summary(new_state))
    
    -- 변경사항만 출력
    if previous_state then
        local changes = utils.compare_tables(previous_state, new_state)
        if #changes > 0 then
            print("변경사항:")
            utils.print_changes(changes)
        else
            print("변경사항 없음")
        end
    end
    
    -- 특정 게임 데이터만 확인
    local game_keys = {"players", "gameState", "score"}
    utils.print_specific_keys(new_state, game_keys, "게임 상태")
end

-- 테스트 데이터로 실행
local test_state = {
    players = { count = 2 },
    gameState = "playing",
    score = { team1 = 10, team2 = 8 }
}

local prev_state = {
    players = { count = 1 },
    gameState = "waiting",
    score = { team1 = 0, team2 = 0 }
}

handle_state_change(test_state, prev_state)

return {
    utils = utils,
    handle_state_change = handle_state_change
} 