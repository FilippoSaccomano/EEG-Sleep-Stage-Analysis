function t1 = hypnogram(filtered_sleep_stage, epoch_duration)
% HYPNOGRAM Generate visual hypnogram of sleep stages over time
%
% Creates a color-coded visualization of sleep stage progression throughout
% a sleep recording. The hypnogram is a standard tool in sleep medicine
% for visualizing sleep architecture.
%
% Inputs:
%   filtered_sleep_stage - Vector of sleep stages (0=Awake, 1=REM, 2=NREM)
%   epoch_duration       - Duration of each epoch in seconds (typically 30)
%
% Outputs:
%   t1 - Time vector in minutes (1 x n_epochs)
%
% The function generates a figure with:
%   - Color-coded rectangles showing sleep stages
%   - Red: Awake (y = 0-0.2)
%   - Light blue: REM (y = 0.2-1.0)
%   - Dark blue: NREM (y = 1.0-2.0)
%
% Example:
%   t1 = hypnogram(filtered_sleep_stage, 30);
%
% See also: RECTANGLE, PLOT

    % Convert epoch indices to time in minutes
    t1 = (1:length(filtered_sleep_stage)) * epoch_duration / 60;
    
    figure;
    
    % Define colors for each sleep stage
    colors = [0.8 0 0;      % Red for Awake
              0.2 0.6 1;    % Light blue for REM
              0 0 0.8];     % Dark blue for NREM
    
    % Draw colored rectangles for each continuous stage period
    start_idx = 1;
    for i = 2:length(filtered_sleep_stage)
        % Detect stage transition
        if filtered_sleep_stage(i) ~= filtered_sleep_stage(i-1)
            % Draw rectangle for previous stage
            draw_rectangle(t1, start_idx, i - 1, filtered_sleep_stage(start_idx), epoch_duration, colors);
            start_idx = i;
        end
    end
    % Draw final rectangle
    draw_rectangle(t1, start_idx, length(filtered_sleep_stage), filtered_sleep_stage(start_idx), epoch_duration, colors);
    
    % Overlay line plot with transparency
    hold on;
    plot(t1, filtered_sleep_stage, 'LineWidth', 2, 'Color', [0.2 0.6 1 0.2]);
    
    % Configure axes
    set(gca, 'YDir', 'reverse');  % Awake at top, NREM at bottom
    xlim([0 max(t1)]);
    ylim([-0.2 2.2]);
    yticks([0.1 0.6 1.5]);
    yticklabels({'Awake', 'REM', 'NREM'});
    
    % Labels and formatting
    xlabel('Time (minutes)', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('Sleep Stage', 'FontSize', 12, 'FontWeight', 'bold');
    title('Hypnogram', 'FontSize', 14, 'FontWeight', 'bold');
    
    % Grid and styling
    grid on;
    grid minor;
    set(gca, 'GridAlpha', 0.3);
    set(gca, 'FontSize', 12);
    box on;
end

function draw_rectangle(t1, start_idx, end_idx, stage, epoch_duration, colors)
% DRAW_RECTANGLE Helper function to draw colored rectangle for sleep stage
%
% Inputs:
%   t1           - Time vector in minutes
%   start_idx    - Starting epoch index
%   end_idx      - Ending epoch index
%   stage        - Sleep stage (0, 1, or 2)
%   epoch_duration - Duration of each epoch in seconds
%   colors       - Color matrix (3x3) for each stage

    % Calculate rectangle width in minutes
    width = (end_idx - start_idx + 1) * epoch_duration / 60;
    x = t1(start_idx);
    
    % Curvature for rounded corners
    cur = [0.4 0.1];
    
    % Draw rectangle based on sleep stage
    if stage == 0  % Awake
        rectangle('Position', [x 0 width 0.2], ...
                 'FaceColor', colors(1,:), ...
                 'EdgeColor', 'none', ...
                 'Curvature', cur);
    elseif stage == 1  % REM
        rectangle('Position', [x 0.2 width 0.8], ...
                 'FaceColor', colors(2,:), ...
                 'EdgeColor', 'none', ...
                 'Curvature', cur);
    elseif stage == 2  % NREM
        rectangle('Position', [x 1 width 1], ...
                 'FaceColor', colors(3,:), ...
                 'EdgeColor', 'none', ...
                 'Curvature', cur);
    end
end
