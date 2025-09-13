function volume = cuboid_volume(x1_rect, y1_rect, x2_rect, y2_rect, p_a, p_b, p_c, p_d)
% This function calculates the volume of a cuboid.
% The cuboid is defined by a rectangular base in the z = 0 plane and a cutting plane ax + by + cz + d = 0 that defines its top surface.
%
% The base is defined by corners (x1_rect, y1_rect) and (x2_rect, y2_rect).
% The top surface height is given by z_plane(x,y) = (-p_a*x - p_b*y - p_d)/p_c.
%
% Interpretation of Volume:
% 1. If z_plane(x,y) > 0 over the entire base: Volume is the integral of z_plane(x,y).
% 2. If z_plane(x,y) < 0 over the entire base: Volume is abs(integral of z_plane(x,y)), representing the space between z=0 and the plane below it.
% 3. If z_plane(x,y) crosses z=0 over the base: Volume is the integral of max(0, z_plane(x,y)), representing the portion of the solid strictly above the z = 0 plane.
%
% Inputs:
%   x1_rect: x-coordinate of the first corner of the rectangular base.
%   y1_rect: y-coordinate of the first corner of the rectangular base.
%   x2_rect: x-coordinate of the opposite corner of the rectangular base.
%   y2_rect: y-coordinate of the opposite corner of the rectangular base.
%   p_a:     Coefficient 'a' of the plane equation ax + by + cz + d = 0.
%   p_b:     Coefficient 'b' of the plane equation ax + by + cz + d = 0.
%   p_c:     Coefficient 'c' of the plane equation ax + by + cz + d = 0 (must NOT be zero).
%   p_d:     Coefficient 'd' of the plane equation ax + by + cz + d = 0.
%
% Output:
%   volume: Calculated volume, based on the interpretation above.

% --- Input Validation ---
% Check if all inputs are numeric
inputs = {x1_rect, y1_rect, x2_rect, y2_rect, p_a, p_b, p_c, p_d};
if ~all(cellfun(@isnumeric, inputs))
    error('All input arguments must be numeric.');
end

% Coefficient 'c' for z in the plane equation cannot be 0 for this method
if p_c == 0
    error('Coefficient p_c (for z in plane equation) cannot be zero for this volume calculation method.');
end

% Determine integration limits for the rectangle,  ensuring x_min <= x_max and y_min <= y_max
rect_xmin = min(x1_rect, x2_rect);
rect_xmax = max(x1_rect, x2_rect);
rect_ymin = min(y1_rect, y2_rect);
rect_ymax = max(y1_rect, y2_rect);

% Calculate z-coordinates of the cutting plane  at the four corners of the base rectangle.
% The height function is z_plane(x,y) = (-p_a*x - p_b*y - p_d)/p_c.
z_at_c1 = (-p_a*x1_rect - p_b*y1_rect - p_d)/p_c; % At (x1_rect, y1_rect)
z_at_c2 = (-p_a*x2_rect - p_b*y1_rect - p_d)/p_c; % At (x2_rect, y1_rect)
z_at_c3 = (-p_a*x2_rect - p_b*y2_rect - p_d)/p_c; % At (x2_rect, y2_rect)
z_at_c4 = (-p_a*x1_rect - p_b*y2_rect - p_d)/p_c; % At (x1_rect, y2_rect)

all_z_plane_corners = [z_at_c1, z_at_c2, z_at_c3, z_at_c4];

% Define the integrand function for the height z_plane(x,y)
integrand_z_plane = @(x_val,y_val) (-p_a*x_val - p_b*y_val - p_d)/p_c;

% --- Volume Calculation ---
% This is based on the plane's position relative to z = 0
if all(all_z_plane_corners > 0)
    % Case 1: The cutting plane is entirely above the z = 0 base over the rectangle.
    % The volume is the integral of z_plane(x,y).
    volume = integral2(integrand_z_plane, rect_xmin, rect_xmax, rect_ymin, rect_ymax);

elseif all(all_z_plane_corners < 0)
    % Case 2: The cutting plane is entirely below the z = 0 base over the rectangle.
    % The volume is the space between z = 0 and the plane (which is below z = 0).
    % The integral of z_plane(x,y) will be negative, so abs() makes it a positive volume.
    volume = abs(integral2(integrand_z_plane, rect_xmin, rect_xmax, rect_ymin, rect_ymax));

else
    % Case 3: The cutting plane intersects the z = 0 base, or some corners are above z = 0 and some are below.
    % The volume calculated is the portion of the solid that lies above the z = 0 plane.
    % This is achieved by integrating max(0, z_plane(x,y)).
    volume = integral2(@(x_val,y_val) max(0, integrand_z_plane(x_val, y_val)), rect_xmin, rect_xmax, rect_ymin, rect_ymax);
end
end