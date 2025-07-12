
function mst = feature_prediction_structure(imageSet)
    % Input: imageSet - cell array of images
    % Output: mst - Minimum Spanning Tree (MST) based on feature distances

    numImages = numel(imageSet); % no.of images in a set
    pairwiseDistances = inf(numImages); % Initialize distance matrix
    validEdges = false; % Track if we found valid matches

    targetSize = [256, 256];  % Standardized image size
    threshold = 10; % Adjust threshold for feature matching

    % Step 1: Preprocess Images and Extract SIFT Features
    keypoints = cell(1, numImages); %In an image of a face, keypoints could be the eyes, nose, mouth, and edges of facial features.
    descriptors = cell(1, numImages); %A descriptor is a numerical representation (vector) that describes the appearance of a keypoint.

    for i = 1:numImages
        if size(imageSet{i}, 3) == 3
            imageSet{i} = rgb2gray(imageSet{i}); % Convert to grayscale
        end
        imageSet{i} = imresize(imageSet{i}, targetSize); % Resize to target size

        % 🔹 Extract SIFT features
        keypoints{i} = detectSIFTFeatures(imageSet{i});%Detects keypoints in the image.
        [descriptors{i}, keypoints{i}] = extractFeatures(imageSet{i}, keypoints{i});%Extracts descriptors from keypoints.

        % 🔥 Debug: Show detected SIFT keypoints
        figure;
        imshow(imageSet{i});
        hold on;
        plot(keypoints{i}.selectStrongest(100), 'showOrientation', true);%Displays the image with 100 strongest SIFT keypoints marked.
        title(sprintf('SIFT Keypoints - Image %d', i));
        hold off; % Stops further additions to this figure
    end

    % Step 2: Compute Pairwise Distances Using SIFT Matching
    for i = 1:numImages
        for j = i+1:numImages
            if isempty(descriptors{i}) || isempty(descriptors{j})% Iterates over all pairs of images (i, j)
                continue; % Skip if no descriptors found
            end
            
            % 🔹 Match Features between Image i and j
            indexPairs = matchFeatures(descriptors{i}, descriptors{j});  %i=1, j=2  → Compare Image 1 and 2
            matchCount = size(indexPairs, 1); % Count matches
           
            %i=1, j=3  → Compare Image 1 and 3
            %i=2, j=3  → Compare Image 2 and 3


            % 🔥 Debug: Print number of matches
            fprintf('Matches between Image %d and Image %d: %d\n', i, j, matchCount);

            % If matches are found, set pairwise distance
            if matchCount > threshold
                %The pairwise distance is calculated as 1 / matchCount (more matches = lower distance).
                pairwiseDistances(i, j) = 1 / matchCount; % Higher matches -> Lower distance
                pairwiseDistances(j, i) = pairwiseDistances(i, j);
                %This line ensures that the distance matrix is symmetric, meaning the distance between 
                % Image i and Image j is the same as the distance between Image j and Image i.
                validEdges = true; % At least one valid edge found
            end
        end
    end

    % Step 3: Check if MST Can Be Created
    if ~validEdges
        warning('⚠️ All images are completely different. No MST will be generated.');
        mst = graph([], []); % Return empty graph
        return;
    end

    % Step 4: Generate MST (Minimum Spanning Tree)
    G = graph(pairwiseDistances);
    mst = minspantree(G);

    % 🔥 Debug: Display MST Structure
    figure;
    plot(mst, 'Layout', 'force');
    %plot(mst, 'Layout', 'circle');  % Arranges nodes in a circle
    %plot(mst, 'Layout', 'layered'); % Best for hierarchical structures
    title('Minimum Spanning Tree (MST) of Image Set');
end
