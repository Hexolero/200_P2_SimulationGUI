classdef drone < handle
    %DRONE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        position % current position of the drone
        vel_max % maximum speed it is possible for the drone to fly at
        
        target_centroid % the drone interpolates towards this point
    end
    
    methods
        function obj = drone(pos, v_max)
            obj.position = pos;
            obj.vel_max = v_max;
            obj.target_centroid = pos;
        end
        
        function update(obj, delta)
            % can change 0.5 to any percentage to accelerate towards
            % centroid at varying rates
            desired_movement = 0.5 * (obj.target_centroid - obj.position);
            if desired_movement > obj.vel_max * delta
                obj.position = obj.position + (obj.vel_max * delta);
            else
                obj.position = obj.position + desired_movement;
            end
        end
    end
    
end

