function make_dendrogram(coord)

% Constructs the dendrogram corresponding to the coordinates 'coord'


rng default;


% Vector of distances between each subject
coord_dist = pdist(coord,'cosine');

% Matrix of links between close subjects, rows indicates the links found,
% first and second columns indicate the subjects linked and third column
% indicates the distance between them.
% Newly formed cluster (from first rows) are present in matrix
coord_links = linkage(coord_dist,'complete');

cutoff = median([coord_links(end-3,3) coord_links(end-2,3)]);

% Graphical representation as a dendogram
figure;
dendrogram(coord_links,100,'ColorThreshold',cutoff);

end


