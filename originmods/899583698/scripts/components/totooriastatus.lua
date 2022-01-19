local function oncurrentdengji(self,dengji)
    self.inst.currentdengji:set(dengji)
end

local function oncurrentjinengdian(self,jinengdian)
    self.inst.currentjinengdian:set(jinengdian)
end

local function oncurrentyijiajineng(self,yijiajineng)
    self.inst.currentyijiajineng:set(yijiajineng)
end

local function oncurrentxingyun(self,xingyun)
    self.inst.currentxingyun:set(xingyun)
end

local function oncurrentgongjili(self,gongjili)
    self.inst.currentgongjili:set(gongjili)
end

local function oncurrentxueliang(self,xueliang)
    self.inst.currentxueliang:set(xueliang)
end

local function oncurrentsudu(self,sudu)
    self.inst.currentsudu:set(sudu)
end

local function oncurrentyonggan(self,yonggan)
    self.inst.currentyonggan:set(yonggan)
end

local function oncurrentshixue(self,shixue)
    self.inst.currentshixue:set(shixue)
end

local function oncurrentlingqiao(self,lingqiao)
    self.inst.currentlingqiao:set(lingqiao)
end

local function oncurrentopen(self,open)
    self.inst.currentopen:set(open)
end

local function oncurrenttintdata01(self,tintdata01)
    self.inst.currenttintdata01:set(tintdata01)
end

local function oncurrenttintdata02(self,tintdata02)
    self.inst.currenttintdata02:set(tintdata02)
end

local function oncurrenttintdata03(self,tintdata03)
    self.inst.currenttintdata03:set(tintdata03)
end

local function oncurrenttintdata04(self,tintdata04)
    self.inst.currenttintdata04:set(tintdata04)
end

local function oncurrenttintdata05(self,tintdata05)
    self.inst.currenttintdata05:set(tintdata05)
end

local function oncurrenttintdata06(self,tintdata06)
    self.inst.currenttintdata06:set(tintdata06)
end

local function oncurrenttintdata07(self,tintdata07)
    self.inst.currenttintdata07:set(tintdata07)
end

local function oncurrenttintdata08(self,tintdata08)
    self.inst.currenttintdata08:set(tintdata08)
end

local function oncurrenttintdata09(self,tintdata09)
    self.inst.currenttintdata09:set(tintdata09)
end

local function oncurrenttintdata10(self,tintdata10)
    self.inst.currenttintdata10:set(tintdata10)
end

local function oncurrenttintdata11(self,tintdata11)
    self.inst.currenttintdata11:set(tintdata11)
end

local function oncurrenttintdata12(self,tintdata12)
    self.inst.currenttintdata12:set(tintdata12)
end

local function oncurrenttintdata13(self,tintdata13)
    self.inst.currenttintdata13:set(tintdata13)
end

local function oncurrenttintdata14(self,tintdata14)
    self.inst.currenttintdata14:set(tintdata14)
end

local function oncurrenttintdata15(self,tintdata15)
    self.inst.currenttintdata15:set(tintdata15)
end

local function oncurrenttintdata16(self,tintdata16)
    self.inst.currenttintdata16:set(tintdata16)
end

local function oncurrenttintdata17(self,tintdata17)
    self.inst.currenttintdata17:set(tintdata17)
end

local function oncurrenttintdata18(self,tintdata18)
    self.inst.currenttintdata18:set(tintdata18)
end

local function oncurrenttintdata19(self,tintdata19)
    self.inst.currenttintdata19:set(tintdata19)
end

local function oncurrenttintdata20(self,tintdata20)
    self.inst.currenttintdata20:set(tintdata20)
end

local function oncurrentdamage(self,damage)
    self.inst.currentdamage:set(damage)
end

local function oncurrentexp(self,exp)
    self.inst.currentexp:set(exp)
end

local function oncurrentexpold(self,expold)
    self.inst.currentexpold:set(expold)
end

local function oncurrentyoushanon(self,youshanon)
    self.inst.currentyoushanon:set(youshanon)
end

local function oncurrentdachuon(self,dachuon)
    self.inst.currentdachuon:set(dachuon)
end

local function oncurrentqiaoshouon(self,qiaoshouon)
    self.inst.currentqiaoshouon:set(qiaoshouon)
end

local function oncurrentxuezheon(self,xuezheon)
    self.inst.currentxuezheon:set(xuezheon)
end

local totooriastatus = Class(function(self, inst)
    self.inst = inst
    self.dengji = 0
    self.jinengdian = 0
    self.yijiajineng = 0
    self.xingyun = 0
    self.gongjili = 0
    self.xueliang = 0
    self.sudu = 0
    self.yonggan = 0
    self.shixue = 0
    self.lingqiao = 0
    self.open = 0
    self.tintdata01 = 0
    self.tintdata02 = 0
    self.tintdata03 = 0
    self.tintdata04 = 0
    self.tintdata05 = 0
    self.tintdata06 = 0
    self.tintdata07 = 0
    self.tintdata08 = 0
    self.tintdata09 = 0
    self.tintdata10 = 0
    self.tintdata11 = 0
    self.tintdata12 = 0
    self.tintdata13 = 0
    self.tintdata14 = 0
    self.tintdata15 = 0
    self.tintdata16 = 0
    self.tintdata17 = 0
    self.tintdata18 = 0
    self.tintdata19 = 0
    self.tintdata20 = 0
    self.youshanon = 1
    self.dachuon = 1
    self.qiaoshouon = 1
    self.xuezheon = 1
    self.damage = 7500
    self.exp = 0
    self.expold = 0
    self.expmod = 1
    self.tsanity = 200
    self.thealth = 75
end,
nil,
{
    dengji = oncurrentdengji,
    jinengdian = oncurrentjinengdian,
    yijiajineng = oncurrentyijiajineng,
    xingyun = oncurrentxingyun,
    gongjili = oncurrentgongjili,
    xueliang = oncurrentxueliang,
    sudu = oncurrentsudu,
    yonggan = oncurrentyonggan,
    shixue = oncurrentshixue,
    lingqiao = oncurrentlingqiao,
    open = oncurrentopen,
    damage = oncurrentdamage,
    exp = oncurrentexp,
    expold = oncurrentexpold,
    youshanon = oncurrentyoushanon,
    dachuon = oncurrentdachuon,
    qiaoshouon = oncurrentqiaoshouon,
    xuezheon = oncurrentxuezheon,
    tintdata01 = oncurrenttintdata01,
    tintdata02 = oncurrenttintdata02,
    tintdata03 = oncurrenttintdata03,
    tintdata04 = oncurrenttintdata04,
    tintdata05 = oncurrenttintdata05,
    tintdata06 = oncurrenttintdata06,
    tintdata07 = oncurrenttintdata07,
    tintdata08 = oncurrenttintdata08,
    tintdata09 = oncurrenttintdata09,
    tintdata10 = oncurrenttintdata10,
    tintdata11 = oncurrenttintdata11,
    tintdata12 = oncurrenttintdata12,
    tintdata13 = oncurrenttintdata13,
    tintdata14 = oncurrenttintdata14,
    tintdata15 = oncurrenttintdata15,
    tintdata16 = oncurrenttintdata16,
    tintdata17 = oncurrenttintdata17,
    tintdata18 = oncurrenttintdata18,
    tintdata19 = oncurrenttintdata19,
    tintdata20 = oncurrenttintdata20,
})

function totooriastatus:OnSave()
    local data = {
        dengji = self.dengji,
        jinengdian = self.jinengdian,
        yijiajineng = self.yijiajineng,
        xingyun = self.xingyun,
        gongjili = self.gongjili,
        xueliang = self.xueliang,
        sudu = self.sudu,
        yonggan = self.yonggan,
        shixue = self.shixue,
        lingqiao = self.lingqiao,
        exp = self.exp,
        tintdata01 = self.tintdata01,
        tintdata02 = self.tintdata02,
        tintdata03 = self.tintdata03,
        tintdata04 = self.tintdata04,
        tintdata05 = self.tintdata05,
        tintdata06 = self.tintdata06,
        tintdata07 = self.tintdata07,
        tintdata08 = self.tintdata08,
        tintdata09 = self.tintdata09,
        tintdata10 = self.tintdata10,
        tintdata11 = self.tintdata11,
        tintdata12 = self.tintdata12,
        tintdata13 = self.tintdata13,
        tintdata14 = self.tintdata14,
        tintdata15 = self.tintdata15,
        tintdata16 = self.tintdata16,
        tintdata17 = self.tintdata17,
        tintdata18 = self.tintdata18,
        tintdata19 = self.tintdata19,
        tintdata20 = self.tintdata20,
        tsanity = math.ceil(self.inst.components.sanity.current),
        thealth = math.ceil(self.inst.components.health.currenthealth),
    }
    return data
end

function totooriastatus:OnLoad(data)
    self.dengji = data.dengji or 0
    self.jinengdian = data.jinengdian or 0
    self.yijiajineng = data.yijiajineng or 0
    self.xingyun = data.xingyun or 0
    self.gongjili = data.gongjili or 0
    self.xueliang = data.xueliang or 0
    self.sudu = data.sudu or 0
    self.yonggan = data.yonggan or 0
    self.shixue = data.shixue or 0
    self.lingqiao = data.lingqiao or 0
    self.exp = data.exp or 0
    self.tintdata01 = data.tintdata01 or 0
    self.tintdata02 = data.tintdata02 or 0
    self.tintdata03 = data.tintdata03 or 0
    self.tintdata04 = data.tintdata04 or 0
    self.tintdata05 = data.tintdata05 or 0
    self.tintdata06 = data.tintdata06 or 0
    self.tintdata07 = data.tintdata07 or 0
    self.tintdata08 = data.tintdata08 or 0
    self.tintdata09 = data.tintdata09 or 0
    self.tintdata10 = data.tintdata10 or 0
    self.tintdata11 = data.tintdata11 or 0
    self.tintdata12 = data.tintdata12 or 0
    self.tintdata13 = data.tintdata13 or 0
    self.tintdata14 = data.tintdata14 or 0
    self.tintdata15 = data.tintdata15 or 0
    self.tintdata16 = data.tintdata16 or 0
    self.tintdata17 = data.tintdata17 or 0
    self.tintdata18 = data.tintdata18 or 0
    self.tintdata19 = data.tintdata19 or 0
    self.tintdata20 = data.tintdata20 or 0
    self.tsanity = data.tsanity or 200
    self.thealth = data.thealth or 75
    self.inst.components.sanity.max = math.ceil (200 + math.min(self.dengji, 20) * 10)
    self.inst.components.health.maxhealth = 75+self.xueliang*125/20
    self.inst.components.sanity:SetPercent(self.tsanity / self.inst.components.sanity.max)
    self.inst.components.health:SetPercent(self.thealth / self.inst.components.health.maxhealth)
end

function totooriastatus:DoDeltaYoushan(delta)
    self.youshanon = self.youshanon + delta
    self.inst:PushEvent("DoDeltaYoushan")
end

function totooriastatus:DoDeltaDachu(delta)
    self.dachuon = self.dachuon + delta
    self.inst:PushEvent("DoDeltaDachu")
end

function totooriastatus:DoDeltaQiaoshou(delta)
    self.qiaoshouon = self.qiaoshouon + delta
    self.inst:PushEvent("DoDeltaQiaoshou")
end

function totooriastatus:DoDeltaXuezhe(delta)
    self.xuezheon = self.xuezheon + delta
    self.inst:PushEvent("DoDeltaXuezhe")
end

function totooriastatus:DoDeltaExp(delta)
    if delta > 0 then
        self.expold = self.exp
        self.exp = self.exp + delta*self.expmod
    else
        self.expold = self.exp
        self.exp = self.exp + delta
    end
    self.inst:PushEvent("DoDeltaExpTTR")
end

return totooriastatus