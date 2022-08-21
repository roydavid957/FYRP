% for each channel collect avg power over time per condition per debate per subject
% then ttest vs conditions
% topoplot it in topoplotAllAlpha.m

datadir = '/Users/roydavid/Downloads/Monks/';
cleanDataDir = '/Users/roydavid/Downloads/Monks/within/';
statsdir = '/Users/roydavid/Downloads/Monks/stats/';
powdir = '/Users/roydavid/Downloads/Monks/powspec/';
figdir = '/Users/roydavid/Documents/FYRP/latex/figs/';

fileroots = {'c284d283h','c286d285h','c287d288h','c292d291h','c294d293h','c295d296h',...
     'c284d283e','c286d285e','c287d288e','c292d291e','c294d293e','c295d296e',...
     'c284d283r','c286d285r','c287d288r','c292d291r','c294d293r','c295d296r',...
     'c283d284sm','c285d286sm','c288d287sm','c291d292sm','c293d294sm','c296d295sm'...
    };

Nchannels = 32;
Nsubj = length(fileroots)*2;

isHard = nan(length(fileroots),64);
isEasy = nan(length(fileroots),64);
isRefl = nan(length(fileroots),64);
isSingl = nan(length(fileroots),64);

for f = 1:length(fileroots)
  fileroots{f}
  thisfile = fileroots{f};
  load([powdir thisfile 'AlphaAll_freq.mat']);
  % avg pow over time 2 subj
%   powAll = rmmissing(squeeze(nanmean(log10(powspec(:,:,:)),3)));
  powAll = mean(rmmissing(squeeze(nanmean(log10(powspec(:,:,:)),3))));
  if thisfile(end) == 'h'
      isHard(f,:) = powAll;
  elseif thisfile(end) == 'e'
      isEasy(f,:) = powAll;
  elseif thisfile(end) == 'r'
      isRefl(f,:) = powAll;
  elseif thisfile(end) == 'm'
      isSingl(f,:) = powAll;
  end

end

% avg pow per channel per condition per debate
avgHard = rmmissing(isHard);
avgEasy = rmmissing(isEasy);
avgRefl = rmmissing(isRefl);
avgSingl = rmmissing(isSingl);

% collapse to 32 channels
avgHard32 = [avgHard(1:32);avgHard(33:64)];
avgEasy32 = [avgEasy(1:32);avgEasy(33:64)];
avgRefl32 = [avgRefl(1:32);avgRefl(33:64)];
avgSingl32 = [avgSingl(1:32);avgSingl(33:64)];

% prepare p, t value collection per channel
pvalsHardEasy = zeros(Nchannels,1); tsHardEasy = zeros(Nchannels,1); dfHE=zeros(Nchannels,1);
pvalsHardRefl = zeros(Nchannels,1); tsHardRefl = zeros(Nchannels,1); dfHR=zeros(Nchannels,1);
pvalsHardSingl = zeros(Nchannels,1); tsHardSingl = zeros(Nchannels,1); dfHS=zeros(Nchannels,1);

pvalsReflEasy = zeros(Nchannels,1); tsReflEasy = zeros(Nchannels,1); dfRE=zeros(Nchannels,1);
pvalsSinglEasy = zeros(Nchannels,1); tsSinglEasy = zeros(Nchannels,1); dfSE=zeros(Nchannels,1);

pvalsReflSingl = zeros(Nchannels,1); tsReflSingl = zeros(Nchannels,1); dfRS=zeros(Nchannels,1);
for c=1:Nchannels
%     [h,p,ci,stats] = ttest(avgHard32(:,c),avgEasy32(:,c));
    [h,p,ci,stats] = ttest(avgHard(:,c),avgEasy(:,c));
    pvalsHardEasy(c) = p; tsHardEasy(c) = stats.tstat; dfHE=stats.df;
%     [h,p,ci,stats] = ttest(avgHard32(:,c),avgRefl32(:,c));
    [h,p,ci,stats] = ttest(avgHard(:,c),avgRefl(:,c));
    pvalsHardRefl(c) = p; tsHardRefl(c) = stats.tstat; dfHR=stats.df;
%     [h,p,ci,stats] = ttest(avgHard32(:,c),avgSingl32(:,c));
    [h,p,ci,stats] = ttest(avgHard(:,c),avgSingl(:,c));
    pvalsHardSingl(c) = p; tsHardSingl(c) = stats.tstat; dfHS=stats.df;

%     [h,p,ci,stats] = ttest(avgRefl32(:,c),avgEasy32(:,c));
    [h,p,ci,stats] = ttest(avgRefl(:,c),avgEasy(:,c));
    pvalsReflEasy(c) = p; tsReflEasy(c) = stats.tstat; dfRE=stats.df;
%     [h,p,ci,stats] = ttest(avgSingl32(:,c),avgEasy32(:,c));
    [h,p,ci,stats] = ttest(avgSingl(:,c),avgEasy(:,c));
    pvalsSinglEasy(c) = p; tsSinglEasy(c) = stats.tstat; dfSE=stats.df;

%     [h,p,ci,stats] = ttest(avgRefl32(:,c),avgSingl32(:,c));
    [h,p,ci,stats] = ttest(avgRefl(:,c),avgSingl(:,c));
    pvalsReflSingl(c) = p; tsReflSingl(c) = stats.tstat; dfRS=stats.df;
end
% save avg ttest stats
% save([statsdir 'avgAlphaAll_ttests.mat'],'pvalsHardEasy','tsHardEasy','pvalsHardRefl','tsHardRefl','pvalsHardSingl','tsHardSingl','pvalsReflEasy','tsReflEasy','pvalsSinglEasy','tsSinglEasy','pvalsReflSingl','tsReflSingl')
save([statsdir 'avgAlphaAll_ttests2.mat'],'pvalsHardEasy','tsHardEasy','pvalsHardRefl','tsHardRefl','pvalsHardSingl','tsHardSingl','pvalsReflEasy','tsReflEasy','pvalsSinglEasy','tsSinglEasy','pvalsReflSingl','tsReflSingl','dfHE','dfHR','dfHS','dfRE','dfSE','dfRS')

