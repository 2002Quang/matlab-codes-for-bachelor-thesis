function [base_edges, top_edges, lateral_edges] = prism_edge(x, y, z_bottom, z_top, n)
% This function calculates the lengths of the edges of a prism.
% The prism is defined by the vertices of its base and top faces.
%
% Inputs:
%   x:        A column vector (n x 1) of x-coordinates of the base vertices.
%   y:        A column vector (n x 1) of y-coordinates of the base vertices.
%   z_bottom: A column vector (n x 1) of z-coordinates of the bottom vertices (e.g., zeros if the base is on the xy-plane).
%   z_top:    A column vector (n x 1) of z-coordinates of the top vertices, corresponding to each (x,y) pair of the base.
%   n:        The number of vertices of the base polygon (scalar, n >= 3).
%
% Outputs:
%   base_edges:    A column vector (n x 1) where the i-th element is the length of the base edge connecting vertex A_i to A_{i+1} (with A_{n+1} being A_1).
%   top_edges:     A column vector (n x 1) where the i-th element is the length of the top edge connecting vertex B_i to B_{i+1} (with B_{n+1} being B_1).
%   lateral_edges: A column vector (n x 1) where the i-th element is the length of the lateral edge connecting vertex A_i (bottom) to B_i (top).

% Input validation (optional but good practice)
if n < 3
    error('Number of vertices n must be at least 3.');
end
if numel(x) ~= n || numel(y) ~= n || numel(z_bottom) ~= n || numel(z_top) ~= n
    error('Coordinate vectors x, y, z_bottom, and z_top must each have n elements.');
end

% Initialize output arrays
base_edges = zeros(n, 1);
top_edges = zeros(n, 1);
lateral_edges = zeros(n, 1);

for i = 1:n
    % Determine the index of the next vertex in the polygon sequence.
    j = mod(i, n) + 1; % mod(i, n) + 1 ensures that for i = n, the next vertex is 1 (wraps around).

    % Calculate length of the base edge A_i to A_j
    % Vertices are (x(i), y(i), z_bottom(i)) and (x(j), y(j), z_bottom(j))
    base_edges(i) = sqrt((x(i) - x(j))^2 + (y(i) - y(j))^2 + (z_bottom(i) - z_bottom(j))^2);

    % Calculate length of the top edge B_i to B_j
    % Vertices are (x(i), y(i), z_top(i))  and (x(j), y(j), z_top(j))
    % Note: The x and y coordinates for B_i are the same as for A_i.
    top_edges(i) = sqrt((x(i) - x(j))^2 + (y(i) - y(j))^2 + (z_top(i) - z_top(j))^2);

    % Calculate length of the lateral edge A_i to B_i
    % Vertices are (x(i), y(i), z_bottom(i)) and (x(i), y(i), z_top(i))
    % This simplifies to the absolute difference in z-coordinates.
    lateral_edges(i) = abs(z_top(i) - z_bottom(i));
end
end