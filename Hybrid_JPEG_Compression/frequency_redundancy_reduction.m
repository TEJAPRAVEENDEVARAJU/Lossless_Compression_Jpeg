
function encodedData = frequency_redundancy_reduction(compensatedImages)
    if isempty(compensatedImages)
        error('Input compensatedImages is empty.');
    end

    numImages = numel(compensatedImages);
    encodedData = cell(size(compensatedImages));

    for i = 1:numImages
        image = double(compensatedImages{i}); %Converts each image to double precision (required for DCT).

        if ndims(image) == 3 % apply the dct for the RGB
            [rows, cols, channels] = size(image);
            dctCoeffs = zeros(rows, cols, channels);
            for c = 1:channels
                dctCoeffs(:, :, c) = computeDCT(image(:, :, c));
            end
        else % dct for the Grayscale 
            dctCoeffs = computeDCT(image);
        end

         
        encodedData{i} = dctCoeffs;% store dct  DCT coefficients of each image
    end
end

function dctCoeffs = computeDCT(image)
    dctCoeffs = dct2(image);
end
% Computes the 2D Discrete Cosine Transform (DCT) using dct2().