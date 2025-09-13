function [edge_lengths, edge_labels_disp] = cuboid_edge(x_coords, y_coords, z_coords, edges_matrix, vertex_labels_cell)
% This function calculates the length of edges of a cuboid.
%
% This function takes the coordinates of the vertices, the definition of edges, and labels for each vertex to compute the length of each edge.
%
% Inputs:
%   x_coords:           1xN array of x-coordinates of the N vertices.
%   y_coords:           1xN array of y-coordinates of the N vertices.
%   z_coords:           1xN array of z-coordinates of the N vertices.
%   edges_matrix:       A M-by-2 matrix where M is the number of edges.
%                       Each row contains the 1-based indices of the two vertices forming an edge, referencing the coordinate arrays.
%   vertex_labels_cell: A 1xN cell array of strings containing labels for each vertex (e.g., {'A1', 'B1', ...}).
%
% Outputs:
%   edge_lengths:     A M-by-1 column vector containing the length of each edge.
%   edge_labels_disp: A M-by-1 cell array of strings. 
%                     Each string is formatted as 'V1LBLV2LBL = length' (e.g., 'A1B1 = 5.00') for display purposes.

% --- Input Validation ---
% Check if x_coords is a numeric vector
if ~isnumeric(x_coords) || ~isvector(x_coords)
    error('Input x_coords must be a numeric vector.');
end
% Check if y_coords is a numeric vector
if ~isnumeric(y_coords) || ~isvector(y_coords)
    error('Input y_coords must be a numeric vector.');
end
% Check if z_coords is a numeric vector
if ~isnumeric(z_coords) || ~isvector(z_coords)
    error('Input z_coords must be a numeric vector.');
end

num_vertices = length(x_coords);
% Check if all coordinate vectors have the same number of elements
if length(y_coords) ~= num_vertices || length(z_coords) ~= num_vertices
    error('Input coordinate vectors x_coords, y_coords, and z_coords must all have the same number of elements.');
end

% Check if edges_matrix is a numeric matrix with two columns
if ~isnumeric(edges_matrix) || size(edges_matrix, 2) ~= 2
    error('Input edges_matrix must be a numeric matrix with two columns.');
end
% Check if edge indices are valid
if ~isempty(edges_matrix) && (max(edges_matrix(:)) > num_vertices || min(edges_matrix(:)) < 1)
    error('Edge indices in edges_matrix are out of bounds for the number of vertices provided.');
end

% Check if vertex_labels_cell is a cell array of strings 
% with the correct number of labels
if ~iscellstr(vertex_labels_cell) || length(vertex_labels_cell) ~= num_vertices
    error('Input vertex_labels_cell must be a cell array of strings, with one label for each vertex.');
end

% --- Edge Length Calculation ---

num_edges = size(edges_matrix, 1);

% Initialize as a column vector for storing lengths
edge_lengths = zeros(num_edges, 1);   
% Initialize as a column cell vector for display strings
edge_labels_disp = cell(num_edges, 1); 

% Loop through each edge defined in the edges_matrix
for i = 1:num_edges
    % Get the 1-based indices of the two vertices forming the current edge
    idx1 = edges_matrix(i, 1);
    idx2 = edges_matrix(i, 2);

    % Get the coordinates of the two endpoints of the edge (P1 and P2) 
    % P1 and P2 will be 1x3 vectors: [x, y, z]
    P1 = [x_coords(idx1), y_coords(idx1), z_coords(idx1)];
    P2 = [x_coords(idx2), y_coords(idx2), z_coords(idx2)];

    % Calculate the Euclidean distance (length of the edge)
    % The norm(V) function calculates the magnitude (or L2 norm) of a vector V.
    current_length = norm(P2 - P1); % (P2 - P1) gives the vector pointing from P1 to P2.

    % Store the calculated length
    edge_lengths(i) = current_length; 

    % Get the string labels for the vertices of the current edge
    label1 = vertex_labels_cell{idx1};
    label2 = vertex_labels_cell{idx2};

    % Create the formatted string for display
    edge_labels_disp{i} = ['Length of edge ' , label1, label2, ' = ', sprintf('%.2f\n', current_length)];
end
end