classdef rocket
    %ROCKET Rocket class used for simulation
    %   Contains position, velocity, and acceleration of the
    %   constructed rocket.
    
    properties (GetAccess=private)
        mass % Scalar representing the mass of the rocket
        position % Vector representing position in a 3D coordinate space
        velocity % Vector representing velocity in a 3D coordinate space
        acceleration % Vector representing acceleration in a 3D coordinate space
        thrust % Vector representing thrust in a 3D coordinate space
        motion % Matrix containing rocket's motion, initially zeros
        ctrl % Control system for landing the rocket
    end
    
    properties (Constant)
        gravity = [0 0 -9.8]
    end
    
    methods
        function obj = rocket(varargin)
            %ROCKET Construct an instance of this class
            %   Takes in position, velocity, and acceleration as an argument
            if nargin == 2
                obj.mass = 100;
                obj.position = cell2mat(varargin(1));
                obj.velocity = cell2mat(varargin(2));
                obj.acceleration = zeros(1, 3);
                obj.thrust = zeros(1, 3);
                obj.motion = [];
                obj.ctrl = false;
            elseif nargin == 0
                obj.mass = 100;
                obj.position = zeros(1, 3);
                obj.velocity = zeros(1, 3);
                obj.acceleration = zeros(1, 3);
                obj.motion = [];
                obj.ctrl = false;
            else
                disp("Error");
            end
        end
        
        function outputArg = get_position(obj)
            %get_position Get position of rocket
            %   Gets position of rocket in 3D
            outputArg = obj.position;
        end
        
        function outputArg = get_velocity(obj)
            %get_velocity Get velocity of rocket
            %   Gets velocity of rocket in 3D
            outputArg = obj.velocity;
        end
        
        function outputArg = get_thrust(obj)
            %get_thrust Get thrust of rocket
            %   Gets thrust of rocket in 3D
            outputArg = obj.thrust;
        end
        
        function obj = set_thrust(obj, new_thrust)
            %set_thrust Set thrust of rocket
            %   Sets thrust of rocket in 3D
            obj.thrust = new_thrust;
        end
        
        function outputArg = get_mass(obj)
            outputArg = obj.mass;
        end
        
        function obj = add_controls(obj, varargin)
            if nargin == 1
                ctrl = controls(obj, 1);
                obj.ctrl = ctrl;
            elseif nargin == 2
                ctrl = controls(obj, varargin(1));
                obj.ctrl = ctrl;
            else
                disp("Error: incorrect number of arguments");
            end
        end
        
        function obj = simulate(obj)
            %simulate Simulates the rocket's motion in 3D
            dt = 0.01;
            z = obj.position(3);
            obj.acceleration = obj.gravity + obj.thrust;
            obj.motion = [];
            
            while z > 0
                x = obj.position(1);
                y = obj.position(2);
                z = obj.position(3);
                
                state = [x; y; z];
                state = vertcat(state, obj.velocity', obj.acceleration');
                
                obj.motion = horzcat(obj.motion, state);
                
                obj.ctrl = obj.ctrl.calc_thrust(obj);
                obj.thrust = obj.ctrl.get_thrust;
                
                obj.acceleration = obj.gravity + obj.thrust / obj.mass;
                obj.velocity = obj.velocity + obj.acceleration * dt;
                obj.position = obj.position + obj.velocity * dt;

            end
            
            x = obj.position(1);
            y = obj.position(2);
            z = obj.position(3);
                
            state = [x; y; z];
            state = vertcat(state, obj.velocity', obj.acceleration');
                
            obj.motion = horzcat(obj.motion, state);
            
            if isempty(obj.motion)
                obj.motion = zeros(9, 1);
            end
            
            if norm(obj.velocity) > 1
                d = dialog('Position',[300 300 250 150],'Name','My Dialog');

                txt = uicontrol('Parent',d,...
                    'Style','text',...
                    'Position',[20 80 210 40],...
                    'String','Rocket crashed into ground.');

                btn = uicontrol('Parent',d,...
                    'Position',[85 20 70 25],...
                    'String','Close',...
                    'Callback','delete(gcf)');
            end
        end
        
        function plot_motion(obj, ax, al, ve, ac)
            cla(ax);
            cla(al);
            cla(ve);
            cla(ac);
            
            x = obj.motion(1, :);
            y = obj.motion(2, :);
            z = obj.motion(3, :);
            
            for k = 1:length(x)
                plot3(ax, x(k), y(k), z(k), "b*");
                
                ax.XGrid = "on";
                ax.YGrid = "on";
                ax.ZGrid = "on";
                
                xlim(ax, [min(x) - 5, max(x) + 5]);
                ylim(ax, [min(y) - 5, max(y) + 5]);
                zlim(ax, [min(z), max(z) + 5]);
                
                
                pause(0.05);
            end
            
            plot(al, 0:0.01:((length(z) - 1)/100), z);
            al.XGrid = "on";
            al.YGrid = "on";
            
            plot(ve, 0:0.01:((length(z) - 1)/100), obj.motion(6, :));
            ve.XGrid = "on";
            ve.YGrid = "on";
            
            plot(ac, 0:0.01:((length(z) - 1)/100), obj.motion(9, :));
            ac.XGrid = "on";
            ac.YGrid = "on";
        end
        
    end
end

