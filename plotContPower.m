% plot regression per subject

figdir = '/Users/roydavid/Documents/FYRP/';
datadir = '/Users/roydavid/Downloads/Monks/powspec/';

fileroots = {'c284d283h','c286d285h','c287d288h','c292d291h','c294d293h','c295d296h',...
    'c284d283e','c286d285e','c287d288e','c292d291e','c294d293e','c295d296e',...
    'c284d283r','c286d285r','c287d288r','c292d291r','c294d293r','c295d296r',...
    'c283d284sm','c285d286sm','c288d287sm','c291d292sm','c293d294sm','c296d295sm',...
    };

% frontal theta; Fz = 31 (31+32)
chanOI = [31 63];
freqOI = 4:9;

% occipital alpha; Oz = 16 (16+32)
chanOI = [16 48];
freqOI = 9:13;

trialDur = 15;

Nfiles = length(fileroots);

% for f = 1:length(fileroots)
f = 1;
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
thetaPow1 = squeeze(nanmean(log10(powspec(:,chanOI(1),:)),3));
thetaPow2 = squeeze(nanmean(log10(powspec(:,chanOI(2),:)),3));

% power over time per subj
figure; plot(timeVec,thetaPow1,'b');
hold on
plot(timeVec,thetaPow2,'r');
hold off
xlabel('time (min)');
ylabel(['power (log10) ' int2str(chanOI(1))]);
title('Power over time')
% publishfig
%     saveas(gcf,[figdir 'thetaByTimeCheck_' fileroot '.fig']);


% regression coeff with degree
% https://nl.mathworks.com/help/matlab/ref/polyval.html
n = 1;  % degree
% subj1
nanx1 = prod(isfinite(thetaPow1),2);
xe1 = thetaPow1(nanx1 == 1,:);
[b1,slope1] = polyfit(timeVec(1:(end-1))', xe1, n);
[y_fit1,delta1] = polyval(b1,timeVec',slope1);
% subj2
nanx2 = prod(isfinite(thetaPow2),2);
xe2 = thetaPow2(nanx2 == 1,:);
[b2,slope2] = polyfit(timeVec(1:(end-1))', xe2, n);
[y_fit2,delta2] = polyval(b2,timeVec',slope2);

% plot regression line, with 95% CI
% subj1
figure;
hold on
plot(timeVec(1:(end-1))',xe1,'bo')
% plot(timeVec(1:(end-1))',xe1,'b')
plot(timeVec',y_fit1,'b','LineWidth',3)
plot(timeVec',y_fit1+2*delta1,'b--',timeVec',y_fit1-2*delta1,'b--')
% subj2
plot(timeVec(1:(end-1))',xe2,'ro')
% plot(timeVec(1:(end-1))',xe2,'r')
plot(timeVec',y_fit2,'r','LineWidth',3)
plot(timeVec',y_fit2+2*delta2,'r--',timeVec',y_fit2-2*delta2,'r--')
hold off
xlabel('time (min)');
ylabel(['power (log10) ' int2str(chanOI(1))]);
title('Linear Fit of Data with 95% Prediction Interval')
% legend('Data','Linear Fit','95% Prediction Interval')
% publishfig
%     saveas(gcf,[figdir 'thetaByTime_' fileroot '.fig']);

% end

% frontal theta Fz: 31
% occiptal alpha Oz: 16
