%% Spectra Data

% Load Study Data
[STUDY ALLEEG] = pop_loadstudy('filename', 'study_file.study', 'filepath', 'C:\Users\yangy\Desktop\Ed Fisica\Filtered Data\All');
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];


% Plot Channel 
STUDY = pop_specparams(STUDY, 'plotconditions','together','ylim',[30 60] ,'freqrange',[2 22] ,'averagechan','on');
STUDY = pop_statparams(STUDY, 'groupstats','on','condstats','on','alpha',0.5);
STUDY = std_specplot(STUDY,ALLEEG,'channels',{'eeg_1','eeg_2','eeg_3','eeg_4'}, 'design', 1);



%%
% Función que exporta un dataframe de 21 filas (bandas de frecuencias con decimales)
% y 9 columnas (tareas)

% Generar el plot con todas las condiciones
figure;
[STUDY, specdata, specfreqs] = std_specplot(STUDY, ALLEEG, ...
    'channels', {'eeg_1','eeg_2','eeg_3','eeg_4'}, ...
    'design', 1);

% Obtener TODAS las líneas del plot
h = gcf;
lines = findobj(h, 'Type', 'line');

disp(['Número de líneas encontradas: ' num2str(length(lines))]);

% Extraer datos de cada línea
all_xdata = {};
all_ydata = {};
line_info = {};

for i = 1:length(lines)
    all_xdata{i} = get(lines(i), 'XData');
    all_ydata{i} = get(lines(i), 'YData');
    
    % Intentar obtener información adicional de la línea
    line_info{i}.color = get(lines(i), 'Color');
    line_info{i}.style = get(lines(i), 'LineStyle');
    line_info{i}.display_name = get(lines(i), 'DisplayName');
end

% Si hay 9 líneas (una por tarea), crear la matriz
if length(lines) >= 9
    % Usar las primeras 9 líneas
    frequencies = all_xdata{1}(:);
    power_matrix = zeros(length(frequencies), 10);
    power_matrix(:,1) = frequencies;
    
    column_names = {'Frequency_Hz'};
    
    for i = 1:9
        power_matrix(:, i+1) = all_ydata{i}(:);
        
        % Intentar obtener el nombre de la tarea del DisplayName
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
% Función que exporta un dataframe de 21 filas (bandas de frecuencias con decimales)
% y 9 columnas (tareas)

% Generar el plot con rango de 0 a 25 Hz para visualización
figure;
[STUDY, specdata, specfreqs] = std_specplot(STUDY, ALLEEG, ...
    'channels', {'eeg_1','eeg_2','eeg_3','eeg_4'}, ...
    'design', 1, ...
    'freqrange', [0 25]); % Especificar rango de frecuencias para el plot

% Obtener TODAS las líneas del plot
h = gcf;
lines = findobj(h, 'Type', 'line');

disp(['Número de líneas encontradas: ' num2str(length(lines))]);

% Extraer datos de cada línea
all_xdata = {};
all_ydata = {};
line_info = {};

for i = 1:length(lines)
    all_xdata{i} = get(lines(i), 'XData');
    all_ydata{i} = get(lines(i), 'YData');
    
    % Intentar obtener información adicional de la línea
    line_info{i}.color = get(lines(i), 'Color');
    line_info{i}.style = get(lines(i), 'LineStyle');
    line_info{i}.display_name = get(lines(i), 'DisplayName');
end

% Si hay 9 líneas (una por tarea), crear la matriz
if length(lines) >= 9
    % Obtener todas las frecuencias de la primera línea
    all_frequencies = all_xdata{1}(:);
    
    % Encontrar índices para el rango de 1 a 20 Hz
    freq_indices = find(all_frequencies >= 1 & all_frequencies <= 20);
    
    % Extraer solo las frecuencias en el rango deseado
    frequencies = all_frequencies(freq_indices);
    
    % Mostrar información sobre las frecuencias
    disp(['Frecuencia mínima: ' num2str(min(frequencies))]);
    disp(['Frecuencia máxima: ' num2str(max(frequencies))]);
    disp(['Número de puntos de frecuencia: ' num2str(length(frequencies))]);
    
    % Crear matriz con dimensiones apropiadas
    power_matrix = zeros(length(frequencies), 10);
    power_matrix(:,1) = frequencies;
    
    column_names = {'Frequency_Hz'};
    
    % Extraer solo los valores de potencia correspondientes al rango 1-20 Hz
    for i = 1:9
        all_power_values = all_ydata{i}(:);
        power_matrix(:, i+1) = all_power_values(freq_indices);
        
        % Intentar obtener el nombre de la tarea del DisplayName
        if ~isempty(line_info{i}.display_name)
            column_names{end+1} = line_info{i}.display_name;
        else
            column_names{end+1} = sprintf('Task_%d', i);
        end
    end
    
    % Opcional: Redondear frecuencias a enteros si están muy cerca
    % Esto ayudará a tener valores más limpios si es posible
    freq_rounded = round(frequencies);
    freq_diff = abs(frequencies - freq_rounded);
    
    % Si las diferencias son muy pequeñas (< 0.1), usar valores redondeados
    if max(freq_diff) < 0.1
        disp('Redondeando frecuencias a valores enteros...');
        power_matrix(:,1) = freq_rounded;
    else
        disp('Manteniendo valores decimales de frecuencia originales');
    end
    
    % Crear tabla
    T = array2table(power_matrix, 'VariableNames', column_names);
    
    % Guardar
    writetable(T, 'spectral_data_1to20Hz.csv');
    
    % Mostrar preview de los datos
    disp('Preview de los primeros 5 valores de frecuencia:');
    disp(power_matrix(1:5, 1));
    
else
    disp('No se encontraron suficientes líneas para las 9 tareas');
end% Generar el plot con rango de 0 a 25 Hz para visualización
figure;
[STUDY, specdata, specfreqs] = std_specplot(STUDY, ALLEEG, ...
    'channels', {'eeg_1','eeg_2','eeg_3','eeg_4'}, ...
    'design', 1, ...
    'freqrange', [0 25]); % Especificar rango de frecuencias para el plot

% Obtener TODAS las líneas del plot
h = gcf;
lines = findobj(h, 'Type', 'line');

disp(['Número de líneas encontradas: ' num2str(length(lines))]);

% Extraer datos de cada línea
all_xdata = {};
all_ydata = {};
line_info = {};

for i = 1:length(lines)
    all_xdata{i} = get(lines(i), 'XData');
    all_ydata{i} = get(lines(i), 'YData');
    
    % Intentar obtener información adicional de la línea
    line_info{i}.color = get(lines(i), 'Color');
    line_info{i}.style = get(lines(i), 'LineStyle');
    line_info{i}.display_name = get(lines(i), 'DisplayName');
end

% Si hay 9 líneas (una por tarea), crear la matriz
if length(lines) >= 9
    % Obtener todas las frecuencias de la primera línea
    all_frequencies = all_xdata{1}(:);
    
    % Encontrar índices para el rango de 1 a 20 Hz
    freq_indices = find(all_frequencies >= 1 & all_frequencies <= 20);
    
    % Extraer solo las frecuencias en el rango deseado
    frequencies = all_frequencies(freq_indices);
    
    % Mostrar información sobre las frecuencias
    disp(['Frecuencia mínima: ' num2str(min(frequencies))]);
    disp(['Frecuencia máxima: ' num2str(max(frequencies))]);
    disp(['Número de puntos de frecuencia: ' num2str(length(frequencies))]);
    
    % Crear matriz con dimensiones apropiadas
    power_matrix = zeros(length(frequencies), 10);
    power_matrix(:,1) = frequencies;
    
    column_names = {'Frequency_Hz'};
    
    % Extraer solo los valores de potencia correspondientes al rango 1-20 Hz
    for i = 1:9
        all_power_values = all_ydata{i}(:);
        power_matrix(:, i+1) = all_power_values(freq_indices);
        
        % Intentar obtener el nombre de la tarea del DisplayName
        if ~isempty(line_info{i}.display_name)
            column_names{end+1} = line_info{i}.display_name;
        else
            column_names{end+1} = sprintf('Task_%d', i);
        end
    end
    
    % Opcional: Redondear frecuencias a enteros si están muy cerca
    % Esto ayudará a tener valores más limpios si es posible
    freq_rounded = round(frequencies);
    freq_diff = abs(frequencies - freq_rounded);
    
    % Si las diferencias son muy pequeñas (< 0.1), usar valores redondeados
    if max(freq_diff) < 0.1
        disp('Redondeando frecuencias a valores enteros...');
        power_matrix(:,1) = freq_rounded;
    else
        disp('Manteniendo valores decimales de frecuencia originales');
    end
    
    % Crear tabla
    T = array2table(power_matrix, 'VariableNames', column_names);
    
    % Guardar
    writetable(T, 'spectral_data_1to20Hz.csv');
    
    % Mostrar preview de los datos
    disp('Preview de los primeros 5 valores de frecuencia:');
    disp(power_matrix(1:5, 1));
    
else
    disp('No se encontraron suficientes líneas para las 9 tareas');
end






%%
% Función que exporta un dataframe de 21 filas (bandas de frecuencias con valores centeros) 
% y 9 columnas (tareas)

% Después de extraer los datos (usando el código anterior hasta obtener all_xdata y all_ydata)

if length(lines) >= 9
    % Definir las frecuencias objetivo (enteros de 1 a 20)
    target_frequencies = (1:20)';
    
    % Crear matriz para almacenar datos interpolados
    power_matrix_interp = zeros(20, 10);
    power_matrix_interp(:,1) = target_frequencies;
    
    column_names = {'Frequency_Hz'};
    
    % Interpolar datos para cada tarea
    for i = 1:9
        % Obtener datos originales
        orig_freq = all_xdata{i}(:);
        orig_power = all_ydata{i}(:);
        
        % Interpolar a las frecuencias objetivo
        interpolated_power = interp1(orig_freq, orig_power, target_frequencies, 'linear');
        
        power_matrix_interp(:, i+1) = interpolated_power;
        
        if ~isempty(line_info{i}.display_name)
            column_names{end+1} = line_info{i}.display_name;
        else
            column_names{end+1} = sprintf('Task_%d', i);
        end
    end
    
    % Crear tabla con datos interpolados
    T_interp = array2table(power_matrix_interp, 'VariableNames', column_names);
    
    % Guardar
    writetable(T_interp, 'spectral_data_1to20Hz_interpolated.csv');
    
    disp('Archivo guardado con frecuencias enteras exactas de 1 a 20 Hz');
end






%% Exportar datos espectrales por cada participante individual
% Genera un archivo CSV de 20 filas (frecuencias 1-20 Hz) x 10 columnas (Freq + 9 tareas)

% Load Study Data
[STUDY ALLEEG] = pop_loadstudy('filename', 'study_file.study', 'filepath', 'C:\Users\yangy\Desktop\Muse_EEG\Ed Fisica\Datos Filtrados\All');
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];

% Configurar parámetros espectrales
STUDY = pop_specparams(STUDY, 'plotconditions','together','ylim',[30 60] ,'freqrange',[1 20] ,'averagechan','on');
STUDY = pop_statparams(STUDY, 'groupstats','on','condstats','on','alpha',0.5);

% Definir las frecuencias objetivo (enteros de 1 a 20)
target_frequencies = (1:20)';

% Definir los IDs de los participantes (ajusta según tus datos)
% Asumiendo que los participantes son s1, s2, ..., s8
participant_ids = {'01', '02', '03', '05', '06', '07', '08', '09'};

% Loop para cada participante
for p = 1:length(participant_ids)
    
    current_participant = participant_ids{p};
    disp(['=== Procesando participante: ' current_participant ' ===']);
    
    % Generar el plot para el participante actual
    figure;
    STUDY = std_specplot(STUDY, ALLEEG, 'channels', {'eeg_1','eeg_2','eeg_3','eeg_4'}, ...
        'subject', current_participant, 'design', 1);
    
    % Obtener el handle de la figura actual
    h = gcf;
    
    % Encontrar todos los objetos de línea en la figura
    lines = findobj(h, 'Type', 'line');
    
    disp(['Número de líneas encontradas para ' current_participant ': ' num2str(length(lines))]);
    
    % Extraer datos de cada línea
    all_xdata = {};
    all_ydata = {};
    line_info = {};
    
    for i = 1:length(lines)
        all_xdata{i} = get(lines(i), 'XData');
        all_ydata{i} = get(lines(i), 'YData');
        
        % Intentar obtener información adicional de la línea
        line_info{i}.color = get(lines(i), 'Color');
        line_info{i}.style = get(lines(i), 'LineStyle');
        line_info{i}.display_name = get(lines(i), 'DisplayName');
    end
    
    % Si hay 9 líneas (una por tarea), crear la matriz
    if length(lines) >= 9
        
        % Crear matriz para almacenar datos interpolados
        power_matrix_interp = zeros(20, 10);
        power_matrix_interp(:,1) = target_frequencies;
        
        column_names = {'Frequency_Hz'};
        
        % Interpolar datos para cada tarea
        for i = 1:9
            % Obtener datos originales
            orig_freq = all_xdata{i}(:);
            orig_power = all_ydata{i}(:);
            
            % Verificar que tenemos datos válidos
            if ~isempty(orig_freq) && ~isempty(orig_power)
                % Interpolar a las frecuencias objetivo
                interpolated_power = interp1(orig_freq, orig_power, target_frequencies, 'linear');
                power_matrix_interp(:, i+1) = interpolated_power;
            else
                % Si no hay datos, llenar con NaN
                power_matrix_interp(:, i+1) = NaN;
                disp(['Advertencia: No hay datos para la tarea ' num2str(i) ' del participante ' current_participant]);
            end
            
            % Nombrar las columnas
            if ~isempty(line_info{i}.display_name)
                column_names{end+1} = line_info{i}.display_name;
            else
                column_names{end+1} = sprintf('Task_%d', i);
            end
        end
        
        % Crear tabla con datos interpolados
        T_interp = array2table(power_matrix_interp, 'VariableNames', column_names);
        
        % Crear nombre de archivo único para este participante
        filename = sprintf('spectral_data_%s_1to20Hz.csv', current_participant);
        
        % Guardar
        writetable(T_interp, filename);
        disp(['Archivo guardado: ' filename]);
        
        % Mostrar resumen
        disp(['Dimensiones: ' num2str(height(T_interp)) ' filas x ' num2str(width(T_interp)) ' columnas']);
        
        % Verificar NaN
        n_nan = sum(sum(isnan(table2array(T_interp(:, 2:end)))));
        if n_nan > 0
            disp(['ADVERTENCIA: ' num2str(n_nan) ' valores NaN encontrados para ' current_participant]);
        end
        
    else
        disp(['ERROR: No se encontraron suficientes líneas para ' current_participant]);
        disp(['Se esperaban 9 líneas (tareas) pero se encontraron ' num2str(length(lines))]);
    end
    
    % Cerrar la figura antes de procesar el siguiente participante
    close(h);
    
    % Pausa pequeña para evitar problemas de memoria
    pause(0.5);
    
end

disp('=== PROCESO COMPLETADO ===');
disp(['Se procesaron ' num2str(length(participant_ids)) ' participantes']);
disp('Los archivos se guardaron como:');
for p = 1:length(participant_ids)
    disp(['  - spectral_data_' participant_ids{p} '_1to20Hz.csv']);
end


