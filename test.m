function x = test(varargin)
x=ones(1,10);
r=randperm(10,2);
x(r)=2;

end