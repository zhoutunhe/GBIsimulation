%returns a matrix containing the thickness of object for each x,y in X,Y
function t = objectThickness(object,X,Y)
%translated, rotated and scaled coordinates
x=((X-object.x)*cos(object.rotation)-...
    (Y-object.y)*sin(object.rotation))*2/object.width;
y=((X-object.x)*sin(object.rotation)+...
    (Y-object.y)*cos(object.rotation))*2/object.height;
if strcmp(object.type,'Ellipsoid')
    r2=(x.^2+y.^2);
    t = (r2<1).*sqrt(1-r2);
elseif strcmp(object.type,'Cylinder')
    t = ((abs(y)<1).*(abs(x)<1)).*sqrt(1-x.^2);
elseif strcmp(object.type,'Box')
    t = (abs(x)<1).*(abs(y)<1);
elseif strcmp(object.type,'Prism')
    t = (abs(y)<1).*(abs(x)<1).*(1-abs(x));
elseif strcmp(object.type,'Wedge')
    t = (abs(y)<1).*(abs(x)<1).*((1+x)/2);
elseif strcmp(object.type,'Disc')
    t = ((x.^2+y.^2)<1);
elseif strcmp(object.type,'Grating')
    t = (abs(x)<1).*(abs(y)<1).*mod(round(x*object.width/object.period),2);
elseif strcmp(object.type,'Flat edge')
    if object.width == 0
        t = ((X-object.x)*cos(object.rotation)-...
        (Y-object.y)*sin(object.rotation)) < 0;
    else
        t = (x<=-1) + (x>-1).*(x<0).*(-x);
    end
elseif strcmp(object.type,'Round edge')
    %R = object.thickness/8/object.width+object.width/2
    %R = R/object.width;
    %t = (x<=-1) + (x>-1).*(x<0).*sqrt((-2*R*x-x.^2)/(2*R-1));
    t = (x<=-1) + (x>-1).*(x<0).*sqrt(-2*x-x.^2);
elseif strcmp(object.type,'Zone plate')
    r2=(x.^2+y.^2);
    t = (r2<1).*mod(floor(r2*(object.width/2/object.period)),2);
elseif strcmp(object.type,'Sinusoidal zone plate')
    r2=(x.^2+y.^2);
    t = (r2<1).*(1+cos(r2*(pi*object.width/2/object.period)))./2;
elseif strcmp(object.type,'Function')
%     t = objectFunction(object, X, Y)./object.thickness;
t = abs(1+randn(size(X)));
else
    warning(['ERROR: invalid type of object :' obj.type]);
    t=[];
end
t = t*object.thickness;