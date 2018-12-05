clear; clc;
%%
load('alltrials.mat'); % available in linked Google drive (file too large to upload to Github)
spr=500;
CMall=cell(1,5);
idset=[5,6,8,9,10];
for i=1:5
    data=eval(['trials',num2str(idset(i))]);
    CMall{i}=[];
    for j=1:size(data,3)
        obj=squeeze(data(:,:,j));
        [cm,fcm]=CoherenceMatrix(obj,[0,spr/2],chebwin(300),[],[],spr);
        CMall{i}=cat(4,CMall{i},cm);
    end
end

%% alpha coherence with variant thresholds
CMalpha=cell(size(CMall));
Ns=length(CMalpha);
Nt=zeros(Ns,1);
for i=1:Ns
    CMalpha{i}=mean(CMall{i}(:,:,10:13,:),3);
    CMalpha{i}=squeeze(CMalpha{i});
    Nt(i)=size(CMalpha{i},3);
end
r=linspace(0,1,100);
Dr=zeros(size(r));
for ir=1:length(r)
    CMr=CMalpha;
    for i=1:Ns
        for j=1:Nt(i)
            CMr{i}(:,:,j)=thresh(CMalpha{i}(:,:,j),[r(ir),1]); % some issue with r=0 because by definition Dr will jump to 1
        end
    end
    Dr(ir)=Discr_CMspec(CMr,'F');
end
figure;plot(r,Dr,'.','MarkerSize',8);
xlabel('Threshold r'); ylabel('Discriminability'); title('Effect of binaryzation');
D0=Discr_CMspec(CMalpha,'F');
hline=refline(0,D0);
hline.Color='r';
legend('thresholding','no threshold','Location','Southeast');

%% coherence-based discrinimability at different frequencies
Nf=length(fcm);
Ns=size(CMall,2);
Df=zeros(1,Nf);
for i=1:Nf
    CMf=cell(1,Ns);
    for k=1:Ns
        CMf{k}=squeeze(CMall{k}(:,:,i,:));
    end
    Df(i)=Discr_CMspec(CMf,'F');
end
figure; 
plot(fcm,Df,'.','MarkerSize',8); axis([0,50,0.86,1]); hold on;
xlabel('Frequency/Hz'); ylabel('Discriminability');
title('Discriminability at different frequencies');
xfill=[fcm(10);fcm(13);fcm(13);fcm(10)]; yfill=[1;1;0;0];
fill(xfill,yfill,[0.9,0.9,0.9],'EdgeColor','none','FaceAlpha',0.5);
yline(D0,'r');

%% enlarge subject set
SampleID={'1_NDARAA075AMK','2_NDARCG984YXZ','4_NDARHR753ZKU','5_NDARFN452VPC',...
    '6_NDARET632ELD','7_NDARAP359UM6','8_NDARLH979WFX','9_NDARRD720XZK','10_NDAREC182WW2',...
    '11_NDARKE331EHD','12_NDARAJ366ZFA','13_NDARAM277WZT','14_NDARAM704GKZ','15_NDARAG143ARJ',...
    '17_NDARPM105MKA','18_NDARAN385MDH','19_NDARAK653RYE','20_NDAREU551GPC','21_NDARMM782KJK',...
    '22_NDARFM080VAF','23_NDARPX155RF3','24_NDAREX091KUR'};
Ns=length(SampleID);
Data=cell(Ns,2);
% maximal unusable channels:[1,8,14,20,24,31] (for above 22 subjects)
remove=[1,8,14,20,24,31]; 
% to detect unusable channels for each subject, set remove to 'auto'
for i=1:Ns
    filename=['.\10samples\MoreSamples\',SampleID{i},'\RestingState.mat'];
    [Data{i,1},Data{i,2}]=ReadData(filename,remove,'closed',2000);
end

%% Data to CM
spr=500;
CMall=cell(1,Ns);
for i=1:Ns
    CMall{i}=[];
    for j=1:size(Data{i,1},3)
        obj=squeeze(Data{i,1}(:,:,j));
        [cm,fcm]=CoherenceMatrix(obj,[0,spr/2],chebwin(300),[],[],spr);
        cmalpha=mean(cm(:,:,10:13),3);
        CMall{i}=cat(3,CMall{i},cmalpha);
    end
end

%% discriminability (alpha coherence) as increasing #subject
Nx=2:Ns;
Dn=zeros(1,Ns-1);
rng('shuffle');
for i=2:Ns
    ind=randperm(Ns,i); % select i random subjects
    CMsub=cell(1,i);
    for j=1:i
        CMsub{j}=CMall{ind(j)};
    end
    Dn(i-1)=Discr_CMspec(CMsub,'F');
end
figure; plot(Nx,Dn,'.','MarkerSize',18);




