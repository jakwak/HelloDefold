-- 네트워크 설정 상수들
local NetworkConfig = {}

-- 서버 연결 설정
NetworkConfig.SERVER_URL = "ws://localhost:2567"
NetworkConfig.PRODUCTION_SERVER = "gxg.kro.kr/game-server/"
NetworkConfig.ROOM_NAME = "matter_room"

-- 연결 설정
NetworkConfig.RECONNECT_DELAY = 3.0
NetworkConfig.PRODUCTION_PORT = 443
NetworkConfig.DEVELOPMENT_PORT = 2567

-- 메시지 타입들
NetworkConfig.MESSAGE_TYPES = {
  REGISTER_LISTENER = "register_listener",
  FACTORY_CREATED = "factory_created",
  PLAYER_TYPE = "player_type",
  NETWORK_CONNECTED = "network_connected",
  SEND_MOVE = "send_move",
  SEND_POSITION = "send_position",
  REQUEST_DEBUG_BODIES = "request_debug_bodies",
  UPDATE_PAD_POSITION = "update_pad_position",
  GET_NETWORK_STATE = "get_network_state",
  DISCONNECT = "disconnect",
  RECONNECT = "reconnect",
  SEND_CUSTOM_MESSAGE = "send_custom_message"
}

-- 이벤트 타입들
NetworkConfig.EVENT_TYPES = {
  ROOM_ERROR = "error",
  ROOM_LEAVE = "leave",
  PLAYER_ADD = "on_add",
  PLAYER_REMOVE = "on_remove"
}

-- 서버 메시지 타입들
NetworkConfig.SERVER_MESSAGE_TYPES = {
  DEBUG_BODIES = "debug_bodies",
  MOVE_RESPONSE = "move_response",
  PAD_POSITION_RESPONSE = "pad_position_response"
}

return NetworkConfig 