function [] = initialize_simulation(num_runners, num_drones)
%INITIALIZE_SIMULATION Summary of this function goes here
% This function is called when the simulation begins, and initializes all
% relevant data.

% clear all global variables
clear global marathon_arclength;
clear global checkpoints;
clear global runners;
clear global drones;
clear global weighted_mass;
clear global target_mass;
clear global num_subpartitions;

global marathon_arclength;
marathon_arclength = 42600.0;

global checkpoints;
global runners;
global drones;
checkpoints = [0.0469 0.1174 0.2347 0.3521 0.4695 0.5869 0.7042 0.8216 1];
runners = runner(0, 0, 0);
drones = drone(0, 1);
%runners = [];
%drones = [];
% runners = zeros(1, num_runners); % preallocate runner memory
% drones = zeros(1, num_drones); % preallocate drone memory

class_probabilities = xlsread('boston_marathon_distribution.xlsx', 'D3:D18');
class_velocities = xlsread('boston_marathon_distribution.xlsx', 'G3:G18') / marathon_arclength;
class_beta_factors = xlsread('boston_marathon_distribution.xlsx', 'H3:H18');

for i=1:num_runners
    % generate runners at position 0 with velocity and beta factor randomly
    % selected from the classes based on percentage probability
    
    % random selection
    vel = pick_random(class_probabilities, class_velocities)
    beta = pick_random(class_probabilities, class_beta_factors)
    
    new_runner = runner(0, vel, beta);
    runners(i) = new_runner;
end
for i=1:num_drones
    % generate drones
    
    % NOTE: max velocity of 1 <=> drone can move the entire marathon in a
    % single time step - this should be adjusted later
    new_drone = drone(0, 1);
    drones(i) = new_drone;
end

% now that runners, drones and checkpoints have been initialized,
% initialize other global constants
global weighted_mass;
global target_mass;
global num_subpartitions;

% calculate total mass - this will never change throughout the race. since
% all runners start at the same point, their placing in the marathon is
% arbitrary, meaning we can just iterate the weighting function.
weighted_mass = 0;
for n=1:num_runners
    % this weighting function can be swapped out for others, but the
    % weighting function used should always be the same throughout the app
    weighted_mass = weighted_mass + weight_equal(n);
end

% now calculate the target mass for which to partition the marathon into
target_mass = weighted_mass / num_drones;

% default - can be changed later for testing
num_subpartitions = num_runners;

end