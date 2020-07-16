% k3 Parameter Sweep
[k3k4t1] = TwoParameterSweep(10^-1, 0, 50, 0.5, 0, 20, 1, 1, 1, 2, 3);
[k3k4t2] = TwoParameterSweep(10^-2, 0, 50, 0.5, 0, 20, 1, 1, 1, 2, 3);

% Plot Results
figure
subplot(1,2,1)
g = gscatter(k3k4t1(:,1),k3k4t1(:,2),k3k4t1(:,3),[1 0 0; 0 1 0; 0 0 1],'ooo',2.3,'off');
set(g, {'MarkerFaceColor'}, get(g,'Color'))
legend('X1 \rightarrow 0 + tol','X2 \rightarrow 2 ± tol','X1 \rightarrow 0 + tol and X2 \rightarrow 2 ± tol','Location','southoutside')
xlabel('Successful Values of k3')
ylabel('Successful Values of k4')
xlim([0 50])
title({'Successful Combinations of k3 and k4 for Parasite Model';'Parameter Sweep with Tolerance = 10^{-1}'})

subplot(1,2,2)
g = gscatter(k3k4t2(:,1),k3k4t2(:,2),k3k4t2(:,3),[1 0 0; 0 1 0; 0 0 1],'ooo',2.3,'off');
set(g, {'MarkerFaceColor'}, get(g,'Color'))
legend('X1 \rightarrow 0 + tol','X2 \rightarrow 2 ± tol','X1 \rightarrow 0 + tol and X2 \rightarrow 2 ± tol','Location','southoutside')
xlabel('Successful Values of k3')
ylabel('Successful Values of k4')
xlim([0 50])
title({'Successful Combinations of k3 and k4 for Parasite Model';'Parameter Sweep with Tolerance = 10^{-2}'})

clearvars g

% Outcomes