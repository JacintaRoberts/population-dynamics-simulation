function [InitialGrid,P_life,P_pos] = SpatialAgentWalkSetUp(PD)
% [InitialGrid,P_life,P_pos] = SpatialAgentWalkSetUp(PD, pos) sets up the
% agent-based spatial simulation of the parasite model. A 2D grid (200x200)
% is populated with Food agents (F) and Parasite agents (P) according to
% the initial density 'PD'. Parasites and food agents will initially be
% placed randomly (whole grid) - the food will be placed according to the
%input 'pos' when growth occurs in the separate process function.
% 
% A food agent (F) will be represented by a 1 (green) and a parasite agent
% (P) will represented by a 2 (red). An empty cell is denoted by 0 (white).
%
% The input arguments are:
% PD - Population density of parasites and food agents (same for both) (ie.
% 10% food, 10% parasites -> enter 0.1) MAXIMUM 0.5 (50%)
%
% The output arguments:
% InitialGrid - is a 200x200 matrix which shows the starting positions
% and number of the agents in the grid.
% P_life - is a Px3 vector initially of zeros which stores how many
% iterations each Parasite has undertaken.
% P_pos - Px2 vector which stores the position of each parasite. The
% columns represent: Parasite number, row position and column position
% respectively.

% Initialise simulation grid
InitialGrid = zeros(200,200);

% Calculate number of food and parasite agents
N = (PD*200*200);

% Initialise food and parasite agent counters
F = 0;
P = 0;

% Initialise P_life - (Parasite number, iterations)
P_life = zeros(N,2);
for count = 1:N
    P_life(count,1) = count;
end
    
% Place food agents (F) into grid (INITIALLY randomised position)
% The decision to place the food all over the grid initially and only 
% birth new food into the specified location was made to ensure that the
% initial food population could always be placed (ie. cannot place 40% food
% if there is only 25% of grid available for this).
while F < N
    % Generate a random number between 1 and 200 for row and col:
     random_row = randperm(200,1); % 1 <= y <= 200
     random_col = randperm(200,1); % 1 <= x <= 200
     if ( InitialGrid(random_row, random_col) == 0 )
        InitialGrid(random_row, random_col) = 1; % Place food
        F = F + 1; % Increment F if unoccupied position found
     end
end

% Place parasite agents (P) into grid (randomised position)
while P < N 
    random_row = randperm(200,1); % 0 <= y <= 200
    random_col = randperm(200,1); % 0 <= y <= 200
    if ( InitialGrid(random_row,random_col) == 0 )
        InitialGrid(random_row,random_col) = 2; % Place parasite
        P = P + 1; % Increment P if unoccupied position found
    end
end

% Output P_pos
P_pos = zeros(length(P_life),3);
P_pos(:,1) = P_life(:,1); % 1st column is parasite number (align with life)
P = 0; % Intialise P
for row = 1:200
    for col = 1:200
        if InitialGrid(row,col) == 2
            P = P + 1; % Increment parasite count
            P_pos(P,2) = row;
            P_pos(P,3) = col; % Store position in P_pos
        end
    end
end

end



