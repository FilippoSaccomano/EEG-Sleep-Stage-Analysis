function t1 = hypnogram(filtered_sleep_stage, epoch_duration)
    t1 = (1:length(filtered_sleep_stage)) * epoch_duration / 60;
    figure;
    colors = [0.8 0 0; 0.2 0.6 1; 0 0 0.8];
    start_idx = 1;
    for i = 2:length(filtered_sleep_stage)
        if filtered_sleep_stage(i) ~= filtered_sleep_stage(i-1)
            draw_rectangle(t1, start_idx, i - 1, filtered_sleep_stage(start_idx), epoch_duration, colors);
            start_idx = i;
        end
    end
    draw_rectangle(t1, start_idx, length(filtered_sleep_stage), filtered_sleep_stage(start_idx), epoch_duration, colors);
    hold on;
    plot(t1, filtered_sleep_stage, 'LineWidth', 2, 'Color', [0.2 0.6 1 0.2]);
    set(gca, 'YDir', 'reverse');
    xlim([0 max(t1)]);
    ylim([-0.2 2.2]);
    yticks([0.1 0.6 1.5]);
    yticklabels({'Awake', 'REM', 'NREM'});
    xlabel('Time (minutes)', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('Sleep Stage', 'FontSize', 12, 'FontWeight', 'bold');
    title('Hypnogram', 'FontSize', 14, 'FontWeight', 'bold');
    grid on;
    grid minor;
    set(gca, 'GridAlpha', 0.3);
    set(gca, 'FontSize', 12);
    box on;
end

function draw_rectangle(t1, start_idx, end_idx, stage, epoch_duration, colors)
    width = (end_idx - start_idx + 1) * epoch_duration / 60;
    x = t1(start_idx);
    cur = [0.4 0.1];
    
    if stage == 0
        rectangle('Position', [x 0 width 0.2], 'FaceColor', colors(1,:), 'EdgeColor', 'none','Curvature', cur);
    elseif stage == 1
        rectangle('Position', [x 0.2 width 0.8], 'FaceColor', colors(2,:), 'EdgeColor', 'none','Curvature', cur);
    elseif stage == 2
        rectangle('Position', [x 1 width 1], 'FaceColor', colors(3,:), 'EdgeColor', 'none','Curvature', cur);
    end
end
