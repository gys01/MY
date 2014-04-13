MY_TalkEx = MY_TalkEx or {}
local _MY_TalkEx = {}
local _L = MY.LoadLangPack()
MY_TalkEx.tTalkChannel = {
    ['NEARBY'] = false,
    ['FRIEND'] = false,
    ['TEAM'] = false,
    ['RAID'] = false,
    ['TONG'] = false,
    ['TONG_ALLIANCE'] = false,
    ['SENCE'] = false,
    ['FORCE'] = false,
    ['CAMP'] = false,
    ['WORLD'] = false,
}
MY_TalkEx.szTalk = ''
MY_TalkEx.tTrickChannel = 'RAID'
MY_TalkEx.tTrickFilter = 'RAID'
MY_TalkEx.tTrickFilterForce = 4
MY_TalkEx.szTrickTextBegin = '$zj斜眼看了身边的羊群，冥想了一会。'
MY_TalkEx.szTrickText = '$zj麻利的拔光了$mb的羊毛。'
MY_TalkEx.szTrickTextEnd = '$zj收拾了一下背包里的羊毛，希望今年能卖个好价钱。'
RegisterCustomData('MY_TalkEx.tTalkChannel')
RegisterCustomData('MY_TalkEx.szTalk')
RegisterCustomData('MY_TalkEx.tTrickChannel')
RegisterCustomData('MY_TalkEx.tTrickFilter')
RegisterCustomData('MY_TalkEx.tTrickFilterForce')
RegisterCustomData('MY_TalkEx.szTrickTextBegin')
RegisterCustomData('MY_TalkEx.szTrickText')
RegisterCustomData('MY_TalkEx.szTrickTextEnd')

_MY_TalkEx.tForce = { [-1] = _L['all force'] } for i=0,10,1 do _MY_TalkEx.tForce[i] = GetForceTitle(i) end
_MY_TalkEx.tFilter = { ['NEARBY'] = _L['nearby players where'], ['RAID'] = _L['teammates where'], }
_MY_TalkEx.tChannels = { 
    ['NEARBY'] = { szName = _L['nearby channel'], tCol = GetMsgFontColor("MSG_NORMAL", true) },
    ['FRIEND'] = { szName = _L['friend channel'], tCol = GetMsgFontColor("MSG_FRIEND", true) },
    ['TEAM'] = { szName = _L['team channel'], tCol = GetMsgFontColor("MSG_TEAM", true) },
    ['RAID'] = { szName = _L['raid channel'], tCol = GetMsgFontColor("MSG_TEAM", true) },
    ['TONG'] = { szName = _L['tong channel'], tCol = GetMsgFontColor("MSG_GUILD", true) },
    ['TONG_ALLIANCE'] = { szName = _L['tong alliance channel'], tCol = GetMsgFontColor("MSG_GUILD_ALLIANCE", true) },
    ['SENCE'] = { szName = _L['map channel'], tCol = GetMsgFontColor("MSG_MAP", true) },
    ['FORCE'] = { szName = _L['school channel'], tCol = GetMsgFontColor("MSG_SCHOOL", true) },
    ['CAMP'] = { szName = _L['camp channel'], tCol = GetMsgFontColor("MSG_CAMP", true) },
    ['WORLD'] = { szName = _L['world channel'], tCol = GetMsgFontColor("MSG_WORLD", true) },
}
_MY_TalkEx.OnUiLoad = function(wnd)
    local ui = MY.UI(wnd)
    -------------------------------------
    -- 喊话部分
    -------------------------------------
    -- 喊话输入框
    MY.UI.AddEdit('TalkEx','WndEdit_TalkEx_Talk',25,25,510,210,MY_TalkEx.szTalk,true):change(function() MY_TalkEx.szTalk = this:GetText() end)
    -- 喊话频道
    local i = 22
    for szChannel, tChannel in pairs(_MY_TalkEx.tChannels) do
        MY.UI.AddCheckBox('TalkEx','WndCheckBox_TalkEx_'..szChannel,540,i,tChannel.szName,tChannel.tCol,MY_TalkEx.tTalkChannel[szChannel]):check(
            function() MY_TalkEx.tTalkChannel[szChannel] = true end,
            function() MY_TalkEx.tTalkChannel[szChannel] = false end
        )
        i = i + 18
    end
    -- 喊话按钮
    MY.UI.AddButton('TalkEx','WndButton_TalkEx_Talk',540,210,_L['send'],{255,255,255}):click(function() 
        if #MY_TalkEx.szTalk == 0 then MY.Sysmsg(_L["please input something."].."\n",nil,{255,0,0}) return end
        for szChannel, bSend in pairs(MY_TalkEx.tTalkChannel) do
            if bSend then MY.Talk(PLAYER_TALK_CHANNEL[szChannel],MY_TalkEx.szTalk) end
        end
    end)
    -------------------------------------
    -- 调侃部分
    -------------------------------------
    -- 文本标题
    ui:find("#Text_TalkEx_Trick_With"):text(_L['have a trick with'])
    -- 调侃对象范围过滤器
    ui:find("#Text_TalkEx_Trick_Filter"):text(_MY_TalkEx.tFilter[MY_TalkEx.tTrickFilter])
    ui:find("#Button_TalkEx_Trick_Filter"):click(function()
        PopupMenu((function() 
            local t = {}
            for szFilterId,szTitle in pairs(_MY_TalkEx.tFilter) do
                table.insert(t,{
                    szOption = szTitle,
                    fnAction = function()
                        ui:find("#Text_TalkEx_Trick_Filter"):text(szTitle)
                        MY_TalkEx.tTrickFilter = szFilterId
                    end,
                })
            end
            return t
        end)())
    end)
    -- 调侃门派过滤器
    ui:find("#Text_TalkEx_Trick_Force"):text(_MY_TalkEx.tForce[MY_TalkEx.tTrickFilterForce])
    ui:find("#Button_TalkEx_Trick_Force"):click(function()
        PopupMenu((function() 
            local t = {}
            for szFilterId,szTitle in pairs(_MY_TalkEx.tForce) do
                table.insert(t,{
                    szOption = szTitle,
                    fnAction = function()
                        ui:find("#Text_TalkEx_Trick_Force"):text(szTitle)
                        MY_TalkEx.tTrickFilterForce = szFilterId
                    end,
                })
            end
            return t
        end)())
    end)
    -- 调侃内容输入框：第一句
    MY.UI.AddEdit('TalkEx','WndEdit_TalkEx_TrickBegin',25,285,510,25,MY_TalkEx.szTrickTextBegin,true):change(function() MY_TalkEx.szTrickTextBegin = this:GetText() end)
    -- 调侃内容输入框：调侃内容
    MY.UI.AddEdit('TalkEx','WndEdit_TalkEx_Trick',25,310,510,75,MY_TalkEx.szTrickText,true):change(function() MY_TalkEx.szTrickText = this:GetText() end)
    -- 调侃内容输入框：最后一句
    MY.UI.AddEdit('TalkEx','WndEdit_TalkEx_TrickEnd',25,385,510,25,MY_TalkEx.szTrickTextEnd,true):change(function() MY_TalkEx.szTrickTextEnd = this:GetText() end)
    -- 调侃发送频道提示框
    ui:find("#Text_TalkEx_Trick_Sendto"):text(_L['send to'])
    -- 调侃发送频道
    ui:find("#Text_TalkEx_Trick_Sendto_Filter"):text(_MY_TalkEx.tChannels[MY_TalkEx.tTrickChannel].szName)
    ui:find("#Text_TalkEx_Trick_Sendto_Filter"):color(_MY_TalkEx.tChannels[MY_TalkEx.tTrickChannel].tCol)
    ui:find("#Button_TalkEx_Trick_Sendto_Filter"):click(function()
        PopupMenu((function() 
            local t = {}
            for szChannel,tChannel in pairs(_MY_TalkEx.tChannels) do
                table.insert(t,{
                    szOption = tChannel.szName,
                    fnAction = function()
                        ui:find("#Text_TalkEx_Trick_Sendto_Filter"):text(tChannel.szName):color(tChannel.tCol)
                        MY_TalkEx.tTrickChannel = szChannel
                    end,
                    rgb = tChannel.tCol,
                })
            end
            return t
        end)())
    end)
    -- 调侃按钮
    MY.UI.AddButton('TalkEx','WndButton_TalkEx_Trick',435,415,_L['have a trick with'],{255,255,255}):click(function()
        if #MY_TalkEx.szTrickText == 0 then MY.Sysmsg(_L["please input something."].."\n",nil,{255,0,0}) return end
        local tPlayers, iPlayers = {}, 0
        if MY_TalkEx.tTrickFilter == 'RAID' then
            for _, dwID in pairs(GetClientTeam().GetTeamMemberList()) do
                local p = GetPlayer(dwID)
                if p and (MY_TalkEx.tTrickFilterForce == -1 or MY_TalkEx.tTrickFilterForce == p.dwForceID) then
                    tPlayers[dwID] = p
                    iPlayers = iPlayers + 1
                end
            end
        elseif MY_TalkEx.tTrickFilter == 'NEARBY' then
            for dwID, p in pairs(MY.GetNearPlayer()) do
                if MY_TalkEx.tTrickFilterForce == -1 or MY_TalkEx.tTrickFilterForce == p.dwForceID then
                    tPlayers[dwID] = p
                    iPlayers = iPlayers + 1
                end
            end
        end
        -- 去掉自己 _(:з」∠)_调侃自己是闹哪样
        if tPlayers[GetClientPlayer().dwID] then iPlayers=iPlayers-1 tPlayers[GetClientPlayer().dwID]=nil end
        -- none target
        if iPlayers == 0 then MY.Sysmsg(_L["no trick target found."].."\n",nil,{255,0,0}) return end
        -- start tricking
        if #MY_TalkEx.szTrickTextBegin > 0 then MY.Talk(PLAYER_TALK_CHANNEL[MY_TalkEx.tTrickChannel], MY_TalkEx.szTrickTextBegin) end
        for _, player in pairs(tPlayers) do
            local szText = string.gsub(MY_TalkEx.szTrickText, "%$mb", '['..player.szName..']')
            MY.Talk(PLAYER_TALK_CHANNEL[MY_TalkEx.tTrickChannel], szText)
        end
        if #MY_TalkEx.szTrickTextEnd > 0 then MY.Talk(PLAYER_TALK_CHANNEL[MY_TalkEx.tTrickChannel], MY_TalkEx.szTrickTextEnd) end
    end)
end
_MY_TalkEx.OnDataLoad = function(wnd)
    local ui = MY.UI(wnd)
    -------------------------------------
    -- 喊话部分
    -------------------------------------
    -- 喊话输入框
    ui:find("#WndEdit_TalkEx_Talk"):text(MY_TalkEx.szTalk)
    -- 喊话频道
    for szChannel, tChannel in pairs(_MY_TalkEx.tChannels) do
        ui:find('#WndCheckBox_TalkEx_'..szChannel):check(MY_TalkEx.tTalkChannel[szChannel])
    end
    -- 喊话按钮
    ui:find('#WndButton_TalkEx_Talk'):text(_L['send'])
    -------------------------------------
    -- 调侃部分
    -------------------------------------
    -- 文本标题
    ui:find("#Text_TalkEx_Trick_With"):text(_L['have a trick with'])
    -- 调侃对象范围过滤器
    ui:find("#Text_TalkEx_Trick_Filter"):text(_MY_TalkEx.tFilter[MY_TalkEx.tTrickFilter])
    -- 调侃门派过滤器
    ui:find("#Text_TalkEx_Trick_Force"):text(_MY_TalkEx.tForce[MY_TalkEx.tTrickFilterForce])
    -- 调侃内容输入框：第一句
    ui:find('#WndEdit_TalkEx_TrickBegin'):text(MY_TalkEx.szTrickTextBegin)
    -- 调侃内容输入框：调侃内容
    ui:find('#WndEdit_TalkEx_Trick'):text(MY_TalkEx.szTrickText)
    -- 调侃内容输入框：最后一句
    ui:find('#WndEdit_TalkEx_TrickEnd'):text(MY_TalkEx.szTrickTextEnd)
    -- 调侃发送频道提示框
    ui:find("#Text_TalkEx_Trick_Sendto"):text(_L['send to'])
    -- 调侃发送频道
    ui:find("#Text_TalkEx_Trick_Sendto_Filter"):text(_MY_TalkEx.tChannels[MY_TalkEx.tTrickChannel].szName)
    ui:find("#Text_TalkEx_Trick_Sendto_Filter"):color(_MY_TalkEx.tChannels[MY_TalkEx.tTrickChannel].tCol)
    -- 调侃按钮
    ui:find('#WndButton_TalkEx_Trick'):text(_L['have a trick with'])
end
MY.RegisterPanel("TalkEx", _L["talk ex"], "interface\\MY\\ui\\MY_TalkEx.ini", "UI/Image/UICommon/ScienceTreeNode.UITex", 123, {255,255,0,200}, _MY_TalkEx.OnUiLoad, _MY_TalkEx.OnDataLoad )