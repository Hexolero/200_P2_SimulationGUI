clear, clc;
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

% Input distances of checkpoints in metres, the plot will
% show you where on the course this distance is located
metres = [0;300;575;1450;1820;2225;4100;5400;6666;8250;8725;9525;10900;
    12500;14050;14850;15650;17250;19200;21700;24000;25750;27200;28250;
    28550;28950;29775;30580;30960;31750;32200;33375;34650;35050;35950;
    37160;39000;40500;41280;41500;41780;42190;42600];

z = metres./42600.00;

checkpoint_location = marathon_mapping(z, x, y, length_lin);
plot(checkpoint_location(:,1), checkpoint_location(:,2), 'rx', 'MarkerSize', 10);