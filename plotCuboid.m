function [planeInfo, z, edges, vertex_labels] = plotCuboid(x1, y1, x2, y2, a, b, c, d)
% This function plots a cuboid with a top face cut by a plane
% and returns geometric data.
%
% Inputs:
%   x1, y1:     Coordinates of the bottom-left vertex (A1).
%   x2, y2:     Coordinates of the top-right vertex (C1).
%   a, b, c, d: Coefficients of the plane equation: a*x + b*y + c*z + d = 0.
%
% Outputs:
%   planeInfo:     Struct containing plane equation information (original output).
%   z:             8x1 vector of z-coordinates for all vertices (bottom + top).
%   edges:         12x2 matrix defining edges (vertex connectivity).
%   vertex_labels: 1x8 cell array of vertex labels.

%% Define vertices
% Bottom face (z = 0)
vertices_bottom = [x1, y1, 0; x2, y1, 0; x2, y2, 0; x1, y2, 0];

% Top face (from plane equation)
z_top = -(a*vertices_bottom(:,1) + b*vertices_bottom(:,2) + d)/c;
vertices_top = [x1, y1, z_top(1); x2, y1, z_top(2); x2, y2, z_top(3); x1, y2, z_top(4)];

% Combined vertices (bottom first, then top)
all_vertices = [vertices_bottom; vertices_top];
x = all_vertices(:,1);
y = all_vertices(:,2);
z = all_vertices(:,3);  % Output for calculations

%% Return plane equation info (original output)
planeInfo.equation = sprintf('(%d)*x + (%d)*y + (%d)*z + (%d) = 0', a, b, c, d);
planeInfo.coord = sprintf([ ...
    '\nA1: (%.2f, %.2f, %.2f)' ...
    '\nB1: (%.2f, %.2f, %.2f)' ...
    '\nC1: (%.2f, %.2f, %.2f)' ...
    '\nD1: (%.2f, %.2f, %.2f)' ...
    '\nA2: (%.2f, %.2f, %.2f)' ...
    '\nB2: (%.2f, %.2f, %.2f)' ...
    '\nC2: (%.2f, %.2f, %.2f)' ...
    '\nD2: (%.2f, %.2f, %.2f)'], ...
    x1, y1, 0, ...        % A1 (bottom)
    x2, y1, 0, ...        % B1 (bottom)
    x2, y2, 0, ...        % C1 (bottom)
    x1, y2, 0, ...        % D1 (bottom)
    x1, y1, z_top(1), ... % A2 (top)
    x2, y1, z_top(2), ... % B2 (top)
    x2, y2, z_top(3), ... % C2 (top)
    x1, y2, z_top(4));    % D2 (top)
planeInfo.z_top = sprintf('%.2f, %.2f, %.2f, %.2f', z_top(1), z_top(2), z_top(3), z_top(4));
if all(z_top > 0)
    planeInfo.display = sprintf('The plane cuts the TOP of the cuboid.\nPlease observe the 3D plot for more details.\n');
elseif all(z_top < 0)
    planeInfo.display = sprintf('The plane cuts the BOTTOM of the cuboid.\nPlease observe the 3D plot for more details.\n');
else
    planeInfo.display = sprintf('The plane INTERSECTS the bottom face of the cuboid.\nPlease observe the 3D plot for more details.\n');
end

%% Define edges & faces (12 edges, 6 faces in a cuboid)
edges = [
    1 2; 2 3; 3 4; 4 1;     % Bottom edges & faces
    5 6; 6 7; 7 8; 8 5;     % Top edges & faces
    1 5; 2 6; 3 7; 4 8      % Lateral edges & faces
    ];

% Vertex labels
vertex_labels = {'A_1', 'B_1', 'C_1', 'D_1', 'A_2', 'B_2', 'C_2', 'D_2'};

%% Plotting (original functionality)
figure;
hold on;

% Plot bottom face
patch(x(1:4), y(1:4), z(1:4), [0.8, 0.1, 0.8], 'FaceAlpha', 0.3, 'EdgeColor', 'k');

% Plot top face
patch(x(5:8), y(5:8), z(5:8), [0.1, 0.8, 0.8], 'FaceAlpha', 0.3, 'EdgeColor', 'k');

% Plot lateral faces
lateral_colors = {[0.8, 0.1, 0.1]; [0.1, 0.8, 0.1]; [0.1, 0.1, 0.8]; [0.8, 0.8, 0.1];};
for i = 1:4
    j = mod(i, 4) + 1; % Next vertex (wraps around)
    % Define face vertices: [A_i, A_j, B_j, B_i]
    face_vertices = [
        all_vertices(i,:);      % A_i
        all_vertices(j,:);      % A_j
        all_vertices(j+4,:);    % B_j
        all_vertices(i+4,:)     % B_i
        ];
    patch(face_vertices(:,1), face_vertices(:,2), face_vertices(:,3), lateral_colors{i}, 'FaceAlpha', 0.3, 'EdgeColor', 'k');
end

% Plot edges (black lines)
for i = 1:size(edges, 1)
    plot3(x(edges(i,:)), y(edges(i,:)), z(edges(i,:)), 'k-', 'LineWidth', 1.5);
end

% Annotate vertices
for i = 1:8
    text(x(i), y(i), z(i), vertex_labels{i}, 'FontSize', 12, 'FontWeight', 'bold');
end

% Label axes and title
xlabel('X'); ylabel('Y'); zlabel('Z');
if any(z_top > 0)
    title('3D Cuboid with Cut Top');
elseif any(z_top < 0)
    title('3D Cuboid with Cut Bottom');
else
    title('3D Cuboid with Intersected Bottom Face');
end
grid on;
axis equal;
view(3);  % Set 3D view

hold off;
end