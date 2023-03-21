function helperGraphicsOpt(ChannelId)
    ax = gca;
    ax.XDir = 'reverse';
    ax.ZLim = [0 120];
    ax.Title.String = ['Input Channel: ' num2str(ChannelId)];
    ax.XLabel.String = 'Frequency (Hz)';
    ax.YLabel.String = 'Time (seconds)';
    ax.View = [30 45];
end