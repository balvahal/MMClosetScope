%% Estimate the center and radius of circle with >2 points on the perimeter
% The center of a circle and its radius can be estimated using at least 3
% points on the perimeter. 
%
% Why was this function created? Aligning the center of a dish with an
% objective can be challenging by eye. It is easier to identify the
% perimeter at the plastic-glass interface of a Mattek dish through and
% objective and then calculating the circle center from this information.
%% Inputs
% * perimdata = an array of paired coordinates that is n x 2.
%% Outputs
% * xc = the center x coordinate
% * yc = the center y coordinate
% * r = the radius of the circle
function [xc,yc,r] = SCAN6config_estimateCircle(perimdata)
if size(perimdata,1)<3
    warning('SCAN6cng_estCir:NotEnoughPts','The input array of (x,y) coordinates did not contain enough data points to make an estimate.');
    [xc,yc,r] = deal(NaN);
    return
end
x1 = perimdata(1,1); 
y1 = perimdata(1,2);
xn = perimdata(2:end,1);
yn = perimdata(2:end,2);
%% Proofread the data points
% * data points should not be identical with the first value.
% * there is a singularity if the y-value of the first point is the same as
% the y-value of an nth point. This must also be avoided.
% * the "coeffx" should not be too large and bias the estimate
testnumx = xn-x1;
testnumy = yn-y1;
testsumchk = testnumx+testnumy ~= 0;
if ~all(testsumchk)
    warning('SCAN6cng_estCir:firstValRedundant','The first pair of points in the input array of (x,y) coordinates is identical to another pair of points in the array.');
    [xc,yc,r] = deal(NaN);
    return
end
if ~all(testnumy)
    warning('SCAN6cng_estCir:firstValYRedundant','The first y-value in the input array of (x,y) coordinates is identical to another y-value in the array.');
    [xc,yc,r] = deal(NaN);
    return
end
%% Calculate the estimate for the center and radius
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
