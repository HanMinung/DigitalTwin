clear; close all; clc;

% Load data
load('pre_c1_features.mat');
pre_c1_features = all_features_folder;
load('pre_c4_features.mat');
pre_c4_features = all_features_folder;
load('pre_c6_features.mat');
pre_c6_features = all_features_folder;
load('pre_c2_features.mat');
pre_c2_features = all_features_folder;
load('pre_c3_features.mat');
pre_c3_features = all_features_folder;
load('pre_c5_features.mat');
pre_c5_features = all_features_folder;

% Apply standard scaling to each table, column-wise
pre_c1_features_scaled = varfun(@standard_scale, pre_c1_features, 'OutputFormat', 'table');
pre_c4_features_scaled = varfun(@standard_scale, pre_c4_features, 'OutputFormat', 'table');
pre_c6_features_scaled = varfun(@standard_scale, pre_c6_features, 'OutputFormat', 'table');
pre_c2_features_scaled = varfun(@standard_scale, pre_c2_features, 'OutputFormat', 'table');
pre_c3_features_scaled = varfun(@standard_scale, pre_c3_features, 'OutputFormat', 'table');
pre_c5_features_scaled = varfun(@standard_scale, pre_c5_features, 'OutputFormat', 'table');

% Define standard scaling function for columns
function scaled_data = standard_scale(data)
    mu = mean(data);
    sigma = std(data);
    scaled_data = (data - mu) ./ sigma;
end