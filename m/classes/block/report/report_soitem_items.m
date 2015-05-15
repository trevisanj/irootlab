%> @brief Shows curves or images from foldmerge of some model selection (e.g. clarchsel or fearchsel)
%>
classdef report_soitem_items < report_soitem
    methods
        function o = report_soitem_items()
            o.classtitle = 'Curves/Images from Model Selection';
            o.inputclass = 'soitem_items';
            o.flag_params = 0;
        end;
    end;
    
    
    
    methods(Access=protected)
        function out = do_use(o, obj)
            s = '';

            if numel(obj.items) > 0 && ~isempty(obj.items{1}.sovalues) % Avoids error when items is empty
            
                % Extract sovalues from soitem_items
                out = obj.extract_sovalues();
                sov = out;

                nd = ndims(sov.values);
                if nd == 3
                    %   If 3D, plot all images slicing through the second dimension
                    p = vis_sovalues_drawimage();
                    p.dimspec = {[1 0 0], [1 2]};
                    p.valuesfieldname = 'rates';
                    p.clim = [];
                    p.flag_logtake = 0;
                    p.flag_transpose = 0;
                    p.flag_star = 0;
                    v_image = p;

                    no_cases = size(sov.values, 1);
                    for i = 1:no_cases
                        v_image.dimspec = {[i 0 0], [1 2]};

                        figure;
                        v_image.use(sov);
                        maximize_window(); s = cat(2, s, o.save_n_close());
                    end;
                elseif nd == 2
                    %   If 2D, extract dataset and plot 3 things:
                    p = blbl_extract_ds_from_sovalues();
                    p.dimspec = {[0 0], [1 2]};
                    p.valuesfieldname = 'rates';
                    blbl_extract_ds_from_sovalues01 = p;

                    [blbl_extract_ds_from_sovalues01, out] = blbl_extract_ds_from_sovalues01.use(sov);
                    ds = out;

                    %     - Hachures
                    p = vis_hachures();
                    vis_hachures01 = p;
                    figure;
                    vis_hachures01.use(ds);
                    a = get(gca, 'title');
                    set(a, 'string', ['Std hachures & Averages - ', sov.ax(2).label, ' - "', get(a, 'string'), '"']);
                    maximize_window([], 2.5);
                    s = cat(2, s, o.save_n_close());

                    %     - Individual curves + average
                    p = vis_alldata();
                    vis_alldata01 = p;
                    figure;
                    vis_alldata01.use(ds);
                    hold on;
                    p = vis_means();
                    p.flag_pieces = 0;
                    vis_means01 = p;
                    vis_means01.use(ds);
                    a = get(gca, 'title');
                    set(a, 'string', ['Individual & Averages - ', sov.ax(2).label, ' - "', get(a, 'string'), '"'])
                    set(gca(), 'ylim', [min(ds.X(:)), max(ds.X(:))]);
                    make_box();
                    maximize_window([], 2.5);
                    s = cat(2, s, o.save_n_close());

% What for??? % %                     %     - Averages only
% % %                     figure;
% % %                     vis_means01.use(ds);
% % % %                     maximize_window([], 2.5);
% % %                     a = get(gca, 'title');
% % %                     set(a, 'string', ['Averages - ', sov.ax(2).label, ' - "', get(a, 'string'), '"']);
% % %                     maximize_window([], 2.5);
% % %                     s = cat(2, s, o.save_n_close());
                end;
            end;            

            out = log_html();
            out.html = [o.get_standardheader(obj), s];
            out.title = obj.get_description();
        end;
    end;
end
