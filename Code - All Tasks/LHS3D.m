function [LHk] = LHS3D(tol, lb, ub, inc, tl, tu, X1i, X2i, k1, k2)
% LHS3D implements Latin Hypercube Sampling on the 3D space of parameters
% k3, k4, and k5. First, it generates 3-tuples of k3, k4, and k5, between
% lb and ub, at increments of inc.
%
% The conditions for 'success' enforced by this Parameter Sweep are
% that all values of X1 and X2 must be non-negative (i.e. greater than or
% equal to zero), and the values of X1 and X2 at Time = 20 units are in
% [0, tol] and [2 - tol, 2 + tol] respectively.
%
% Input Variables
% tol:  The tolerance such that at T = 20 X1 is an element of
%       [0,tol] and X2 is an element of [2-tol,2+tol].
% lb:   The lower bound on the potential ranges of k3, k4, and k5.
% ub:   The upper bound on the potential ranges of k3, k4, and k5.
% inc:  The increment we wish to use to step from the lower bound to the
%       upper bound of the ranges of k3, k4, and k5.
% tl:   The lower bound on the time span of the simulation.
% tu:   The upper bound on the time span of the simulation.
% X1i:  The initial condition of X1 (i.e. the value of X1 at t1).
% X2i:  The initial condition of X2 (i.e. the value of X2 at t1).
% k1:   The birth rate of X1.
% k2:   The death rate of X1.
%
% Output Variables
% LHk:  An array containing all combinations of k3, k4, and k5 tested in
%       in this LHS in columns one through three. Column contains coded
%       values based on whether the combination is 'successful' (i.e. 0 if
%       unsuccessful and 1 if successful).

% Generate ((ub-lb)/inc)+1 3-tuples of k3, k4, and k5 to test.
k3 = linspace(lb,ub,((ub-lb)/inc)+1)';
LHk = [k3, datasample(k3,length(k3),'Replace',false), datasample(k3,length(k3),'Replace',false), zeros(length(k3),1)];

tspan = [tl tu];                            % defines time span vector given tl and tu
X0 = [X1i X2i];                             % defines initial condition vector given X1i and X2i
for i = 1:length(k3)                        % indexes through each 3-tuples
    [~,X] = ode45(@(t,X)ParasiteModelFn(t,X,k1,k2,LHk(i,1),LHk(i,2),LHk(i,3)), tspan, X0);      % determines X = [X1 X2] for [k3,k4,k5] = LHk(i,1:3) using external function
    if all(all(X >= 0)) && ((abs(X(end,1)) <= tol) || (abs(X(end,2)-2) <= tol))                 % success conditions
        LHk(i,4) = 1;                       % records successful 3-tuples
    end
end

end