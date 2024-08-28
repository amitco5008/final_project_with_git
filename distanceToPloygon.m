function d2 = distanceToPloygon(xp,yp,xq,yq)
% xp,yp are the x,y coordinates of the polygon vertices.
% xq,yq are the x,y coordinates of a specific point outside the polygon.
% the function returns d2 - minimal distance between the point and the
% polygon.
% this code is based on:
% Alejandro Weinstein (2008). Distance from a point to polygon (https://www.mathworks.com/matlabcentral/fileexchange/19398-distance-from-a-point-to-polygon), MATLAB Central File Exchange.
%%
% If (xp,yp) is not closed, close it 
% (have the start and end points be the same, to easily get all the polygon edges, including the last one).
xp = xp(:);
yp = yp(:);
N = length(xp);
if ((xp(1) ~= xp(N)) || (yp(1) ~= yp(N)))
    xp = [xp ; xp(1)];
    yp = [yp ; yp(1)];
end
% linear parameters of segments that connect the vertices
% Ax + By + C = 0
A = -diff(yp);
B =  diff(xp);
C = yp(2:end).*xp(1:end-1) - xp(2:end).*yp(1:end-1);
% find the projection of point (x,y) on each edge
AB = 1./(A.^2 + B.^2);
vv = (A*xq+B*yq+C);
xpr = xq - (A.*AB).*vv;
ypr = yq - (B.*AB).*vv;
% find all cases where projected point is inside the segment
id_x = (((xpr>=xp(1:end-1)) & (xpr<=xp(2:end))) | ((xpr>=xp(2:end)) & (xpr<=xp(1:end-1))));
id_y = (((ypr>=yp(1:end-1)) & (ypr<=yp(2:end))) | ((ypr>=yp(2:end)) & (ypr<=yp(1:end-1))));
id = id_x & id_y;
% distance from point (x,y) to the vertices
dv = sqrt((xp(1:end-1)-xq).^2 + (yp(1:end-1)-yq).^2);
if(~any(id)) % all projections are outside of polygon edges
   d2 = min(dv);
else
   % distance from point (x,y) to the projection on edges
   dpr = sqrt((xpr(id)-xq).^2 + (ypr(id)-yq).^2);
   min_dv = min(dv);
   min_dp = min(dpr);
   d2 = min([min_dv min_dp]);
end
end