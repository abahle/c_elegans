ang = angles';

[U,S,V] = svd(ang);
SS = cell(1,10);
SS{1,10} = S;
for i = 1:9
    SS{i} = S;
    SS{i}(:,i+1:end) = 0;
end

% figure, hold on
% for ii = 1:10
%     rec = (U*SS{ii}*V')';
%     plot((sum(abs(angles)-abs(rec),2)),'k-o')
% end

%title('residuals for angles and compressed reconstructions')
rec = cell(1,10);
figure, hold on
for ii = 1:10
    rec{ii} = (U*SS{ii}*V')';
    plot((rms((angles)-(rec{ii}),2)),'-','color',g(ii,:),'markersize',5)
end
title('rms of residuals')


cbrew_init=colorbrewer.div.RdBu{length(colorbrewer.div.RdBu)};
CT=interpolate_cbrewer(cbrew_init, 'PCHIP', 100);
CT=CT./255;
    
figure, subplot(2,1,1)
imagesc(angles), xlim([1500,3000]), colorbar, colormap(gca,CT),caxis([-pi,pi]), axis off
xlabel('seg angle'),ylabel('frame number')
subplot(2,1,2),
imagesc(angles-rec{1,4}), xlim([1500,3000]), colorbar, colormap(gca,CT),caxis([-pi,pi]), axis off
xlabel('seg angle'),ylabel('frame number')


figure, subplot(2,1,1)
imagesc(angles), xlim([1500,2000]),ylim([0,10]), colorbar,  colormap(gca,CT),caxis([-pi,pi]), axis off
xlabel('seg angle'),ylabel('frame number')
subplot(2,1,2)
imagesc(angles-rec{1,4}), xlim([1500,2000]),ylim([0,10]), colorbar,  colormap(gca,CT),caxis([-pi,pi]), axis off
xlabel('seg angle'),ylabel('frame number')


figure, subplot(2,1,1)
imagesc(angles), xlim([1500,2000]),ylim([50,60]), colorbar,  colormap(gca,CT),caxis([-pi,pi]), axis off
xlabel('seg angle'),ylabel('frame number')
subplot(2,1,2)
imagesc(angles-rec{1,4}), xlim([1500,2000]),ylim([50,60]), colorbar,  colormap(gca,CT),caxis([-pi,pi]), axis off
xlabel('seg angle'),ylabel('frame number')



