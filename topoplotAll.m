% plot the results from collAvgPowCond.Rmd

datadir = '/Users/roydavid/Downloads/Monks/';
cleanDataDir = '/Users/roydavid/Downloads/Monks/within/';
statsdir = '/Users/roydavid/Downloads/Monks/stats/';
powdir = '/Users/roydavid/Downloads/Monks/powspec/';
figdir = '/Users/roydavid/Documents/FYRP/latex/figs/';

fileroots = {'c284d283h','c286d285h','c287d288h','c292d291h','c294d293h','c295d296h',...
%     'c284d283e','c286d285e','c287d288e','c292d291e','c294d293e','c295d296e',...
%     'c284d283r','c286d285r','c287d288r','c292d291r','c294d293r','c295d296r',...
%     'c283d284sm','c285d286sm','c288d287sm','c291d292sm','c293d294sm','c296d295sm',...
    };
labels = {'Fp1','AF3','F7','F3','FC1','FC5','T7','C3','CP1','CP5','P7','P3','Pz','PO3','O1','Oz','O2','PO4','P4','P8','CP6','CP2','C4','T8','FC6','FC2','F4','F8','AF4','Fp2','Fz','Cz'};

Nfiles = length(fileroots);
trialDur = 15;

pthresh = 0.05;
plow = 0.01; phigh=0.1;

f=1;
% fprintf('%d of %d\n',f,Nfiles);
fileroot = fileroots{f}
% load([statsdir fileroot 'AlphaAll_stats.mat']);
% load([statsdir 'avgAlphaAll_ttests.mat']);
load([statsdir 'avgAlphaAll_ttests2.mat']); % avg pow/time/condition/subject w/ df
load([powdir fileroot 'AlphaAll_freq.mat']);
Ntrials = size(freq.powspctrm,1);
timeVec  = 0:trialDur:(Ntrials*trialDur); timeVec = timeVec(1:(end-1));
timeVec = timeVec/60;
freq.powspctrm = permute(freq.powspctrm,[2 1 3]);

% figure(1)
data = []; data.dimord = 'chan_time';
% data.avg = -norminv(stats(:,2));

pvals = {pvalsHardEasy,pvalsHardRefl,pvalsHardSingl,...
    pvalsReflEasy,pvalsSinglEasy,...
    pvalsReflSingl,...
    };

cfg =[];

data.avg = -norminv(pvalsHardEasy); cfg.title = 'Hard vs Easy';
% data.avg = -norminv(pvalsHardRefl); cfg.title = 'Hard vs Reflection';
% data.avg = -norminv(pvalsHardSingl); cfg.title = 'Hard vs Singlepointed';

% data.avg = -norminv(pvalsReflEasy); cfg.title = 'Reflection vs Easy';
% data.avg = -norminv(pvalsSinglEasy); cfg.title = 'Singlepointed vs Easy';

% data.avg = -norminv(pvalsReflSingl); cfg.title = 'Reflection vs Singlepointed';

data.time = 1;
% data.label = freq.cfg.channel(1:32);
data.label = labels;
cfg.parameter = 'avg';
cfg.colorbar = 'East';
% cfg.xlim = [1 1];
cfg.zlim = [-norminv(phigh) -norminv(plow)];
cfg.layout = 'EEG1005.lay';
cfg.marker = 'labels';
cfg.markerfontsize = 14;
cfg.zlabel = 'inverse-normal p value';
ft_topoplotER(cfg,data);
% adjust the colorbar
hC = get(gcf,'Children');
set(hC(2),'FontSize',15);
set(hC(2),'Position',[0.9 0.1336 0.0357 0.7674]);

[minp,minPind] = min(pvalsHardEasy);
fprintf('HE: ttest(%i): %.02f (p=%.02f) at %i\n',dfHE,tsHardEasy(minPind,1),minp,minPind);
[minp,minPind] = min(pvalsHardRefl);
fprintf('HR: ttest(%i): %.02f (p=%.02f) at %i\n',dfHR,tsHardRefl(minPind,1),minp,minPind);
[minp,minPind] = min(pvalsHardSingl);
fprintf('HS: ttest(%i): %.02f (p=%.02f) at %i\n',dfHS,tsHardSingl(minPind,1),minp,minPind);

[minp,minPind] = min(pvalsReflEasy);
fprintf('RE: ttest(%i): %.02f (p=%.02f) at %i\n',dfRE,tsReflEasy(minPind,1),minp,minPind);
[minp,minPind] = min(pvalsSinglEasy);
fprintf('SE: ttest(%i): %.02f (p=%.02f) at %i\n',dfSE,tsSinglEasy(minPind,1),minp,minPind);

[minp,minPind] = min(pvalsReflSingl);
fprintf('RS: ttest(%i): %.02f (p=%.02f) at %i',dfRS,tsReflSingl(minPind,1),minp,minPind);

fprintf('\nsignificant channel per condition:\n')
for f = 1:length(pvals)
    for p = 1:length(pvalsHardSingl)
        if f==1
            if pvalsHardEasy(p) <= 0.05
                fprintf('HE: ttest(%i): %.02f (p=%.02f) at %s\n',dfHE,tsHardEasy(p),pvalsHardEasy(p),string(labels(p)));
            end
        elseif f==2
            if pvalsHardRefl(p) <= 0.05
                fprintf('HR: ttest(%i): %.02f (p=%.02f) at %s\n',dfHR,tsHardRefl(p),pvalsHardRefl(p),string(labels(p)));
            end
        elseif f==3
            if pvalsHardSingl(p) <= 0.05
                fprintf('HS: ttest(%i): %.02f (p=%.02f) at %s\n',dfHS,tsHardSingl(p),pvalsHardSingl(p),string(labels(p)));
            end
        elseif f==4
            if pvalsReflEasy(p) <= 0.05
                fprintf('RE: ttest(%i): %.02f (p=%.02f) at %s\n',dfRE,tsReflEasy(p),pvalsReflEasy(p),string(labels(p)));
            end
        elseif f==5
            if pvalsSinglEasy(p) <= 0.05
                fprintf('SE: ttest(%i): %.02f (p=%.02f) at %s\n',dfSE,tsSinglEasy(p),pvalsSinglEasy(p),string(labels(p)));
            end
        elseif f==6
            if pvalsReflSingl(p) <= 0.05
                fprintf('RS: ttest(%i): %.02f (p=%.02f) at %s\n',dfRS,tsReflSingl(p),pvalsReflSingl(p),string(labels(p)));
            end
        end
    end
end


