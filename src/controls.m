classdef controls
    %CONTROLS Control system for landing rocket autonomously
    %   Detailed explanation goes here
    
    properties (GetAccess=private)
        threshold
        thrust
        system
    end
    
    methods
        function obj = controls(rkt, system)
            %CONTROLS Construct an instance of this class
            %   Detailed explanation goes here
            pos = rkt.get_position;
            vel = rkt.get_velocity;
            
            apogee = pos(3) + vel(3) ^ 2 / 19.6;
            obj.threshold = apogee * 0.8;
            obj.thrust = [0, 0, 0];
            if isa(system, "cell")
                obj.system = system{1};
            else
                obj.system = system;
            end
            
            if obj.system == 3
                obj.threshold = pos(3);
            end
        end
        
        function obj = calc_thrust(obj, rkt)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            if obj.system == 1
                pos = rkt.get_position;
                vel = rkt.get_velocity;
           
                if pos(3) <= obj.threshold && vel(3) < 0
                    if abs(vel(3)) > 1
                        if obj.thrust == [0, 0, 0]
                            obj.thrust = rkt.get_mass * [0, 0, 9.8 + vel(3) ^ 2 / (2 * pos(3))];
                        end
                    else
                        obj.thrust = rkt.get_mass * [0, 0, 9.8];
                    end
                else
                    obj.thrust = [0, 0, 0];
                end
            elseif obj.system == 2
                pos = rkt.get_position;
                vel = rkt.get_velocity;
                
                if abs(vel(1)) < 0.577
                    obj.thrust(1) = 0;
                end
                
                if abs(vel(2)) < 0.577
                    obj.thrust(2) = 0;
                end
           
                if pos(3) <= obj.threshold && vel(3) < 0
                    if abs(vel(3)) > 0.577
                        if obj.thrust == [0, 0, 0]
                            z_thrust = vel(3) ^ 2 / (2 * pos(3));
                            t = -1 * vel(3) / z_thrust;
                            
                            x_thrust = -1 * vel(1) / t;
                                
                            y_thrust = -1 * vel(2) / t;
                            
                            
                            obj.thrust = rkt.get_mass * [...
                                x_thrust,... 
                                y_thrust,...
                                9.8 + z_thrust];
                        end
                    else
                        obj.thrust(3) = rkt.get_mass * 9.8;
                    end
                else
                    obj.thrust = [0, 0, 0];
                end
            elseif obj.system == 3
                vel = rkt.get_velocity;
                if norm(vel) > 1
                    if obj.thrust == [0, 0, 0]
                        obj.thrust = rkt.get_mass * -0.71 * vel;
                    else
                        obj.thrust = norm(obj.thrust) * -1 * vel / norm(vel);
                    end
                else
                    obj.thrust = rkt.get_mass * [0, 0, 9.8];
                end
            end
                
        end
        
        function thrust = get_thrust(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            thrust = obj.thrust;
        end
    end
end

