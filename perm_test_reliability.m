function p_rel = perm_test_reliability(idx1,idx2,nb_perm)

% Performs a permutation test with nb_perm permuatations of idx2, for each
% permuation the balanced reliability is determined (with compare_cluster.m
% function)
%
% Returns a histogram of the permutations results, and shows the observed 
% reliability and the p-value
%
% Method based on permutationTest.m function from 
% https://nl.mathworks.com/matlabcentral/fileexchange/63276-permutation-test

rel_rand = zeros(nb_perm,1);

s = numel(idx2);

[~,rel_obs] = compare_cluster(idx1,idx2);

for n = 1:nb_perm
    idx2_perm = idx2(randperm(s));
    [~,rel_rand(n)] = compare_cluster(idx1,idx2_perm);
end

% p-value
p_rel = (length(find(abs(rel_rand) > abs(rel_obs)))+1)/(nb_perm+1);

figure;
histogram(rel_rand,'FaceColor',[.3 .8 .6],'EdgeColor',[.2 .5 .9]);
xlabel('Balanced reliability');
ylabel('Frequency');
hold on
od = plot(rel_obs,0,'r*','MarkerSize',20,'DisplayName',sprintf('\n\nObserved reliability \n\np-value = %f',p_rel));
legend(od);
legend('boxoff')
hold off

end