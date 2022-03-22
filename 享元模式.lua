require("functions")

-- 内部状态
local TreeMode = class("TreeMode")
function TreeMode:ctor()
    self.image = "我是一棵树"
end
local treeMode = TreeMode.new()

local TreeBase = class("TreeBase")
function TreeBase:ctor()
    self.mode = treeMode
end
function TreeBase:Draw()
end
    
-- 外部状态
local Tree = class("Tree", TreeBase)
function Tree:ctor(name, color, height)
    self.super.ctor(self)
    self.name = name
    self.color = color
    self.height = height
    print("创建",self.mode.image, self.name, self.color, self.height)
end
function Tree:Draw()
    print("绘制", self.name)
end

-- 对象池
local TreeFactory = class("TreeFactory")
function TreeFactory:ctor()
    self.trees = {}
end
function TreeFactory:GetTree(name, color, height)
    if self.trees[name] then
        return self.trees[name]
    end
    local tree = Tree.new(name, color, height)
    self.trees[name] = tree
    return tree
end

-- test
local factory = TreeFactory.new()
factory:GetTree("树1",1,1):Draw()
factory:GetTree("树2",2,2):Draw()
factory:GetTree("树3",3,3):Draw()
factory:GetTree("树1",1,1):Draw()


-- 总结：在有大量对象时，把其中共同的部分抽象出来，直接返回在内存中已有的对象，避免重新创建。
-- 好处：减少对象的创建，减少内存的使用，提高性能。
-- 缺点：需要分离出内部状态和外部状态，提高系统的复杂度。
-- 场景：1.大量相似对象
--       2.需要缓冲对象池