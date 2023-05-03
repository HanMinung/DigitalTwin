% TRAIN DATA
inputData = trainAN;
outputPrefixes = 'N1';
class_name = "N1";
[N1_static, N1_envelop, N1_wavelet] = getEachFeatures(inputData, outputPrefixes, class_name);

inputData = trainMN;
outputPrefixes = 'N2';
class_name = "N2";
[N2_static, N2_envelop, N2_wavelet] = getEachFeatures(inputData, outputPrefixes, class_name);

inputData = trainAI;
outputPrefixes = 'I1';
class_name = "I1";
[I1_static, I1_envelop, I1_wavelet] = getEachFeatures(inputData, outputPrefixes, class_name);

inputData = trainMI;
outputPrefixes = 'I2';
class_name = "I2";
[I2_static, I2_envelop, I2_wavelet] = getEachFeatures(inputData, outputPrefixes, class_name);

inputData = trainAO;
outputPrefixes = 'O1';
class_name = "O1";
[O1_static, O1_envelop, O1_wavelet] = getEachFeatures(inputData, outputPrefixes, class_name);

inputData = trainMO;
outputPrefixes = 'O2';
class_name = "O2";
[O2_static, O2_envelop, O2_wavelet] = getEachFeatures(inputData, outputPrefixes, class_name);

inputData = trainAB;
outputPrefixes = 'B1';
class_name = "B1";
[B1_static, B1_envelop, B1_wavelet] = getEachFeatures(inputData, outputPrefixes, class_name);

inputData = trainMB;
outputPrefixes = 'B2';
class_name = "B2";
[B2_static, B2_envelop, B2_wavelet] = getEachFeatures(inputData, outputPrefixes, class_name);


staticFeaturesTrain = vertcat(N1_static, N2_static, I1_static, I2_static, O1_static, O2_static, B1_static, B2_static);
envelopFeaturesTrain = vertcat(N1_envelop, N2_envelop, I1_envelop, I2_envelop, O1_envelop, O2_envelop, B1_envelop, B2_envelop);
waveletFeaturesTrain = vertcat( N1_wavelet, N2_wavelet,  I1_wavelet, I2_wavelet, O1_wavelet, O2_wavelet, B1_wavelet, B2_wavelet);
globalPoolTrain = [staticFeaturesTrain(:, 1:end-1), envelopFeaturesTrain(:, 1:end-1), waveletFeaturesTrain];