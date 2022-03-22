-- local breakSocketHandle,debugXpCall = require("LuaDebug")("localhost",7003)

require("functions")
local Player = class("Player")
function Player:Jump()
    print("Player jump")
end
function Player:Fire()
    print("Player Fire")
end
function Player:Move(x,y)
    print("Player Move:"..x..","..y)
end

-- 定义命令接口
local Command = class("Command")
function Command:ctor()
    self.m_commandList = {}
end
function Command:Execute(player)
    print("Command:Execute() -- 接口")
end
function Command:UnDo()
    print("Command:UnDo() -- 接口")
end

-- 跳跃命令
local JumpCommand = class("JumpCommand", Command)
function JumpCommand:ctor()
    JumpCommand.super.ctor(self)
end
function JumpCommand:Execute(player)
    self.super.Execute(self, player)
    player:Jump()
end
function JumpCommand:UnDo(player)
    self.super.UnDo(self, player)
    player:Jump()
end

-- 开火命令
local FireCommand = class("FireCommand", Command)
function FireCommand:ctor()
    FireCommand.super.ctor(self)
end
function FireCommand:Execute(player)
    self.super.Execute(self,player)
    player:Fire()
end
function FireCommand:UnDo(player)
    self.super.UnDo(self,player)
    player:Fire()
end

-- 移动命令
local MoveCommand = class("MoveCommand", Command)
function MoveCommand:ctor(x, y)
    MoveCommand.super.ctor(self)
    self.x, self.y = x or 0, y or 0
end
function MoveCommand:Execute(player)
    self.super.Execute(self)
    player:Move(self.x, self.y)
end
function MoveCommand:UnDo(player)
    self.super.UnDo(self)
    player:Move(-self.x, -self.y)
end


-- 调用者
local InputHandler = class("InputHandler")
function InputHandler:ctor()
    self.jumpCommand = JumpCommand.new()
    self.fireCommand = FireCommand.new()
    self.pressed = "Jump"
end
function InputHandler:IsPressed(command)
    -- 判断是否触发命令
    if command == self.pressed then
        return true
    else
        return false
    end
end
function InputHandler:HandleInput()
    if self:IsPressed("Jump") then
        return self.jumpCommand
    elseif self:IsPressed("Fire") then
        return self.fireCommand
    elseif self:IsPressed("MoveUp") then
        return MoveCommand.new(0, 1)
    elseif self:IsPressed("MoveDown") then
        return MoveCommand.new(0, -1)
    end
    return nil
end

-- test
local player = Player.new()
local input = InputHandler.new()
local command = input:HandleInput()
if command then
    command:Execute(player)
    command:UnDo(player)
end

input.pressed = "MoveUp"
command = input:HandleInput()
if command then
    command:Execute(player)
    command:UnDo(player)
end

-- 总结：命令模式将"请求"封装成对象，以便使用不同的请求、队列、日志来参数化其他对象。
-- 好处：请求调用者input和请求接收者player之间解耦，也可以更换请求接收者，比如接收者可以是玩家，也可以是AI。
-- 缺点：
-- 场景：