
resistances = [4000, 9.7196]; % Resistances in ohms
parallel_resistance = parallelSumOfResistors(resistances);
disp(['The parallel resistance is: ', num2str(parallel_resistance), ' ohms']);


function parallel_resistance = parallelSumOfResistors(resistances)
    % resistances: vector containing the resistances
    
    % Calculate the reciprocal of each resistance
    reciprocals = 1 ./ resistances;
    
    % Sum up the reciprocals
    total_reciprocal = sum(reciprocals);
    
    % Take the reciprocal of the total to get the parallel resistance
    parallel_resistance = 1 / total_reciprocal;
end


