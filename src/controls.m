classdef controls
    %CONTROLS Control system for landing rocket autonomously
    %   Detailed explanation goes here
    
    properties (GetAccess=private)
        kP
        kI
        kD
    end
    
    methods
        function obj = controls(kP, kI, kD)
            %CONTROLS Construct an instance of this class
            %   Detailed explanation goes here
            obj.kP = kP;
            obj.kI = kI;
            obj.kD = kD;
        end
        
        function new_thrust = calc_thrust(obj, rkt)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            pos = rkt.get_position;
            new_thrust = [0, 0, 80*exp(-0.1*(abs(pos(3) - 20)))];
        end
    end
end

