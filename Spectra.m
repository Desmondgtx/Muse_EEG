%% Spectra Data

% Load Study Data
[STUDY ALLEEG] = pop_loadstudy('filename', 'study_file.study', 'filepath', 'C:\Users\yangy\Desktop\Ed Fisica\Filtered Data\All');
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];


% Plot Channel 
STUDY = pop_specparams(STUDY, 'plotconditions','together','ylim',[30 60] ,'freqrange',[2 22] ,'averagechan','on');
STUDY = pop_statparams(STUDY, 'groupstats','on','condstats','on','alpha',0.5);
STUDY = std_specplot(STUDY,ALLEEG,'channels',{'eeg_1','eeg_2','eeg_3','eeg_4'}, 'design', 1);



%%
% Function that exports a dataframe of 21 rows (frequency bands with decimal values)
% and 9 columns (tasks)

% Generate the plot with all conditions
figure;
[STUDY, specdata, specfreqs] = std_specplot(STUDY, ALLEEG, ...
    'channels', {'eeg_1','eeg_2','eeg_3','eeg_4'}, ...
    'design', 1);

% Get ALL lines from the plot
h = gcf;
lines = findobj(h, 'Type', 'line');

disp(['Número de líneas encontradas: ' num2str(length(lines))]);

% Extract data from each line
all_xdata = {};
all_ydata = {};
line_info = {};

for i = 1:length(lines)
    all_xdata{i} = get(lines(i), 'XData');
    all_ydata{i} = get(lines(i), 'YData');
    
    % Try to get additional information from the line
    line_info{i}.color = get(lines(i), 'Color');
    line_info{i}.style = get(lines(i), 'LineStyle');
    line_info{i}.display_name = get(lines(i), 'DisplayName');
end

% If there are 9 lines (one per task), create the matrix
if length(lines) >= 9
    % Use the first 9 lines
    frequencies = all_xdata{1}(:);
    power_matrix = zeros(length(frequencies), 10);
    power_matrix(:,1) = frequencies;
    
    column_names = {'Frequency_Hz'};
    
    for i = 1:9
        power_matrix(:, i+1) = all_ydata{i}(:);
        
        % Try to get the task name from DisplayName
        if ~isempty(line_info{i}.display_name)
            column_names{end+1} = line_info{i}.display_name;
        else
            column_names{end+1} = sprintf('Task_%d', i);
        end
    end
    
    T = array2table(power_matrix, 'VariableNames', column_names);
    writetable(T, 'spectral_data_9_tasks.csv');
else
    disp('No se encontraron suficientes líneas para las 9 tareas');
    disp('Intenta plotear con diferentes parámetros');
end




%%
% Function that exports a dataframe of 21 rows (frequency bands with decimal values)
% and 9 columns (tasks)

% Generate the plot with a range of 0 to 25 Hz for visualization
figure;
[STUDY, specdata, specfreqs] = std_specplot(STUDY, ALLEEG, ...
    'channels', {'eeg_1','eeg_2','eeg_3','eeg_4'}, ...
    'design', 1, ...
    'freqrange', [0 25]); % Specify frequency range for the plot

% Get ALL lines from the plot
h = gcf;
lines = findobj(h, 'Type', 'line');

disp(['Número de líneas encontradas: ' num2str(length(lines))]);

% Extract data from each line
all_xdata = {};
all_ydata = {};
line_info = {};

for i = 1:length(lines)
    all_xdata{i} = get(lines(i), 'XData');
    all_ydata{i} = get(lines(i), 'YData');
    
    % Try to get additional information from the line
    line_info{i}.color = get(lines(i), 'Color');
    line_info{i}.style = get(lines(i), 'LineStyle');
    line_info{i}.display_name = get(lines(i), 'DisplayName');
end

% If there are 9 lines (one per task), create the matrix
if length(lines) >= 9
    % Get all frequencies from the first line
    all_frequencies = all_xdata{1}(:);
    
    % Find indices for the 1 to 20 Hz range
    freq_indices = find(all_frequencies >= 1 & all_frequencies <= 20);
    
    % Extract only the frequencies in the desired range
    frequencies = all_frequencies(freq_indices);
    
    % Display frequency information
    disp(['Frecuencia mínima: ' num2str(min(frequencies))]);
    disp(['Frecuencia máxima: ' num2str(max(frequencies))]);
    disp(['Número de puntos de frecuencia: ' num2str(length(frequencies))]);
    
    % Create matrix with appropriate dimensions
    power_matrix = zeros(length(frequencies), 10);
    power_matrix(:,1) = frequencies;
    
    column_names = {'Frequency_Hz'};
    
    % Extract only the power values corresponding to the 1-20 Hz range
    for i = 1:9
        all_power_values = all_ydata{i}(:);
        power_matrix(:, i+1) = all_power_values(freq_indices);
        
        % Try to get the task name from DisplayName
        if ~isempty(line_info{i}.display_name)
            column_names{end+1} = line_info{i}.display_name;
        else
            column_names{end+1} = sprintf('Task_%d', i);
        end
    end
    
    % Optional: Round frequencies to integers if they are very close
    % This will help have cleaner values if possible
    freq_rounded = round(frequencies);
    freq_diff = abs(frequencies - freq_rounded);
    
    % If differences are very small (< 0.1), use rounded values
    if max(freq_diff) < 0.1
        disp('Redondeando frecuencias a valores enteros...');
        power_matrix(:,1) = freq_rounded;
    else
        disp('Manteniendo valores decimales de frecuencia originales');
    end
    
    % Create table
    T = array2table(power_matrix, 'VariableNames', column_names);
    
    % Save
    writetable(T, 'spectral_data_1to20Hz.csv');
    
    % Show data preview
    disp('Preview de los primeros 5 valores de frecuencia:');
    disp(power_matrix(1:5, 1));
    
else
    disp('No se encontraron suficientes líneas para las 9 tareas');
end% Generate the plot with a range of 0 to 25 Hz for visualization
figure;
[STUDY, specdata, specfreqs] = std_specplot(STUDY, ALLEEG, ...
    'channels', {'eeg_1','eeg_2','eeg_3','eeg_4'}, ...
    'design', 1, ...
    'freqrange', [0 25]); % Specify frequency range for the plot

% Get ALL lines from the plot
h = gcf;
lines = findobj(h, 'Type', 'line');

disp(['Número de líneas encontradas: ' num2str(length(lines))]);

% Extract data from each line
all_xdata = {};
all_ydata = {};
line_info = {};

for i = 1:length(lines)
    all_xdata{i} = get(lines(i), 'XData');
    all_ydata{i} = get(lines(i), 'YData');
    
    % Try to get additional information from the line
    line_info{i}.color = get(lines(i), 'Color');
    line_info{i}.style = get(lines(i), 'LineStyle');
    line_info{i}.display_name = get(lines(i), 'DisplayName');
end

% If there are 9 lines (one per task), create the matrix
if length(lines) >= 9
    % Get all frequencies from the first line
    all_frequencies = all_xdata{1}(:);
    
    % Find indices for the 1 to 20 Hz range
    freq_indices = find(all_frequencies >= 1 & all_frequencies <= 20);
    
    % Extract only the frequencies in the desired range
    frequencies = all_frequencies(freq_indices);
    
    % Display frequency information
    disp(['Frecuencia mínima: ' num2str(min(frequencies))]);
    disp(['Frecuencia máxima: ' num2str(max(frequencies))]);
    disp(['Número de puntos de frecuencia: ' num2str(length(frequencies))]);
    
    % Create matrix with appropriate dimensions
    power_matrix = zeros(length(frequencies), 10);
    power_matrix(:,1) = frequencies;
    
    column_names = {'Frequency_Hz'};
    
    % Extract only the power values corresponding to the 1-20 Hz range
    for i = 1:9
        all_power_values = all_ydata{i}(:);
        power_matrix(:, i+1) = all_power_values(freq_indices);
        
        % Try to get the task name from DisplayName
        if ~isempty(line_info{i}.display_name)
            column_names{end+1} = line_info{i}.display_name;
        else
            column_names{end+1} = sprintf('Task_%d', i);
        end
    end
    
    % Optional: Round frequencies to integers if they are very close
    % This will help have cleaner values if possible
    freq_rounded = round(frequencies);
    freq_diff = abs(frequencies - freq_rounded);
    
    % If differences are very small (< 0.1), use rounded values
    if max(freq_diff) < 0.1
        disp('Redondeando frecuencias a valores enteros...');
        power_matrix(:,1) = freq_rounded;
    else
        disp('Manteniendo valores decimales de frecuencia originales');
    end
    
    % Create table
    T = array2table(power_matrix, 'VariableNames', column_names);
    
    % Save
    writetable(T, 'spectral_data_1to20Hz.csv');
    
    % Show data preview
    disp('Preview de los primeros 5 valores de frecuencia:');
    disp(power_matrix(1:5, 1));
    
else
    disp('No se encontraron suficientes líneas para las 9 tareas');
end






%%
% Function that exports a dataframe of 21 rows (frequency bands with integer values)
% and 9 columns (tasks)

% After extracting the data (using the code above up to obtaining all_xdata and all_ydata)

if length(lines) >= 9
    % Define target frequencies (integers from 1 to 20)
    target_frequencies = (1:20)';
    
    % Create matrix to store interpolated data
    power_matrix_interp = zeros(20, 10);
    power_matrix_interp(:,1) = target_frequencies;
    
    column_names = {'Frequency_Hz'};
    
    % Interpolate data for each task
    for i = 1:9
        % Get original data
        orig_freq = all_xdata{i}(:);
        orig_power = all_ydata{i}(:);
        
        % Interpolate to target frequencies
        interpolated_power = interp1(orig_freq, orig_power, target_frequencies, 'linear');
        
        power_matrix_interp(:, i+1) = interpolated_power;
        
        if ~isempty(line_info{i}.display_name)
            column_names{end+1} = line_info{i}.display_name;
        else
            column_names{end+1} = sprintf('Task_%d', i);
        end
    end
    
    % Create table with interpolated data
    T_interp = array2table(power_matrix_interp, 'VariableNames', column_names);
    
    % Save
    writetable(T_interp, 'spectral_data_1to20Hz_interpolated.csv');
    
    disp('Archivo guardado con frecuencias enteras exactas de 1 a 20 Hz');
end






%% Export spectral data for each individual participant
% Generates a CSV file of 20 rows (frequencies 1-20 Hz) x 10 columns (Freq + 9 tasks)

% Load Study Data
[STUDY ALLEEG] = pop_loadstudy('filename', 'study_file.study', 'filepath', 'C:\Users\yangy\Desktop\Muse_EEG\Ed Fisica\Datos Filtrados\All');
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];

% Configure spectral parameters
STUDY = pop_specparams(STUDY, 'plotconditions','together','ylim',[30 60] ,'freqrange',[1 20] ,'averagechan','on');
STUDY = pop_statparams(STUDY, 'groupstats','on','condstats','on','alpha',0.5);

% Define target frequencies (integers from 1 to 20)
target_frequencies = (1:20)';

% Define participant IDs (adjust according to your data)
% Assuming participants are s1, s2, ..., s8
participant_ids = {'01', '02', '03', '05', '06', '07', '08', '09'};

% Loop for each participant
for p = 1:length(participant_ids)
    
    current_participant = participant_ids{p};
    disp(['=== Procesando participante: ' current_participant ' ===']);
    
    % Generate the plot for the current participant
    figure;
    STUDY = std_specplot(STUDY, ALLEEG, 'channels', {'eeg_1','eeg_2','eeg_3','eeg_4'}, ...
        'subject', current_participant, 'design', 1);
    
    % Get the handle of the current figure
    h = gcf;
    
    % Find all line objects in the figure
    lines = findobj(h, 'Type', 'line');
    
    disp(['Número de líneas encontradas para ' current_participant ': ' num2str(length(lines))]);
    
    % Extract data from each line
    all_xdata = {};
    all_ydata = {};
    line_info = {};
    
    for i = 1:length(lines)
        all_xdata{i} = get(lines(i), 'XData');
        all_ydata{i} = get(lines(i), 'YData');
        
        % Try to get additional information from the line
        line_info{i}.color = get(lines(i), 'Color');
        line_info{i}.style = get(lines(i), 'LineStyle');
        line_info{i}.display_name = get(lines(i), 'DisplayName');
    end
    
    % If there are 9 lines (one per task), create the matrix
    if length(lines) >= 9
        
        % Create matrix to store interpolated data
        power_matrix_interp = zeros(20, 10);
        power_matrix_interp(:,1) = target_frequencies;
        
        column_names = {'Frequency_Hz'};
        
        % Interpolate data for each task
        for i = 1:9
            % Get original data
            orig_freq = all_xdata{i}(:);
            orig_power = all_ydata{i}(:);
            
            % Verify that we have valid data
            if ~isempty(orig_freq) && ~isempty(orig_power)
                % Interpolate to target frequencies
                interpolated_power = interp1(orig_freq, orig_power, target_frequencies, 'linear');
                power_matrix_interp(:, i+1) = interpolated_power;
            else
                % If no data, fill with NaN
                power_matrix_interp(:, i+1) = NaN;
                disp(['Advertencia: No hay datos para la tarea ' num2str(i) ' del participante ' current_participant]);
            end
            
            % Name the columns
            if ~isempty(line_info{i}.display_name)
                column_names{end+1} = line_info{i}.display_name;
            else
                column_names{end+1} = sprintf('Task_%d', i);
            end
        end
        
        % Create table with interpolated data
        T_interp = array2table(power_matrix_interp, 'VariableNames', column_names);
        
        % Create unique filename for this participant
        filename = sprintf('spectral_data_%s_1to20Hz.csv', current_participant);
        
        % Save
        writetable(T_interp, filename);
        disp(['Archivo guardado: ' filename]);
        
        % Show summary
        disp(['Dimensiones: ' num2str(height(T_interp)) ' filas x ' num2str(width(T_interp)) ' columnas']);
        
        % Check for NaN values
        n_nan = sum(sum(isnan(table2array(T_interp(:, 2:end)))));
        if n_nan > 0
            disp(['ADVERTENCIA: ' num2str(n_nan) ' valores NaN encontrados para ' current_participant]);
        end
        
    else
        disp(['ERROR: No se encontraron suficientes líneas para ' current_participant]);
        disp(['Se esperaban 9 líneas (tareas) pero se encontraron ' num2str(length(lines))]);
    end
    
    % Close the figure before processing the next participant
    close(h);
    
    % Small pause to avoid memory issues
    pause(0.5);
    
end

disp('=== PROCESO COMPLETADO ===');
disp(['Se procesaron ' num2str(length(participant_ids)) ' participantes']);
disp('Los archivos se guardaron como:');
for p = 1:length(participant_ids)
    disp(['  - spectral_data_' participant_ids{p} '_1to20Hz.csv']);
end
