% Data conversion script:
% conversion of the data and plotting the relevant graphs

%% Plot 2: Alphapower with trialtypes

% clearing all the variable exept the data;
clearvars -except data bl1Trialtype

% load the data file; (imp : change this if the path changes);

% prompt = 'Please enter the subject name : ';
% subjectname = input(prompt,'s');
% prompt = 'Load the combined subjects data file for the selected subejct ';
% load(uigetfile(prompt,'s'));
% load('C:\Users\RayLabCNS\Documents\MATLAB\Ankan_M\Biofeedback\A_ProjectRawData\3VI\BiofeedbackData_Rishi_211216\biofeedback_211216rishifirst2.mat');
load('C:\Users\RayLabCNS\Documents\MATLAB\Ankan_M\Biofeedback\A_ProjectRawData\2IS\Combined_session_data\biofeedback_S03.mat')

% %% We would define a matix setfreqdata 
% We would define a matix alphapowerdata

% powerdata    = []; dont need it right now

% Creating separate matrix for the constant, alpha and alpha 
% indpendent data
% keeping it same

consData       = [];
alpahDepData   = [];
alphaIndData   = [];

%% Getting specified indices which meets a trial condion.

% defining zero for the constant tone    (25% of the total trials),
% defining one for the dependent tone   (50% of the total trials),
% defining two for the independent tone (25% of the total trial)

constant = find(sub_trialtypes == 0);
alpahdep = find(sub_trialtypes == 1);
alphaind = find(sub_trialtypes == 2);

% Next we would in for loop bring the data in it:
% have to change here to bring alphapowerdata from data
% for that I have to know where alpha power is getting stored?

%% starttime and the endtime of the eyesclose task performed by the subjects
starttime = 8;
endtime = 57;

for i=1:48 % for total of 20 trial, it it go to each of the cell within which each of the trial is located 
%     rawalphapow = [];
    rawAlphaPow = sub_data{3,i}; % i would varie from first trial to last trial
    rawAlphaPow = rawAlphaPow*10;
    alphaPower = mean(rawAlphaPow(:,8:15),2)';
    alphaPowerAllTrial(i,:) = alphaPower(starttime:endtime); % and would keep inside the alphaPowerAllTrial   
end

%% Note: alphaPowerAllTrial is a matrix which have the alphapower in it
%  The x axis and in y axis(coloum no) denotes the trail no)
%  Now from this I have to pull out the trials which I need.
%  Now I would make three matix out of this original matrix
%  each one would be for a separate trial type

%% Creating final data matrix

% Creating consdata matrix

for i = 1:size(constant,2)
    rowval = constant(i);
    consData(i,:) = alphaPowerAllTrial(rowval,:);   
end

% Similarly for other matrices

for i = 1:size(alphaind,2) % alpha independent
    rowval = alphaind(i);
    alphaIndData(i,:) = alphaPowerAllTrial(rowval,:);   
end

for i = 1:size(alpahdep,2) % alpha dependent
    rowval = alpahdep(i);
    alpahDepData (i,:) = alphaPowerAllTrial(rowval,:);   
end

% average across trials
avgacr_trials_consData     = mean(consData,1);
avgacr_trials_alpaDepData = mean(alpahDepData,1);
avgacr_trials_alphaIndData = mean(alphaIndData,1);

% average across timeperiods
avgtime_consData = mean(avgacr_trials_consData(:));         std_ConsData     = (std(avgacr_trials_consData(:)))/sqrt(size(constant,2));
avgtime_alphaIndData = mean(avgacr_trials_alphaIndData(:)); std_alphaIndData = (std(avgacr_trials_alphaIndData(:)))/sqrt(size(alphaind,2));
avgtime_alpaDepData = mean(avgacr_trials_alpaDepData(:));   std_alpaDepData  = (std(avgacr_trials_alpaDepData(:)))/sqrt(size(alpahdep,2));

% acculmulating the datas in one single array;
% in the order : constand dependent independent

%% creating x and y axis for the final plot
trialtypes = 1:3;  % x axis
avgsetfreq = [avgtime_consData,avgtime_alphaIndData,avgtime_alpaDepData];
error_upper      = [std_ConsData,std_alphaIndData,std_alpaDepData];
error_lower      = [std_ConsData,std_alphaIndData,std_alpaDepData];

%% plotting
bar(trialtypes,avgsetfreq); hold on
hc = errorbar(trialtypes,avgsetfreq,error_lower,error_upper,'.','MarkerSize',20,...
    'MarkerEdgeColor','cyan','MarkerFaceColor','cyan');
set(hc,'color','r')
% grid on
ax = gca;
ax.YMinorGrid = 'on';
set(gca,'XTickLabel',{'Constant','Alpha Independent','ALpha Dependent'})
% ax.XTickLabel={'ankan'} % this would work also, % the hing to remember
% here is to put this string in a cell array not in a matrix.
xlabel('Trialtypes','FontSize',12,'FontWeight','bold','Color','k'); ylabel('Change in Alphapower(db)','FontSize',12,'FontWeight','bold','Color','k');
title('Average change in alphapower from baseline vs. different trialtypes','FontSize',14,'FontWeight','bold','Color','k');

% save the figure in the pwd;
saveas(gca,'Average alpha power vs. different trialtypes.png','png');

