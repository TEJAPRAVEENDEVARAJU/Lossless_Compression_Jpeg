 function compensatedImages = spatial_disparity_compensation(imageSet, mst)
    % Input: imageSet - a cell array of images
    %        mst - minimum spanning tree
    % Output: compensatedImages - globally and locally compensated images

    if nargin < 2
        error('Both imageSet and mst must be provided.');
    end %if the function is called without an mst, it throws an error.

    %numImages stores the number of images, and compensatedImages is initialized to store the processed images.
    numImages = numel(imageSet);
    compensatedImages = cell(size(imageSet));

    % Define a sample affine transformation matrix (identity matrix as default)
    tformMatrix = [1 0 0; 0 1 0; 0 0 1]; % No transformation (placeholder)
    %The affine transformation is applied in spatial disparity compensation to 
    % align images properly using translation, rotation, and scaling based on the MST structure.

    % Apply global and local compensations
    for i = 1:numImages
        if i == 1
            compensatedImages{i} = imageSet{i}; % Root node, no compensation
        else
            % Manually apply affine transformation
            compensatedImages{i} = applyAffineTransform(imageSet{i}, tformMatrix);
        end
    end
end

function transformedImage = applyAffineTransform(image, tformMatrix)
    % Manually apply an affine transformation to the image
    [rows, cols, channels] = size(image);
    transformedImage = zeros(rows, cols, channels, 'like', image);% it store the transformed image

    % Process each channel separately
    for c = 1:channels
        channel = double(image(:, :, c));
        [X, Y] = meshgrid(1:cols, 1:rows);
        % meshgrid is used to generate the original pixel coordinates.
        % It helps map pixels correctly after transformation.

        % Create homogeneous coordinates
        coords = [X(:)'; Y(:)'; ones(1, numel(X))];

        % Apply transformation matrix
        transformedCoords = tformMatrix * coords;

        % Interpolate the transformed image
        transformedX = reshape(transformedCoords(1, :), rows, cols);
        transformedY = reshape(transformedCoords(2, :), rows, cols);
        transformedChannel = interp2(X, Y, channel, transformedX, transformedY, 'linear', 0);

        % Assign the transformed channel
        transformedImage(:, :, c) = transformedChannel;
    end

    % Convert back to the original data type
    transformedImage = uint8(transformedImage);
end

% 
% Step-by-Step Explanation
% Initialize the Transformed Image
% 
% It creates an empty image of the same size as the original.
% 
% Loop Through Each Color Channel
% 
% If the image is RGB, each color channel (Red, Green, Blue) is processed separately.
% 
% Generate Pixel Coordinates (meshgrid)
% 
% Creates a grid of pixel positions in the original image.
% 
% Convert to Homogeneous Coordinates
% 
% Adds an extra row ([X; Y; 1]) to allow matrix multiplication.
% 
% Apply the Affine Transformation
% 
% Uses the given transformation matrix (tformMatrix) to compute new pixel locations.
% 
% Interpolate to Fill Missing Pixels (interp2)
% 
% Since transformed pixel locations may not fall exactly on a grid, interpolation is used to smoothly map pixel values.
% 
% Store Transformed Channel in the Output Image
% 
% The transformed pixel values are stored for each color channel.
% 
% Convert Back to uint8 for Display
% 
% Ensures the final image has correct data type.

