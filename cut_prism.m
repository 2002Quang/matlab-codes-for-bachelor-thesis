%% Request user input for the number of lateral faces and coefficients
valid_input = false; % Flag to check validity of inputs

while ~valid_input
    n = input('Enter the number of vertices of the bottom surface (n >= 3): ');

    % Check if n >= 3
    if n < 3
        disp('The number of vertices of the bottom surface must be at least 3. Please try again.');
        continue; % Skip the rest of the loop and retry
    end

    % Request user input for the x and y coordinates of the vertices
    x = zeros(n, 1);
    y = zeros(n, 1);
    disp('Enter the coordinates of the bottom surface (by default, z_i = 0):');
    for i = 1:n
        x(i) = input(['Enter the x-coordinate of vertex A' num2str(i) ': ']);
        y(i) = input(['Enter the y-coordinate of vertex A' num2str(i) ': ']);
    end

    % Add the polygon validation check
    if ~isValidPolygon(x, y)
        disp('Error: Invalid polygon. Vertices must form a simple, non-degenerate polygon.');
        continue;
    end

    disp('Enter the coefficient of the top plane equation:');
    a = input('Enter the coefficient a: ');
    b = input('Enter the coefficient b: ');
    c = input('Enter the coefficient c (c must not be 0): ');
    d = input('Enter the coefficient d: ');

    % Check if c is zero
    if c == 0
        disp('Coefficient c must be non-zero (plane cannot be vertical).');
        continue; % Skip the rest of the loop and retry
    end

    % Set valid_input to true to allow plotting
    valid_input = true;
end

% Call the function to plot the prism
[plane] = plotPrism(n, x, y, a, b, c, d);

%% Calculate the length of the edges and display them
o11 = sprintf('Calculated Length of each edge:\n');
o12a = ''; o12b = ''; o12c = '';
% Call the new function to calculate all edge lengths at once
z_bottom = zeros(n, 1);
z_top = -(a*x + b*y + d)/c;
[base_edges, top_edges, lateral_edges] = prism_edge(x, y, z_bottom, z_top, n);
for i = 1:n
    % Calculate the index of the next vertex (wrap around for the last vertex)
    j = mod(i, n) + 1; 

    l_base = base_edges(i); % A_i to A_(i+1) (base edges)
    l_top = top_edges(i); % B_i to B_(i+1) (top edges)
    l_side = lateral_edges(i); % A_i to B_i (lateral edges)

    % Display the lengths in the command window
    o12a = [o12a, sprintf('Length of edge A%dB%d = %.3f\n', i, i, l_side)];
    o12b = [o12b, sprintf('Length of edge A%dA%d = %.3f\n', i, j, l_base)];
    o12c = [o12c, sprintf('Length of edge B%dB%d = %.3f\n', i, j, l_top)];

    % Annotate the lengths on the figure
    x_centroid_1 = (x(i) + x(j))/2;
    x_centroid_2 = (x(i) + x(i))/2;
    y_centroid_1 = (y(i) + y(j))/2;
    y_centroid_2 = (y(i) + y(i))/2;
    z_centroid_1 = (z_bottom(i) + z_bottom(j))/2;
    z_centroid_2 = (z_top(i) + z_top(j))/2;
    z_centroid_3 = (z_bottom(i) + z_top(i))/2;

    text(x_centroid_1, y_centroid_1, z_centroid_1, sprintf('%.3f', l_base), 'FontSize', 10, 'FontWeight', 'bold', 'Color', 'k', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    text(x_centroid_1, y_centroid_1, z_centroid_2, sprintf('%.3f', l_top), 'FontSize', 10, 'FontWeight', 'bold', 'Color', 'k', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    text(x_centroid_2, y_centroid_2, z_centroid_3, sprintf('%.3f', l_side), 'FontSize', 10, 'FontWeight', 'bold', 'Color', 'k', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
end
o1 = [o11, o12a, o12b, o12c];

%% Calculate the area of each face
o21 = sprintf('\nCalculated Area of each face:\n');
[bottom_area, top_area, lateral_areas] = prism_face(x, y, z_bottom, z_top, n);

% Calculate and display the area of the bottom face
o22a = sprintf('Area of bottom face ');
o22b = '';
for i = 1:n
    o22b = [o22b, sprintf('A%d', i)];
end
o22c = sprintf(' = %.3f\n', bottom_area);
o22 = [o22a, o22b, o22c];

% Annotate the area of the bottom face on the figure
text(mean(x), mean(y), mean(z_bottom), sprintf('Area: %.3f', bottom_area), 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');

% Calculate and display the area of the top face
o23a = sprintf('Area of top face ');
o23b = '';
for i = 1:n
    o23b = [o23b, sprintf('B%d', i)];
end
o23c = sprintf(' = %.3f\n', top_area);
o23 = [o23a, o23b, o23c];

% Annotate the area of the top face on the figure
text(mean(x), mean(y), mean(z_top), sprintf('Area: %.3f', top_area), 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');

% Calculate and display the area of each lateral face
o24 = '';
for i = 1:n
    j = mod(i, n) + 1; % Next vertex (wraps around)

    % Display result
    o24 = [o24, sprintf('Area of lateral face A%dA%dB%dB%d = %.4f\n', i, j, j, i, lateral_areas(i))];

    % Define the 4 vertices of the lateral face (A_i, A_j, B_j, B_i)
    vertices = [
        x(i), y(i), z_bottom(i);  % A_i
        x(j), y(j), z_bottom(j);  % A_j
        x(j), y(j), z_top(j);     % B_j
        x(i), y(i), z_top(i)      % B_i
    ];    

    % Annotate the area on the figure (placing it at the midpoint of the lateral face)
    centroid = mean(vertices, 1);
    text(centroid(1), centroid(2), centroid(3), sprintf('Area: %.2f', lateral_areas(i)), 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
end

o2 = [o21, o22, o23, o24];

%% Calculate the volume of the prism and display the result
% Calculate the volume of the prism
volume = prism_volume(x, y, z_bottom, z_top);
o3 = sprintf('\nVolume of the prism = %.3f cubic units \n', volume);

% Display the volume on the 3D plot
center_x = mean(x);
center_y = mean(y);
center_z = mean([z_bottom; z_top]);
text(center_x, center_y, center_z, sprintf('Volume: %.3f', volume), 'FontSize', 14, 'FontWeight', 'bold', 'Color', 'b', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')

%%
[plot_ex] = plotPrism(n, x, y, a, b, c, d);

%% Display the output on a txt file
% Define the filename for the output file
filename = 'output-prism.txt';

% Open the file for writing 
fileID = fopen(filename, 'w'); % ('w' mode creates a new file or overwrites an existing one)

% Check if the file was opened successfully
if fileID == -1
    error('Fail to open the file %s for writing.', filename);
end

% Write the string to the file
fprintf(fileID, 'Plane equation: %s\n', plane.equation);
fprintf(fileID, 'Calculated top z-coordinates: %s\n', plane.z_top_value);
fprintf(fileID, 'Vertex Coordinates:\n%s\n', plane.coord);
fprintf(fileID, '%s\n', plane.display);
outputString = [o1, o2, o3];
fprintf(fileID, '%s\n', outputString);

% Close the file
fclose(fileID);

%% Local function for validating input
function valid = isValidPolygon(x, y)
    % Check if vertices form a valid simple polygon
    n = length(x);
    
    % 1. Check for minimum 3 distinct points
    if n < 3
        valid = false;
        return;
    end
    
    % 2. Check for collinear points
    for i = 1:n-2
        x1 = x(i); y1 = y(i);
        x2 = x(i+1); y2 = y(i+1);
        x3 = x(i+2); y3 = y(i+2);
        
        cross_prod = (x2-x1)*(y3-y1) - (y2-y1)*(x3-x1);
        
        if abs(cross_prod) < 2
            valid = false;
            return;
        end
    end
    
    % 3. Basic check for self-intersections
    valid = true;
end