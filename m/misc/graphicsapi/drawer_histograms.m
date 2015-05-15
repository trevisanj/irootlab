% @todo This is the only place where rank-wise histograms are drawn as lines. I had to deactivate this to simplify things. In the future, a "vis_rankwisehists" could be created
% %> @ingroup graphicsapi
% %> @brief Draws 2 subplots, one with individual rank-wise hits, and on the right, a histogram using given subsetsprocessor
% %>
% %> This class is auxiliary for report generation
% classdef drawer_histograms
%     properties
%         peakdetector;
% %         subsetsprocessor_fixed;
%         subsetsprocessor;
%         flag_legends = 0;
%     end;
%     
%     methods
%         %> 3 subplots
%         %> @param log log_fselrepeater
%         function hist = draw(o, log)
%             ds_hint = load_data_hint();
% 
% 
%             % First shows the individual individual per-selection-order histograms as lines overlapping each other
%             ssp = subsetsprocessor(); %#ok<CPROP,PROP>
%             hist = ssp.use(log);
%             
%             subplot(1, 2, 1);
%             hist.draw_as_lines();
% %             title('Individual histograms');
%             xlabel(''); ylabel('');
%             freezeColors();
%             if ~o.flag_legends; legend off; end;
%             set(gca, 'outerposition', [0, 0.03, .48, .97])
%             set(gca, 'color', 1.15*[0.8314    0.8157    0.7843]);
%             
% 
%             
%             % Second plot is a stacked histogram calculated using the subsetsprocessor
%             ssp = def_subsetsprocessor(o.subsetsprocessor);
%             hist = ssp.use(log);
% 
%             subplot(1, 2, 2);
%             hist.draw_stackedhists(ds_hint, {[], .8*[1 1 1]}, def_peakdetector(o.peakdetector));
% %             title(sprintf('# informative features: %d', hist.nf4grades));
%             xlabel(''); ylabel('');
%             freezeColors();
%             if ~o.flag_legends; legend off; end;
%             set(gca, 'outerposition', [.5, 0.03, .48, 0.97]);
%             set(gca, 'color', 1.15*[0.8314    0.8157    0.7843]);
% 
%             
%             set(gcf, 'InvertHardCopy', 'off'); % This is apparently needed to preserve the gray background
%             set(gcf, 'color', [1, 1, 1]);
%         end;
%         
%         %> 3 subplots
%         %> @param log log_fselrepeater
%         function o = draw_for_legend(o, log)
%             ds_hint = [];
%             
%             ssp = subsetsprocessor(); %#ok<CPROP,PROP>
%             hist = ssp.use(log);
% 
%             % Second plot is a stacked histogram with all features informative
%             hist.draw_stackedhists(ds_hint, {[], [.8, .8, .8]}, def_peakdetector(o.peakdetector));
%             freezeColors();
%         end;
%     end;
% end
