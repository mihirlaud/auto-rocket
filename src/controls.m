classdef controls
    %CONTROLS Control system for landing rocket autonomously
    %   Detailed explanation goes here
    
    properties (GetAccess=private)
        threshold
        thrust
    end
    
    methods
        function obj = controls(rkt)
            %CONTROLS Construct an instance of this class
            %   Detailed explanation goes here
            pos = rkt.get_position;
            vel = rkt.get_velocity;
            
            apogee = pos(3) + vel(3) ^ 2 / 19.6;
            obj.threshold = apogee * 0.8;
            obj.thrust = 0;
        end
        
        function obj = calc_thrust(obj, rkt)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            pos = rkt.get_position;
            vel = rkt.get_velocity;
            
            if pos(3) <= obj.threshold
                if abs(vel(3)) > 1
                    if obj.thrust == 0
                        obj.thrust = 9.8 + vel(3) ^ 2 / (2 * obj.threshold);
                    end
                else
                    obj.thrust = 9.8;
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

