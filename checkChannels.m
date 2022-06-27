% check channels

cfg = [];
cfg.layout = 'biosemi32.lay';
cfg.layout = ft_prepare_layout(cfg);
figure; ft_plot_layout(cfg.layout)

cfg = [];
cfg.layout = 'biosemi32_1.lay';
cfg.layout = ft_prepare_layout(cfg);
figure; ft_plot_layout(cfg.layout)

cfg = [];
cfg.layout = 'biosemi32_2.lay';
cfg.layout = ft_prepare_layout(cfg);
figure; ft_plot_layout(cfg.layout)