function [outarg] = Discr_CMspec(CMall,mode)
% CMall: 1*N cell, where N is the number of subjects
% CMall{i}: nchan*nchan*Ntrial array, all CMs belonging to subject i
% nchan: total number of channels; Ntrail: total number of trials, each associated with a CM
% mode: in accordance with types of norm as defined by norm(), 'svd' for 2-norm, F for Frobenius norm
% ??? if mode is 'elementwise', outarg is a matrix of discriminability for each element in CM
% otherwise outarg is a scalar in [0,1]
%   calculate discriminability for CM sets only
%   can write a more general one that does basicaly the same as discr.stat in R package MGC

Ns=size(CMall,2);
Nt=zeros(Ns,1);
for i=1:Ns
    Nt(i)=size(CMall{i},3);
end
% Nc=size(CMall{1},1);
if strcmp(mode,'svd')==1
    normtype=2;
elseif strcmp(mode,'F')==1
    normtype='fro';
end
allpairs=cell(Ns,Ns);
for i=1:Ns
    for j=1:Ns
        allpairs{i,j}=zeros(Nt(i),Nt(j));
        for m=1:Nt(i)
            for n=1:Nt(j)
                allpairs{i,j}(m,n)=norm(CMall{i}(:,:,m)-CMall{j}(:,:,n),normtype);
            end
        end
    end
end
% mat_pairs=cell2mat(allpairs); % for output to be passed on to discr.stat in MGC R package
intrapool=[]; % distances between CMs that belong to the same subject 提取对角线附近的值啦...在cell里提取会比较方便
interpool=[]; % distances between CMs that belong to different subjects
for i=1:Ns
    pooli=allpairs{i,i};
    for j=1:Nt(i)
        for k=j+1:Nt(i)
            intrapool=cat(2,intrapool,pooli(j,k));
        end
    end
    for j=i+1:Ns
        poolij=allpairs{i,j};
        for m=1:Nt(i)
            for n=1:Nt(j)
                interpool=cat(2,interpool,poolij(m,n));
            end
        end
    end
end
nn=0; % numerator
nd=length(intrapool)*length(interpool); % denominator
for i=1:length(intrapool)
    obj=intrapool(i);
    comp=interpool>=obj;
    nn=nn+sum(comp,'all');
end
outarg=nn/nd;

end

