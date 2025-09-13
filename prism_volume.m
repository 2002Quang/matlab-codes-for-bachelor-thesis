function volume = prism_volume(x, y, z_bottom, z_top)
% This function calculates the volume of an oblique prism.
%   volume = PRISM_VOLUME(x, y, z_bottom, z_top) 
%   computes the volume of a prism ith vertices defined by (x, y, z_bottom) on the base and (x, y, z_top) on the top.
%
% Inputs:
%   x:        Column vector of x-coordinates of base vertices.
%   y:        Column vector of y-coordinates of base vertices.
%   z_bottom: Column vector of z-coordinates of base vertices (Optional since default = 0).
%   z_top:    Column vector of z-coordinates of top vertices.
%
% Output:
%   volume: Volume of the prism (scalar).

% --- Input Validation ---
% Check if z_bottom is provided (default to 0 if omitted)
if nargin < 3 || isempty(z_bottom)
    z_bottom = zeros(size(x)); % Default base at z = 0
end

% Ensure all inputs are column vectors
x = x(:);
y = y(:);
z_bottom = z_bottom(:);
z_top = z_top(:);

% Check vector lengths match
if ~isequal(length(x), length(y), length(z_bottom), length(z_top))
    error('Inputs x, y, z_bottom, and z_top must have the same number of elements.');
end

% Require at least 3 vertices for a valid polygon
if length(x) < 3
    error('At least 3 vertices are required to define a polygonal base.');
end

% Check for collinear points (invalid base polygon)
if rank([x, y, ones(size(x))]) < 2
    error('Base vertices are collinear. Cannot form a valid polygon.');
end

% Check for zero-height prism (warning only)
if all(abs(z_top - z_bottom) < eps)
    warning('Prism has zero height. Volume will be zero.');
end

% --- Volume Calculation ---

% Calculate base area using the Shoelace formula
area_bottom = polyarea(x, y); % MATLAB's built-in function for 2D polygon area

% Compute average height (absolute difference between top and bottom z-coordinates)
average_height = abs(mean(z_top - z_bottom));

% Volume = base area multiplies with average height
volume = area_bottom*average_height;
end