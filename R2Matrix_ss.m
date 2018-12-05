function [CM] = R2Matrix_ss(xt)
% xt is the input EEG signal, channel*timepoints
%   returns the connectivity matrix (nchan*nchan) measured by Pearson correlation R^2 coefficient
%   for rsEEG, assume the recordings are at steady state so var(x(t)) stays constant (???can be spurious...)
%   a more generalized version would segment xt into windows and calculate piecewise var
nchan=size(xt,1);
CM=zeros(nchan,nchan);
for i=1:nchan
    CM(i,i)=1;
    for j=i+1:nchan
       s1=xt(i,:)-mean(xt(i,:));
       s2=xt(j,:)-mean(xt(j,:));
       c12=xcorr(s1,s2,'unbiased');
       CM(i,j)=max(c12.^2)/(var(s1,1)*var(s2,1));
       CM(j,i)=CM(i,j);
    end
end

end

