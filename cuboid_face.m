function [face_areas, face_labels_disp] = cuboid_face(x_coords, y_coords, z_coords, faces_matrix, vertex_labels_cell)
% This function calculates the area of each quadrilateral face of a cuboid.
%
% This function assumes each face is a quadrilateral (defined by 4 vertices) and calculates its area by dividing it into two triangles. 
% The vertices for each face in faces_matrix should be listed in sequential order (clockwise or counter-clockwise).
%
% Inputs:
%   x_coords:           1xN array of x-coordinates of the N vertices.
%   y_coords:           1xN array of y-coordinates of the N vertices.
%   z_coords:           1xN array of z-coordinates of the N vertices.
%   faces_matrix:       A M-by-4 matrix where M is the number of faces.
%                       Each row must contain the 1-based indices of the four vertices forming a quadrilateral face, in order.
%   vertex_labels_cell: A 1xN cell array of strings containing labels for each vertex (e.g., {'A1', 'B1', ...}).
%
% Outputs:
%   face_areas:       A M-by-1 column vector containing the area of each face.
%   face_labels_disp: A M-by-1 cell array of strings. 
%                     Each string is formatted as 'Area(VL1VL2VL3VL4) = area' for display.

% --- Input Validation ---
if ~isnumeric(x_coords) || ~isvector(x_coords)
    error('Input x_coords must be a numeric vector.');
end
if ~isnumeric(y_coords) || ~isvector(y_coords)
    error('Input y_coords must be a numeric vector.');
end
if ~isnumeric(z_coords) || ~isvector(z_coords)
    error('Input z_coords must be a numeric vector.');
end

num_vertices = length(x_coords);
if length(y_coords) ~= num_vertices || length(z_coords) ~= num_vertices
    error('Input coordinate vectors x_coords, y_coords, and z_coords must all have the same number of elements.');
end

if ~isnumeric(faces_matrix) || ndims(faces_matrix) ~= 2
    error('Input faces_matrix must be a 2D numeric matrix.');
end
if size(faces_matrix, 2) ~= 4
    error('Function cuboid_face expects quadrilateral faces (4 vertices per face). faces_matrix must have 4 columns.');
end
if ~isempty(faces_matrix) && (max(faces_matrix(:)) > num_vertices || min(faces_matrix(:)) < 1)
    error('Face indices in faces_matrix are out of bounds for the number of vertices provided.');
end

if ~iscellstr(vertex_labels_cell) || length(vertex_labels_cell) ~= num_vertices
    error('Input vertex_labels_cell must be a cell array of strings, with one label for each vertex.');
end

% --- Face Area Calculation ---
num_faces = size(faces_matrix, 1);
face_areas = zeros(num_faces, 1); % Initialize column vector for areas
face_labels_disp = cell(num_faces, 1); % Initialize column cell vector for display strings

% Loop through each face defined in faces_matrix
for i = 1:num_faces
    % Get the 1-based indices of the four vertices for the current face
    vertex_indices = faces_matrix(i, :); % Contains [idx_v1, idx_v2, idx_v3, idx_v4]

    % Retrieve the 3D coordinates of these four vertices
    % v1_coords, v2_coords, v3_coords, v4_coords are 1x3 vectors [x, y, z]
    v1_coords = [x_coords(vertex_indices(1)); y_coords(vertex_indices(1)); z_coords(vertex_indices(1))];
    v2_coords = [x_coords(vertex_indices(2)); y_coords(vertex_indices(2)); z_coords(vertex_indices(2))];
    v3_coords = [x_coords(vertex_indices(3)); y_coords(vertex_indices(3)); z_coords(vertex_indices(3))];
    v4_coords = [x_coords(vertex_indices(4)); y_coords(vertex_indices(4)); z_coords(vertex_indices(4))];

    % Calculate the area of the quadrilateral face by splitting it into two triangles:
    % Triangle 1 is formed by (v1, v2, v3)
    % Triangle 2 is formed by (v1, v3, v4)
    % This triangulation works for convex quadrilaterals. 
    % Cuboid faces are planar and convex.

    % Calculate vectors for Triangle 1 (v1, v2, v3)
    vec_12 = v2_coords - v1_coords; % Vector from v1 to v2
    vec_13 = v3_coords - v1_coords; % Vector from v1 to v3

    % Area of Triangle 1 = half of magnitude of (cross product of vec_12 and vec_13)
    area_triangle1 = 0.5*norm(cross(vec_12, vec_13));

    % Calculate vectors for Triangle 2 (v1, v3, v4)
    % vec_13 is already calculated (vector from v1 to v3)
    vec_14 = v4_coords - v1_coords; % Vector from v1 to v4

    % Area of Triangle 2 = half magnitude of (cross product of vec_13 and vec_14)
    area_triangle2 = 0.5*norm(cross(vec_13, vec_14)); 

    % Total area of the quadrilateral face is the sum of the two triangle areas
    current_area = area_triangle1 + area_triangle2;
    face_areas(i) = current_area; % Store the calculated area

    % Retrieve the string labels for the vertices of the current face
    lb1 = vertex_labels_cell{vertex_indices(1)};
    lb2 = vertex_labels_cell{vertex_indices(2)};
    lb3 = vertex_labels_cell{vertex_indices(3)};
    lb4 = vertex_labels_cell{vertex_indices(4)};

    % Create the formatted string for display
    face_labels_disp{i} = ['Area of surface ', lb1, lb2, lb3, lb4, ' = ', sprintf('%.2f\n', current_area)];
end
end