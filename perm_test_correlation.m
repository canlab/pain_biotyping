function [p_wi_corr,p_btw_corr] = perm_test_correlation(maps1,maps2,idx1,idx2,nb_perm)

% Performs a permutation test with nb_perm permuatations of idx2, for each
% permuation the within-cluster correlation is determined (with
% assess_similarity.m function)
%
% Returns a histogram of the permutations results, and shows the observed 
% correlation and the p-value
%
% Method based on permutationTest.m function from 
% https://nl.mathworks.com/matlabcentral/fileexchange/63276-permutation-test

corr_matrix = assess_similarity(maps1,maps2,idx1,idx2);

s = numel(idx2);

wi_corr_obs = mean(diag(corr_matrix));

btw_corr_obs = mean(corr_matrix(~(eye(size(corr_matrix)))));

wi_corr_rand = zeros(nb_perm,1);
btw_corr_rand = zeros(nb_perm,1);

for n = 1:nb_perm
    idx2_perm = idx2(randperm(s));
    corr_matrix_rand = assess_similarity(maps1,maps2,idx1,idx2_perm);
    wi_corr_rand(n) = mean(diag(corr_matrix_rand));
    btw_corr_rand(n) = mean(corr_matrix_rand(~(eye(size(corr_matrix_rand)))));
end

% p-values
p_wi_corr = (length(find(abs(wi_corr_rand) > abs(wi_corr_obs)))+1)/(nb_perm+1);
p_btw_corr = (length(find(abs(btw_corr_rand) > abs(btw_corr_obs)))+1)/(nb_perm+1);

figure;
histogram(wi_corr_rand,'FaceColor',[.8 .8 .1],'EdgeColor',[.1 .1 .1]);
xlabel('Within-cluster correlation');
ylabel('Frequency');
hold on
od = plot(wi_corr_obs,0,'r*','MarkerSize',20,'DisplayName',sprintf('\n\nObserved correlation \n\np-value = %f',p_wi_corr));
legend(od);
legend('boxoff')
hold off

figure;
histogram(btw_corr_rand,'FaceColor',[.8 .8 .1],'EdgeColor',[.1 .1 .1]);
xlabel('Between-cluster correlation');
ylabel('Frequency');
hold on
od = plot(btw_corr_obs,0,'r*','MarkerSize',20,'DisplayName',sprintf('\n\nObserved correlation \n\np-value = %f',p_btw_corr));
legend(od);
legend('boxoff')
hold off

end