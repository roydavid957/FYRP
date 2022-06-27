% redefine trials based on trialDur

% easy
cleanDataDir = '/Users/roydavid/Downloads/Monks/easy/processed/';
fileroots = {'c273d274e','c274d273e','c275d276e','c276d275e','c277d278e','c278d277e','c279d280e','c280d279e','c281d282e','c282d281e','c283d284e','c284d283e','c285d286e','c286d285e','c287d288e','c288d287e','c289d290e','c291d292e','c292d291e','c293d294e','c294d293e','c295d296e','c296d295e'};
fileroots = {'c284d283e','c286d285e','c287d288e','c292d291e','c294d293e','c295d296e'};  % within

% hard
% cleanDataDir = '/Users/roydavid/Downloads/Monks/hard/processed/';
% fileroots = {'c273d274h','c274d273h','c276d275h','c277d278h','c278d277h','c279d280h','c280d279h','c281d282h','c282d281h','c283d284h','c284d283h','c285d286h','c286d285h','c287d288h','c288d287h','c289d290h','c290d289h','c291d292h','c292d291h','c293d294h','c294d293h','c295d296h','c296d295h'};
% fileroots = {'c284d283h','c286d285h','c287d288h','c292d291h','c294d293h','c295d296h'};  % within

% singlepointed
% cleanDataDir = '/Users/roydavid/Downloads/Monks/singlepointed/processed/';
% fileroots = {'c278d277sm','c279d280sm','c282d281sm','c283d284sm','c285d286sm','c288d287sm','c291d292sm','c293d294sm','c296d295sm'};
% fileroots = {'c283d284sm','c285d286sm','c288d287sm','c291d292sm','c293d294sm','c296d295sm'};  % within


% reflection
% cleanDataDir = '/Users/roydavid/Downloads/Monks/reflection/processed/';
% fileroots = {'c284d283r','c286d285r','c287d288r','c292d291r','c294d293r','c295d296r'};

% divide into n second trials
trialDur = 15;
resampledRate = 256; %Hz
preStimTime = 0.5;

for f = 1:length(fileroots)
    % load data
    fileroot = fileroots{f};
    cd(cleanDataDir);
    load([fileroot 'clean.mat']);
    
    % redefine to continous
    cfg = [];
    cfg.continuous = 'yes';
    data_iccleanedACont = ft_redefinetrial(cfg,data_iccleanedA);
    cfg = [];
    cfg.continuous = 'yes';
    data_iccleanedBCont = ft_redefinetrial(cfg,data_iccleanedB);
    
    % define events every trialDur seconds
    cfg = [];
    trialDurSamples = fix(trialDur*resampledRate);
    preStimTimeSamples = fix(preStimTime*resampledRate);
    startTrial = 1:trialDurSamples:length(data_iccleanedACont.time{1});
    endTrial = startTrial-1; endTrial = endTrial(2:end);
    endTrial = [endTrial length(data_iccleanedACont.time{1})];
    endTrial = endTrial+2*preStimTimeSamples;
    preStim = -preStimTimeSamples*ones(size(startTrial));
    trl = [startTrial' endTrial' preStim'];
    
    cfg = [];
    cfg.trl = trl;
    data_iccleanedA = ft_redefinetrial(cfg,data_iccleanedACont);
    cfg = [];
    cfg.trl = trl;  
    data_iccleanedB = ft_redefinetrial(cfg,data_iccleanedBCont);
    
    % save the data
    cd(cleanDataDir);
    outFile = [fileroot 'clean' int2str(trialDur) 's.mat'];
    save(outFile,'data_iccleanedA','data_iccleanedB');
end