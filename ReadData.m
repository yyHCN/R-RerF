function [alltrials,nullchan] = ReadData(filename,remove,state,lseg)
% used for reading in rsEEG data (HBN format), with a known eventtable
% eventtype=[1,90,20,30,20,30,20,30,20,30,20,30,20,1]
% channels with constant 0 value are rejected (when remove='auto'), eye-closed sections are extracted, and segmented into specified length
% segments from different sections are stack together as output
% nullchan returns rejected channel number
% or, when remove is a numeric vector, its elements serve as indices of rejected channels 
load(filename,'result');
eegdata=result.data;
if ischar(remove)==1
    check=sum(abs(eegdata),2)==0;
    nullchan=1:size(eegdata,1); nullchan=nullchan(check);
    eegdata=eegdata(~check,:);
else
    nullchan=remove;
    eegdata(nullchan,:)=[];
end
t=[result.event.sample];
% for event type: 1=start and end; 90=paradigm start; 20=eyes open start; 30=eyes closed start
eventtype=[1,90,20,30,20,30,20,30,20,30,20,30,20,1];
if strcmp(state,'closed')==1
    inds=find(eventtype==30); % extract eye-closed sections
elseif strcmp(state,'open')==1
    inds=find(eventtype==20); % extract eye-open sections
end
Ns=length(inds);
alltrials=[];
for i=1:Ns
    section=eegdata(:,t(inds(i)):t(inds(i)+1)-1);
    alltrials=cat(3,alltrials,CutDown(section,lseg,'npoint'));
end

end

