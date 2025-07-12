 function encodedData = frequency_redundancy_reduction(compensatedImages)
    if isempty(compensatedImages)
        error('Input compensatedImages is empty.');
    end

    numImages = numel(compensatedImages);
    encodedData = cell(size(compensatedImages));

    for i = 1:numImages
        image = double(compensatedImages{i});

        if ndims(image) == 3
            [rows, cols, channels] = size(image);
            dctCoeffs = zeros(rows, cols, channels);
            for c = 1:channels
                dctCoeffs(:, :, c) = computeDCT(image(:, :, c));
                % ✅ Apply Adaptive Quantization
                Q = adaptiveQuantizationMatrix(dctCoeffs(:, :, c));
                dctCoeffs(:, :, c) = round(dctCoeffs(:, :, c) ./ Q);
            end
        else
            dctCoeffs = computeDCT(image);
            Q = adaptiveQuantizationMatrix(dctCoeffs);
            dctCoeffs = round(dctCoeffs ./ Q);
        end

        encodedData{i} = dctCoeffs;
    end
end

function Q = adaptiveQuantizationMatrix(dctCoeffs)
    % 🔹 Compute an adaptive quantization matrix based on variance
    baseQ = [16 11 10 16 24 40 51 61;
             12 12 14 19 26 58 60 55;
             14 13 16 24 40 57 69 56;
             14 17 22 29 51 87 80 62;
             18 22 37 56 68 109 103 77;
             24 35 55 64 81 104 113 92;
             49 64 78 87 103 121 120 101;
             72 92 95 98 112 100 103 99];

    % 🔹 Scale quantization based on the variance of DCT coefficients
    scaleFactor = max(0.5, min(2, std(dctCoeffs(:)) / 10));
    Q = baseQ * scaleFactor;
end


function reconstructedImages = lossless_recovery(encodedData)
    if isempty(encodedData)
        error('Input encodedData is empty.');
    end

    numImages = numel(encodedData);
    reconstructedImages = cell(size(encodedData));

    for i = 1:numImages
        encodedImage = double(encodedData{i});

        if ndims(encodedImage) == 3
            [rows, cols, channels] = size(encodedImage);
            reconstructedImage = zeros(rows, cols, channels);
            for c = 1:channels
                Q = adaptiveQuantizationMatrix(encodedImage(:, :, c));
                encodedImage(:, :, c) = encodedImage(:, :, c) .* Q; % Dequantization
                reconstructedImage(:, :, c) = computeIDCT(encodedImage(:, :, c));
            end
        else
            Q = adaptiveQuantizationMatrix(encodedImage);
            encodedImage = encodedImage .* Q; % Dequantization
            reconstructedImage = computeIDCT(encodedImage);
        end

        reconstructedImages{i} = uint8(reconstructedImage);
    end
end
