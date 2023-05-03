clear; close all; clc;

% Train data
load('pre_c1_features.mat');
pre_c1_features = all_features_folder;
load('pre_c4_features.mat');
pre_c4_features = all_features_folder;
load('pre_c6_features.mat');
pre_c6_features = all_features_folder;
load('fluteValue.mat');

% Test data
load('pre_c2_features.mat');
pre_c2_features = all_features_folder;
load('pre_c3_features.mat');
pre_c3_features = all_features_folder;
load('pre_c5_features.mat');
pre_c5_features = all_features_folder;

% lable data
fluteValue = array2table(matFile);
rowTimes = minutes(fluteValue{:, 1});

% Apply Min-Max scaling to each table, column-wise
pre_c1_features_min_max = varfun(@min_max_scale, pre_c1_features, 'OutputFormat', 'table');
pre_c4_features_min_max = varfun(@min_max_scale, pre_c4_features, 'OutputFormat', 'table');
pre_c6_features_min_max = varfun(@min_max_scale, pre_c6_features, 'OutputFormat', 'table');
pre_c2_features_min_max = varfun(@min_max_scale, pre_c2_features, 'OutputFormat', 'table');
pre_c3_features_min_max = varfun(@min_max_scale, pre_c3_features, 'OutputFormat', 'table');
pre_c5_features_min_max = varfun(@min_max_scale, pre_c5_features, 'OutputFormat', 'table');

% Rename the variables by adding 'min_max_scale_' prefix
pre_c1_features_min_max.Properties.VariableNames = pre_c1_features.Properties.VariableNames;
pre_c4_features_min_max.Properties.VariableNames = pre_c4_features.Properties.VariableNames;
pre_c6_features_min_max.Properties.VariableNames = pre_c6_features.Properties.VariableNames;
pre_c2_features_min_max.Properties.VariableNames = pre_c2_features.Properties.VariableNames;
pre_c3_features_min_max.Properties.VariableNames = pre_c3_features.Properties.VariableNames;
pre_c5_features_min_max.Properties.VariableNames = pre_c5_features.Properties.VariableNames;

c2_array = pre_c2_features_min_max;
c3_array = pre_c3_features_min_max;
c6_array = pre_c6_features_min_max;
c6_array(:, end + 1) = fluteValue(:,4);

% Convert the new tables to timetables, using the row times
c1_timetable = table2timetable(pre_c1_features_min_max, 'RowTimes', rowTimes);
c4_timetable = table2timetable(pre_c4_features_min_max, 'RowTimes', rowTimes);
c6_timetable = table2timetable(pre_c6_features_min_max, 'RowTimes', rowTimes);

% % Convert the new tables to timetables, using the row times
% c2_timetable = table2timetable(pre_c2_features_min_max, 'RowTimes', rowTimes);
% c3_timetable = table2timetable(pre_c3_features_min_max, 'RowTimes', rowTimes);
% c5_timetable = table2timetable(pre_c5_features_min_max, 'RowTimes', rowTimes);

% smoothing train data set
filter_num = 7;

% Train dataset apply the smoothing filter
variableNames = c1_timetable.Properties.VariableNames;
c1_timetable_smooth = varfun(@(x) movmean(x, [filter_num 0]), c1_timetable(:,1:end));
c1_timetable_smooth.Properties.VariableNames = variableNames(1:end);
c1_timetable_smooth.Wear = fluteValue{:, 2};
c1_timetable.Wear = fluteValue{:, 2};

variableNames = c4_timetable.Properties.VariableNames;
c4_timetable_smooth = varfun(@(x) movmean(x, [filter_num 0]), c4_timetable(:,1:end));
c4_timetable_smooth.Properties.VariableNames = variableNames(1:end);
c4_timetable_smooth.Wear = fluteValue{:, 3};
c4_timetable.Wear = fluteValue{:, 3};

variableNames = c6_timetable.Properties.VariableNames;
c6_timetable_smooth = varfun(@(x) movmean(x, [filter_num 0]), c6_timetable(:,1:end));
c6_timetable_smooth.Properties.VariableNames = variableNames(1:end);
c6_timetable_smooth.Wear = fluteValue{:, 4};
c6_timetable.Wear = fluteValue{:, 4};

% Save the traing timetables as .mat files
save('c1_timetable.mat', 'c1_timetable');
save('c4_timetable.mat', 'c4_timetable');
save('c6_timetable.mat', 'c6_timetable');

save('c1_timetable_smooth.mat', 'c1_timetable_smooth');
save('c4_timetable_smooth.mat', 'c4_timetable_smooth');
save('c6_timetable_smooth.mat', 'c6_timetable_smooth');

% Save the timetables as .mat files
save('c2_array.mat', 'c2_array');
save('c3_array.mat', 'c3_array');
save('c6_array.mat', 'c6_array');

% Define Min-Max scaling function for columns
function scaled_data = min_max_scale(data)
    min_val = min(data);
    max_val = max(data);
    scaled_data = (data - min_val) ./ (max_val - min_val);
end
