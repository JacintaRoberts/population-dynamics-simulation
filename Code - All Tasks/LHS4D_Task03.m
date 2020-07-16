%% Cleanse
clc
clear
close all
format compact

%% Load Results
load('matlab.mat')

%% Obtain Data by Running ‘LHS4D’ 100 Times
LHkIterated = [];                                           % initialize results array
for i = 1:100
    fprintf(join(string({'k2 =', num2str(i)})))             % track what iteration we are up to in the command window
    fprintf('\n');
    [LHk] = LHS4D(10^-1, 0, 50, 0.5, 0, 20, 1, 1, 1);       % test 101 4-tuples with tol = 10^-1
    LHkIterated = [LHkIterated;LHk];                        % add results to array
    LHkIterated = unique(LHkIterated,'rows');               % remove duplicate rows from results array
end
LHkIterated = sortrows(LHkIterated,[1 2 3 4]);              % sort results array

%% Plot Results for Four Parameter Sweep (k2, k3, k4, and k5) ... 
% My own version of plot matrix - showing success and fails

figure
labels = {'k2', 'k3', 'k4', 'k5', 'success'};

colour = {[1 0 0],[0 1 0]};

index = 1;
N = length(LHkIterated(1,:));
for r = 1:(N-1)
    for c = 1:(N-1)
            subplot((N-1),(N-1),index)
            for i = 0:1
                indices = find(LHkIterated(:,N) == i);
                scatter(LHkIterated(indices,c),LHkIterated(indices,r),2,'filled','MarkerFaceColor',colour{i+1})
                hold on
            end
            ylabel(labels{r})
            xlabel(labels{c})
            xlim([0 50])
            ylim([0 50])
            index = index + 1;
    end
end
%% 3D Scatter - showing successes only
figure
indices = find(LHkIterated(:,5) == 1);
scatter3(LHkIterated(indices,2),LHkIterated(indices,3),LHkIterated(indices,1),20,LHkIterated(indices,4),'filled')    % draw the scatter plot

xlabel('k3')
ylabel('k4')
zlabel('k2')
xlim([0 50])
ylim([0 50])
zlim([0 25])    

cb = colorbar;
cb.Label.String = 'k5';


%%

figure
subplot(1,2,1)
for i = 0:1
    colour = {[1 0 0],[0 1 0]};
    indices = find(LHkIterated(:,4) == i);
    scatter3(LHkIterated(indices,1),LHkIterated(indices,2),LHkIterated(indices,3),20,'filled','MarkerFaceColor',colour{i+1})
    hold on
end
box on
legend('Unsuccessful','Successful','Location','southoutside')
xlabel('Value of k3')
xlim([0 50])
ylabel('Value of k4')
ylim([0 50])
zlabel('Value of k5')
zlim([0 50])
title({'Combinations of k3, k4, and k5 for Parasite Model';'Latin Hypercube Sampling with Tolerance = 10^{-1}'})

subplot(1,2,2)
for i = 0:1
    colour = {[1 0 0],[0 1 0]};
    indices = find(LHkIterated(:,4) == i);
    scatter(LHkIterated(indices,1),LHkIterated(indices,2),20,'filled','MarkerFaceColor',colour{i+1})
    hold on
end
legend('Unsuccessful','Successful','Location','southoutside')
xlabel('Value of k3')
ylabel('Value of k4')
title({'Combinations of k3 and k4 for all k5';'Latin Hypercube Sampling with Tolerance = 10^{-1}'})

figure
subplot(1,2,1)
for i = 0:1
    colour = {[1 0 0],[0 1 0]};
    indices = find(LHkIterated(:,4) == i);
    scatter(LHkIterated(indices,1),LHkIterated(indices,3),20,'filled','MarkerFaceColor',colour{i+1})
    hold on
end
legend('Unsuccessful','Successful','Location','southoutside')
xlabel('Value of k3')
ylabel('Value of k5')
title({'Combinations of k3 and k5 for all k4';'Latin Hypercube Sampling with Tolerance = 10^{-1}'})

subplot(1,2,2)
for i = 0:1
    colour = {[1 0 0],[0 1 0]};
    indices = find(LHkIterated(:,4) == i);
    scatter(LHkIterated(indices,2),LHkIterated(indices,3),20,'filled','MarkerFaceColor',colour{i+1})
    hold on
end
legend('Unsuccessful','Successful','Location','southoutside')
xlabel('Value of k4')
ylabel('Value of k5')
title({'Combinations of k4 and k5 for all k3';'Latin Hypercube Sampling with Tolerance = 10^{-1}'})

%% Determining Inequality Coefficients
coefficients = zeros(11*11*6*21*6,7);
p = 1;
for i = linspace(1,14/9,6)
    fprintf(join(string({'i =', num2str(i)})))
    fprintf('\n');
    for j = linspace(0,10,21)
        for k = linspace(0,0.5,6)
            for m = linspace(0,10,11)
                for n = linspace(0,1,11)
                    load('LHK100.mat')
                    LHkIterated = LHkIterated(LHkIterated(:,3) <= i*LHkIterated(:,1),:);
                    LHkIterated = LHkIterated(LHkIterated(:,2) >= j + k*LHkIterated(:,1),:);
                    LHkIterated = LHkIterated(LHkIterated(:,3) >= m - n*LHkIterated(:,2),:);
                    coefficients(p,:) = [i,j,k,m,n,sum(LHkIterated(:,4))/length(LHkIterated(:,4)),length(LHkIterated(:,4))];
                    p = p + 1;
                end
            end
        end
    end
end

%% Plot (Fraction of Successes vs Number of Successes Observed for each Coefficient Combination)
scatter(coefficients(:,6),coefficients(:,7),20,'filled')
xlabel('Fraction of Successes')
ylabel('Number of Successes Observed')
title({'Plot of Fraction of Successes vs Number of Successes Observed'; 'Given Various Coefficient Combinations'})

%% Find Best Coefficients 
maxi = coefficients(coefficients(:,6) >= 1,:);  % isolate all coefficients combinations that result only successes
[~,i] = max(maxi(:,7));                         % finds the maximum number of successes remaining
FinalCoefficients = maxi(i,1:5);                % records these coefficients

% These values are determined to be (10/9), 0, 0.1, 3, and 0.1.

%% Apply Inequalities
load('LHK100.mat')
Successes_Originally_Observed = sum(LHkIterated(:,4));
LHkIterated = LHkIterated(LHkIterated(:,3) <= (10/9)*LHkIterated(:,1),:);       % k5 <= (10/9)*k3
LHkIterated = LHkIterated(LHkIterated(:,2) >= (1/10)*LHkIterated(:,1),:);       % k4 >= (1/10)*k3
LHkIterated = LHkIterated(LHkIterated(:,3) >= 3 - (1/10)*LHkIterated(:,2),:);   % k5 >= 3 - (1/10)*k4
Fraction_of_Successes = sum(LHkIterated(:,4))/length(LHkIterated(:,4));         % 1
Successes_Lost = Successes_Originally_Observed - length(LHkIterated(:,4));      % 843
Fraction_of_Successes_Lost = Successes_Lost/Successes_Originally_Observed;      % 0.1448

%% Plot Step by Step
load('LHK100.mat')
figure
for i = 0:1
    colour = {[1 0 0],[0 1 0]};
    indices = find(LHkIterated(:,4) == i);
    scatter(LHkIterated(indices,1),LHkIterated(indices,3),20,'filled','MarkerFaceColor',colour{i+1})
    hold on
end
legend('Unsuccessful','Successful','Location','southoutside')
xlabel('Value of k3')
ylabel('Value of k5')
title({'Combinations of k3 and k5 for all k4';'Latin Hypercube Sampling with Tolerance = 10^{-1}'})
h = line([0 45],[0 50]);      % enforce the condition that k5 <= (10/9)*k3
h.Color = 'blue';

load('LHK100.mat')
LHkIterated = LHkIterated(LHkIterated(:,3) <= (10/11)*LHkIterated(:,1),:);
figure
for i = 0:1
    colour = {[1 0 0],[0 1 0]};
    indices = find(LHkIterated(:,4) == i);
    scatter(LHkIterated(indices,1),LHkIterated(indices,2),20,'filled','MarkerFaceColor',colour{i+1})
    hold on
end
legend('Unsuccessful','Successful','Location','southoutside')
xlabel('Value of k3')
ylabel('Value of k4')
title({'Combinations of k3 and k4 for all k5';'Latin Hypercube Sampling with Tolerance = 10^{-1}'})
h = line([0 50],[0 5]);      % enforce the condition that k4 >= (1/10)*k3
h.Color = 'blue';

load('LHK100.mat')
LHkIterated = LHkIterated(LHkIterated(:,3) <= (10/11)*LHkIterated(:,1),:);
LHkIterated = LHkIterated(LHkIterated(:,2) >= (1/10)*LHkIterated(:,1),:);
figure
for i = 0:1
    colour = {[1 0 0],[0 1 0]};
    indices = find(LHkIterated(:,4) == i);
    scatter(LHkIterated(indices,2),LHkIterated(indices,3),20,'filled','MarkerFaceColor',colour{i+1})
    hold on
end
legend('Unsuccessful','Successful','Location','southoutside')
xlabel('Value of k4')
ylabel('Value of k5')
title({'Combinations of k4 and k5 for all k3';'Latin Hypercube Sampling with Tolerance = 10^{-1}'})
h = line([0 30],[3 0]);      % enforce the condition that k5 >= 3 - (1/10)*k4
h.Color = 'blue';

%% Conclusions
% enforce the condition that k5 <= (11/10)*k3
% enforce the condition that k4 >= (1/10)*k3
% enforce the condition that k5 >= 3 - (1/10)*k4

%% Plot Results for Three Parameter Sweep (k3, k4, and k5) with Conditions
load('LHK100.mat')
LHkIterated = LHkIterated(LHkIterated(:,3) <= (11/10)*LHkIterated(:,1),:);      % k5 <= (11/10)*k3
LHkIterated = LHkIterated(LHkIterated(:,2) >= (1/10)*LHkIterated(:,1),:);       % k4 >= (1/10)*k3
LHkIterated = LHkIterated(LHkIterated(:,3) >= 3 - (1/10)*LHkIterated(:,2),:);   % k5 >= 3 - (1/10)*k4

figure
subplot(1,2,1)
for i = 0:1
    colour = {[1 0 0],[0 1 0]};
    indices = find(LHkIterated(:,4) == i);
    scatter3(LHkIterated(indices,1),LHkIterated(indices,2),LHkIterated(indices,3),20,'filled','MarkerFaceColor',colour{i+1})
    hold on
end
box on
legend('Unsuccessful','Successful','Location','southoutside')
xlabel('Value of k3')
xlim([0 50])
ylabel('Value of k4')
ylim([0 50])
zlabel('Value of k5')
zlim([0 50])
title({'Combinations of k3, k4, and k5 for Parasite Model';'Latin Hypercube Sampling with Tolerance = 10^{-1}'})

subplot(1,2,2)
for i = 0:1
    colour = {[1 0 0],[0 1 0]};
    indices = find(LHkIterated(:,4) == i);
    scatter(LHkIterated(indices,1),LHkIterated(indices,2),20,'filled','MarkerFaceColor',colour{i+1})
    hold on
end
legend('Unsuccessful','Successful','Location','southoutside')
xlabel('Value of k3')
ylabel('Value of k4')
title({'Combinations of k3 and k4 for all k5';'Latin Hypercube Sampling with Tolerance = 10^{-1}'})

figure
subplot(1,2,1)
for i = 0:1
    colour = {[1 0 0],[0 1 0]};
    indices = find(LHkIterated(:,4) == i);
    scatter(LHkIterated(indices,1),LHkIterated(indices,3),20,'filled','MarkerFaceColor',colour{i+1})
    hold on
end
legend('Unsuccessful','Successful','Location','southoutside')
xlabel('Value of k3')
ylabel('Value of k5')
title({'Combinations of k3 and k5 for all k4';'Latin Hypercube Sampling with Tolerance = 10^{-1}'})

subplot(1,2,2)
for i = 0:1
    colour = {[1 0 0],[0 1 0]};
    indices = find(LHkIterated(:,4) == i);
    scatter(LHkIterated(indices,2),LHkIterated(indices,3),20,'filled','MarkerFaceColor',colour{i+1})
    hold on
end
legend('Unsuccessful','Successful','Location','southoutside')
xlabel('Value of k4')
ylabel('Value of k5')
title({'Combinations of k4 and k5 for all k3';'Latin Hypercube Sampling with Tolerance = 10^{-1}'})