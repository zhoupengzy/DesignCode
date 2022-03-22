require("functions")

-- 事件中心
local EventCenter = class("EventCenter")
function EventCenter:ctor()
    self.eventList = {} -- 事件列表
    self.handleList = {} -- 句柄列表
end
function EventCenter:Subscribe(eventId, obj, func)
    local handle = closure(func, obj)
    self:Subscribe(eventId, handle)
end
function EventCenter:Subscribe(eventId, handle)
    if self.handleList[eventId] == nil then
        self.handleList[eventId] = {}
    end
    table.insert(self.handleList[eventId], handle)
end
function EventCenter:UnSubscribe(eventId, handle)
    if self.handleList[eventId] ~= nil then
        for k,v in pairs(self.handleList[eventId]) do
            if v == handle then
                self.handleList[eventId][k] = nil
                break
            end
        end
    end
end
function EventCenter:Notify(obj, eventId, data)
    table.insert(self.eventList, {obj, eventId, data})
end
function EventCenter:NotifyNow(obj, eventId, data)
    if self.handleList[eventId] ~= nil then
        for _,handle in pairs(self.handleList[eventId]) do
            handle(data, obj)
        end
    end
end
-- 线程安全
function EventCenter:Update()
    print("下一帧")
    if #self.eventList > 0 then
        for _,v in pairs(self.eventList) do
            self:NotifyNow(v[1], v[2], v[3])
        end
        self.eventList = {}
    end
end
function EventCenter:Clear()
    for k,_ in pairs(self.handleList) do
        self.handleList[k] = nil
    end
    self.handleList = {}
end

SingleEventCenter = EventCenter.new()
local EventName = {
    Event1 = 1,
    Event2 = 2,
    Event3 = 3,
}

-- 被观察者(发送者)
local Sender = class("Sender")
function Sender:ctor()
    print("被观察者：", self)
end
function Sender:Send()
    print("延迟发送")
    SingleEventCenter:Notify(self, EventName.Event1, {"延迟事件1"})
    SingleEventCenter:Notify(self, EventName.Event2, {"延迟事件2"})
    SingleEventCenter:Notify(self, EventName.Event3, {"延迟事件3"})
end
function Sender:SendNow()
    print("立即发送")
    SingleEventCenter:NotifyNow(self, EventName.Event1, {"事件1"})
    SingleEventCenter:NotifyNow(self, EventName.Event2, {"事件2"})
    SingleEventCenter:NotifyNow(self, EventName.Event3, {"事件3"})
end

-- 观察者(接收者)
local Listener = class("Listener")
function Listener:ctor()
    SingleEventCenter:Subscribe(EventName.Event1, closure(self.OnEvent, self))
    SingleEventCenter:Subscribe(EventName.Event2, closure(self.OnEvent, self))
    SingleEventCenter:Subscribe(EventName.Event3, closure(self.OnEvent, self))
end
function Listener:OnEvent(data, sender)
    print("接收到事件", sender, next(data))
    -- dump(data)
end

-- test
local sender = Sender.new()
local listener = Listener.new()
sender:SendNow()
sender:Send()
SingleEventCenter:Update()

-- 总结：
-- 好处：
-- 缺点：
-- 场景：