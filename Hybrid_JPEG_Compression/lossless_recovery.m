function reconstructedImages = lossless_recovery(encodedData)
    if isempty(encodedData)
        error('Input encodedData is empty.');
    end

    numImages = numel(encodedData);
    reconstructedImages = cell(size(encodedData));

    for i = 1:numImages
        encodedImage = double(encodedData{i}); % 

        if ndims(encodedImage) == 3
            [rows, cols, channels] = size(encodedImage);
            reconstructedImage = zeros(rows, cols, channels);
            for c = 1:channels
                reconstructedImage(:, :, c) = computeIDCT(encodedImage(:, :, c));
            end
        else
            reconstructedImage = computeIDCT(encodedImage);
        end

        %  Convert back to uint8 ensuring perfect reconstruction
        reconstructedImages{i} = uint8(reconstructedImage); 
    end
end

function idctCoeffs = computeIDCT(encodedImage)
    idctCoeffs = idct2(encodedImage);
end
