load('Data_study3.mat')
font_size = 20;



simple_model = fitlme(Table_data_study3, 'Rate ~ 1 +  Pre_baseline + Sessions_mean_centered + Biological_Sex +  Runs_mean_centered + Trials_mean_centered + Order + (An_Others + Ca_Sh) * Intensity_Offer_mean_centered * Monetary_Offer_mean_centered * Stimulus_Intensity   + (1 + An_Others + Ca_Sh + Intensity_Offer_mean_centered + Monetary_Offer_mean_centered + Stimulus_Intensity | Sub)','DummyVarCoding', 'reference');
anova_simple_model  = anova(simple_model,'dfmethod','satterthwaite');


complex_model = fitlme(Table_data_study3, 'Rate ~ 1 +  Pre_baseline + Sessions_mean_centered + Biological_Sex +  Order +  (An_Others + Ca_Sh) * (Runs_mean_centered * Trials_mean_centered  + Intensity_Offer_mean_centered * Monetary_Offer_mean_centered * Stimulus_Intensity)   + (1 + Sessions_mean_centered + (An_Others + Ca_Sh) * (Runs_mean_centered * Trials_mean_centered  + Intensity_Offer_mean_centered * Monetary_Offer_mean_centered * Stimulus_Intensity)  | Sub)','DummyVarCoding', 'reference');
anova_complex_model  = anova(complex_model,'dfmethod','satterthwaite');



numericTable = Table_data_study3(:, varfun(@isnumeric, Table_data_study3, 'OutputFormat', 'uniform'));
data_study3 = table2array(numericTable);

data_study3 (:,7) = data_study3(:,7) - data_study3(:,9); % All_data_post is post minus pre
for i=1:50
    v = data_study3(find(data_study3(:,1)==i),:);

    v_h_pain_h_reward_low_temp = v(find((v(:,5)>0)&(v(:,6)>0)&(v(:,8)==-1)),7);
    v_h_pain_l_reward_low_temp = v(find((v(:,5)>0)&(v(:,6)<0)&(v(:,8)==-1)),7);
    v_l_pain_h_reward_low_temp = v(find((v(:,5)<0)&(v(:,6)>0)&(v(:,8)==-1)),7);
    v_l_pain_l_reward_low_temp = v(find((v(:,5)<0)&(v(:,6)<0)&(v(:,8)==-1)),7);
    out_h_pain_h_reward_low_temp (i) = mean(v_h_pain_h_reward_low_temp);
    out_h_pain_l_reward_low_temp (i) = mean(v_h_pain_l_reward_low_temp);
    out_l_pain_h_reward_low_temp (i) = mean(v_l_pain_h_reward_low_temp);
    out_l_pain_l_reward_low_temp (i) = mean(v_l_pain_l_reward_low_temp);

    v_h_pain_h_reward_high_temp = v(find((v(:,5)>0)&(v(:,6)>0)&(v(:,8)==1)),7);
    v_h_pain_l_reward_high_temp = v(find((v(:,5)>0)&(v(:,6)<0)&(v(:,8)==1)),7);
    v_l_pain_h_reward_high_temp = v(find((v(:,5)<0)&(v(:,6)>0)&(v(:,8)==1)),7);
    v_l_pain_l_reward_high_temp = v(find((v(:,5)<0)&(v(:,6)<0)&(v(:,8)==1)),7);
    out_h_pain_h_reward_high_temp (i) = mean(v_h_pain_h_reward_high_temp);
    out_h_pain_l_reward_high_temp (i) = mean(v_h_pain_l_reward_high_temp);
    out_l_pain_h_reward_high_temp (i) = mean(v_l_pain_h_reward_high_temp);
    out_l_pain_l_reward_high_temp (i) = mean(v_l_pain_l_reward_high_temp);

end

data_boxplot = [out_h_pain_h_reward_high_temp' out_h_pain_l_reward_high_temp' out_l_pain_h_reward_high_temp' out_l_pain_l_reward_high_temp' out_h_pain_h_reward_low_temp' out_h_pain_l_reward_low_temp' out_l_pain_h_reward_low_temp' out_l_pain_l_reward_low_temp'];

pain_effect = [1 1 -1 -1 1 1 -1 -1]'/4;
reward_effect = [1 -1 1 -1 1 -1 1 -1]'/4;
pain_reward_effect = pain_effect.*reward_effect;
Temp_effect = [1 1 1 1 -1 -1 -1 -1]'/4;
pain_Temp_effect = pain_effect .* Temp_effect;
reward_Temp_effect = reward_effect .* Temp_effect;
pain_reward_Temp_effect = pain_effect .*reward_effect .* Temp_effect;
CC_all = [pain_effect reward_effect Temp_effect pain_Temp_effect reward_Temp_effect reward_Temp_effect pain_reward_Temp_effect];

Results_study3 = data_boxplot * CC_all;

% CANlab toolbox
barplot_columns(Results_study3(:,1:3) , 'noviolin', 'colors', {[0.3765 0.2902 0.4824] [0.3765 0.2902 0.4824] [0.3765 0.2902 0.4824] [0.3765 0.2902 0.4824] [0.3765 0.2902 0.4824] [0.3765 0.2902 0.4824] [0.3765 0.2902 0.4824]})
xticklabels({'Pain' 'Monetary' 'Stimulus'})

%% violin plot toolbox
for i=1:50
    v = data_study3(find(data_study3(:,1)==i),:);

    v_h_pain_h_reward_low_temp_An = v(find((v(:,5)>0)&(v(:,6)>0)&(v(:,8)==-1)&(v(:,10)==2/3) &(v(:,11)==0)),7);    % index for Anodal Left M1 High Intensity Offer - High Monetary Offer - Low Stimulus Intensity
    v_h_pain_l_reward_low_temp_An = v(find((v(:,5)>0)&(v(:,6)<0)&(v(:,8)==-1)&(v(:,10)==2/3) &(v(:,11)==0)),7);    % index for Anodal Left M1 High Intensity Offer - Low Monetary Offer - Low Stimulus Intensity
    v_l_pain_h_reward_low_temp_An = v(find((v(:,5)<0)&(v(:,6)>0)&(v(:,8)==-1)&(v(:,10)==2/3) &(v(:,11)==0)),7);    % index for Anodal Left M1 Low Intensity Offer - High Monetary Offer - Low Stimulus Intensity
    v_l_pain_l_reward_low_temp_An = v(find((v(:,5)<0)&(v(:,6)<0)&(v(:,8)==-1)&(v(:,10)==2/3) &(v(:,11)==0)),7);    % index for Anodal Left M1 Low Intensity Offer - Low Monetary Offer - Low Stimulus Intensity
    out_h_pain_h_reward_low_temp_An (i) = mean(v_h_pain_h_reward_low_temp_An);
    out_h_pain_l_reward_low_temp_An (i) = mean(v_h_pain_l_reward_low_temp_An);
    out_l_pain_h_reward_low_temp_An (i) = mean(v_l_pain_h_reward_low_temp_An);
    out_l_pain_l_reward_low_temp_An (i) = mean(v_l_pain_l_reward_low_temp_An);

    v_h_pain_h_reward_high_temp_An = v(find((v(:,5)>0)&(v(:,6)>0)&(v(:,8)==1)&(v(:,10)==2/3) &(v(:,11)==0)),7);    % index for Anodal Left M1 High Intensity Offer - High Monetary Offer - High Stimulus Intensity
    v_h_pain_l_reward_high_temp_An = v(find((v(:,5)>0)&(v(:,6)<0)&(v(:,8)==1)&(v(:,10)==2/3) &(v(:,11)==0)),7);    % index for Anodal Left M1 High Intensity Offer - Low Monetary Offer - High Stimulus Intensity
    v_l_pain_h_reward_high_temp_An = v(find((v(:,5)<0)&(v(:,6)>0)&(v(:,8)==1)&(v(:,10)==2/3) &(v(:,11)==0)),7);    % index for Anodal Left M1 Low Intensity Offer - High Monetary Offer - High Stimulus Intensity
    v_l_pain_l_reward_high_temp_An = v(find((v(:,5)<0)&(v(:,6)<0)&(v(:,8)==1)&(v(:,10)==2/3) &(v(:,11)==0)),7);    % index for Anodal Left M1 Low Intensity Offer - Low Monetary Offer - High Stimulus Intensity
    out_h_pain_h_reward_high_temp_An (i) = mean(v_h_pain_h_reward_high_temp_An);
    out_h_pain_l_reward_high_temp_An (i) = mean(v_h_pain_l_reward_high_temp_An);
    out_l_pain_h_reward_high_temp_An (i) = mean(v_l_pain_h_reward_high_temp_An);
    out_l_pain_l_reward_high_temp_An (i) = mean(v_l_pain_l_reward_high_temp_An);

    v_h_pain_h_reward_low_temp_Ca = v(find((v(:,5)>0)&(v(:,6)>0)&(v(:,8)==-1)&(v(:,10)==-1/3) &(v(:,11)==1/2)),7); % index for Cathodal Left M1 or Anodal Right DLPFC
    v_h_pain_l_reward_low_temp_Ca = v(find((v(:,5)>0)&(v(:,6)<0)&(v(:,8)==-1)&(v(:,10)==-1/3) &(v(:,11)==1/2)),7);
    v_l_pain_h_reward_low_temp_Ca = v(find((v(:,5)<0)&(v(:,6)>0)&(v(:,8)==-1)&(v(:,10)==-1/3) &(v(:,11)==1/2)),7);
    v_l_pain_l_reward_low_temp_Ca = v(find((v(:,5)<0)&(v(:,6)<0)&(v(:,8)==-1)&(v(:,10)==-1/3) &(v(:,11)==1/2)),7);
    out_h_pain_h_reward_low_temp_Ca (i) = mean(v_h_pain_h_reward_low_temp_Ca);
    out_h_pain_l_reward_low_temp_Ca (i) = mean(v_h_pain_l_reward_low_temp_Ca);
    out_l_pain_h_reward_low_temp_Ca (i) = mean(v_l_pain_h_reward_low_temp_Ca);
    out_l_pain_l_reward_low_temp_Ca (i) = mean(v_l_pain_l_reward_low_temp_Ca);
    v_h_pain_h_reward_high_temp_Ca = v(find((v(:,5)>0)&(v(:,6)>0)&(v(:,8)==1)&(v(:,10)==-1/3) &(v(:,11)==1/2)),7);
    v_h_pain_l_reward_high_temp_Ca = v(find((v(:,5)>0)&(v(:,6)<0)&(v(:,8)==1)&(v(:,10)==-1/3) &(v(:,11)==1/2)),7);
    v_l_pain_h_reward_high_temp_Ca = v(find((v(:,5)<0)&(v(:,6)>0)&(v(:,8)==1)&(v(:,10)==-1/3) &(v(:,11)==1/2)),7);
    v_l_pain_l_reward_high_temp_Ca = v(find((v(:,5)<0)&(v(:,6)<0)&(v(:,8)==1)&(v(:,10)==-1/3) &(v(:,11)==1/2)),7);
    out_h_pain_h_reward_high_temp_Ca (i) = mean(v_h_pain_h_reward_high_temp_Ca);
    out_h_pain_l_reward_high_temp_Ca (i) = mean(v_h_pain_l_reward_high_temp_Ca);
    out_l_pain_h_reward_high_temp_Ca (i) = mean(v_l_pain_h_reward_high_temp_Ca);
    out_l_pain_l_reward_high_temp_Ca (i) = mean(v_l_pain_l_reward_high_temp_Ca);

    v_h_pain_h_reward_low_temp_Sh = v(find((v(:,5)>0)&(v(:,6)>0)&(v(:,8)==-1)&(v(:,10)==-1/3) &(v(:,11)==-1/2)),7);  % index for Sham
    v_h_pain_l_reward_low_temp_Sh = v(find((v(:,5)>0)&(v(:,6)<0)&(v(:,8)==-1)&(v(:,10)==-1/3) &(v(:,11)==-1/2)),7);
    v_l_pain_h_reward_low_temp_Sh = v(find((v(:,5)<0)&(v(:,6)>0)&(v(:,8)==-1)&(v(:,10)==-1/3) &(v(:,11)==-1/2)),7);
    v_l_pain_l_reward_low_temp_Sh = v(find((v(:,5)<0)&(v(:,6)<0)&(v(:,8)==-1)&(v(:,10)==-1/3) &(v(:,11)==-1/2)),7);
    out_h_pain_h_reward_low_temp_Sh (i) = mean(v_h_pain_h_reward_low_temp_Sh);
    out_h_pain_l_reward_low_temp_Sh (i) = mean(v_h_pain_l_reward_low_temp_Sh);
    out_l_pain_h_reward_low_temp_Sh (i) = mean(v_l_pain_h_reward_low_temp_Sh);
    out_l_pain_l_reward_low_temp_Sh (i) = mean(v_l_pain_l_reward_low_temp_Sh);
    v_h_pain_h_reward_high_temp_Sh = v(find((v(:,5)>0)&(v(:,6)>0)&(v(:,8)==1)&(v(:,10)==-1/3) &(v(:,11)==-1/2)),7);
    v_h_pain_l_reward_high_temp_Sh = v(find((v(:,5)>0)&(v(:,6)<0)&(v(:,8)==1)&(v(:,10)==-1/3) &(v(:,11)==-1/2)),7);
    v_l_pain_h_reward_high_temp_Sh = v(find((v(:,5)<0)&(v(:,6)>0)&(v(:,8)==1)&(v(:,10)==-1/3) &(v(:,11)==-1/2)),7);
    v_l_pain_l_reward_high_temp_Sh = v(find((v(:,5)<0)&(v(:,6)<0)&(v(:,8)==1)&(v(:,10)==-1/3) &(v(:,11)==-1/2)),7);
    out_h_pain_h_reward_high_temp_Sh (i) = mean(v_h_pain_h_reward_high_temp_Sh);
    out_h_pain_l_reward_high_temp_Sh (i) = mean(v_h_pain_l_reward_high_temp_Sh);
    out_l_pain_h_reward_high_temp_Sh (i) = mean(v_l_pain_h_reward_high_temp_Sh);
    out_l_pain_l_reward_high_temp_Sh (i) = mean(v_l_pain_l_reward_high_temp_Sh);
end

data_study3_violinplot = [out_h_pain_h_reward_high_temp_An' out_h_pain_l_reward_high_temp_An' out_l_pain_h_reward_high_temp_An' out_l_pain_l_reward_high_temp_An' out_h_pain_h_reward_low_temp_An' out_h_pain_l_reward_low_temp_An' out_l_pain_h_reward_low_temp_An' out_l_pain_l_reward_low_temp_An' ...
    out_h_pain_h_reward_high_temp_Sh' out_h_pain_l_reward_high_temp_Sh' out_l_pain_h_reward_high_temp_Sh' out_l_pain_l_reward_high_temp_Sh' out_h_pain_h_reward_low_temp_Sh' out_h_pain_l_reward_low_temp_Sh' out_l_pain_h_reward_low_temp_Sh' out_l_pain_l_reward_low_temp_Sh' ...
    out_h_pain_h_reward_high_temp_Ca' out_h_pain_l_reward_high_temp_Ca' out_l_pain_h_reward_high_temp_Ca' out_l_pain_l_reward_high_temp_Ca' out_h_pain_h_reward_low_temp_Ca' out_h_pain_l_reward_low_temp_Ca' out_l_pain_h_reward_low_temp_Ca' out_l_pain_l_reward_low_temp_Ca'
    ];

pain_effect = [1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1]'/12;
reward_effect = [1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1]'/12;
tDCS_An_Ca = [ones(1,8) zeros(1,8) -ones(1,8)]'/8;
tDCS_An_Sh = [ones(1,8) -ones(1,8) zeros(1,8)]'/8;
tDCS_Ca_Sh = [zeros(1,8) -ones(1,8) ones(1,8)]'/8;

Temp_effect = [1 1 1 1 -1 -1 -1 -1 1 1 1 1 -1 -1 -1 -1 1 1 1 1 -1 -1 -1 -1]'/12;
CC_all = [pain_effect reward_effect Temp_effect tDCS_An_Ca tDCS_An_Sh tDCS_Ca_Sh];

figure
condition_names_all = {'APL', 'DP', 'Stimulus \newline  Intensity','An vs. Ca', 'An vs. Sh', 'Ca vs. Sh'};

all_plot_violin = data_study3_violinplot * CC_all;
X_viloin{1,1} = all_plot_violin(:,1);
X_viloin{1,2} = all_plot_violin(:,2);
X_viloin{1,3} = all_plot_violin(:,3);
X_viloin{1,4} = all_plot_violin(:,4);
X_viloin{1,5} = all_plot_violin(:,5);
X_viloin{1,6} = all_plot_violin(:,6);

h = daviolinplot(X_viloin , 'outsymbol','k+','violin', 'half2', 'violinwidth', 3, 'boxcolors','same',...
    'box' ,2, 'boxcolors','same','boxalpha', 0.6, 'scatter',1,'scattersize',30,'scatteralpha' , 0.4,'jitter',1 , 'outliers',0);
xlim([0.4 6.2])
ylabel('Performance');
ylabel('Effect on Pain Sensation')
ylim([-45 70])

% Remove default x-tick labels
xticklabels('');
title('Study 3')
% Manually add closer labels
text(1, -49, {'APL'}, 'HorizontalAlignment', 'center','FontSize',font_size);
text(2, -49, {'DP'}, 'HorizontalAlignment', 'center','FontSize',font_size);
text(3, -49, {'Stim-Int'}, 'HorizontalAlignment', 'center','FontSize',font_size);
text(4, -49, {'M1-DLPFC'}, 'HorizontalAlignment', 'center','FontSize',font_size);
text(5, -49, {'M1-Sh'}, 'HorizontalAlignment', 'center','FontSize',font_size);
text(6, -49, {'DLPFC-Sh'}, 'HorizontalAlignment', 'center','FontSize',font_size);

text(1, -55, {'High vs. Low'}, 'HorizontalAlignment', 'center','FontSize',font_size-5);
text(2, -55, {'High vs. Low'}, 'HorizontalAlignment', 'center','FontSize',font_size-5);
text(3, -55, {'High vs. Low'}, 'HorizontalAlignment', 'center','FontSize',font_size-5);

set(gca, 'FontSize', font_size,'FontName', 'Helvetica-Narrow')
set(gcf, 'Units', 'inches', 'Position', [1, 1, 11 6]);
hold on
yline(0, ":", 'LineWidth', 0.1);

%% tDCS interaction with Intensity Offer
Table_data_study3_interaction = Table_data_study3;
Table_data_study3_interaction.Rate = Table_data_study3_interaction.Rate - Table_data_study3_interaction.Pre_baseline;

subs = unique(Table_data_study3_interaction.Sub);
for s = 1:length(subs)
    sub_idx = Table_data_study3_interaction.Sub == subs(s);
    sub_mean = mean(Table_data_study3_interaction.Rate(sub_idx));
    Table_data_study3_interaction.Rate(sub_idx) = Table_data_study3_interaction.Rate(sub_idx) - sub_mean; % Remove intercept for each participant across three tDCS conditions
end

T = Table_data_study3_interaction;

% Define the three stimulation conditions
conditions = {'Anodal', 'Cathodal', 'Sham'};
labels =  {'Anodal Left M1', 'Anodal Right DLPFC', 'Sham'};
colors = lines(3);  % Three distinct colors

% Preallocate arrays
means_low = [];
means_high = [];
errs_low = [];
errs_high = [];

% Create a new figure
figure;
hold on;
% Loop through each condition
for i = 1:3
    switch labels{i}
        case 'Anodal Left M1'
            idx = Table_data_study3_interaction.An_Others == 2/3;
        case 'Anodal Right DLPFC'
            idx = Table_data_study3_interaction.Ca_Sh == 0.5;
        case 'Sham'
            idx = Table_data_study3_interaction.Ca_Sh == -0.5;
    end
    Tsub = Table_data_study3_interaction(idx, :);
    % Classify trials as low or high Pain
    Tsub.Intensity_Offer_mean_centered_Group = repmat("Mid", height(Tsub), 1);
    Tsub.Intensity_Offer_mean_centered_Group(Tsub.Intensity_Offer_mean_centered < 0) = "Low";
    Tsub.Intensity_Offer_mean_centered_Group(Tsub.Intensity_Offer_mean_centered > 0) = "High";

    % Group by Subject and PainGroup and compute mean Rate
    G = groupsummary(Tsub, {'Sub', 'Intensity_Offer_mean_centered_Group'}, 'mean', 'Rate');

    % Separate low and high
    low = G(strcmp(G.Intensity_Offer_mean_centered_Group, 'Low'), :);
    high = G(strcmp(G.Intensity_Offer_mean_centered_Group, 'High'), :);

    % Align participants
    commonSubs = intersect(low.Sub, high.Sub);
    low = low(ismember(low.Sub, commonSubs), :);
    high = high(ismember(high.Sub, commonSubs), :);

    % Compute group mean and SEM
    mLow = mean(low.mean_Rate);
    mHigh = mean(high.mean_Rate);
    semLow = std(low.mean_Rate) / sqrt(height(low));
    semHigh = std(high.mean_Rate) / sqrt(height(high));

    % Plot error bars and connecting line
    errorbar([1 2], [mLow, mHigh], [semLow, semHigh], '-o', ...
        'Color', colors(i,:), 'LineWidth', 2, 'DisplayName', labels{i});
end

% Format plot
set(gca, 'XTick', [1 2], 'XTickLabel', {'Low APL', 'High APL'});
ylabel('Pain Rating (Post – Pre)');
legend('Location', 'northwest');

hold off;
xlim([0.5 2.5]);
ylim([-10 11])
set(gca, 'XTick', [1 2], 'XTickLabel', {'Low APL', 'High APL'});

set(gca, 'FontSize', font_size,'FontName', 'Helvetica-Narrow')
set(gcf, 'Units', 'inches', 'Position', [1, 1, 6 6]);
hold on
yline(0, ":", 'LineWidth', 0.1);
