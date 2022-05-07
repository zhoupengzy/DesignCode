require("functions")

local ActionStateType =
{
    State_Idle = 1,
    State_Run = 2,
    State_Jump = 3,
    State_Down = 5,
    State_Weapon_Fire = 6,
    State_Weapon_Charge = 7,
    State_Weapon_Switch = 8,
    State_Weapon_Fire = 9,
}


local Hero = class("Hero")
function Hero:ctor(state1, state2)
    self.actionState = state1
    self.weaponState = state2
end
-- action
function Hero:Run()
    print("英雄正在跑动")
end
function Hero:Jump()
    print("英雄正在跳跃")
end
function Hero:Idle()
    print("英雄正在站立")
end
function Hero:Down()
    print("英雄正在卧倒")
end
-- 
function Hero:Fire()
    print("英雄正在开火")
end

function Hero:ChangeState(state)
    local state = self.actionState:ChangeState(state)
    if state then
        self.actionState = state
        self.actionState:Enter(self)
    end
    -- state = self.weaponState:ChangeState(state)
    -- if state then
    --     self.weaponState = state
    --     self.weaponState:Enter(self)
    -- end
end
function Hero:Update()
    self.actionState:Update(self )
end


-- 接口
local ActionState = class("ActionState")
function ActionState:ctor()
end
function ActionState:ChangeState(state)
end
function ActionState:Update(hero)
end


local IdleState = class("IdleState", ActionState)
function IdleState:ctor()
    self.stateType = ActionStateType.State_Idle
end
function IdleState:Enter(hero)
    hero:Idle()
end
function IdleState:ChangeState(state)
    if state.stateType == ActionStateType.State_Fire 
            or state.stateType == ActionStateType.State_Jump 
            or state.stateType == ActionStateType.State_Run then
        return state
    else 
        return nil
    end
end

local RunState = class("RunState", ActionState)
function RunState:ctor()
    self.stateType = ActionStateType.State_Run
end
function RunState:Enter(hero)
    hero:Run()
end
function RunState:ChangeState(state)
    if state.stateType == ActionStateType.State_Fire
            or state.stateType == ActionStateType.State_Jump
            or state.stateType == ActionStateType.State_Idle then
        return state
    else
        return nil
    end
end

local JumpState = class("JumpState", ActionState)
function JumpState:ctor()
    self.stateType = ActionStateType.State_Jump
    self.runTime = 0
end
function JumpState:Enter(hero)
    hero:Jump()
end
function JumpState:ChangeState(state)
    if state.stateType == ActionStateType.State_Fire then
        return state
    elseif state.stateType == ActionStateType.State_Idle
        and self.runTime >= 1 then
        return state
    else
        return nil
    end
end
function JumpState:Update(hero)
    self.runTime = self.runTime + 0.1
    if self.runTime >= 1 then
        hero:ChangeState(IdleState.new())
    end
end

local StateDown = class("StateDown", ActionState)
function StateDown:ctor()
    self.stateType = ActionStateType.State_Down
end
function StateDown:Enter(hero)
    hero:Down()
end
function StateDown:ChangeState(state)
   if state.stateType == ActionStateType.State_Idle then
        return state
    else
        return nil
    end
end

local StateManager =  class("StateManager")
function StateManager:ctor()
    self.manager = {}
end
function StateManager:GetState(stateType)
    if self.manager[stateType] then
        return self.manager[stateType]
    else
        if stateType == ActionStateType.State_Run then
            return RunState.new()
        elseif stateType == ActionStateType.State_Jump then
            return JumpState.new()
        elseif stateType == ActionStateType.State_Idle then
            return IdleState.new()
        else
            return nil
        end
    end
end

local stateManager = StateManager.new()
local hero = Hero.new(stateManager:GetState(ActionStateType.State_Idle))

function KeyInput(input)
    if input == "PRESS_A" or intpu == "PRESS_D" then
        hero:ChangeState(stateManager:GetState(ActionStateType.State_Run))
    elseif input == "PRESS_W" then
        hero:ChangeState(stateManager:GetState(ActionStateType.State_Jump))
    elseif input == "PRESS_S" then
        hero:ChangeState(stateManager:GetState(ActionStateType.State_Idle))
    end
end

print("开始游戏")
KeyInput("PRESS_A")
KeyInput("PRESS_W")
KeyInput("PRESS_S")
KeyInput("PRESS_A")
for i=1,20 do
    KeyInput("PRESS_A")
    hero:Update()
end
KeyInput("PRESS_S")
KeyInput("PRESS_A")

print("结束游戏")

-- 总结：对象的行为是基于它的状态改变的
-- 优点：
-- 缺点：
-- 场景：玩家控制,怪物AI,UI状态,流程控制