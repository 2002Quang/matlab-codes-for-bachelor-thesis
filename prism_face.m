function [bottom_face, top_face, lateral_face] = prism_face(x, y, z_bottom, z_top, n)
% This function calculates the area of each face of a general prism.
%
% Inputs:
%   x:        Column vector of x-coordinates of the base vertices.
%   y:        Column vector of y-coordinates of the base vertices.
%   z_bottom: Column vector of z-coordinates of the bottom vertices.
%   z_top:    Column vector of z-coordinates of the top vertices.
%   n:        Number of vertices of the base polygon (must be >= 3).
%
% Outputs:
%   bottom_face  - Scalar: Area of the bottom face.
%   top_face     - Scalar: True 3D area of the top face.
%   lateral_face - Column vector (nx1): Areas of the lateral faces.

% --- Calculate the area of the bottom face ---
% Using the Shoelace formula for a polygon in the xy-plane (or its projection).
% Assumes z_bottom coordinates define a plane (e.g., all are 0 for a base on xy-plane).
bottomCalc = 0;
for i = 1:n
    j = mod(i, n) + 1; % Index of the next vertex, wraps around
    bottomCalc = bottomCalc + (x(i)*y(j) - x(j)*y(i));
end
bottom_face = 0.5*abs(bottomCalc);

% --- Calculate the true 3D area of the top face ---
% The top face vertices are (x(i), y(i), z_top(i)).
% We sum the areas of triangles formed by a common vertex (e.g., T_1) and successive pairs of other vertices (T_1, T_i, T_{i+1}).
topCalc = 0;
if n >= 3
    % Define the first vertex of the top face as the common point for triangles
    T1 = [x(1), y(1), z_top(1)];

    % Iterate through other vertices to form triangles (T1, T_i, T_{i+1})
    for i = 2:(n-1)
        Ti = [x(i), y(i), z_top(i)];
        Ti_plus_1 = [x(i+1), y(i+1), z_top(i+1)];

        % Vectors from T1 to Ti and T1 to Ti_plus_1
        vec1_top = Ti - T1;
        vec2_top = Ti_plus_1 - T1;

        % Area of the triangle is half of norm of the cross product
        topCalc = topCalc + 0.5*norm(cross(vec1_top, vec2_top));
    end
end
top_face = topCalc;

% --- Calculate the area of each lateral face ---
% Initialize array for lateral face areas
lateral_face = zeros(n, 1); 
for i = 1:n
    j = mod(i, n) + 1; % Index of the next vertex, wraps around

    % Vertices of the i-th lateral face: A_i, A_j, B_j, B_i
    % A_i: bottom vertex i
    % A_j: bottom vertex j
    % B_j: top vertex j (corresponding to A_j)
    % B_i: top vertex i (corresponding to A_i)

    P1 = [x(i), y(i), z_bottom(i)]; % Vertex A_i
    P2 = [x(j), y(j), z_bottom(j)]; % Vertex A_j
    P3 = [x(j), y(j), z_top(j)];    % Vertex B_j 
    P4 = [x(i), y(i), z_top(i)];    % Vertex B_i 

    % Decompose the quadrilateral lateral face (P1-P2-P3-P4) into two triangles:
    
    % Triangle 1: P1, P2, P3 (A_i, A_j, B_j)
    vec_P1P2 = P2 - P1;
    vec_P1P3 = P3 - P1;
    area_triangle1 = 0.5*norm(cross(vec_P1P2, vec_P1P3));

    % Triangle 2: P1, P3, P4 (A_i, B_j, B_i)
    % vec_P1P3 is already calculated
    vec_P1P4 = P4 - P1;
    area_triangle2 = 0.5*norm(cross(vec_P1P3, vec_P1P4));

    lateral_face(i) = area_triangle1 + area_triangle2;
end
end