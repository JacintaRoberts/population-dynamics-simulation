%% Get Data
LHkIterated = [];
for i = 1:100
    fprintf(join(string({'k3 =', num2str(i)})))         % track what iteration we are up to in the command window
    fprintf('\n');
    [LHk] = LHS3D(10^-1, 0, 50, 0.5, 0, 20, 1, 1, 1, 2);
    LHkIterated = [LHkIterated;LHk];
    LHkIterated = unique(LHkIterated,'rows');
end
LHkIterated = sortrows(LHkIterated,[1 2 3]);

%% Plot Unrestricted Data
load('LHK100.mat')
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

%% Determining Coefficients
coefficients = zeros(11*11*6*21*6,7);
p = 1;
for i = linspace(1,1.5,6)
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

%% Plot
scatter(coefficients(:,6),coefficients(:,7),20,'filled')
xlabel('Fraction of Successes')
ylabel('Number of Successes Observed')
title({'Plot of Fraction of Successes vs Number of Successes Observed'; 'Given Various Coefficient Combinations'})

%% Find Best Coefficients
maxi = coefficients(coefficients(:,6) >= 1,:);  % isolate all coefficients combinations that result only successes
[~,i] = max(maxi(:,7));                         % finds the maximum number of successes remaining
FinalCoefficients = maxi(i,1:5);                % records these coefficients

%% Test
load('LHK100.mat')
Successes_Originally_Observed = sum(LHkIterated(:,4));
LHkIterated = LHkIterated(LHkIterated(:,3) <= (11/10)*LHkIterated(:,1),:);
LHkIterated = LHkIterated(LHkIterated(:,2) >= (1/10)*LHkIterated(:,1),:);
LHkIterated = LHkIterated(LHkIterated(:,3) >= 3 - (1/10)*LHkIterated(:,2),:);
Fraction_of_Successes = sum(LHkIterated(:,4))/length(LHkIterated(:,4));         % 1
Successes_Lost = Successes_Originally_Observed - length(LHkIterated(:,4));      % 883
Fraction_of_Successes_Lost = Successes_Lost/Successes_Originally_Observed;      % 0.1517

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
h = line([0 (500/11)],[0 50]);      % enforce the condition that k5 <= (11/10)*k3
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
