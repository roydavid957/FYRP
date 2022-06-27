% plot all conditions (regression) per subject

figdir = '/Users/roydavid/Documents/FYRP/';
datadir = '/Users/roydavid/Downloads/Monks/powspec/';

fileroots = {'c284d283h',...'c286d285h','c287d288h','c292d291h','c294d293h','c295d296h',...
    'c284d283e',...'c286d285e','c287d288e','c292d291e','c294d293e','c295d296e',...
    'c284d283r',...'c286d285r','c287d288r','c292d291r','c294d293r','c295d296r',...
    'c283d284sm',...'c285d286sm','c288d287sm','c291d292sm','c293d294sm','c296d295sm',...
    };

% frontal theta; Fz = 31 (31+32)
chanOI = [31 63];
freqOI = 4:9;

% occipital alpha; Oz = 16 (16+32)
% chanOI = [16 48];
% freqOI = 9:13;

trialDur = 15;

Nfiles = length(fileroots);


AllPow = [];
AllXe = [];
AllYfit = [];
AllDelta = [];

for f = 1:length(fileroots)
%     f = 1;
    fprintf('%d of %d\n',f,Nfiles);
    % load data
    fileroot = fileroots{f};
    
    % load frequency analyses
    load([datadir fileroot '_freq.mat']);
    load([datadir fileroot int2str(chanOI(1)) '_freq.mat']);
    
    % plot frontal theta; Fz = 31 (31+32)
    Ntrials = size(freq.powspctrm,1);
    timeVec  = 0:trialDur:(Ntrials*trialDur); timeVec = timeVec(1:(end-1));
    timeVec = timeVec/60;
    Pow1 = squeeze(nanmean(log10(powspec(:,chanOI(1),:)),3));
    Pow2 = squeeze(nanmean(log10(powspec(:,chanOI(2),:)),3));

    Pow1 = Pow1(1:20,:);
    AllPow(:,f) = Pow1;

    timeVec = timeVec(:,1:20);

    % regression coeff with degree
    % https://nl.mathworks.com/help/matlab/ref/polyval.html
    n = 1;  % degree
    % subj1
    nanx1 = prod(isfinite(Pow1),2);
    xe1 = Pow1(nanx1 == 1,:);
    [b1,slope1] = polyfit(timeVec', xe1, n);
    [y_fit1,delta1] = polyval(b1,timeVec',slope1);

    AllXe(:,f) = xe1;
    AllYfit(:,f) = y_fit1;
    AllDelta(:,f) = delta1;

end

% power over time per subj
figure;
hold on
plot(timeVec,AllPow(:,1),'LineWidth',2);
plot(timeVec,AllPow(:,2),'LineWidth',2);
plot(timeVec,AllPow(:,3),'LineWidth',2);
plot(timeVec,AllPow(:,4),'LineWidth',2);
hold off
xlabel('time (min)');
ylabel(['power (log10) ' int2str(chanOI(1))]);
title('Power over time')
legend('hard','easy','reflection','singlepointed')
% publishfig
%     saveas(gcf,[figdir 'thetaByTimeCheck_' fileroot '.fig']);

% plot regression line, with 95% CI
% subj1
figure;
hold on

plot(timeVec',AllXe(:,1),'o','Color','#0072BD')
plot(timeVec',AllYfit(:,1),'Color','#0072BD','LineWidth',3)
plot(timeVec',AllYfit(:,1)+2*AllDelta(:,1),'--','Color','#0072BD')
plot(timeVec',AllYfit(:,1)-2*AllDelta(:,1),'--','Color','#0072BD')

plot(timeVec',AllXe(:,2),'o','Color','#D95319')
plot(timeVec',AllYfit(:,2),'Color','#D95319','LineWidth',3)
plot(timeVec',AllYfit(:,2)+2*AllDelta(:,2),'--','Color','#D95319')
plot(timeVec',AllYfit(:,2)-2*AllDelta(:,2),'--','Color','#D95319')

plot(timeVec',AllXe(:,3),'o','Color','#EDB120')
plot(timeVec',AllYfit(:,3),'Color','#EDB120','LineWidth',3)
plot(timeVec',AllYfit(:,3)+2*AllDelta(:,3),'--','Color','#EDB120')
plot(timeVec',AllYfit(:,3)-2*AllDelta(:,3),'--','Color','#EDB120')

plot(timeVec',AllXe(:,4),'o','Color','#7E2F8E')
plot(timeVec',AllYfit(:,4),'Color','#7E2F8E','LineWidth',3)
plot(timeVec',AllYfit(:,4)+2*AllDelta(:,4),'--','Color','#7E2F8E')
plot(timeVec',AllYfit(:,4)-2*AllDelta(:,4),'--','Color','#7E2F8E')
hold off
xlabel('time (min)');
ylabel(['power (log10) ' int2str(chanOI(1))]);
title('Linear Fit of Data with 95% Prediction Interval')
% legend('Data','Linear Fit','95% Prediction Interval')
% publishfig
%     saveas(gcf,[figdir 'thetaByTime_' fileroot '.fig']);
