-- Minetest mod "goto waypoint"
-- Easily find place by coordinates in game world.

--This library is free software; you can redistribute it and/or
--modify it under the terms of the GNU Lesser General Public
--License as published by the Free Software Foundation; either
--version 2.1 of the License, or (at your option) any later version.

goto_waypoint = {}
goto_waypoint.huds = {}

minetest.register_chatcommand("goto", {
	params = "Coordinates",
	description = "Write coordinates to see them in world.",
	func = function(playername, text)
        text = string.sub(text, 1 , 25);
    
        local s0 = string.split(text, ' ');
        local s1 = {}
        local s2 = {}
        local s3 = {}
        local x,y,z,t = nil;
        if #s0 > 0 then
            s1 = string.split(s0[1], ',');
            if #s1 > 2 then
                z = s1[3];
            end
            if #s1 > 1 then
                y = s1[2];
            end
            if #s1 > 0 then
                x = s1[1];
            end
        end
        if #s0 > 1 then
            s2 = string.split(s0[2], ',');
            if #s2 > 0 then
                if y == nil then
                    y = s2[1];
                elseif z == nil then
                    z = s2[1];
                else
                    t = s2[1];
                end
            end
            if #s2 > 1 then
                if z == nil then
                    z = s2[2];
                elseif t == nil then
                    t = s2[1];
                end
            end
        end
        if #s0 > 2 then
            s3 = string.split(s0[3], ',');
            if #s3 > 0 then
                if z == nil then
                    z = s3[1];
                elseif t == nil then
                    t = s3[1];
                end
            end
        end
        
        local player = minetest.get_player_by_name(playername);
        
        if x == nil or y == nil then
            if goto_waypoint.huds[playername] ~= nil and #goto_waypoint.huds[playername] > 0 then
                minetest.chat_send_player( playername, "Waypoints cleared");
                minetest.log("action", "Player <"..playername.."> cleared waypoints");
                for key, val in pairs(goto_waypoint.huds[playername]) do
                    player:hud_remove(key);
                    goto_waypoint.huds[playername][key] = nil;
                end
            end
            return
        end
        
        if z == nil then
            z = y;
            y = ""..player:getpos().y;
        end
        
        x = x:gsub("%(", "");
        y = y:gsub("%)", "");
        z = z:gsub("%)", "");
        
        if tonumber(z) == nil then
            t = z;
            z = y;
            y = player:getpos().y;
        end
        
        x = tonumber(x);
        y = tonumber(y);
        z = tonumber(z);
        
        if x == nil or y == nil or z == nil then
            return
        end
        
        if t == nil then
            t = " ("..x..","..y..","..z..")";
        else
            t = " "..t;
        end
        
        
        
        if not goto_waypoint.huds[playername] then
            goto_waypoint.huds[playername] = {}
        end
        
        local hudid = player:hud_add({
            hud_elem_type = "waypoint",
            name = "goto:",
            text = t,
            number = 30000,
            world_pos = {x=x, y=y, z=z},
        });
        
        minetest.chat_send_player( playername, "Waypoint set to "..t);
        minetest.log("action", "Player <"..playername.."> goto "..t);
        
        goto_waypoint.huds[playername][hudid] = hudid;
        
	end,
})