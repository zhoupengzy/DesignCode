require("functions")

local StateType =
{
    State_Stand = 1,
    State_Run = 2,
    State_Jump = 3,
    State_Fire = 4,
    State_Ice = 5,
}

-- 状态管理
local StateManger = class("StateManger")
function StateManger:ctor()
    self.runState = RunState.new()
    self.standState = StandState.new()
    self.jumpState = JumpState.new()
    self.fireState = FireState.new()
end


-- 接口
local ActionState = class("ActionState")
function ActionState:ChangeState(hero, state)
end

local StandState = class("StandState", ActionState)
function StandState:ctor(hero)
    hero.state = StateType.State_Stand
end
function StandState:Enter(hero)
    hero:Stand()
end
function StandState:ChangeState(hero, state)
    if state == StateType.State_Fire then
        hero.actionState = FireState.new(hero)
    elseif state == StateType.State_Jump then
        hero:Jump()
    elseif state == StateType.State_Run then
        hero:Run()
    end
end

local RunState = class("RunState", ActionState)
function RunState:Enter(hero)
    hero:Run()
end
function RunState:ChangeState(hero, state)
    if state == StateType.State_Fire then
        hero:Fire()
    elseif state == StateType.State_Jump then
        hero:Jump()
    elseif state == StateType.State_Stand then
        hero:Stand()
    end
end

local JumpState = class("JumpState", ActionState)
function JumpState:Enter(hero)
    hero:Jump()
end
function JumpState:ChangeState(hero, state)
    if state == StateType.State_Fire then
        hero:Fire()
    end
end
function JumpState:Update(hero)
    self.changeTime = self.changeTime + 1
    if self.changeTime >= 1 then
        hero:Stand()
    end
end

local FireState = class("FireState", ActionState)
function FireState:Enter(hero)
    hero:Fire()
end
function FireState:ChangeState(hero, state)
    if state == StateType.State_Stand then
        hero:Stand()
    end
end

local Hero = require("Hero")
function Hero:ctor()
    self.actionState = nil
end
function Hero:Run()
end
function Hero:Jump()
end
function Hero:Fire()
end
function Hero:Stand()
end
-- function Hero:Update(state)
--     if self.actionState.state == StateType.State_Fire then
--         self:Fire()
--     elseif state == StateType.State_Jump then
--         self:Jump()
--     elseif state == StateType.State_Run then
--         self:Run()
--     elseif state == StateType.State_Stand then
--         self:Stand()
--     end
-- end




local stateManager = StateManger.new()
local hero = Hero.new()

function KeyInput(input)
    if input == PRESS_A or intpu == PRESS_D then
        hero.actionState:ChangeState(self.hero, StateType.State_Run)
    elseif input == PRESS_W then
        hero.actionState:ChangeState(self.hero, StateType.State_Jump)
    elseif input == PRESS_S then
        hero.actionState:ChangeState(self.hero, StateType.State_Stand)
    elseif input == PRESS_SPACE then
        hero.actionState:ChangeState(self.hero, StateType.State_Fire)
    end
end


-- 总结：对象的行为是基于它的状态改变的
-- 优点：
-- 缺点：
-- 场景：