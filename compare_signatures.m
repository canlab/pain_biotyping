function corr_between_sign = compare_signatures(coord1,coord2)

% Alternative to the measure of reliability in the clusters: test/retest on
% the signatures responses
% 
% Finds the spatial correlation between zscore(NPS1) - zscore(SIIPS1) and
% zscore(NPS2) - zscore(SIIPS2), and plots those values on a
% two-dimensional space


coord1 = zscore(coord1);
coord2 = zscore(coord2);


sign1 = coord1(:,1) - coord1(:,2);
sign2 = coord2(:,1) - coord2(:,2);

figure;
scatter(sign1,sign2,16,[0 .5 0])
xlabel('Signatures scores - first data set')
ylabel('Signatures scores - second data set')
title('Correlation between signatures scores')

corr_between_sign = corr(sign1,sign2);

end