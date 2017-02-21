function pixelLine = thin_and_sort(a)
    thinned = bwmorph(a, 'thin', Inf);
    boundaries = bwboundaries(thinned);
    [xend,yend] = find( bwmorph(thinned,'endpoints') == 1 );
    b1 = find(boundaries{1}(:,1) == xend(1) & boundaries{1}(:,2) == yend(1));
    b2 = find(boundaries{1}(:,1) == xend(2) & boundaries{1}(:,2) == yend(2));
    pixelLine = boundaries{1}(min(b1,b2):max(b1,b2),:);
end