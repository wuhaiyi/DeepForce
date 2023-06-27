clear all;
close all;
% code use to plot the angular distribution
%% data import
nbin = 600;
xmax = 60; % unit A
NNwater = [33,35,39,46,46,54,59,66,71,75,81,99,130,188, 283];
NNwaterQC = [188,280,390,600,1000];
%NNwater = [4, 17, 20,24];
xmim = 0;
area = 12.762*12.2802; %unit A
T = 300; 
kb = 0.001985875;  %unit kcal/mol

direct  = '/Users/haiyi1/Documents/windows/UT/groupmeeting/Chenxing/DeepMD/Umodel/';
direct2 = '/Users/haiyi1/Documents/windows/UT/groupmeeting/Chenxing/DeepMD/Umodel/U36/'; % DPMD data 4nm 6nm

filename1 = [direct, 'forceGs6nm.dat'];
filename2 = [direct, 'densMD6nm.dat'];
filename3 = [direct, 'forceInput6nm.dat'];
filename4 = [direct, 'ploterror.dat'];

error = load(filename4);
X = categorical({'1.0nm','1.4nm','1.9nm','4.0nm','6.0nm'});
X = reordercats(X,{'1.0nm','1.4nm','1.9nm','4.0nm','6.0nm'});
hb =bar(X, error)
hb(1).FaceColor = [1.00 0.54 0.00];
hb(2).FaceColor = [0.3010 0.7450 0.9330];
ylabel('relative error');
plot_style(22);
legend({'Deep Force','MD'},'FontSize',22, 'Location','northeast')
print('-dpng','-r300','errorplot.png');

densDP = load(filename1);
densMD = load(filename2);
forceIn = load(filename3);

ave_data = densDP;

    [v1, id1] = max(forceIn(:,2));
    [v2, id2] = min(forceIn(:,2));
    forceIn(1:id1,2) = max(forceIn(:,2));
    forceIn(id2:end,2) = min(forceIn(:,2));

fx3 = ave_data(:,2);
fx2 =  fx3;
fx1  = [fx3(1:end/2);fx2(end/2+1:end)] ; 
fx1flip = flipud(fx1);
ave_fx = 0.5*(fx1 - fx1flip); % ave both size
ave_fx2 = - ave_fx;
fx = [ave_fx(1:end/2);ave_fx2(end/2+1:end)];

filename2 = [direct2,'forceQC100-60U875more.dat']; %6nm
%filename2 = [direct2,'forceQC100-DP875.dat']; % 4nm
forceQC = load(filename2);

binVol = (xmax-xmim)/nbin*area*1e-3; % change unit to nm^3
z = ((1 : nbin)-0.5)*(xmax-xmim)/nbin + xmim;
 
% ave_fxQC = [ave_fxQC1(1:end/2),ave_fxQC2(end/2+1:end)];

ave_fxQC2 = forceQC(:,2);
ave_fxQC3 = -ave_fxQC2;
ave_fxQC1 = [ave_fxQC2(1:end/2);ave_fxQC3(end/2+1:end)];
flipfxQC = flipud(ave_fxQC1);
ave_fxQC = 0.5*(ave_fxQC1 + flipfxQC);
zCQ = ave_data(:,1);
zDP = forceQC(:,1);
ddz = (zCQ(2)-zCQ(1));
sum_dens = NNwater(15)/area*1e3;
ave_dens = forceQC(:,3);
%sum_dens = NNwater1/area*1e3;

AA = 2/ddz/ddz;

[rouEQTA, EQTzA] = SolverM(ave_fxQC,zDP,sum_dens,ddz,AA,kb,T) ;

newEQTzA = [zDP(1);EQTzA;zDP(end)];
newrouEQTA = [0;rouEQTA;0];

% QC denoise results
sum_densQC = NNwaterQC(2)/area*1e3;
[rouEQTA2, EQTzA2] = SolverMQC(fx,zCQ,sum_densQC,ddz,AA,kb,T) ;

newEQTzA2 = [zCQ(1);EQTzA2;zCQ(end)];
newrouEQTA2 = [0;rouEQTA2;0];

figure;
%plot(forceQC(:,1)/10,forceQC(:,3) ,'r-','linewidth',2); hold on
plot(newEQTzA2/10,newrouEQTA2 ,'k-','linewidth',2.5); hold on
pp= plot(newEQTzA/10,newrouEQTA ,'ro','linewidth',2.5,'markersize',8); hold on
nummarkers(pp,200); 
%plot(densMD(:,1)/10,densMD(:,2) ,'b--','linewidth',2.5); hold on

xlabel('z (nm)');
ylabel('\rho (nm^{-3})');
plot_style(26);
xlim([0 (xmax+xmim)/10]);
ylim([0 130]);
legend({'Deep Force','MD'},'FontSize',26, 'Location','north')
%legend({'Deep Force','DPMD(truth)','MD'},'FontSize',26, 'Location','north') %4,6,8nm
%rectangle('position',[0 0 1.5 130 ],'facecolor',[0 1 0 0.12],'edgecolor',[0 1 0 0.12]);
rectangle('position',[0 0 1.5 130 ],'facecolor',[0 0.4470 0.7410 0.12],'edgecolor',[0 0.4470 0.7410 0.12]);

%print('-dpng','-r300','DPAIforce20nm.png');

figure;
%plot(forceQC(:,1)/10,forceQC(:,3) ,'r-','linewidth',2); hold on
aa=plot(newEQTzA2/10,newrouEQTA2 ,'k-','linewidth',2.5); hold on
pp2=plot(newEQTzA/10,newrouEQTA ,'ro','linewidth',2.5,'markersize',10); hold on
nummarkers(pp2,150);
% p2 = plot(newEQTzA/10,newrouEQTA,'o','linewidth', 2.0,'markersize',10,'Markeredgecolor',[0.83 0.14 0.14]); hold on
% nummarkers(p2,200);      
% uistack(aa,'top');
%plot(densMD(:,1)/10,densMD(:,2) ,'b--','linewidth',2.5); hold on
        
xlabel('z (nm)');
ylabel('\rho (nm^{-3})');
plot_style(26);
xlim([0 1.5]);
ylim([0 130]);
legend({'Deep Force','DPMD(6nm)'},'FontSize',26, 'Location','northeast')
%legend({'Deep Force','DPMD(6nm)','MD'},'FontSize',26, 'Location','northeast')
%legend({'AbDPQT','Truth'},'FontSize',26, 'Location','northeast')
%print('-dpng','-r300','DPAIforce20nmzoom.png');

figure;
forceQCplt = 0.5*(ave_fxQC2 - flipud(ave_fxQC2));
forceQCplt(1:24) = forceQCplt(25);
%forceQCplt(377:end) = forceQCplt(376); %4nm
forceQCplt(577:end) = forceQCplt(576); %6nm
grayColor = [.7 .7 .7];%[0.4660 0.6740 0.1880];


ave_fxQC6 = -ave_fx;
ave_fxQCf = [ave_fx(1:end/2);ave_fxQC6(end/2+1:end)];

%plot(zCQ/10,ave_fxQCf ,'b-','linewidth',2); hold on
plot(forceIn(:,1)/10,forceIn(:,2) ,'-', 'Color', grayColor,'linewidth',2.5); hold on
plot(zCQ/10,ave_fx ,'k-','linewidth',2.5); hold on
%plot(forceIn(:,1)/10,forceIn(:,2) ,'m--','linewidth',2.5); hold on
pp3 = plot(zDP/10,forceQCplt ,'ro','linewidth',2.5,'markersize',10); hold on
nummarkers(pp3,140);

legend({'Noise F','Denoise F'},'FontSize',26, 'Location','north')
%legend({'Noise F','Denoise F','DPMD(truth)'},'FontSize',26, 'Location','north')
xlabel('z (nm)');
ylabel('force (kcal/mol*A)');
plot_style(26);
xlim([-0.5 xmax/10+0.5]);
ylim([-5 5]);
%print('-dpng','-r300','force20nm.png');

% name8 = sprintf('DeepAIMD20nm.dat');
% fid8 = fopen(name8, 'wt');
% for nn = 1 : length(newrouEQTA2) 
%         fprintf(fid8, '%12.6e  %12.6e\n', newEQTzA2(nn), newrouEQTA2(nn,1));
% end
