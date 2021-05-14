function t2scan=scanning(t2,n,dx,dx0,p)
%n: nth step
%dx: distance of each step
%p - peirod
N=length(t2);
shift=round(dx/dx0*n);  %the number of points shifted in nth step
for i=1:N
    if i<=shift
        t2scan(:,i)=t2(:,i-shift+p);  %move the end of grating to the start part
    else
        t2scan(:,i)=t2(:,i-shift);  %move the points to the right side
    end
end