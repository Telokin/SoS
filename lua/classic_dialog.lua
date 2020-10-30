--[[
    This file override original functions
    See: interface_utlis.lua
    See: interface.lua
]]--

function FROMOW_SHOW_GAMEDIALOG(DATA) -- OW CALLS THIS!
    dialog.game.FORMID = DATA.FORMID;

    if (interface.current.side == 'Alien') then
        classicDialog = getDialog(DATA);
    else -- old code below
        sgui_deletechildren(dialog.game.panel.ID);

        local b = nil;
        local list = {};

        local h = 10;
        local w = 360 - 20;
        local mh = getHeight(dialog.game) - getHeight(dialog.game.panel);
        local mw = getWidth(dialog.game) - getWidth(dialog.game.panel);

        for i= 1, DATA.COUNT do
            b = getImageButtonEX(
                    dialog.game.panel,
                    anchorLT,
                    XYWH(0,h,0,24),
                    DATA.LIST[i],
                    '',
                    'HideDialog(dialog.game);OW_FORM_CLOSE(dialog.game.FORMID,'..(i)..');',
                    SKINTYPE_BUTTON,
                    {
                        autosize = true
                    }
                );
            
            UpdateDialogButton(b, interface.current.dialog.button);
            sgui_autosizecheck(b.ID);

            if getWidth(b) > w then
                w = getWidth(b);
            end;

            h = h + getHeight(b) + 4;

            list[i] = b;
        end;

        w = w + 20;

        setWidth(dialog.game,mw+w);

        local lab = getLabelEX(
            dialog.game.panel, 
            anchorLT, 
            XYWH(0,0,0,0),
            Tahoma_16, 
            DATA.QUESTION, 
            {
                wordwrap = true,
                autosize = true,
                automaxwidth = w
            }
        );

        sgui_autosizecheck(lab.ID);

        h = h + getHeight(lab);

        for i = 1, DATA.COUNT do
            setWidth(list[i], w);
            setY(list[i], getY(list[i]) + getHeight(lab));
        end;

        setHeight(dialog.game, mh + h);
        ShowDialog(dialog.game);
        OF_HideDialog(dialog.game.FORMID, 'dialog.game');
    end;
end;

function getDialog(DATA)
    local ELEMENT = getElementEX(
        nil,
        anchorNone,
        XYWH(0, 0, ScrWidth, ScrHeight),
        true,
        {
            colour1 = BLACKA(50)
        }
    );

    local height = 108 + 30 * DATA.COUNT;

    ELEMENT.dialog = getElementEX(
        ELEMENT,
        anchorNone,
        XYWH(ScrWidth / 2 - 150, ScrHeight / 2 - (height / 2), 299, height),
        true,
        {
            colour1 = WHITEA()
        }
    );

    ELEMENT.dialog.top = getElementEX(
        ELEMENT.dialog,
        anchorNone,
        XYWH(0, 0, 299, 96),
        true,
        {
            texture = 'classic/edit/query_t.png'
        }
    );

    ELEMENT.dialog.top.label = getLabelEX(
        ELEMENT.dialog, 
        anchorLT, 
        XYWH(18, 6, 260, 72),
        Arial_12, 
        DATA.QUESTION,
        {
            wordwrap = true,
            autosize = true,
            font_colour = BLACK()
        }
    );

    ELEMENT.dialog.center = getElementEX(
        ELEMENT.dialog,
        anchorNone,
        XYWH(0, 96, 299, 30 * DATA.COUNT),
        true,
        {
            colour1 = WHITEA()
        }
    );

    sgui_deletechildren(ELEMENT.dialog.center);

    for i = 1, DATA.COUNT do
        local tmp = getElementEX(
            ELEMENT.dialog.center,
            anchorNone,
            XYWH(0, 30 * (i - 1), 299, 30),
            true,
            {
                texture = 'classic/edit/query_c.png'
            }
        );

        local PROPERTIES = {};

        if (i == 1) then
            PROPERTIES.clickSoundSelect = true;
        end;

        button(
            tmp, 
            8, 
            2,
            284, 
            30, 
            DATA.LIST[i], 
            'setVisibleID(' .. ELEMENT.ID .. ', false); OW_FORM_CLOSE(dialog.game.FORMID,'..(i)..');',
            PROPERTIES
        );
    end;

    ELEMENT.dialog.bottom = getElementEX(
        ELEMENT.dialog,
        anchorNone,
        XYWH(0, ELEMENT.dialog.top.height + (30 * DATA.COUNT), 299, 12),
        true,
        {
            texture = 'classic/edit/query_b.png'
        }
    );

    return ELEMENT;
end;