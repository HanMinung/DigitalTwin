numSegments = 20;
overlap_ratio = 0.2;

% Ball 07
input_files = {'Ball_DE_0007.mat', 'Ball_FE_0007.mat'};
variable_names = {'X118_DE_time', 'X282_FE_time'};
output_prefixes = {'Ball_07_DE', 'Ball_07_FE'};
class_name = "Ball_07";
[Ball_07_static, Ball_07_envelop, Ball_07_wavelet] = getFeatures(numSegments, overlap_ratio, input_files, variable_names, output_prefixes, class_name);

% Ball 14
input_files = {'Ball_DE_0014.mat', 'Ball_FE_0014.mat'};
variable_names = {'X185_DE_time', 'X286_FE_time'};
output_prefixes = {'Ball_14_DE', 'Ball_14_FE'};
class_name = "Ball_14";
[Ball_14_static, Ball_14_envelop, Ball_14_wavelet] = getFeatures(numSegments, overlap_ratio, input_files, variable_names, output_prefixes, class_name);

% Ball 21
input_files = {'Ball_DE_0021.mat', 'Ball_FE_0021.mat'};
variable_names = {'X222_DE_time', 'X290_FE_time'};
output_prefixes = {'Ball_21_DE', 'Ball_21_FE'};
class_name = "Ball_21";
[Ball_21_static, Ball_21_envelop, Ball_21_wavelet] = getFeatures(numSegments, overlap_ratio, input_files, variable_names, output_prefixes, class_name);

% inner 07
input_files = {'IR_DE_0007.mat', 'IR_FE_0007.mat'};
variable_names = {'X105_DE_time', 'X278_FE_time'};
output_prefixes = {'Inner_07_DE', 'Inner_07_FE'};
class_name = "Inner_07";
[Inner_07_static, Inner_07_envelop, Inner_07_wavelet] = getFeatures(numSegments, overlap_ratio, input_files, variable_names, output_prefixes, class_name);

% inner 14
input_files = {'IR_DE_0014.mat', 'IR_FE_0014.mat'};
variable_names = {'X169_DE_time', 'X274_FE_time'};
output_prefixes = {'Inner_14_DE', 'Inner_14_FE'};
class_name = "Inner_14";
[Inner_14_static, Inner_14_envelop, Inner_14_wavelet] = getFeatures(numSegments, overlap_ratio, input_files, variable_names, output_prefixes, class_name);

% inner 21
input_files = {'IR_DE_0021.mat', 'IR_FE_0021.mat'};
variable_names = {'X209_DE_time', 'X270_FE_time'};
output_prefixes = {'Inner_21_DE', 'Inner_21_FE'};
class_name = "Inner_21";
[Inner_21_static, Inner_21_envelop, Inner_21_wavelet] = getFeatures(numSegments, overlap_ratio, input_files, variable_names, output_prefixes, class_name);

% outer 07
input_files = {'OR_DE_0007.mat', 'OR_FE_0007.mat'};
variable_names = {'X130_DE_time', 'X294_FE_time'};
output_prefixes = {'Outer_07_DE', 'Outer_07_FE'};
class_name = "Outer_07";
[Outer_07_static, Outer_07_envelop, Outer_07_wavelet]  = getFeatures(numSegments, overlap_ratio, input_files, variable_names, output_prefixes, class_name);
 
% outer 14
input_files = {'OR_DE_0014.mat', 'OR_FE_0014.mat'};
variable_names = {'X197_DE_time', 'X313_FE_time'};
output_prefixes = {'Outer_14_DE', 'Outer_14_FE'};
class_name = "Outer_14";
[Outer_14_static, Outer_14_envelop, Outer_14_wavelet] = getFeatures(numSegments, overlap_ratio, input_files, variable_names, output_prefixes, class_name);

% outer 21
input_files = {'OR_DE_0021.mat', 'OR_FE_0021.mat'};
variable_names = {'X234_DE_time', 'X315_FE_time'};
output_prefixes = {'Outer_21_DE', 'Outer_21_FE'};
class_name = "Outer_21";
[Outer_21_static, Outer_21_envelop, Outer_21_wavelet] = getFeatures(numSegments, overlap_ratio, input_files, variable_names, output_prefixes, class_name);

% normal
numSegments = 10;
overlap_ratio = 0.0;
input_files = {'Normal_1.mat', 'Normal_1.mat', 'Normal_2.mat', 'Normal_2.mat'};
variable_names = {'X097_DE_time', 'X097_FE_time', 'X098_DE_time', 'X098_FE_time'};
output_prefixes = {'Normal1_DE', 'Normal1_FE', 'Normal2_DE', 'Normal2_FE'};
class_name = "Normal";
[Normal_static, Normal_envelop, Normal_wavelet] = getFeatures(numSegments, overlap_ratio, input_files, variable_names, output_prefixes, class_name);
 
staticFeatures = vertcat(Ball_07_static, Ball_14_static, Ball_21_static, Inner_07_static, Inner_14_static, Inner_21_static, Outer_07_static, Outer_14_static, Outer_21_static, Normal_static);
envelopFeatures = vertcat(Ball_07_envelop, Ball_14_envelop, Ball_21_envelop, Inner_07_envelop, Inner_14_envelop, Inner_21_envelop, Outer_07_envelop, Outer_14_envelop, Outer_21_envelop, Normal_envelop);
wavletFeatures = vertcat(Ball_07_wavelet, Ball_14_wavelet, Ball_21_wavelet, Inner_07_wavelet, Inner_14_wavelet, Inner_21_wavelet, Outer_07_wavelet, Outer_14_wavelet, Outer_21_wavelet, Normal_wavelet);