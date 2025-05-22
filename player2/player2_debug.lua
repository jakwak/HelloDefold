local M = {}

local DEBUG_COLOR = vmath.vector4(0, 1, 0, 0.7) -- 초록색 (RGBA)
local debug_bodies = {} -- 현재 표시할 바디 목록

function M.debug_draw(self)
    if #debug_bodies == 0 then
        return
    end
    for _, body in ipairs(debug_bodies) do
        if body and body.shape then
            if body.shape == "rectangle" then
                if body.width and body.height then
                    msg.post("@render:", "draw_line", {
                        start_point = vmath.vector3(body.x - body.width/2, body.y - body.height/2, 0),
                        end_point = vmath.vector3(body.x + body.width/2, body.y - body.height/2, 0),
                        color = DEBUG_COLOR
                    })
                    msg.post("@render:", "draw_line", {
                        start_point = vmath.vector3(body.x + body.width/2, body.y - body.height/2, 0),
                        end_point = vmath.vector3(body.x + body.width/2, body.y + body.height/2, 0),
                        color = DEBUG_COLOR
                    })
                    msg.post("@render:", "draw_line", {
                        start_point = vmath.vector3(body.x + body.width/2, body.y + body.height/2, 0),
                        end_point = vmath.vector3(body.x - body.width/2, body.y + body.height/2, 0),
                        color = DEBUG_COLOR
                    })
                    msg.post("@render:", "draw_line", {
                        start_point = vmath.vector3(body.x - body.width/2, body.y + body.height/2, 0),
                        end_point = vmath.vector3(body.x - body.width/2, body.y - body.height/2, 0),
                        color = DEBUG_COLOR
                    })
                end
            elseif body.shape == "circle" and body.radius then
                local segments = 16
                local angle_step = 2 * math.pi / segments
                for i = 0, segments - 1 do
                    local angle1 = i * angle_step
                    local angle2 = (i + 1) * angle_step
                    local x1 = body.x + body.radius * math.cos(angle1)
                    local y1 = body.y + body.radius * math.sin(angle1)
                    local x2 = body.x + body.radius * math.cos(angle2)
                    local y2 = body.y + body.radius * math.sin(angle2)
                    msg.post("@render:", "draw_line", {
                        start_point = vmath.vector3(x1, y1, 0),
                        end_point = vmath.vector3(x2, y2, 0),
                        color = DEBUG_COLOR
                    })
                end
            end
            local cross_size = 5
            msg.post("@render:", "draw_line", {
                start_point = vmath.vector3(body.x - cross_size, body.y, 0),
                end_point = vmath.vector3(body.x + cross_size, body.y, 0),
                color = DEBUG_COLOR
            })
            msg.post("@render:", "draw_line", {
                start_point = vmath.vector3(body.x, body.y - cross_size, 0),
                end_point = vmath.vector3(body.x, body.y + cross_size, 0),
                color = DEBUG_COLOR
            })
        end
    end
end

function M.setup_debug_callbacks(self, room_callbacks)
    if not room_callbacks or not self or not self.room then return end
    local room = self.room
    timer.delay(1, false, function()
        if self.is_connected and room then
            room:send("get_debug_bodies", {})
        end
    end)
    room:on_message("debug_bodies_update", function(message)
        debug_bodies = {}
        for i, body_data in ipairs(message.bodies) do
            table.insert(debug_bodies, {
                label = body_data.label,
                x = body_data.x,
                y = body_data.y,
                width = body_data.width,
                height = body_data.height,
                radius = body_data.radius,
                shape = body_data.shape,
                isStatic = body_data.isStatic
            })
        end
    end)

end

return function(self, room_callbacks)
    return M.debug_draw, function() return M.setup_debug_callbacks(self, room_callbacks) end
end 