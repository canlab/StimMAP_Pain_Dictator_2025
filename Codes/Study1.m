load('Data_study1.mat')
font_size = 20;

glme_data_study1 = fitlme(Table_data_study1, 'Rate ~ 1 + Runs_mean_centered * Trials_mean_centered + Stimulus_Intensity *  Intensity_Offer_mean_centered * Montary_Offer_mean_centered + (1 + Runs_mean_centered * Trials_mean_centered + Intensity_Offer_mean_centered * Montary_Offer_mean_centered * Stimulus_Intensity | Sub)','StartMethod','random');
anova_glme_data_study1 = anova(glme_data_study1,'dfmethod','satterthwaite');

numericTable = Table_data_study1(:, varfun(@isnumeric, Table_data_study1, 'OutputFormat', 'uniform'));
data_study1 = table2array(numericTable);

selected_subjects =unique(data_study1(:,1));

for i=1:length(selected_subjects)

    v = data_study1(find(data_study1(:,1)==selected_subjects(i)),:);

    v_h_pain_h_reward_low_temp = v(find((v(:,4)>0)&(v(:,5)>0)&(v(:,7)==-1)),6); % index for High Intensity Offer - High Monetary Offer - Low Stimulus Intensity
    v_h_pain_l_reward_low_temp = v(find((v(:,4)>0)&(v(:,5)<0)&(v(:,7)==-1)),6); % index for High Intensity Offer - Low Monetary Offer - Low Stimulus Intensity
    v_l_pain_h_reward_low_temp = v(find((v(:,4)<0)&(v(:,5)>0)&(v(:,7)==-1)),6); % index for Low Intensity Offer - High Monetary Offer - Low Stimulus Intensity
    v_l_pain_l_reward_low_temp = v(find((v(:,4)<0)&(v(:,5)<0)&(v(:,7)==-1)),6); % index for Low Intensity Offer - Low Monetary Offer - Low Stimulus Intensity

    out_h_pain_h_reward_low_temp (i) = mean(v_h_pain_h_reward_low_temp);
    out_h_pain_l_reward_low_temp (i) = mean(v_h_pain_l_reward_low_temp);
    out_l_pain_h_reward_low_temp (i) = mean(v_l_pain_h_reward_low_temp);
    out_l_pain_l_reward_low_temp (i) = mean(v_l_pain_l_reward_low_temp);


    v_h_pain_h_reward_high_temp = v(find((v(:,4)>0)&(v(:,5)>0)&(v(:,7)==1)),6);  % index for High Intensity Offer - High Monetary Offer - High Stimulus Intensity
    v_h_pain_l_reward_high_temp = v(find((v(:,4)>0)&(v(:,5)<0)&(v(:,7)==1)),6);  % index for High Intensity Offer - Low Monetary Offer - High Stimulus Intensity
    v_l_pain_h_reward_high_temp = v(find((v(:,4)<0)&(v(:,5)>0)&(v(:,7)==1)),6);  % index for Low Intensity Offer - High Monetary Offer - High Stimulus Intensity
    v_l_pain_l_reward_high_temp = v(find((v(:,4)<0)&(v(:,5)<0)&(v(:,7)==1)),6);  % index for Low Intensity Offer - Low Monetary Offer - High Stimulus Intensity

    out_h_pain_h_reward_high_temp (i) = mean(v_h_pain_h_reward_high_temp);
    out_h_pain_l_reward_high_temp (i) = mean(v_h_pain_l_reward_high_temp);
    out_l_pain_h_reward_high_temp (i) = mean(v_l_pain_h_reward_high_temp);
    out_l_pain_l_reward_high_temp (i) = mean(v_l_pain_l_reward_high_temp);


end

Output_final = [out_h_pain_h_reward_high_temp' out_h_pain_l_reward_high_temp' out_l_pain_h_reward_high_temp' out_l_pain_l_reward_high_temp' out_h_pain_h_reward_low_temp' out_h_pain_l_reward_low_temp' out_l_pain_h_reward_low_temp' out_l_pain_l_reward_low_temp'];

pain_effect = [1 1 -1 -1 1 1 -1 -1]';
reward_effect = [1 -1 1 -1 1 -1 1 -1]';
pain_reward_effect = pain_effect.*reward_effect;
Temp_effect = [1 1 1 1 -1 -1 -1 -1]';
pain_Temp_effect = pain_effect .* Temp_effect;
reward_Temp_effect = reward_effect .* Temp_effect;
pain_reward_Temp_effect = pain_effect .*reward_effect .* Temp_effect;

CC_all = [pain_effect reward_effect Temp_effect pain_Temp_effect reward_Temp_effect reward_Temp_effect pain_reward_Temp_effect]/4;
Out_presentation_study1 = Output_final * CC_all;

% CANlab toolbox
barplot_columns(Out_presentation_study1(:,1:3) , 'Mean Changes', 'nofig', 'noviolin', 'colors', {[0.3765 0.2902 0.4824] [0.3765 0.2902 0.4824] [0.3765 0.2902 0.4824] [0.3765 0.2902 0.4824] [0.3765 0.2902 0.4824] [0.3765 0.2902 0.4824] [0.3765 0.2902 0.4824]})
xticklabels({'Pain' 'Monetary' 'Temp'});
ylabel('Effects of Pain and Monetary and Temperature')
xtickangle(0)
set(gca, 'FontSize', 20,'FontName', 'Times')

%% violin plot toolbox
figure
condition_names = {'Intesity \newline Offer', 'Monetary \newline Offer', 'Stimulus \newline  Intensity'};
X_study1{1,1} = Out_presentation_study1(:,1);
X_study1{1,2} = Out_presentation_study1(:,2);
X_study1{1,3} = Out_presentation_study1(:,3);
%

h = daviolinplot(X_study1, 'outsymbol','k+','violin', 'half2', 'violinwidth', 1, 'boxcolors','same',...
    'box' ,2, 'boxcolors','same','boxalpha', 0.6, 'scatter',1,'scattersize',30,'scatteralpha' , 0.4,'jitter',1 ,'xtlabels', condition_names, 'outliers',0);
ylabel('Effect on Pain Sensation')
ylim([-20  90])

% Remove default x-tick labels
xticklabels('');
title('Study 1')

% Manually add closer labels
text(1, -23, {'Intensity Offer'}, 'HorizontalAlignment', 'center','FontSize',font_size);
text(2, -23, {'Monetary Offer'}, 'HorizontalAlignment', 'center','FontSize',font_size);
text(3, -23, {'Stimulus Intensity'}, 'HorizontalAlignment', 'center','FontSize',font_size);
set(gca, 'FontSize', font_size,'FontName', 'Helvetica-Narrow')
set(gcf, 'Units', 'inches', 'Position', [1, 1, 9 7]);
hold on
yline(0, ":", 'LineWidth', 0.1);
text(1, -29, {'High vs. Low'}, 'HorizontalAlignment', 'center','FontSize',font_size);
text(2, -29, {'High vs. Low'}, 'HorizontalAlignment', 'center','FontSize',font_size);
text(3, -29, {'High vs. Low'}, 'HorizontalAlignment', 'center','FontSize',font_size);


