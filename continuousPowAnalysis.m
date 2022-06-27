% t test for slope across conditions

datadir = '/Users/roydavid/Downloads/Monks/';
statsdir = '/Users/roydavid/Downloads/Monks/stats/';

fileroots = {'c284d283h','c286d285h','c287d288h','c292d291h','c294d293h','c295d296h',...
    'c284d283e','c286d285e','c287d288e','c292d291e','c294d293e','c295d296e',...
    'c284d283r','c286d285r','c287d288r','c292d291r','c294d293r','c295d296r',...
    'c283d284sm','c285d286sm','c288d287sm','c291d292sm','c293d294sm','c296d295sm',...
    };

chanSlopes = zeros(length(fileroots),2);

trialDur = 15;
Nfiles = length(fileroots);

% frontal theta; Fz = 31 (31+32)
chanOI = [31 63];
freqOI = 4:9;
% occipital alpha; Oz = 16 (16+32)
% chanOI = [16 48];
% freqOI = 9:13;

for f = 1:length(fileroots)
% f = 1;
    fprintf('%d of %d\n',f,Nfiles);
    % load data
    fileroot = fileroots{f};
    
    % load regress
    load([statsdir fileroot int2str(chanOI(1)) '_stats.mat']);

    chanSlopes(f,1) = b1(2);
    chanSlopes(f,2) = b2(2);
    
end

% reshape
chanSlopesHard = [chanSlopes(1:6,1); chanSlopes(1:6,2)];
chanSlopesEasy = [chanSlopes(7:12,1); chanSlopes(7:12,2)];
chanSlopesRefl = [chanSlopes(13:18,1); chanSlopes(13:18,2)];
chanSlopesSing = [chanSlopes(19:24,1); chanSlopes(19:24,2)];
% save([datadir 'slopes' int2str(chanOI(1)) '.mat'],'chanSlopesHard',"chanSlopesSing","chanSlopesRefl","chanSlopesEasy")

outMat = [chanSlopesHard chanSlopesEasy chanSlopesRefl chanSlopesSing];
writematrix(outMat,[datadir 'slopesAll' int2str(chanOI(1)) '.csv'])

chanSlopes = [chanSlopes(:,1); chanSlopes(:,2)];
writematrix(chanSlopes,[datadir 'allSlopes' int2str(chanOI(1)) '.csv'])

% paired t tests Fz theta
% slopes of condition are not different from each other
[h,p,ci,stats] = ttest(chanSlopesHard,chanSlopesEasy) 
% h=0
% p=0.7053
% tstat: -0.3882
%        df: 11
%        sd: 0.0236
[h,p,ci,stats] = ttest(chanSlopesHard,chanSlopesRefl)
% h=0
% p=0.9718
% tstat: 0.0362
%        df: 11
%        sd: 0.0591
[h,p,ci,stats] = ttest(chanSlopesHard,chanSlopesSing)
% h=0
% p=0.6422
% tstat: 0.4777
%        df: 11
%        sd: 0.0540
[h,p,ci,stats] = ttest(chanSlopesRefl,chanSlopesEasy)
% h=0
% p=0.8630
% tstat: -0.1766
%        df: 11
%        sd: 0.0640
[h,p,ci,stats] = ttest(chanSlopesSing,chanSlopesEasy)
% h=0
% p=0.5168
% tstat: -0.6697
%        df: 11
%        sd: 0.0522
[h,p,ci,stats] = ttest(chanSlopesRefl,chanSlopesSing)
% h=0
% p=0.8058
% tstat: 0.2518
%        df: 11
%        sd: 0.0940

% test whether across everything, theta slopes are positive
[h,p,ci,stats] = ttest(chanSlopes(:),0,'tail','right')
% h=0
% p=0.3871
% tstat: 0.2885
%        df: 47
%        sd: 0.0390




% paired t tests Oz alpha
% slopes of condition are not different from each other
[h,p,ci,stats] = ttest(chanSlopesHard,chanSlopesEasy) 
% h=0
% p=0.6326
% tstat: 0.4917
%        df: 11
%        sd: 0.0257
[h,p,ci,stats] = ttest(chanSlopesHard,chanSlopesRefl)
% h=0
% p=0.5555
% tstat: -0.6080
%        df: 11
%        sd: 0.0394
[h,p,ci,stats] = ttest(chanSlopesHard,chanSlopesSing)
% h=0
% p=0.3028
% tstat: 1.0810
%        df: 11
%        sd: 0.0469
[h,p,ci,stats] = ttest(chanSlopesRefl,chanSlopesEasy)
% h=0
% p=0.2720
% tstat: 1.1566
%        df: 11
%        sd: 0.0316
[h,p,ci,stats] = ttest(chanSlopesSing,chanSlopesEasy)
% h=0
% p=0.4548
% tstat: -0.7748
%        df: 11
%        sd: 0.0492
[h,p,ci,stats] = ttest(chanSlopesRefl,chanSlopesSing)
% h=0
% p=0.2051
% tstat: 1.3469
%        df: 11
%        sd: 0.0554

% test whether across everything, theta slopes are positive
[h,p,ci,stats] = ttest(chanSlopes(:),0,'tail','right')
% h=0
% p=0.2849
% tstat: 0.5724
%        df: 47
%        sd: 0.0319
