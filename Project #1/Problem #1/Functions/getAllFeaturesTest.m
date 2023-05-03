% TEST DATA
input_data = testAN;
output_prefix = 'N1';
class_name = "N1";
[N1_static_test, N1_envelop_test, N1_wavelet_test] = getEachFeatures(input_data, output_prefix, class_name);

input_data = testMN;
output_prefix = 'N2';
class_name = "N2";
[N2_static_test, N2_envelop_test, N2_wavelet_test] = getEachFeatures(input_data, output_prefix, class_name);

input_data = testAI;
output_prefix = 'I1';
class_name = "I1";
[I1_static_test, I1_envelop_test, I1_wavelet_test] = getEachFeatures(input_data, output_prefix, class_name);

input_data = testMI;
output_prefix = 'I2';
class_name = "I2";
[I2_static_test, I2_envelop_test, I2_wavelet_test] = getEachFeatures(input_data, output_prefix, class_name);

input_data = testAO;
output_prefix = 'O1';
class_name = "O1";
[O1_static_test, O1_envelop_test, O1_wavelet_test] = getEachFeatures(input_data, output_prefix, class_name);

input_data = testMO;
output_prefix = 'O2';
class_name = "O2";
[O2_static_test, O2_envelop_test, O2_wavelet_test] = getEachFeatures(input_data, output_prefix, class_name);

input_data = testAB;
output_prefix = 'B1';
class_name = "B1";
[B1_static_test, B1_envelop_test, B1_wavelet_test] = getEachFeatures(input_data, output_prefix, class_name);

input_data = testMB;
output_prefix = 'B2';
class_name = "B2";
[B2_static_test, B2_envelop_test, B2_wavelet_test] = getEachFeatures(input_data, output_prefix, class_name);


staticFeaturesTest = vertcat(N1_static_test, N2_static_test, I1_static_test, I2_static_test, O1_static_test, O2_static_test, B1_static_test, B2_static_test);
envelopFeatureTest = vertcat(N1_envelop_test, N2_envelop_test, I1_envelop_test, I2_envelop_test, O1_envelop_test, O2_envelop_test, B1_envelop_test, B2_envelop_test);
waveletFeatureTest = vertcat( N1_wavelet_test, N2_wavelet_test,  I1_wavelet_test, I2_wavelet_test, O1_wavelet_test, O2_wavelet_test, B1_wavelet_test, B2_wavelet_test);
globalPoolTest = [staticFeaturesTest(:, 1:end-1), envelopFeatureTest(:, 1:end-1), waveletFeatureTest];