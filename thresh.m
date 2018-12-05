function [Mthresh] = thresh(Mdist,range)
% apply thresholds to the input matrix: elements in the range [min,max] (closed interval) are set to 1, otherwise 0
min=range(1); max=range(2);
ind1=Mdist>=min;
ind2=Mdist<=max;
Mthresh=ind1.*ind2;

end

