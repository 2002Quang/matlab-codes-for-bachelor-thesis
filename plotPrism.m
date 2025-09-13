function [planeInfo] = plotPrism(n, x, y, a, b, c, d)
% This function plots an oblique prism with a cut plane.
%
% Inputs:
%   n:          Numbers of base vertices or edges, or numbers of lateral faces
%   x, y:       Coordinates of the bottom face (z = 0)
%   a, b, c, d: Coefficients of the top plane equation ax + by + cz + d = 0
%               Note: c must not be zero
%
% Output:
%   planeInfo: A string describing how the plane cuts the prism

% Calculate the z_bottom and z_top for each vertex
z_bottom = zeros(n, 1); % Bottom z-coordinates (z_bottom = 0)
z_top = -(a*x + b*y + d)/c; % Top z-coordinates based on the equation

% Check the position of the top plane 
% relative to the bottom surface
if all(z_top > 0)
    planeInfo.display = sprintf('The plane cuts the TOP of the prism.\nPlease observe the 3D plot for more details.\n');
    plane_position = 'Inclined Top';
elseif all(z_top < 0)
    planeInfo.display = sprintf('The plane cuts the BOTTOM of the prism.\nPlease observe the 3D plot for more details.\n');
    plane_position = 'Inclined Bottom';
else
    planeInfo.display = sprintf('The plane INTERSECTS the bottom face of the prism.\nSome lateral faces may be triangles.\nPlease observe the 3D plot for more details.\n');
    plane_position = 'Intersected Bottom Surface';
end
planeInfo.equation = sprintf('(%d)*x + (%d)*y + (%d)*z + (%d) = 0', a, b, c, d);

coord_str = '';
for i = 1:n
    coord_str = [coord_str sprintf('A%d: (%.2f, %.2f, %.2f)\n', i, x(i), y(i), 0)];
end

for i = 1:n
    coord_str = [coord_str sprintf('B%d: (%.2f, %.2f, %.2f)\n', i, x(i), y(i), z_top(i))];
end

planeInfo.coord = coord_str;
planeInfo.z_top_value = '';
for i = 1:n
    planeInfo.z_top_value = [planeInfo.z_top_value, sprintf('%.2f ', z_top(i))];
end

% Define a list of distinct colors for the lateral faces
colors = [
    1, 0, 0;     % Red
    0, 1, 0;     % Green
    0, 0, 1;     % Blue
    1, 1, 0;     % Yellow
    0, 1, 1;     % Cyan
    1, 0, 1;     % Magenta
    0.5, 0.5, 0; % Olive
    0.5, 0, 0.5; % Purple
    0, 0.5, 0.5; % Teal
    ];

% Create the figure
figure;
hold on;

% Plot the base vertices (A_i) at z = 0 (bottom of the prism)
for i = 1:n
    % Label the base vertex (A_i)
    text(x(i), y(i), z_bottom(i), sprintf('A_{%d}', i), 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'black');
end

% Plot the top vertices (B_i) at z = z_top
for i = 1:n
    % Label the top vertex (B_i)
    text(x(i), y(i), z_top(i), sprintf('B_{%d}', i), 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'black');
end

% Plot the top and bottom faces of the prism (using a closed polygon)
fill3(x, y, z_bottom, 'b', 'FaceAlpha', 0.3); % Bottom face in blue with some transparency
fill3(x, y, z_top, 'r', 'FaceAlpha', 0.3); % Top face in red with some transparency

% Plot lateral faces (connecting A_i to B_i for each i)
for i = 1:n
    % Define the color for this lateral face
    face_color = colors(mod(i-1, size(colors, 1)) + 1, :);

    % Connecting A_i to B_i
    j = mod(i, n) + 1; % Wrap around for the last vertex to first vertex

    % Plot the side face (connecting A_i to A_j and B_i to B_j)
    fill3([x(i), x(j), x(j), x(i)], [y(i), y(j), y(j), y(i)], [z_bottom(i), z_bottom(j), z_top(j), z_top(i)], face_color, 'FaceAlpha', 0.5);
end

% Set axis labels and title
axis equal;
xlabel('X');
ylabel('Y');
zlabel('Z');
title(sprintf('3D Oblique Prism with %s', plane_position), 'FontSize', 14);

% Set the view angle for better 3D visualization
view(3);

% Add grid
grid on;

% Hold off to stop adding to the current plot
hold off;
end