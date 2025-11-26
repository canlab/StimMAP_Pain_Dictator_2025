% clear
% clc
load('Mediation_study2.mat')
%% All_data_post

% Col_1: Subject's id
% Col_2: Session number (we had only one session, thereofore is eual to 1
% Col_3: Run number, 4 runs (1,2,3,4)
% Col_4: Pain (30%,40%,50%,70%,80%,90%)
% Col_5: Monetary ($1,$2,$3,$6,$7,$8)
% Col_6: Trialnumber (1-12)
% Col_7: Pain sensation
% Col_8: Temperature (Celius)
% Col_9: Temperature (1:Low or 2: High)
% Col_10: Guess tempeature
% Col_11: Fairness/Unfairness
% Col_12: Pain_cue (-1: Pain_cue < 60%  1: Pain_cue > 60%)
% Col_13: Monetary_cue (-1: Monetary_cue < 4  1: Monetary_cue > 5)





mediation_data_pain_guess(:,3) = mediation_data_pain_guess(:,3) - 2.5;       % Mean centered Runs (1,2,3,4)
mediation_data_pain_guess(:,4) = (mediation_data_pain_guess(:,4) - 60)/10;   % Mean Pain_cue
mediation_data_pain_guess(:,5) = (mediation_data_pain_guess(:,5) - 4.5);     % Mean Monetary_cue
mediation_data_pain_guess(:,6) = mediation_data_pain_guess(:,6) - 6.5;       % Mean Trial(1-12)


mediation_data_pain_guess(:,10) = (((mediation_data_pain_guess(:,10)/180)*4) + 45 - 47)/2;  % Guess tempertaure (conver degree to temp)
mediation_data_pain_guess(:,11) = (mediation_data_pain_guess(:,11) - 90)/90;    % Fairness/Unfairness


mediation_data_pain_guess(:,14) = mediation_data_pain_guess(:,3).* mediation_data_pain_guess(:,6);  % run:trial
mediation_data_pain_guess(:,15) = mediation_data_pain_guess(:,3).* mediation_data_pain_guess(:,5);  % run:monetary 
mediation_data_pain_guess(:,16) = mediation_data_pain_guess(:,6).* mediation_data_pain_guess(:,5);  % trial:monetary 
mediation_data_pain_guess(:,17) = mediation_data_pain_guess(:,3).* mediation_data_pain_guess(:,5).* mediation_data_pain_guess(:,6);  % run:monetary:trial
mediation_data_pain_guess(:,18) = mediation_data_pain_guess(:,9).* mediation_data_pain_guess(:,6);  % temp:trial
mediation_data_pain_guess(:,19) = mediation_data_pain_guess(:,9).* mediation_data_pain_guess(:,3);  % temp:run
mediation_data_pain_guess(:,20) = mediation_data_pain_guess(:,9).* mediation_data_pain_guess(:,3).* mediation_data_pain_guess(:,6);  % temp:run:trial
mediation_data_pain_guess(:,21) = mediation_data_pain_guess(:,9).* mediation_data_pain_guess(:,3).* mediation_data_pain_guess(:,6) .* mediation_data_pain_guess(:,5);  % temp:run:trial:monetary
mediation_data_pain_guess(:,22) = mediation_data_pain_guess(:,9).* mediation_data_pain_guess(:,5);  % temp:money
mediation_data_pain_guess(:,23) = mediation_data_pain_guess(:,9).* mediation_data_pain_guess(:,5).* mediation_data_pain_guess(:,6);  % temp:money:trial
mediation_data_pain_guess(:,24) = mediation_data_pain_guess(:,9).* mediation_data_pain_guess(:,3) .* mediation_data_pain_guess(:,5);  % temp:run:monetary



% load('t1.mat')
%  1: Sub                      2: Ses                       3:  Run             
%  4: Pain_cue                 5: Monetary_cue              6:  Trial     
%  7: Sensation Rating         8: Temp in degree            9:  Temp 1 -1  
%  10: Guess Temp              11: Fairness/unfirness       12: Pain_cue (1 and -1) 
%  13: Monetary: 1 and -1      14: Run:trial                15: Run:Monetary
%  16: Trial:Monetary          17: Run:Monetary:Trial       18: Temp:Trial
%  19: Temp:Run                20: Temp:Run:Trial           21: Temp:Run:Trial:Monetary
%  22: Temp:Monetary           23: Temp:Monetary:Trial      24: Run:temp:Money


col_x_mediation = 4;        % Pain_cue
col_M_mediation = 10;       % Guess Temp
col_M2_mediation = 11;      % Fairness/Unfairness
col_Y_mediation = 7;        % Pain sensation


id = unique(mediation_data_pain_guess(:,1));
for i= 1:1:length(id)  
    index = find(mediation_data_pain_guess(:,1) ==id(i));
    X_mediation{i} = [mediation_data_pain_guess(index,col_x_mediation)];  % 
    M_mediation{i} = [mediation_data_pain_guess(index,col_M_mediation)];  % Guess temp as mediator
    M2_mediation{i} = [mediation_data_pain_guess(index,col_M2_mediation)];  % Fairness/Unfairness as mediator

    Y_mediation{i} = [mediation_data_pain_guess(index,col_Y_mediation)];   % 

    cov_mediation_paincue{i} = [mediation_data_pain_guess(index,3) ... % Run
                                mediation_data_pain_guess(index,5) ... % Monetary
                                mediation_data_pain_guess(index,6)... % Trial
                                mediation_data_pain_guess(index,9) ... % Temp 1 -1
                                mediation_data_pain_guess(index,14:24)
                                
                                ];

end

[paths, stats] = mediation(X_mediation, Y_mediation, M_mediation, 'M', M2_mediation, 'covs', cov_mediation_paincue ,  'boot', 'verbose','plots', ...
'names', {'Pain_Cue' 'Rating' 'Guess Temperature'},'bootsamples', 10000);
