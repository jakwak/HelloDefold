-- debug_override.lua
-- 불필요한 로그 메시지를 필터링하는 모듈

local M = {}

-- 원본 print 함수를 저장
local original_print = print

-- 필터링할 메시지 패턴 목록
local filtered_messages = {
    "trying to remove ref_id that doesn't exist:",
    "on_message not registered for type \"update_pad_position\"",
}

-- print 함수 오버라이드
function M.override_print()
    print = function(...)
        local args = {...}
        local message = ""
        
        -- 모든 인자를 문자열로 연결
        for i, arg in ipairs(args) do
            message = message .. tostring(arg)
            if i < #args then
                message = message .. "\t"
            end
        end
        
        -- 필터링할 메시지인지 확인
        for _, filter in ipairs(filtered_messages) do
            if string.find(message, filter) then
                return -- 필터링된 메시지는 출력하지 않음
            end
        end
        
        -- 필터링되지 않은 메시지는 원본 print로 출력
        original_print(...)
    end
end

-- 원래 print 함수로 복원
function M.restore_print()
    print = original_print
end

-- 필터링할 메시지 추가
function M.add_filter(pattern)
    table.insert(filtered_messages, pattern)
end

return M 