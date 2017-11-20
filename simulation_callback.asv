function [] = simulation_callback(~, ~, gui_handle)
%SIMULATION_CALLBACK Summary of this function goes here
%   Detailed explanation goes here
% persistent variables between timer calls, initialize if first call
global simulation_delta;
if isempty(simulation_delta), simulation_delta = 0.0, end6

if ~isempty(gui_handle)
    handles = guidata(gui_handle)
    if ~isempty(handles)
        xdata = get(handles.hPlot, 'XData');
        ydata = sin(simulation_delta * xdata) + cos(simulation_delta * xdata);
        set(handles.hPlot, 'YData', ydata);
    end
end

simulation_delta = simulation_delta + 0.02;

end

