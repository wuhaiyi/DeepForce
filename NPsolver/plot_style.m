function plot_style(fontSize)
%namesx={'PZC-1.48V'; 'PZC-0.72V'; 'PZC';' PZC+0.9V'; 'PZC+1.43V'  };


set(gca,'fontsize',fontSize,'FontWeight', 'Bold','Fontname','Arial');
set(gca,'linewidth',2);


% set(get(gca,'xlabel'),'FontSize', fontSize,'FontWeight', 'Bold','Fontname','Arial');
% set(get(gca,'ylabel'),'FontSize', fontSize,'FontWeight', 'Bold','Fontname','Arial');
% set(gca,'xticklabel','FontSize', fontSize,'Fontname','Arial')

% set(gca,'fontsize',fontSize,'fontweight','bold','Fontname','Arial');
% set(gca,'linewidth',1);
% set(get(gca,'xlabel'),'FontSize', fontSize, 'FontWeight', 'Bold','Fontname','Arial');
% set(get(gca,'ylabel'),'FontSize', fontSize, 'FontWeight', 'Bold','Fontname','Arial');
% set(gca,'xtick',[0 1 2 3]);
%set(gca,'xticklabel',[PZC-1.48 PZC-0.72 PZC PZC+0.9 PZC+1.43],'Fontname','Arial');
% set(gca,'ytick',[0 0.2 0.4 0.6 0.8]);
%set(gca,'yticklabel',[],'Fontname','Arial');
end
