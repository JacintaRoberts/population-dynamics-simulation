function [k3] = OneParameterSweep(tol, lb, ub, inc, tl, tu, X1i, X2i, k1, k2, k4, k5)
% OneParameterSweep performs a parameter sweep for k3, where k3 
% can take on any value between lb and ub, at increments of inc. 
%
% The conditions for 'success' enforced by this Parameter Sweep are 
% that all values of X1 and X2 must be non-negative (i.e. greater than or 
% equal to zero), and X1 ? 0 + tol and X2 ? 2 ± tol. 
% 
% I experienced some conflict as to how this second condition should be 
% specified, and have been torn between classifying this condition met if 
% the final values of X1 and X2 - that is their values at Time = 20 units -
% are in [0, tol] and [2 - tol, 2 + tol] respectively, or if any of their 
% values ever enter these intervals.
% 
% Theoretically, given the equilibriums of the system are (0,k3/k4) and 
% ((k3-2(k4))/3,2) these should yield VERY similar results, as once X1 = 0
% or X2 = 2, our system enters a steady state (i.e. if X1 or X2 reach 0 or
% 2 at any time they will never change). Upon running both variations
% we see they do produce strikingly similar results, however, for small
% increments (inc) we see that the condition of "if any of their values ever
% enter these intervals" yields extra entries. The fact that these entries 
% don't appear for the "final values" condition implies that while the
% parameters take the populations close to the steady states at some points,
% i.e. within tol distance, they don't go toward them as time increases. 
% Thus, I have employed the "final values" condition in the following code.
%
% Input Variables
% tol:  The tolerance such that at T = 20 X1 is an element of 
%       [0,tol] and X2 is an element of [2-tol,2+tol].
% lb:   The lower bound on the potential range of k3.
% ub:   The upper bound on the potential range of k3.
% inc:  The increment we wish to use to step from the lower bound to the
%       upper bound of the range of k3.
% tl:   The lower bound on the time span of the simulation.
% tu:   The upper bound on the time span of the simulation.
% X1i:  The initial condition of X1 (i.e. the value of X1 at t1).
% X2i:  The initial condition of X2 (i.e. the value of X2 at t1).
% k1:   The birth rate of X1.
% k2:   The death rate of X1.
% k4:   Rate of food decay.
% k5:   Rate of food consumption.
% 
% Output Variables
% k3:   An array containing the successful values of the k3 parameter (i.e. 
%       the rate of food growth) according to the aforementioned conditions 
%       in the first column, and coded values based on which condition was 
%       met to make it successful in the second column (i.e. 0 if at T = 20
%       X1 is an element of [0, tol], 1 if X2 is an element of [2 - tol, 
%       2 + tol], and 2 if both conditions are met).

tspan = [tl tu];                                        % defines time span vector given tl and tu
X0 = [X1i X2i];                                         % defines initial condition vector given X1i and X2i
PotentialValues = linspace(lb,ub,((ub-lb)/inc)+1);      % defines a vector containing possible vales of k3
k3 = zeros(length(PotentialValues),2);                  % defines an empty array 'k3' as defined in the output section above
j = 1;                                                  % initializes index to iterate through k3
for i = PotentialValues                                 % indexes through possible values of k3
    [~,X] = ode45(@(t,X)ParasiteModelFn(t,X,k1,k2,i,k4,k5), tspan, X0);             % determines X = [X1 X2] for k3 = i using external function
    if all(all(X >= 0)) && ((abs(X(end,1)) <= tol) || (abs(X(end,2)-2) <= tol))     % success conditions
        k3(j,1) = i;                        % records successful values of k3
        if (abs(X(end,2)-2) <= tol)
            k3(j,2) = 1;                    % sets coded value to 1 if X2 is an element of [2 - tol, 2 + tol] at T = 20
            if (abs(X(end,1)) <= tol)
                k3(j,2) = 2;                % sets coded value to 2 if X1 is also an element of [0, tol] at T = 20
            end
        end
        j = j + 1;                          % increases index k3 recording index by 1
    end
end
k3 = k3(1:j-1,:);                           % removes unnecessary/unused rows of k3

end