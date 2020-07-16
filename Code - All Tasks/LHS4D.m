function [LHk] = LHS4D(tol,lb,ub,inc,tl,tu,X1i,X2i,k1)
% LHC4D implements Latin Hypercube Sampling on the 4D space for parameters
% k2, k3, k4, and k5, and returns an array containing all tested 4-tuples with
% coded values indicating whether they were 'successful' in accordance with
% specified criteria.
%
% First, LHC4D generates 3-tuples of k2, k3, k4, and k5, between lb and ub, at 
% increments of inc. By definition, an (n x n) Latin square in 2D space is
% defined when there is only one sample in each row and column. Extending 
% this to 4D, LHC4D defines k2 as a vector containing all potential values 
% the parameters could take on from within the range at the specified 
% incrementation, and creates corresponding 4-tuples such that each row, 
% column, and level contain at most one value by sampling from k2 without 
% replacement to form k3, k4 and k5.
%
% The conditions for 'success' enforced by this Parameter Sweep are
% that all values of X1 and X2 must be non-negative (i.e. greater than or
% equal to zero), and the values of X1 and X2 at Time = 20 units are in
% [0,tol] or [2-tol,2+tol] respectively.
%
% Input Variables
% tol:  The tolerance such that at t = 20 X1 is an element of 
%       [0,tol] or X2 is an element of [2-tol,2+tol].
% lb:   The lower bound on the potential ranges of k3, k4, and k5.
% ub:   The upper bound on the potential ranges of k3, k4, and k5.
% inc:  The increment we wish to use to step from the lower bound to the
%       upper bound of the ranges of k3, k4, and k5.
% tl:   The lower bound on the time span of the simulation.
% tu:   The upper bound on the time span of the simulation.
% X1i:  The initial condition of X1 (i.e. the value of X1 at t = 1).
% X2i:  The initial condition of X2 (i.e. the value of X2 at t = 1).
% k1:   The birth rate of X1 (i.e. parasite).
% k2:   The death rate of X1.
%
% Output Variables
% LHk:  An array containing all combinations of k2, k3, k4, and k5 tested in
%       in this LHS in columns one through four. Column five contains coded
%       values based on whether the combination is 'successful' (i.e. 0 if
%       unsuccessful and 1 if successful).

% Generate ((ub-lb)/inc)+1 4-tuples of k2, k3, k4, and k5 to test.
k2 = linspace(lb,ub,((ub-lb)/inc)+1)';
k3 = datasample(k2,length(k2),'Replace',false);
k4 = datasample(k2,length(k2),'Replace',false);
k5 = datasample(k2,length(k2),'Replace',false);
LHk = [k2, k3, k4, k5, zeros(length(k2),1)];

tspan = [tl tu];                            % defines time span vector given tl and tu
X0 = [X1i X2i];                             % defines initial condition vector given X1i and X2i
for i = 1:length(k2)                        % indexes through each 4-tuples
    [~,X] = ode45(@(t,X)ParasiteModelFn(t,X,k1,LHk(i,1),LHk(i,2),LHk(i,3),LHk(i,4)), tspan, X0);      % determines X = [X1 X2] for [k3,k4,k5] = LHk(i,1:3) using external function
    if all(all(X >= 0)) && ((abs(X(end,1)) <= tol) || (abs(X(end,2)-2) <= tol))                 % success conditions
        LHk(i,5) = 1;                       % records successful 4-tuples
    end
end

end