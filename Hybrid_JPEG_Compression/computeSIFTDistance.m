function dist = computeSIFTDistance(image1, image2)
    % Ensure images are of the same size
    if ~isequal(size(image1), size(image2))
        error('Images must be the same size for SIFT distance computation.');
    end

    % Compute Euclidean distance between flattened images
    dist = norm(double(image1(:)) - double(image2(:)));
end
function distance = computeSIFTDistance(image1, image2)
    points1 = detectSIFTFeatures(image1);
    points2 = detectSIFTFeatures(image2);
    [features1, validPoints1] = extractFeatures(image1, points1);
    [features2, validPoints2] = extractFeatures(image2, points2);
    indexPairs = matchFeatures(features1, features2);

    % 🔥 Debug: Print the number of matches
    fprintf('Matches found: %d\n', size(indexPairs, 1));

    if size(indexPairs, 1) < 5 % If too few matches, return large distance
        distance = inf;
    else
        distance = size(indexPairs, 1);
    end
end
