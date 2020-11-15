classdef controls
    %CONTROLS Control system for landing rocket autonomously
    %   Detailed explanation goes here
    
    properties (GetAccess=private)
        kP
        kI
        kD
        thrust
    end
    
    methods
        function obj = controls(kP, kI, kD)
            %CONTROLS Construct an instance of this class
            %   Detailed explanation goes here
            obj.kP = kP;
            obj.kI = kI;
            obj.kD = kD;
            obj.thrust = 0;
        end
        
        function obj = calc_thrust(obj, rkt)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            pos = rkt.get_position;
            vel = rkt.get_velocity;
            
            if pos(3) <= 200
                if obj.thrust == 0
                    obj.thrust = 9.8 + vel(3) ^ 2 / 400;
                end
            else
                obj.thrust = 0;
            end
        end
        
        function thrust = get_thrust(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            thrust = [0, 0, obj.thrust];
        end
    end
end

