 
compressedImage = imread('compressed_image.jpg');
grayImage = rgb2gray(compressedImage); % Ensure grayscale format

% Detect feature points
points = detectSURFFeatures(grayImage);

% Visualize strongest feature points
figure(1);
imshow(compressedImage);
hold on;
plot(points.selectStrongest(50)); % Visualize 50 strongest points
title('Strongest Feature Points');
hold off;

% Extract feature locations
numPoints = points.Count;
locations = points.Location;%Extracts the coordinates of detected feature points.

% Check if there are enough points for MST
if numPoints < 2 % Ensures that at least two points exist for MST computation.

    error('Not enough feature points detected for MST computation.');
end

% Compute pairwise distances between feature points
distances = pdist2(locations, locations);% Uses Euclidean distance to compute distances between all feature points.

% Convert pairwise distances into a format suitable for MST
Z = linkage(squareform(distances), 'single'); % Hierarchical clustering
mstEdges = mst(Z, numPoints); % Extract MST edges

% Construct graph for visualization
G = graph(mstEdges(:,1), mstEdges(:,2));

% Visualize MST on the image
figure(2);
imshow(compressedImage);
hold on;
plot(locations(:,1), locations(:,2), 'r*'); % Feature points
plot(G, 'XData', locations(:,1), 'YData', locations(:,2), 'LineWidth', 2);
title('Minimum Spanning Tree on Feature Points');
hold off;

% Creates a graph representation of the MST.
% 
% Plots feature points (red stars).
% 
% Overlays the MST structure on the image.