% k3 Parameter Sweep
[k3t1] = OneParameterSweep(10^-1, 0, 50, 0.5, 0, 20, 1, 1, 1, 2, 4, 3);
[k3t2] = OneParameterSweep(10^-2, 0, 50, 0.5, 0, 20, 1, 1, 1, 2, 4, 3);

% Plot Results
figure
subplot(1,2,1)
g = gscatter(k3t1(:,1),zeros(length(k3t1),1),k3t1(:,2),[1 0 0; 0 1 0; 0 0 1],'ooo',2.3,'off');
set(g, {'MarkerFaceColor'}, get(g,'Color'))
legend('X1 \rightarrow 0 + tol','X2 \rightarrow 2 ± tol','X1 \rightarrow 0 + tol and X2 \rightarrow 2 ± tol','Location','north')
xlabel('Successful Values of k3')
set(gca,'YTickLabel',[])
xlim([0 50])
title({'Successful Values of k3 for Parasite Model';'Parameter Sweep with Tolerance = 10^{-1}'})

subplot(1,2,2)
g = gscatter(k3t2(:,1),zeros(length(k3t2),1),k3t2(:,2),[1 0 0; 0 1 0; 0 0 1],'ooo',2.3,'off');
set(g, {'MarkerFaceColor'}, get(g,'Color'))
legend('X1 \rightarrow 0 + tol','X2 \rightarrow 2 ± tol','X1 \rightarrow 0 + tol and X2 \rightarrow 2 ± tol','Location','north')
xlabel('Successful Values of k3')
set(gca,'YTickLabel',[])
xlim([0 50])
title({'Successful Values of k3 for Parasite Model';'Parameter Sweep with Tolerance = 10^{-2}'})

clearvars g

% Outcome
% For tol = 10^-1 we see 1.5 <= k3 <= 45.5, where X1 -> 0 + tol for 1.5 <= k3 <= 7.5, 
% X2 -> 2 ± tol for 8.5 <= k3 <= 45.5, and X1 -> 0 + tol and X2 -> 2 ± tol for k3 = 8.
% For tol = 10^-2 we see 1.5 <= k3 <= 7 and 8.5 <= k3 <= 45.5, where X1 -> 0 + tol for 1.5 <= k3 <= 7, 
% X2 -> 2 ± tol for 8.5 <= k3 <= 45.5, and X1 -> 0 + tol and X2 -> 2 ± tol for no k3.