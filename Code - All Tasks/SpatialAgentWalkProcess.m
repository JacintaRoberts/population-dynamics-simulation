function [NewGrid,P_lifenew,P_pos,F] = SpatialAgentWalkProcess(G,P_life,P_pos,pos,f1,f2,f3)
% [NewGrid,P_lifenew,P_pos,F] = SpatialAgentWalkProcess(G,P_life,P_pos,pos,f1,f2,f3)
% updates the agent-based spatial simulation of the parasite model. A 2D
% grid (200x200) is populated with food agents (F) and parasite agents (P)
% according to the initial density 'PD'. Parasites will be placed randomly
% but the food will be placed according to the input of 'pos'.
% Given the current grid (G), this function will perform 1 iteration of
% required steps and output the new grid.
% 
% There are 4 components of each step of the simulation: parasites move,
% parasite iteration death check, random food death check and birth of
% food population. In the first step, each parasite will attempt to move
% to an adjacent cell and 1 of 3 scenarios will occur:
% 1. either the new cell is empty and it successfully moves,
% 2. the cell is occupied by another parasite and the move does not occur, 
% 3. the new cell is occupied by food in which the food is consumed and
% a birth takes place with the new parasite placed in the original cell.
% A parasite dies after 'f1' iterations' and is removed from the grid.
% A food agent dies if its uniform random sample U(0,1) is less than the
% input variable 'f2'.
% Finally, 'f3' new food agents are added to grid according to the
% positioning strategy, 'pos'. If the cell is occupied, a nearby cell is
% instead selected.
%
% A food agent (F) will be represented by a 1 (green) and a parasite agent
% (P) will represented by a 2 (red). An empty cell is denoted by 0 (white).
%
% The input arguments are:
% G - Current grid (prior to performing steps).
% P_life - is a Px2 vector which stores how many iterations each Parasite
% has undertaken (before the current step).
% P_pos - is  a Px3 vector which stores the parasite positions (row, col)
% and their associated number (before the current step).
% pos - Positioning of food agents (1x4 array) which specifies
% [x_width, x_offset, y_width, y_offset]. (ie. [200,0,200,0] = randomised)
% Note: x_width + x_offset <= 200 and y_width + y_offset <= 200.
% f1 - Parasite agent dies after f1 iterations (parasite lifespan).
% f2 - Food agent dies if u ~ U(0,1) < f2 (likelihood for food to spoil).
% f3 - Number of food agents to be created at each end step.
%
% The output arguments:
% NewGrid - is a 200x200 matrix which updates the model behaviour (this is
% to be called at every step).
% P_lifenew - is a Px2 vector which stores how many iterations each
% Parasite has undertaken (after the current step).
% P_pos - is  a Px3 vector which stores the parasite positions (row, col)
% and their associated number (after the current step).
% F - the number of food agents

% Initialise variables
F = 0;
P = size(P_pos,1); % Number of Parasites
Last_Parasite = max(max(P_pos(:,1))); % Maximum Parasite Number
P_births = 0;

% Count current number of food agents and store coordinates (stationary)
for row = 1:200
    for col = 1:200
        if G(row,col) == 1
            F = F + 1; % Increment food count
            F_pos(F,1) = row;
            F_pos(F,2) = col; % Store position (Food: row, col)
        end
    end
end

% Move the Parasites either N, S, E or W
for i = 1:P
    % Generate a random move (N = 1, S = 2, E = 3 and W = 4)
    direction = randperm(4,1);
        switch direction
            case 1
                % Move Parasite North (if within border) (row, col)
                if ( P_pos(i,2) > 1 ) % If y_coord > 1
                    % No collision
                    if ( G(P_pos(i,2)-1, P_pos(i,3)) == 0 )
                    G(P_pos(i,2)-1, P_pos(i,3)) = 2; % Move to new posn
                    G(P_pos(i,2), P_pos(i,3)) = 0; % Remove old posn
                    P_pos(i,2:3) = [P_pos(i,2)-1, P_pos(i,3)]; % Update P_pos
                    
                    % Food collision    
                    elseif ( G(P_pos(i,2)-1, P_pos(i,3)) == 1 )
                        G(P_pos(i,2)-1, P_pos(i,3)) = 2; % Move to new posn
                        new_parasite_pos = [P_pos(i,2)-1, P_pos(i,3)];
                        % Find and remove food from F_pos at new position
                        for j = length(F_pos):-1:1
                            if isequal(F_pos(j,:), new_parasite_pos)
                                F_pos(j,:) = [];
                            end
                        end
                        F = F - 1; % Reduce food count
                        P_births = P_births + 1; % Birth event at old posn
                        % Add new parasite to P_pos
                        P_pos(P+P_births,:) = [Last_Parasite+P_births, P_pos(i,2), P_pos(i,3)];
                        P_pos(i,2:3) = [P_pos(i,2)-1, P_pos(i,3)]; % Update P_pos
                    end
                end
            
            case 2
                % Move Parasite South (if within border)
                if ( P_pos(i,2) < 200 ) % If y_coord < 200
                    % No collision
                    if ( G(P_pos(i,2)+1, P_pos(i,3)) == 0 )
                        G(P_pos(i,2)+1, P_pos(i,3)) = 2; % Move to new posn
                        G(P_pos(i,2),P_pos(i,3)) = 0; % Remove old posn
                        P_pos(i,2:3) = [P_pos(i,2)+1, P_pos(i,3)]; % Update P_pos
              
                    % Food collision    
                    elseif ( G(P_pos(i,2)+1, P_pos(i,3)) == 1 )
                        G(P_pos(i,2)+1, P_pos(i,3)) = 2; % Move to new posn
                        new_parasite_pos = [P_pos(i,2)+1, P_pos(i,3)];
                        % Find and remove food from F_pos at new position
                        for j = length(F_pos):-1:1
                            if isequal(F_pos(j,:), new_parasite_pos)
                                F_pos(j,:) = [];
                            end
                        end
                        F = F - 1; % Reduce food count
                        P_births = P_births + 1; % Birth event at old posn
                        % Add new parasite to P_pos
                        P_pos(P+P_births,:) = [Last_Parasite+P_births, P_pos(i,2), P_pos(i,3)];
                        P_pos(i,2:3) = [P_pos(i,2)+1, P_pos(i,3)]; % Update P_pos
                    end
                end
           case 3
                % Move Parasite East (if within border)
                if ( P_pos(i,3) < 200 ) % If x_coord < 200
                    % No collision
                    if ( G(P_pos(i,2), P_pos(i,3)+1) == 0 )
                    G(P_pos(i,2), P_pos(i,3)+1) = 2; % Move to new posn
                    G(P_pos(i,2),P_pos(i,3)) = 0; % Remove old posn
                    P_pos(i,2:3) = [P_pos(i,2), P_pos(i,3)+1]; % Update P_pos
                    
                    % Food collision    
                    elseif ( G(P_pos(i,2), P_pos(i,3)+1) == 1 )
                        G(P_pos(i,2), P_pos(i,3)+1) = 2; % Move to new posn
                        new_parasite_pos = [P_pos(i,2), P_pos(i,3)+1];
                        % Find and remove food from F_pos at new position
                        for j = length(F_pos):-1:1
                            if isequal(F_pos(j,:), new_parasite_pos)
                                F_pos(j,:) = []; % Remove food
                            end
                        end
                        F = F - 1; % Reduce Food count
                        P_births = P_births + 1; % Birth event at old posn
                        % Add new parasite to P_pos
                        P_pos(P+P_births,:) = [Last_Parasite+P_births, P_pos(i,2), P_pos(i,3)];
                        P_pos(i,2:3) = [P_pos(i,2), P_pos(i,3)+1]; % Update P_pos
                    end
                end
                
           case 4
                % Move Parasite West (if within border)
                if ( P_pos(i,3) > 1 ) % If x_coord > 1
                    % No Collision
                    if ( G(P_pos(i,2), P_pos(i,3)-1) == 0 )
                        G(P_pos(i,2), P_pos(i,3)-1) = 2; % Move to new posn
                        G(P_pos(i,2),P_pos(i,3)) = 0; % Remove old posn
                        P_pos(i,2:3) = [P_pos(i,2), P_pos(i,3)-1]; % Update P_pos
                        
                    % Food collision    
                    elseif ( G(P_pos(i,2), P_pos(i,3)-1) == 1 )
                        G(P_pos(i,2), P_pos(i,3)-1) = 2; % Move to new posn
                        new_parasite_pos = [P_pos(i,2), P_pos(i,3)-1];
                        % Find and remove food from F_pos at new position
                        for j = length(F_pos):-1:1
                            if isequal(F_pos(j,:), new_parasite_pos)
                                F_pos(j,:) = [];
                            end
                        end
                        F = F - 1; % Reduce Food count
                        P_births = P_births + 1; % Birth event at old posn
                        % Add new parasite to P_pos
                        P_pos(P+P_births,:) = [Last_Parasite+P_births, P_pos(i,2), P_pos(i,3)];
                        P_pos(i,2:3) = [P_pos(i,2), P_pos(i,3)-1]; % Update P_pos
                    end       
                end
        end
end

P_life(:,2) = P_life(:,2) + 1; % Increment every adult parasite iteration
% Check to see if Parasites have outlived their lifespan
for index = size(P_life,1):-1:1
        if P_life(index,2) >= f1
            Dead_parasite = P_life(index,1); % Find the corresponding parasite number
            k = find(P_pos(:,1)==Dead_parasite);
            G(P_pos(k,2),P_pos(k,3)) = 0; % Remove parasite from grid
            P_life(index,:) = [];
            P_pos(k,:) = [];
        end
end

% Add births onto the life vector (start at 0 iterations) 
P_birthlife = zeros(P_births, 2);
P_lifenew = [P_life; P_birthlife]; % Pad P_lifenew with new 0's
for NP = 1:P_births
    P_lifenew(P+NP, 1) = Last_Parasite + NP;
end

% Remove null entries
if size(P_lifenew,1) >= 1
    for index = size(P_lifenew,1):-1:1
        if isequal(P_lifenew(index,:), [0,0])
            P_lifenew(index,:) = [];
        end
    end
end

% Food random deaths occur
for food_agent = F:-1:1
    uni_random = rand(); % Sample u ~ U(0,1) for each food agent
    if uni_random < f2 % If less than given f2 variable, remove food
        G(F_pos(food_agent,1), F_pos(food_agent,2)) = 0;
        F = F - 1;
        F_pos(food_agent,:) = [];
   end
end

food_birth = 0; % Initialise food_birth
break_count = 0; % Initialsie break_count

% Create f3 new food agents and position according to input of pos
% Use a switch case for starting position of food agents (F)
while food_birth < f3
    food_birth_check = food_birth; % Store initial value
    random_row = randperm(pos(3),1) + pos(4); % y_offset <= y <= y_offset + y_width
    random_col = randperm(pos(1),1) + pos(2); % x_offset <= x <= x_offset + x_width
    % If unoccupied, place in randomised position
    if ( G(random_row, random_col) == 0 )
        G(random_row, random_col) = 1;
        food_birth = food_birth + 1;
    % If occupied, attempt to place in nearby unoccupied cell
    else
        % Check below
        if ( random_row + 1 < 201 )
            if ( G(random_row + 1, random_col) == 0 )
                G(random_row + 1, random_col) = 1;
                food_birth = food_birth + 1;
            end
        % Check above
        elseif ( random_row - 1 > 0 )
            if ( G(random_row - 1, random_col) == 0 )
                G(random_row - 1, random_col) = 1;
                food_birth = food_birth + 1;
            end
        % Check left
        elseif ( random_col - 1 > 0 )
            if ( G(random_row, random_col - 1) == 0 )
                G(random_row, random_col - 1) = 1;
                food_birth = food_birth + 1;
            end
        % Check right
        elseif ( random_col + 1 < 201 )
            if ( G(random_row, random_col + 1) == 0 ) 
            G(random_row, random_col + 1) = 1;
            food_birth = food_birth + 1;
            end
        end
    end
    
    % If no more space for food births, increment break_count
    if food_birth_check == food_birth
        break_count = break_count + 1;
    end
            
    % Check if should break
    if break_count >= 10000 % Arbitrarily large
        break;
    end
end

NewGrid = G; % Output the new grid

end



