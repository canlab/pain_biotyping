function s = mySilhouette(X, IDX)

    % Creates a Silhouette

    %# X  : matrix of size N-by-p, data where rows are instances
    %# IDX: vector of size N, cluster index of each instance (starting from 1)
    %# s  : vector of size N, silhouette score value of each instance

    N = size(X,1);            %# number of instances
    K = numel(unique(IDX));   %# number of clusters

    %# compute pairwise distance matrix
    D = squareform( pdist(X,'cosine').^2 );

    %# indices belonging to each cluster
    kIndices = accumarray(IDX, 1:N, [K 1], @(x){sort(x)});

    %# compute a,b,s for each instance
    %# a(i): average distance from i to all other data within the same cluster.
    %# b(i): lowest average dist from i to the data of another single cluster
    a = zeros(N,1);
    b = zeros(N,1);
    for i=1:N
        ind = kIndices{IDX(i)}; ind = ind(ind~=i);
        a(i) = mean( D(i,ind) );
        b(i) = min( cellfun(@(ind) mean(D(i,ind)), kIndices([1:K]~=IDX(i))) );
    end
    s = (b-a) ./ max(a,b);
end