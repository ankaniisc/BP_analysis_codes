% Data conversion script:
% conversion of the data and plotting the relevant graphs

%% Plot 3: To check that the alphapower is changing as trial progression is happening with time or not?

% clearing all the variable exept the data;
clearvars -except data bl1Trialtype

% load the data file; (imp : change this if the path changes);

load('C:\Users\RayLabCNS\Documents\MATLAB\Ankan_M\Recorded Data\ButterflyProjectRawData\BiofeedbackData_Rishi_211216\biofeedback_211216rishifirst2.mat');

% %% We would define a matix setfreqdata 
% We would define a matix alphapowerdata

% powerdata    = []; dont need it right now

% Creating separate matrix for the constant, alpha and alpha 
% indpendent data
% keeping it same

% consData       = [];
% alpahDepData   = [];
% alphaIndData   = [];

%% Getting specified indices which meets a trial condion.

constant = find(bl1Trialtype==0);
alpahdep = find(bl1Trialtype==1);
alphaind = find(bl1Trialtype==2);

% Next we would in for loop bring the data in it:
% have to change here to bring alphapowerdata from data
% $ for that I have to knwo where alpha power is getting stored?
starttime = 11;
endtime = 60;

%% Extracting alphapower from the recorded data:

for i=1:20
%     rawalphapow = [];
    rawAlphaPow = data{1,1}{2,i};
    rawAlphaPow = rawAlphaPow*10;
    alphaPower = mean(rawAlphaPow(:,8:15),2)';
    alphaPowerAllTrial(i,:) = alphaPower(starttime:endtime);    
end



%% Note: set freq data is a matrix which have the setfredata in 
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
% 
% % Similarly for other matrices
% 
for i = 1:size(alpahdep,2)
    rowval = alpahdep(i);
    alpahDepData (i,:) = alphaPowerAllTrial(rowval,:);   
end
% 
for i = 1:size(alphaind,2)
    rowval = alphaind(i);
    alphaIndData(i,:) = alphaPowerAllTrial(rowval,:);   
end


% average across trials
% avgacr_trials_consData     = mean(consData,1);
% avgacr_trials_alpaDepData = mean(alpahDepData,1);
% avgacr_trials_alphaIndData = mean(alphaIndData,1);

% average across timeperiods 
avgtime_consData = mean(consData,2)';          error_lower_con = (std(consData'))/sqrt(4);    
avgtime_alpaDepData = mean(alpahDepData,2)';   error_lower_dep = (std(alpahDepData'))/sqrt(8);
avgtime_alphaIndData = mean(alphaIndData,2)';  error_lower_ind = (std(alphaIndData'))/sqrt(4);

average_alphaPowerAllTrials = mean(alphaPowerAllTrial,2)'; error_lower_all = (std(alphaPowerAllTrial'))/sqrt(16);


% acculmulating the datas in one single array;
% in the order : constand dependent independent

trialno = [1:20];  % x axis
constrailno = [1:5];
deptrailano = [1:10];
indtraialno = [1:5];

% avgsetfreq = [avgtime_consData,avgtime_alpaDepData,avgtime_alphaIndData];
% error_upper      = [0,std_alpaDepData,std_alphaIndData];
% error_lower      = [std_ConsData,0,0];
% plotting
% bar(trialtypes,avgsetfreq); hold on
% hc = errorbar(trialtypes,avgsetfreq,error_lower,error_upper,'.','MarkerSize',20,...
%     'MarkerEdgeColor','cyan','MarkerFaceColor','cyan');

figure('name','Change in alpha power from baseline(db) vs trial no');
subplot(2,3,1);
plot(constrailno,avgtime_consData,'r-*'); hold on
hc =  errorbar(constrailno,avgtime_consData,error_lower_con,error_lower_con,'.','MarkerSize',15,...
    'MarkerEdgeColor','r','MarkerFaceColor','r');
% errorbar(constrailno,avgtime_consData,error_lower_con,error_lower_con);
set(hc,'color','r');
% set(gca,'XTickLabel',{'1','2','3','4'});
title('Contant feedback','FontSize',10,'FontWeight','bold','Color','k');
xlabel('TrialNumber','FontSize',8,'FontWeight','bold','Color','k'); ylabel('Change in alpha power from baseline (db)  ','FontSize',8,'FontWeight','bold','Color','k');

subplot(2,3,2);
plot(indtraialno,avgtime_alphaIndData,'g-*'); hold on
hc = errorbar(indtraialno,avgtime_alphaIndData,error_lower_ind,error_lower_ind,'.','MarkerSize',20,...
    'MarkerEdgeColor','g','MarkerFaceColor','g');
set(hc,'color','g');
% set(gca,'XTickLabel',{'1','2','3','4'});
title('AlphaInDep Feedback','FontSize',10,'FontWeight','bold','Color','k');
xlabel('TrialNumber','FontSize',8,'FontWeight','bold','Color','k'); ylabel('Change in alpha power from baseline (db) ','FontSize',8,'FontWeight','bold','Color','k');

subplot(2,3,3);
plot(deptrailano,avgtime_alpaDepData,'b-*'); hold on
hc = errorbar(deptrailano,avgtime_alpaDepData,error_lower_dep,error_lower_dep,'.','MarkerSize',20,...
    'MarkerEdgeColor','b','MarkerFaceColor','b');
set(hc,'color','b');
% set(gca,'XTickLabel',{'1','2','3','4','5','6','7','8'});
title('AlphaDep Feedback','FontSize',10,'FontWeight','bold','Color','k');
xlabel('TrialNumber','FontSize',8,'FontWeight','bold','Color','k'); ylabel('Change in alpha power from baseline (db)  ','FontSize',8,'FontWeight','bold','Color','k');



subplot(2,3,[4,5,6]);
hc =  errorbar(constant,avgtime_consData,error_lower_con,error_lower_con,'.','MarkerSize',13,...
    'MarkerEdgeColor','r','MarkerFaceColor','r','DisplayName','Constant trials'); hold on
set(hc,'color','r');
hc = errorbar(alphaind,avgtime_alphaIndData,error_lower_ind,error_lower_ind,'.','MarkerSize',13,...
    'MarkerEdgeColor','g','MarkerFaceColor','g','DisplayName','alpha Independent trials');hold on
set(hc,'color','g');
hc = errorbar(alpahdep,avgtime_alpaDepData,error_lower_dep,error_lower_dep,'.','MarkerSize',13,...
    'MarkerEdgeColor','b','MarkerFaceColor','b','DisplayName','alpha dependent trials'); hold on
set(hc,'color','b');
legend('show');
plot(trialno,average_alphaPowerAllTrials,'k-'); hold on
xlabel('TrialNumber','FontSize',12,'FontWeight','bold','Color','k'); ylabel('Change in alpha power from baseline (db)  ','FontSize',12,'FontWeight','bold','Color','k');
title('Change in alpha power from baseline (db) vs. trialno','FontSize',14,'FontWeight','bold','Color','k');


% set(hc,'color','r')
% grid on
ax = gca;
ax.YMinorGrid = 'on';
% set(gca,'XTickLabel',{'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16'})
% ax.XTickLabel={'ankan'} % this would work also, % the hing to remember
% here is to put this string in a cell array not in a matrix.
xlabel('TrialNumber','FontSize',12,'FontWeight','bold','Color','k'); ylabel('Change in alpha power from baseline (db) ','FontSize',12,'FontWeight','bold','Color','k');
title('Change in alpha power from baseline (db)   vs. trialno','FontSize',14,'FontWeight','bold','Color','k');

% save the figure in the pwd;
saveas(gca,'Change in alpha power from baseline (db)  vs. trialno.png','png');

