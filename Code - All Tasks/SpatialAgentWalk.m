function SpatialAgentWalk(filename,no_frames,PD,pos,f1,f2,f3)
% SpatialAgentWalk(filename,no_frames,PD,pos,f1,f2,f3) captures an
% agent-based spatial simulation of the parasite model by calling the
% previous 'Setup' and 'Process' functions. At the end of the simulation,
% an .avi movie file will be generated to show the evolution of the
% spatial stochastic model and the agent count will be plotted against
% time for further analysis in the report.
%
% A 2D grid (200x200) is populated with Food agents (F) and Parasite agents
% (P) according to the density 'PD'. Parasites and food will initially be
% placed randomly but the food births will be placed according to 'pos'.
% A food agent (F) will be represented by a 1 and a parasite agent (P) will
% represented by a 2. An empty cell is denoted by a 0.
% There are 4 components of each step in the simulation: parasites move,
% parasite iteration death check, random food death check and birth of
% food population.
%
% The input arguments are:
% filename - The name of the .avi movie file to be created.
% no_frames - The number of frames to include in the movie.
% PD - Population density of parasites and food agents (same for both) (ie.
% 10% food, 10% parasites -> enter 0.1) MAXIMUM 0.5 (50%)
% pos - Positioning of food agents (1x4 array) which specifies
% [x_width, x_offset, y_width, y_offset]. (ie. [200,0,200,0] = randomised)
% Note: x_width + x_offset <= 200 and y_width + y_offset <= 200.
% f1 - Parasite agent dies after f1 iterations (parasite lifespan)
% f2 - Food agent dies if u ~ U(0,1) < f2 (likelihood for food to spoil)
% f3 - Number of food agents to be created at each end step.

% Create movie from matrix and set up file
close all;
file = VideoWriter(filename);
file.FrameRate = 15; % Speed
open(file);

% Initialise the agent counter for parasite and food
agent_counter = zeros(no_frames,2);

% Loop each frame of the spatial agent-based matrix
for index = 1:no_frames
    % If first frame
    if ( index == 1 )
        [G,P_lifenew,P_pos] = SpatialAgentWalkSetUp(PD); % Set up
        N = PD*200*200;
        agent_counter(index,:) = [N, N]; % Count agent population
    % Iterate the simulation (by-pass the first frame)
    else
       [G,P_lifenew,P_pos,F] = SpatialAgentWalkProcess(G,P_lifenew,P_pos,pos,f1,f2,f3);
       agent_counter(index,:) = [size(P_pos,1), F]; % Count number of each agent
    end
    
    % Display current simulation state
    clf
    hold on
    spy(G==1,'g') % Food agents are green
    spy(G==2, 'r') % Parasites agents are red
    xlabel('X Position')
    xlim([1 200])
    ylim([1 200])
    ylabel('Y Position')
    title(['Frame ',num2str(index)])
    mov(index) = getframe; % Capture an image of the matrix
end

% Write the video to the file
writeVideo(file,mov); 
close(file);

% Prepare subplots
both = figure();
suptitle(['Initial population: ',num2str(PD*100),'% each  [f_1= ',...
    num2str(f1),', f_2= ',num2str(f2), ', f_3= ',num2str(f3),']']);
subplot(1,2,1);
hold on
spy(G==1,'g') % Food agents are green
spy(G==2, 'r') % Parasites agents are red
xlabel('X Position')
xlim([1 200])
ylim([1 200])
ylabel('Y Position')
title(['Frame ',num2str(no_frames)])

% Plot the populations
subplot(1,2,2);
hold on
plot(agent_counter(:,1),'r'); % Parasites
plot(agent_counter(:,2),'g'); % Food
xlabel('Time (Frame number)')
xlim([1 no_frames]) % Remove the 0th frame (indexing starts at 1)
ylabel('Population')
title('Population vs Time')
legend('Parasites', 'Food')

% Save as a figure
fig_filename1 = replace(filename,'.avi','--1.fig'); % Remove '.avi' extension from name
savefig(both, fig_filename1)

% Create figure for comparing population density outcome
counts = figure();
hold on
plot(agent_counter(:,1),'r'); % Parasites
plot(agent_counter(:,2),'g'); % Food
xlabel('Time (Frame number)')
xlim([1 no_frames]) % Remove the 0th frame (indexing starts at 1)
ylim([1 35000]) % Ensure same y-scale for accurate comparison
ylabel('Population')
suptitle(['Initial population: ',num2str(PD*100),'% each  [f_1= ',...
    num2str(f1),', f_2= ',num2str(f2), ', f_3= ',num2str(f3),']']);
legend('Parasites', 'Food')

% Save as a figure
fig_filename2 = replace(fig_filename1,'--1.fig','--2.fig'); % Remove '.avi' extension from name
savefig(counts, fig_filename2)
end

