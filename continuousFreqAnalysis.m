% get powerspectrum (log10)
% regression analysis in eegMonksResults.rmd
% or collect avg power over time per condition collAvgPowCond.m
% for topoplots

datadir = '/Users/roydavid/Downloads/Monks/';
cleanDataDir = '/Users/roydavid/Downloads/Monks/within/';
statdir = '/Users/roydavid/Downloads/Monks/stats/';
powdir = '/Users/roydavid/Downloads/Monks/powspec/';

fileroots = {'c284d283h','c286d285h','c287d288h','c292d291h','c294d293h','c295d296h',...
    'c284d283e','c286d285e','c287d288e','c292d291e','c294d293e','c295d296e',...
    'c284d283r','c286d285r','c287d288r','c292d291r','c294d293r','c295d296r',...
    'c283d284sm','c285d286sm','c288d287sm','c291d292sm','c293d294sm','c296d295sm'};

% mid-frontal theta; Fz = 31 (31+32)
% chanOI = [31 63];
freqOI = 4:9;
freqName = "Theta";

% mid-occipital alpha; Oz = 16 (16+32)
% chanOI = [16 48];
% freqOI = 9:14;
% freqName = "Alpha";

trialDur = 15;
Nchannels = 32;

Nfiles = length(fileroots);

outMat = [];

for c=1:Nchannels
    for f = 1:length(fileroots)
        fprintf('%d of %d\n',f,Nfiles);
        % load data
        fileroot = fileroots{f};
        if length(fileroot) == 9
            condition = fileroot(end);
        elseif length(fileroot) == 10
            condition = fileroot(end-1:end);
        else
            fprintf('check file: %d',fileroot);
        end
        % code conditions: hard=1,easy=2,reflection=3,singlepointed=4
        if condition == 'h'
            cond = 1;
        elseif condition == 'e'
            cond = 2;
        elseif condition == 'r'
            cond = 3;
        elseif condition == "sm"
            cond = 4;
        end
        
        load([cleanDataDir fileroot 'clean' int2str(trialDur) 's.mat']);
        
        % recombine the cleaned data 
        cfg = [];
        combData = ft_appenddata(cfg,data_iccleanedA,data_iccleanedB);
        
        % frequency analyses
        cfg = [];
        cfg.method     = 'mtmfft';
        cfg.taper      = 'hanning';
        cfg.foi     = freqOI;
        cfg.channel = 'all';
        cfg.keeptrials = 'yes';
        freq = ft_freqanalysis(cfg, combData);

%         load([powdir fileroot 'AlphaAll_freq.mat']);
%         load([powdir thisfile 'ThethaAll_freq.mat']);
        
        powspec = squeeze(nanmean(freq.powspctrm,4));
        % powspec = permute(powspec,[2 3 1]);
    %     save([powdir fileroot freqName 'All_freq.mat'],'freq','powspec');
        
        % setup time and power
        Ntrials = size(freq.powspctrm,1);
        timeVec  = 0:trialDur:(Ntrials*trialDur); timeVec = timeVec(1:(end-1));
        timeVec = timeVec/60;
        Pow1 = squeeze(nanmean(log10(powspec(:,c,:)),3));
        Pow2 = squeeze(nanmean(log10(powspec(:,c+32,:)),3));
        
        % linear regress
        % https://nl.mathworks.com/help/stats/regress.html
%         b1 = regress(Pow1,[ones(size(timeVec')) timeVec']);
%         b2 = regress(Pow2,[ones(size(timeVec')) timeVec']);
%         save([statdir fileroot int2str(chanOI(1)) '_stats.mat'], "b1", "b2");
        
%         subjects = [fileroot(1:4) fileroot(5:8)];

        chann = repelem(c,length(timeVec))';
        
        subj1 = repelem({fileroot(2:4)},length(timeVec)); subj1 = str2double(subj1)';
        subj2 = repelem({fileroot(6:8)},length(timeVec)); subj2 = str2double(subj2)';
        
        cond = repelem(cond,length(timeVec))';
        
        MatS1 = [subj1 cond chann Pow1 timeVec'];
        MatS2 = [subj2 cond chann Pow2 timeVec'];
        outMat = [outMat; MatS1; MatS2];
        
    end
end
% write output matrix to file
% writematrix(outMat,[datadir 'powSpecAllChannelsAlpha.csv'])
writematrix(outMat,[datadir 'powSpecAllChannelsTheta.csv'])

