function app
    f = figure("Visible", "off", "Position", [0, 0, 600, 500], "Name", "Auto Rocket");
    movegui(f, "center");
    
    btn_create = uicontrol("Style", "pushbutton", "String", "Create",...
                           "Position", [10 450 80 40], "Callback", {@create_Callback});
    btn_simulate = uicontrol("Style", "pushbutton", "String", "Simulate",...
                             "Position", [10 400 80 40], "Callback", {@simulate_Callback});
    
    ve = axes("Units", "pixels", "Position", [120, 30, 200, 200]);
    grid on;
    
    ac = axes("Units", "pixels", "Position", [350, 30, 200, 200]);
    grid on;
    
    ax = axes("Units", "pixels", "Position", [120, 260, 200, 200]);
    grid on;
    
    al = axes("Units", "pixels", "Position", [350, 260, 200, 200]);
    grid on;
    
    align([btn_create, btn_simulate], "Center", "None");
    
    f.Visible = "on";

    rkt = rocket;
    
    function create_Callback(~, ~)
        d = dialog('Position',[300 300 250 150],'Name','My Dialog');

        p_txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 120 50 20],...
               'String','Position:');
        p_input = uicontrol('Parent',d,...
               'Style','edit',...
               'Position',[90 125 100 20],...
               'String','0, 0, 0');
        
        v_txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 100 50 20],...
               'String','Velocity:');
        v_input = uicontrol('Parent',d,...
               'Style','edit',...
               'Position',[90 105 100 20],...
               'String','0, 0, 0');
        
        sel = uicontrol('Parent',d,...
               'Position',[50 55 140 25],...
               'String','Select Controls...',...
               'Callback',{@select_Callback});

        btn = uicontrol('Parent',d,...
               'Position',[85 20 70 25],...
               'String','Create',...
               'Callback',{@dialog_Callback});
        
        selection = 1;
           
        function dialog_Callback(~, ~)
            
            p_0 = eval(strcat("[", p_input.String, "]"));
            v_0 = eval(strcat("[", v_input.String, "]"));
        
            rkt = rocket(p_0, v_0);
            rkt = rkt.add_controls(selection);
            
            delete(gcf);
        end
        
        function select_Callback(~, ~)
            
            selection = menu("Select Control System:",...
                             "Kinematic Vertical Control",...
                             "Kinematic Total Control",...
                             "Gravity Turn");
        end
    end
    
    function simulate_Callback(~, ~)
        rkt = rkt.simulate;
        rkt.plot_motion(ax, al, ve, ac);
    end
end