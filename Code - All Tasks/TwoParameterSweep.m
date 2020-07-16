function [k3k4] = TwoParameterSweep(tol, lb, ub, inc, tl, tu, X1i, X2i, k1, k2, k5)
% TwoParameterSweep performs a parameter sweep for k3 and k4, where k3 and
% k4 can take on any value between lb and ub, at increments of inc.
%
% The conditions for 'success' enforced by this Parameter Sweep are
% that all values of X1 and X2 must be non-negative (i.e. greater than or
% equal to zero), and the values of X1 and X2 at Time = 20 units are in
% [0, tol] and [2 - tol, 2 + tol] respectively.
%
% Input Variables
% tol:  The tolerance such that at T = 20 X1 is an element of
%       [0,tol] and X2 is an element of [2-tol,2+tol].
% lb:   The lower bound on the potential ranges of k3 and k4.
% ub:   The upper bound on the potential ranges of k3 and k4.
% inc:  The increment we wish to use to step from the lower bound to the
%       upper bound of the ranges of k3 and k4.
% tl:   The lower bound on the time span of the simulation.
% tu:   The upper bound on the time span of the simulation.
% X1i:  The initial condition of X1 (i.e. the value of X1 at t1).
% X2i:  The initial condition of X2 (i.e. the value of X2 at t1).
% k1:   The birth rate of X1.
% k2:   The death rate of X1.
% k5:   Rate of food consumption.
%
% Output Variables
% k3k4: An array containing the successful pairs of values of the k3 and k4
%       parameters (i.e. the rate of food growth and the rate of food decay)
%       according to the aforementioned conditions in the first two columns,
%       and coded values based on which conditions were met to make it
%       successful in the third column (i.e. 0 if at T = 20 X1 is an element
%       of [0, tol], 1 if X2 is an element of [2 - tol, 2 + tol], and 2 if
%       both conditions are met).

tspan = [tl tu];                                        % defines time span vector given tl and tu
X0 = [X1i X2i];                                         % defines initial condition vector given X1i and X2i
PotentialValues = linspace(lb,ub,((ub-lb)/inc)+1);      % defines a vector containing possible vales of k3 and k4
k3k4 = zeros(length(PotentialValues)^2,3);              % defines an empty array 'k3k4' as defined in the output section above
n = 1;                                                  % initializes index to iterate through k3k4
for i = PotentialValues                                 % indexes through possible values of k3
    fprintf(join(string({'k3 =', num2str(i)})))         % track what k3 value we are up to in the command window
    fprintf('\n');
    for j = PotentialValues                             % indexes through possible values of k4
        [~,X] = ode45(@(t,X)ParasiteModelFn(t,X,k1,k2,i,j,k5), tspan, X0);              % determines X = [X1 X2] for k3 = i using external function
        if all(all(X >= 0)) && ((abs(X(end,1)) <= tol) || (abs(X(end,2)-2) <= tol))     % success conditions
            k3k4(n,1) = i;                      % records successful values of k3
            k3k4(n,2) = j;                      % records successful values of k4
            if (abs(X(end,2)-2) <= tol)
                k3k4(n,3) = 1;                  % sets coded value to 1 if X2 is an element of [2 - tol, 2 + tol] at T = 20
                if (abs(X(end,1)) <= tol)
                    k3k4(n,3) = 2;              % sets coded value to 2 if X1 is also an element of [0, tol] at T = 20
                end
            end
            n = n + 1;                          % increases index k3 recording index by 1
        end
    end
end
k3k4 = k3k4(1:n-1,:);                           % removes unnecessary/unused rows of k3

end