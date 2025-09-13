%% Request user input for cuboid coordinates and coefficients
valid_input = false; % Flag to check validity of inputs
while ~valid_input
    disp('Enter the coordinates of the bottom surface (by default, z1 & z2 is 0):');
    x1 = input('Enter x1: ');
    x2 = input('Enter x2: ');
    y1 = input('Enter y1: ');
    y2 = input('Enter y2: ');

    disp('Enter the coefficients of the top plane equation:')
    a = input('Enter the coefficient a: ');
    b = input('Enter the coefficient b: ');
    c = input('Enter the coefficient c (c must not be 0): ');
    d = input('Enter the coefficient d: ');

    % Check if c is zero
    if c == 0
        disp('Coefficient c must be non-zero (plane cannot be vertical).');
        continue; % Skip the rest of the loop and retry
    end

    % Validate input coordinates to ensure proper cuboid plotting
    if x1 == x2 || y1 == y2
        disp('Error: (x1, x2) and (y1, y2) must differ.');   
        continue; % Skip the rest of the loop and retry
    end

    % Additional check for minimum size
    if abs(x2 - x1) < 2 || abs(y2 - y1) < 2
        disp('Cuboid dimensions must be at least 2 units in both x and y directions.'); 
        continue; % Skip the rest of the loop and retry
    end

    valid_input = true;
end

% Call the function to plot and get plane info
[plane, z, edges, vertex_labels] = plotCuboid(x1, y1, x2, y2, a, b, c, d);
x = [x1, x2, x2, x1, x1, x2, x2, x1];
y = [y1, y1, y2, y2, y1, y1, y2, y2];
faces = [1 2 3 4; 5 6 7 8; 1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8];
calcVertex = {'A1', 'B1', 'C1', 'D1', 'A2', 'B2', 'C2', 'D2'};

%% Calculate and display the length of each edge
% Call the new function to get edge lengths and display strings
[edge_lengths, edge_display] = cuboid_edge(x, y, z, edges, calcVertex);
o11 = sprintf('Calculated Length of each edge:\n');
o12 = '';
for i = 1:length(edge_display)
    % Display the pre-formatted string
    o12 = [o12, sprintf(edge_display{i}, '\n')];
end
o1 = [o11, o12];

% Annotation
for i = 1:size(edges, 1)
    % Get the coordinates of the two endpoints of the edge
    P1 = [x(edges(i, 1)), y(edges(i, 1)), z(edges(i, 1))];
    P2 = [x(edges(i, 2)), y(edges(i, 2)), z(edges(i, 2))];
    midpoint = (P1 + P2)/2; % Midpoint of the edge for annotation
    
    % Display the edge length 
    text(midpoint(1), midpoint(2), midpoint(3), sprintf('%.2f', edge_lengths(i)), 'Color', 'k', 'FontSize', 10, 'FontWeight', 'bold');
end

%% Calculate and display the area of each face
[face_areas, face_display] = cuboid_face(x, y, z, faces, calcVertex);
o21 = sprintf('\nCalculated Area of each face:\n');
o22 = '';
for i = 1:length(face_display)
    % Display the face area in the required format: Area(AiBiCiDi) = <area>
    o22 = [o22, sprintf(face_display{i}, '\n')];
end
o2 = [o21, o22];

% Annotation
for i = 1:size(faces, 1)
    vertex_face = faces(i, :);
    v1 = [x(vertex_face(1)), y(vertex_face(1)), z(vertex_face(1))];
    v2 = [x(vertex_face(2)), y(vertex_face(2)), z(vertex_face(2))];
    v3 = [x(vertex_face(3)), y(vertex_face(3)), z(vertex_face(3))];
    v4 = [x(vertex_face(4)), y(vertex_face(4)), z(vertex_face(4))];
    
    % Display the area of the face at its center
    centroid = (v1 + v2 + v3 + v4)/4;
    text(centroid(1), centroid(2), centroid(3), sprintf('Area: %.2f', face_areas(i)), 'Color', 'b', 'FontSize', 10, 'FontWeight', 'bold');
end

%% Calculate and display the volume of the cuboid cut by a plane
volume = cuboid_volume(x1, y1, x2, y2, a, b, c, d);
% Display the result 
if volume == 0 
    o3 = sprintf(['\nThe volume calculation resulted in 0.\n' ...
                  'Please check the plane coefficients and base coordinates.\n' ...
                  'This might occur if the plane intersects such that no part is above or below z = 0.\n']);
else
    o3 = sprintf(['\nVolume of the cuboid = ', sprintf('%.3f', volume), ' cubic units']);
end

% Display the volume result at the center of the cuboid
text(mean(x), mean(y), mean(z), sprintf('Volume: %.3f', volume), 'Color', 'r', 'FontSize', 12, 'FontWeight', 'bold');

%%
[plane_ex, z_ex, edges_ex, labels_ex] = plotCuboid(x1, y1, x2, y2, a, b, c, d);

%% Display the output on a txt file
% Define the filename for the output file
filename = 'output-cuboid.txt';

% Open the file for writing 
fileID = fopen(filename, 'w'); % ('w' mode creates a new file or overwrites an existing one)

% Check if the file was opened successfully
if fileID == -1
    error('Fail to open the file %s for writing.', filename);
end

% Write the string to the file
fprintf(fileID, 'Plane equation: %s\n', plane.equation);
fprintf(fileID, 'Calculated top z-coordinates: %s\n', plane.z_top);
fprintf(fileID, 'Vertex Coordinates: %s\n', plane.coord);
fprintf(fileID, '%s\n', plane.display);
outputString = [o1, o2, o3];
fprintf(fileID, '%s\n', outputString);

% Close the file
fclose(fileID); 