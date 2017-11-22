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
partition_mass = zeros(1, num_subpartitions);
for n=1:number_runners
    % again, can change this weighting function but must be careful to use
    % the same weighting function in all areas
    pos = runners(n).position;
    index = ceil(pos * num_subpartitions);;
    partition_mass(index) = partition_mass(index) + weight_equal(n);
end
%% STEP 3 - CALCULATE PARTITION SEPERATIONS


%% STEP 4 - CALCULATE AND ASSIGN CENTROIDS


end

