function drawTimeLine(objH,data)
objH.timelineGraph = barh(data, 'stack');
set(objH.timelineGraph(1), 'facecolor', 'none', 'EdgeColor', 'none'); % disable the color of the first column (init time)
set(gca, 'YTickLabel', 'boog' ); % change the y axis tick to your name of the process
axis ij; % Put the first row at top
end