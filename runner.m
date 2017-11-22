classdef runner < handle
    %RUNNER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        position % runner position along track
        vel_avg % average velocity for runner
        vel_curr % current (actual) velocity of runner
        
        beta_factor % percentage of velocity to vary by over time
        volatility % beta_factor * vel_avg (amount of velocity to vary by)
        vel_min % minimum velocity
        vel_max % maximum velocity
        
        drone_view % drone's interpolation of runner variables
    end
    
    methods
        function obj = runner(pos, v_in, beta)
            obj.position = pos;
            obj.vel_avg = v_in;
            obj.vel_curr = v_in;
            obj.beta_factor = beta;
            obj.volatility = v_in * beta; % precalculate and store volatility
            obj.vel_min = (1 - beta) * v_in; % precalculate min velocity
            obj.vel_max = (1 + beta) * v_in; % precalculate max velocity
            
            % drone view consists of interpolated position, interpolated
            % velocity, position of the previous checkpoint and time
            % elapsed since previous checkpoint was reached
            obj.drone_view = [0 0 0 0];
        end
        % note - r is the return value
        % use dot notation and obj is the current instance of class
        function r = update(obj, delta)
            % wrapper method for runner update methods
            obj.update_velocity();
            obj.update_position(delta);
            % return whether this runner should be removed from the race
            if obj.position >= 1
                r = true;
            else
                r = false;
            end
        end
        function update_velocity(obj)
            % increment velocity by random value between +-volatility and
            % clamp this velocity between the min/max
            obj.vel_curr = obj.vel_curr + (obj.volatility * (rand(1) - 1));
            
            if obj.vel_curr > obj.vel_max, obj.vel_curr = obj.vel_max; end
            if obj.vel_curr < obj.vel_min, obj.vel_curr = obj.vel_min; end
        end
        function update_position(obj, delta)
            % declare that you're using global variables
            global checkpoints;
            
            % store current (will be previous) position before incrementing
            prev_pos = obj.position;
            % increment runner position based on velocity
            obj.position = obj.position + (obj.vel_curr * delta);
            
            % store value which says whether we crossed a checkpoint
            crossed_checkpoint = false;
            % check to see if runner crossed a checkpoint
            for i=1:length(checkpoints)
                point = checkpoints(i);
                if (point - prev_pos) * (point - obj.position) < 0
                    % we have crossed this checkpoint
                    crossed_checkpoint = true;
                    obj.drone_view(1) = point; % drone interpolated position
                    % drone interpolated velocity
                    obj.drone_view(2) = (point - obj.drone_view(3)) / obj.drone_view(4);
                    obj.drone_view(3) = point; % most recent checkpoint
                    obj.drone_view(4) = 0; % time since most recent checkpoint
                    
                    break; % exit the loop
                end
            end
            if ~crossed_checkpoint
                % we did not cross a checkpoint
                % update interpolated position
                obj.drone_view(1) = obj.drone_view(1) + (obj.drone_view(2) * delta);
                % update elapsed time since most recent checkpoint
                obj.drone_view(4) = obj.drone_view(4) + delta;
            end
        end
    end
    
end

