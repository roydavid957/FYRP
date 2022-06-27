% get powerspectrum (log10) and regression statistics
% https://www.fieldtriptoolbox.org/faq/how_can_i_do_time-frequency_analysis_on_continuous_data/
% https://www.fieldtriptoolbox.org/tutorial/plotting/#singleplot-functions

datadir = '/Users/roydavid/Downloads/Monks/';
cleanDataDir = '/Users/roydavid/Downloads/Monks/within';
statdir = '/Users/roydavid/Downloads/Monks/stats/';
powdir = '/Users/roydavid/Downloads/Monks/powspec/';

fileroots = {'c284d283h','c286d285h','c287d288h','c292d291h','c294d293h','c295d296h',...
    'c284d283e','c286d285e','c287d288e','c292d291e','c294d293e','c295d296e',...
    'c284d283r','c286d285r','c287d288r','c292d291r','c294d293r','c295d296r',...
    'c283d284sm','c285d286sm','c288d287sm','c291d292sm','c293d294sm','c296d295sm'};

% frontal theta; Fz = 31 (31+32)
chanOI = [31 63];
freqOI = 4:9;

% occipital alpha; Oz = 16 (16+32)
% chanOI = [16 48];
% freqOI = 9:13;

trialDur = 15;

Nfiles = length(fileroots);

outMat = [];

for f = 1:length(fileroots)
    fprintf('%d of %d\n',f,Nfiles);
    % load data
%     f = 1;
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
    else
        fprintf('check condition: %d',condition);
    end
    
    cd(cleanDataDir);
    % load([fileroot 'clean.mat']);
    load([fileroot 'clean' int2str(trialDur) 's.mat']);
    
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
    
    powspec = squeeze(nanmean(freq.powspctrm,4));
    % powspec = permute(powspec,[2 3 1]);
%     save([powdir fileroot '_freq.mat'],'freq','powspec');
    save([powdir fileroot int2str(chanOI(1)) '_freq.mat'],'freq','powspec');
    
    % setup time and power
    Ntrials = size(freq.powspctrm,1);
    timeVec  = 0:trialDur:(Ntrials*trialDur); timeVec = timeVec(1:(end-1));
    timeVec = timeVec/60;
    thetaPow1 = squeeze(nanmean(log10(powspec(:,chanOI(1),:)),3));
    thetaPow2 = squeeze(nanmean(log10(powspec(:,chanOI(2),:)),3));
    
    % linear regress
    % https://nl.mathworks.com/help/stats/regress.html
    b1 = regress(thetaPow1,[ones(size(timeVec')) timeVec']);
    b2 = regress(thetaPow2,[ones(size(timeVec')) timeVec']);
    save([statdir fileroot int2str(chanOI(1)) '_stats.mat'], "b1", "b2");
    
    subjects = [fileroot(1:4) fileroot(5:8)];
    % code challenger, defender: 1,0
    if fileroot(1)=='c'
        m1 = 1;
    elseif fileroot(1)=='d'
        m1 = 0;
    else
        fprintf('check fileroot(1): %d',fileroot)
    end
    if fileroot(5)=='c'
        m2 = 1;
    elseif fileroot(5)=='d'
        m2 = 0;
    else
        fprintf('check fileroot(5): %d',fileroot)
    end
    
    mode1 = repelem(m1,length(timeVec))';
    mode2 = repelem(m2,length(timeVec))';
    
    subj1 = repelem({fileroot(2:4)},length(timeVec)); subj1 = str2double(subj1)';
    subj2 = repelem({fileroot(6:8)},length(timeVec)); subj2 = str2double(subj2)';
    
    cond = repelem(cond,length(timeVec))';
    
    MatS1 = [subj1 mode1 cond thetaPow1 timeVec'];
    MatS2 = [subj2 mode2 cond thetaPow2 timeVec'];
    outMat = [outMat; MatS1; MatS2];
    
end

% write output matrix to file
writematrix(outMat,[datadir 'powSpecAll' int2str(chanOI(1)) '.csv'])

