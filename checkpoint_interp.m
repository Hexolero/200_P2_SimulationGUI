%% Import speed data
clear, clc;
data = xlsread('bm_distribution.xlsx');

speed_seconds = data(:,5); % speeds in metres/seconds
max_speed = data(:,8);
min_speed = data(:,9);
vol = data(:,7);

seconds_per_tick = 50; % time conversion factor from seconds to ticks

speed_tick = speed_seconds .* seconds_per_tick; % speeds in metres/tick
max_tick = max_speed .* seconds_per_tick;
min_tick = min_speed .* seconds_per_tick;
vol_tick = vol .* seconds_per_tick;

%% Load map data

map_data = xlsread('marathon_mapping_points.xlsx');

x = map_data(:,1);
y = map_data(:,2);

hold on;
plot(x,y, 'b-','LineWidth', 1.5)

length_lin = 0;
for k = 2:length(x)
    length_lin = length_lin + sqrt((x(k)-x(k-1))^2 + (y(k)-y(k-1))^2);
end

km_per_unit = 38.57/(sqrt(x(end)^2 + y(end)^2));
km_length = length_lin * km_per_unit;

%% Track Runner's Position

% Initialize the runner
runner = zeros(3,1);
runner(1) = 0; % time
runner(2) = 0.1; % initial position
runner(3) = speed_tick(5); % initial speed, metres/tick

checkpoint = [2000; 5000; 10000; 15000; 20000; 25000; 30000; 35000; 42600]; % in metres

for j = 1:length(checkpoint)
    check_location = marathon_mapping(checkpoint(j), x, y, length_lin);
    plot(check_location(:,1), check_location(:,2), 'g*');
end

% track the position until runner hits first checkpoint
time = 1;
while runner(2) < checkpoint(1)
    runner(1) = time; % set time index
    runner(2) = runner(2) + runner(3); % set new position
    % set new velocity
    adjust = -vol_tick(5) + (2*vol_tick(5))*rand;
    runner(3) = runner(3) + adjust;
    if runner(3) > max_tick(5)
        runner(3) = max_tick(5);
    elseif runner(3) < min_tick(5)
        runner(3) = min_tick(5);
    end
    
    time = time + 1;
    
    hold on;
    runner_location = marathon_mapping(runner(2), x, y, length_lin);
    plot(runner_location(:,1), runner_location(:,2), 'r.');
end

%% After the first checkpoint
runner_check = zeros(2,1);
runner_check(2) = runner(1);

drone = zeros(3,1); % drone's data
% set drone's data to the runner's data right as they hit checkpoint
drone(1) = runner(1); % time
drone(2) = runner(2); % position
drone(3) = checkpoint(1)/runner_check(2); % velocity

check_num = 2; % checkpoint number

while check_num <= length(checkpoint)
    runner(1) = time;
    runner(2) = runner(2) + runner(3);
    
    adjust = (-vol_tick(5)+(2*vol_tick(5))*rand);
    runner(3) = runner(3) + adjust;
    if runner(3) > max_tick(5)
        runner(3) = max_tick(5);
    elseif runner(3) < min_tick(5)
        runner(3) = min_tick(5);
    end
    
    if runner(2) < checkpoint(check_num)
        
        drone(1) = time;
        drone(2) = drone(2) + drone(3); % update position using same velocity
        
    else
        runner_check(1) = runner_check(2);
        runner_check(2) = time;
        
        drone(1) = time;
        drone(2) = runner(2);
        % set drone speed to avg speed between previous checkpoints
        drone(3) = (checkpoint(check_num) - checkpoint(check_num-1))/(time-runner_check(1));
        
        check_num = check_num + 1;
    end
    
    if runner(2) <= checkpoint(end)
        hold on;
        runner_location = marathon_mapping(runner(2), x, y, length_lin);
        plot(runner_location(:,1), runner_location(:,2), 'r.', 'MarkerSize', 10);

        drone_location = marathon_mapping(drone(2), x, y, length_lin);
        plot(drone_location(:,1), drone_location(:,2), 'c.', 'MarkerSize', 10);
    end
    
    time = time + 1;
end