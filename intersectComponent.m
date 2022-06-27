% compare component and save intersect

% singlepointed
% icDataDirA = '/Users/roydavid/Downloads/Monks/singlepointed/components/';
% icDataDirB = '/Users/roydavid/Downloads/Monks/singlepointed/sm_sterre/';
% cleanDataDir = '/Users/roydavid/Downloads/Monks/singlepointed/sm_intersect/';
% fileroots = {'c278d277sm','c279d280sm','c282d281sm','c283d284sm','c285d286sm','c288d287sm','c291d292sm','c293d294sm','c296d295sm'};

% reflection
icDataDirA = '/Users/roydavid/Downloads/Monks/reflection/components/';
icDataDirB = '/Users/roydavid/Downloads/Monks/reflection/r_sterre/';
cleanDataDir = '/Users/roydavid/Downloads/Monks/reflection/r_intersect/';
fileroots = {'c284d283r','c286d285r','c287d288r','c292d291r','c294d293r','c295d296r'};

for f = 1:length(fileroots)
    fileroot = fileroots{f};
    % load component subject 1
    cd(icDataDirA)
    load([fileroot 'ic_s1.mat']);
    comp_s1A = cfg.component;
    % load component subject 2
    load([fileroot 'ic_s2.mat']);
    comp_s2A = cfg.component;

    % same for comparing directory
    cd(icDataDirB)
    load([fileroot 'ic_s1.mat']);
    comp_s1B = cfg.component;

    load([fileroot 'ic_s2.mat']);
    comp_s2B = cfg.component;
    
    % compare component keep intersect
    cfg.component = intersect(comp_s1A,comp_s1B);
    % check components
    keyboard
    % save intersect
    cd(cleanDataDir);
    outFile_s1 = [fileroot 'ic_s1.mat'];
    save(outFile_s1,'cfg');

    % same for subject 2
    cfg.component = intersect(comp_s2A,comp_s2B);
    % check components
    keyboard
    outFile_s1 = [fileroot 'ic_s2.mat'];
    save(outFile_s1,'cfg');
end
