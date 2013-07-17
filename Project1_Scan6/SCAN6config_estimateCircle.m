%% Estimate the center and radius of circle with >2 points on the perimeter
% The center of a circle and its radius can be estimated using at least 3
% points on the perimeter. 
%% Inputs
% * perimdata = an array of paired coordinates that is n x 2.
%% Outputs
% * x = the center x coordinate
% * y = the center y coordinate
% * r = the radius of the circle
function [xc,yc,r] = SCAN6config_estimateCircle(perimdata)
x1 = perimdata(1,1); 
y1 = perimdata(1,2);
xn = perimdata(2:end,1);
yn = perimdata(2:end,2);
coeffx = (xn-x1)./(yn-y1);
coeffy = (xn.^2 + yn.^2 - x1^2 - y1^2)./(2*(yn-y1));
[xc,yc] = leastsquaresfit(coeffx,coeffy);
r = (perimdata(:,1)-xc).^2 + (perimdata(:,2)-yc).^2;
r = mean(r);
r = sqrt(r);

function [b,a]=leastsquaresfit(x,y)
%%
% The following format is assumed: $y = a + b*x$
xm=mean(x);
ym=mean(y);
SSxx=sum(x.*x)-length(x)*xm^2;
%SSyy=sum(y.*y)-length(y)*ym^2;
SSxy=sum(x.*y)-length(x)*xm*ym;
b=SSxy/SSxx;
a=ym-b*xm;
%r2=(SSxy^2)/(SSxx*SSyy);
