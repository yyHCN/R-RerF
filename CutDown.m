function [array] = CutDown(xt,N,mode)
% xt is the input EEG signal, channel*timepoints
% n is either number of segments (mode='nseg') or number of timepoints per segment (mode='npoint')
% return 3D array with each page representing one segment
%   CutDown.m differs from SampleDown.m in that it preserves sample time & fs so it's more like "real" different trials only shorter in time
%   *always discarding the tail
if strcmp(mode,'nseg')==1
    nseg=N;
    npoint=floor(size(xt,2)/N);
elseif strcmp(mode,'npoint')==1
    npoint=N;
    nseg=floor(size(xt,2)/N);
end
array=[];
for i=1:nseg
    segnow=xt(:,((i-1)*npoint+1):(i*npoint));
    array=cat(3,array,segnow);
end
end

