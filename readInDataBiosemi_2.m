% read in continuous data
% get powspec in continuousFreqAnalysis.m

% singlepointed
icDataDir = '/Users/roydavid/Downloads/Monks/singlepointed/components/';
cleanDataDir = '/Users/roydavid/Downloads/Monks/singlepointed/processed/';
rawDataDir = '/Users/roydavid/Downloads/Monks/singlepointed/';
fileroots = {'c278d277sm','c279d280sm','c282d281sm','c283d284sm','c285d286sm','c288d287sm','c291d292sm','c293d294sm','c296d295sm'};

% reflection
icDataDir = '/Users/roydavid/Downloads/Monks/reflection/components/';
cleanDataDir = '/Users/roydavid/Downloads/Monks/reflection/processed/';
rawDataDir = '/Users/roydavid/Downloads/Monks/reflection/';
fileroots = {'c284d283r','c286d285r','c287d288r','c292d291r','c294d293r','c295d296r'};


relevantChannels = {'1-A1','1-A2','1-A3','1-A4','1-A5','1-A6','1-A7','1-A8','1-A9','1-A10','1-A11','1-A12','1-A13','1-A14','1-A15','1-A16','1-A17','1-A18','1-A19','1-A20','1-A21','1-A22','1-A23','1-A24','1-A25','1-A26','1-A27','1-A28','1-A29','1-A30','1-A31','1-A32','1-EXG1','1-EXG2','1-EXG3','1-EXG4','1-EXG5','1-EXG6','1-EXG7','1-EXG8','2-A1','2-A2','2-A3','2-A4','2-A5','2-A6','2-A7','2-A8','2-A9','2-A10','2-A11','2-A12','2-A13','2-A14','2-A15','2-A16','2-A17','2-A18','2-A19','2-A20','2-A21','2-A22','2-A23','2-A24','2-A25','2-A26','2-A27','2-A28','2-A29','2-A30','2-A31','2-A32','2-EXG1','2-EXG2','2-EXG3','2-EXG4','2-EXG5','2-EXG6','2-EXG7','2-EXG8'};
trialDur = 15; % divide into 15 second trials
resampledRate = 256; %Hz
preStimTime = 0.5;

for f = 1:length(fileroots)
  fileroot = fileroots{f};
  % load data
  % % figure out what kinds of events there are
  cd(rawDataDir);
  cfg = [];
  cfg.dataset = [fileroot '.bdf'];
  % cfg.trialdef.eventtype = '?';
  % ft_definetrial(cfg);
  % define the data as a single trial for ICA
  % run low-pass filter to remove muscle activity
  cfg.hpfilter = 'yes';
  cfg.hpfreq = 0.5;
  cfg.hpfiltord = 3;
  cfg.lpfilter = 'yes';
  cfg.lpfreq = 45;
  cfg.lpfiltord = 3;
  cfg.continuous = 'yes';
  cfg.channel = relevantChannels;
  % get raw data 
  data_raw = ft_preprocessing(cfg);

  % resample the data to 256 Hz
  cfg = [];
  cfg.resamplefs = resampledRate;
  data_raw = ft_resampledata(cfg,data_raw);
  
  % % % read into the dataviewer
  % cfg = [];
  % cfg.viewmode = 'vertical'; % butterfly
  % cfg = ft_databrowser(cfg,data_raw);
  % keyboard
  
  % separate into the two participants to do ICA on
  cfg = [];
  cfg.channel = 1:40;
  data_subj1 = ft_selectdata(cfg,data_raw);
  cfg.channel = 41:80;
  data_subj2 = ft_selectdata(cfg,data_raw);

 % artifact detection to remove eye blinks (need to run separately
  % on subj 1 and subj 2)
  cfg = [];
  % only include the EEG channels in the component analysis (not
  % the eye channels etc)
  cfg.channel = 1:32;
  ic_dataA = ft_componentanalysis(cfg,data_subj1);
  % look at IC components in databrowser
  cfg = [];
  cfg.layout = 'biosemi32_1.lay';
  cfg.viewmode = 'component';
  cfg.continuous = 'yes';
  cfg.blocksize = 30;
  cfg.channel = 1:13;
  ft_databrowser(cfg,ic_dataA);

  % remove eyeblink components & reconstitute data for subj 1
  cfg = [];
  cfg.component = [1 ];
  % load ic components
%   cd(icDataDir)
%   load([fileroot 'ic_s1.mat']);
  fprintf('check components to remove')
  keyboard
  data_iccleanedA = ft_rejectcomponent(cfg, ic_dataA);

  % save ic components
%   cd(icDataDir)
%   outFile_s1 = [fileroot 'ic_s1.mat'];
%   save(outFile_s1,'cfg');
  
  % same for subj 2
  cfg = [];
  cfg.channel = 1:32;
  ic_dataB = ft_componentanalysis(cfg,data_subj2);
  
  cfg = [];
  cfg.layout = 'biosemi32_2.lay';
  cfg.viewmode = 'component';
  cfg.continuous = 'yes';
  cfg.blocksize = 30;
  cfg.channel = 1:13;
  ft_databrowser(cfg,ic_dataB);

  cfg = [];
  cfg.component = [1 ];
  % load ic components
%   cd(icDataDir)
%   load([fileroot 'ic_s2.mat']);
  fprintf('check components to remove')
  keyboard
  data_iccleanedB = ft_rejectcomponent(cfg, ic_dataB);

  % save ic components
%   cd(icDataDir)
%   outFile_s2 = [fileroot 'ic_s2.mat'];
%   save(outFile_s2,'cfg');
  
  % re-reference the data to the average reference
  cfg = [];
  cfg.reref = 'yes';
  cfg.refchannel = 'all';
  data_iccleanedAreref = ft_preprocessing(cfg,data_iccleanedA);
  data_iccleanedBreref = ft_preprocessing(cfg,data_iccleanedB);  
  
  
  % define events every trialDur seconds
  cfg = [];
  trialDurSamples = fix(trialDur*resampledRate);
  preStimTimeSamples = fix(preStimTime*resampledRate);
  startTrial = 1:trialDurSamples:length(data_iccleanedAreref.time{1});
  endTrial = startTrial-1; endTrial = endTrial(2:end);
  endTrial = [endTrial length(data_iccleanedAreref.time{1})];
  endTrial = endTrial+2*preStimTimeSamples;
  preStim = -preStimTimeSamples*ones(size(startTrial));
  trl = [startTrial' endTrial' preStim'];
 
  cfg = [];
  cfg.trl = trl;
  data_iccleanedA = ft_redefinetrial(cfg,data_iccleanedAreref);
  cfg = [];
  cfg.trl = trl;  
  data_iccleanedB = ft_redefinetrial(cfg,data_iccleanedBreref);
  
  % save the data
  cd(cleanDataDir);
%   outFile = [fileroot 'clean.mat'];
  outFile = [fileroot 'clean' int2str(trialDur) 's.mat'];
  keyboard
  save(outFile,'data_iccleanedA','data_iccleanedB');
  
end % loop over participants
