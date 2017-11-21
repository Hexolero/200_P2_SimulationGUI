function [map_points] = marathon_mapping(distance, x, y, length_lin)

map_points = zeros(length(distance),2);

for i = 1:length(distance)
    km = distance(i);
    
    if km ~= 0
        z = km/42600;
        A = 0;
        bin = 1;
        path_length = 0;
        
        while A == 0
            piece_length = sqrt((x(bin+1)-x(bin))^2 + (y(bin+1)-y(bin))^2);
            
            if ((path_length + piece_length)/length_lin) < z
                path_length = path_length + piece_length;
                bin = bin + 1;
            else
                A = 1;
            end
        end
        
        m = (y(bin+1) - y(bin))/(x(bin+1) - x(bin));
        b = y(bin) - m * x(bin);
        
        A = m^2 + 1;
        B = 2*(m * (b - y(bin)) - x(bin));
        C = x(bin)^2 + (b - y(bin))^2 - (z*length_lin - path_length)^2;
        
        sol_X = (-B+sqrt(B^2 - 4*A*C))/(2*A);
        sol_Y = m * sol_X + b;
    else
        sol_X = 0;
        sol_Y = 0;
    end
    
    map_points(i,1) = sol_X;
    map_points(i,2) = sol_Y;
end

end