function graphsBuilder(x, y, tit)
    figure()
    hold on
    LineSpec = {'LineWidth',3,'Color',1/255*[190,143,158]};
    plot(x, y, LineSpec{:}); 
    title(tit);
    set(gca,'FontSize',20,'FontName','Avenir')
    hold off
end