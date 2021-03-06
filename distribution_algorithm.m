function [] = distribution_algorithm(delta)
%DISTRIBUTION_ALGORITHM Summary of this function goes here
% Using already-defined global constants and object arrays, updates all
% runners, calculates the centroids of each drone partition and assigns
% them to drones, and then finally updates all drones.

%% GLOBAL VARIABLES
global marathon_arclength;
global number_runners;
global number_drones;
global checkpoints;
global runners;
global drones;
global weighted_mass;
global target_mass;
global num_subpartitions;
%% STEP 0 - UPDATE RUNNERS
% Minor step.
for i=1:number_runners
    r = runners(i);
    r.update(delta);
end
%% STEP 1 - SORT RUNNERS
% This is necessary as the weighting function takes in their place as
% input, and so we sort them such that runners(n) is in nth place.
[~, ind] = sort([runners.position]);
runners = fliplr(runners(ind));
%% STEP 2 - CALCULATE PARTITION MASSES
global partition_mass;
partition_mass = zeros(1, num_subpartitions);
for n=1:number_runners
    % again, can change this weighting function but must be careful to use
    % the same weighting function in all areas
    pos = runners(n).position;
    index = ceil(pos * num_subpartitions);
    partition_mass(index) = partition_mass(index) + weight_equal(n);
end
%% STEP 3 - CALCULATE PARTITION SEPERATIONS
% initialize variables
mass_accum = 0;
drone_partitions = cell(1, number_drones, 1);
current_start_index = 1;
current_drone = 1;
% loop through subpartitions and accumulate masses until target mass is
% reached, then create a partition for each drone
for p=1:num_subpartitions
    if current_drone == number_drones
        % when we reach the last drone, assign all remaining area to drone
        drone_partitions{1, end} = [current_start_index num_subpartitions];
        break;
    end
    mass_accum = mass_accum + partition_mass(p);
    if mass_accum >= target_mass
        drone_partitions{1, current_drone} = [current_start_index p];
        current_start_index = p + 1;
        current_drone = current_drone + 1;
    end
end
%% STEP 4 - CALCULATE AND ASSIGN CENTROIDS
global centroid_list;
centroid_list = zeros(1, number_drones);
for d=1:number_drones
    current_partition = drone_partitions{1, d};
    total_mass = 0.0;
    centroid = 0.0;
    for s=current_partition(1):current_partition(2)
        % formula for centroid contribution is m * (x - 1/2)/d
        centroid = centroid + partition_mass(s) * (s - 0.5) / number_drones;
        total_mass = total_mass + partition_mass(s); 
    end
    centroid = centroid / total_mass;
    centroid_list(d) = centroid;
    drones(d).target_centroid = centroid; % assign a centroid to each drone
end
%% STEP 5 - UPDATE DRONES
for i=1:number_drones
    d = drones(i);
    d.update(delta);
end
%% FUNCTION COMPLETE
end