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

z = [0; 0.1; 1]; % input distances of checkpoints as percent here, the plot will
                 % show you where on the course this distance is located

checkpoint_location = marathon_mapping(z, x, y, length_lin);
plot(checkpoint_location(:,1), checkpoint_location(:,2), 'c*', 'MarkerSize', 15);