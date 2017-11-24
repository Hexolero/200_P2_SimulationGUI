function [] = simulation_callback(~, ~, gui_handle)
%SIMULATION_CALLBACK Summary of this function goes here
%   Detailed explanation goes here
% persistent variables between timer calls, initialize if first call
global simulation_delta;
if isempty(simulation_delta), simulation_delta = 0.0, end

global frame_delta;
global runners;
global drones;
global checkpoints;

% simulation update
distribution_algorithm(frame_delta);

if ~isempty(gui_handle)
    handles = guidata(gui_handle)
    if ~isempty(handles)
        %axis(handles.axes1,[runners(end).position runners(1).position 0 1]);
        pos = zeros(1, length(runners));
        for i=1:length(runners)
            pos(i) = runners(i).position;
        end
        set(handles.hPlot, 'XData', pos, 'YData', 0.5 * ones(1, length(runners)));
    end
end

simulation_delta = simulation_delta + frame_delta;

end

