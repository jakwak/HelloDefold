-- 공유 색상 테이블
local M = {}

M.colors = {
	vmath.vector4(1, 1, 1, 1),     -- 흰색
	vmath.vector4(1, 0, 0, 1),     -- 빨강
	vmath.vector4(0, 1, 0, 1),     -- 초록
	vmath.vector4(0, 0, 1, 1),     -- 파랑
	vmath.vector4(1, 1, 0, 1),     -- 노랑
	vmath.vector4(1, 0, 1, 1),     -- 마젠타
	vmath.vector4(0, 1, 1, 1),     -- 시안
	vmath.vector4(0.5, 0, 0, 1),   -- 진한 빨강
	vmath.vector4(0, 0.5, 0, 1),   -- 진한 초록
	vmath.vector4(0, 0, 0.5, 1),   -- 진한 파랑
	vmath.vector4(1, 0.5, 0, 1),   -- 주황
	vmath.vector4(0.5, 0, 1, 1)    -- 보라
}

return M 