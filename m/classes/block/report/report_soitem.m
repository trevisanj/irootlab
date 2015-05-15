%> @brief Base for all reports that operate on a @ref soitem object
classdef report_soitem < irreport
    methods
        function o = report_soitem()
            o.classtitle = 'System optimization item';
            o.inputclass = ''; % This class is a base class
            o.flag_params = 0;
        end;
    end;

    % *-*-*-*-*-*-*-* TOOLS
    methods
        function s = get_standardheader(o, obj)
            s = ['<h1>', o.get_description(), '</h1>', 10, '<p>Input description: <b>', obj.get_description(), '</b></p>', 10, ...
                 iif(~isempty(obj.dstitle), ['<p>Input dataset: <b>', obj.dstitle, '</b></p>', 10], '')];
        end;

        %> Creates curves from sovalues object.
        function s = images_1d(o, sor)
            s = '';
            flag_many = size(sor.values, 2) > 1;

            % First part

            u = vis_sovalues_drawplot();
            u.dimspec = {[0 0], [1 2]};
            u.valuesfieldname = 'rates';
            u.flag_legend = 1;
            u.flag_star = 1;
            u.ylimits = [];
            u.xticks = [];
            u.xticklabels = {};
            u.flag_hachure = ~flag_many;


            % Creates legend image
            if flag_many
                % Legend is only justified if there is more than one curve
                figure;u.use(sor);
                fnleg = find_filename('irr_image', [], 'png');
                save_legend(o.gff(fnleg), 150); % High DPI because this may be the only opportunity to have the legend
                close;
            end;


            figure;
            subplot(1, 2, 1);
            u.use(sor);
            legend off;

            u.valuesfieldname = 'times3';
            subplot(1, 2, 2);
            u.use(sor);
            legend off;

            pause(.1);
            maximize_window(gcf(), 4);

            s = cat(2, s, o.save_n_close());

            if flag_many
                s = cat(2, s, o.get_imgtag(fnleg, 10, 0));
            end;


            % Second part: the hachured sub-images

            if flag_many
                u = vis_sovalues_drawsubplot();
                u.dimspec = {[0 0], [1 2]};
                u.valuesfieldname = 'rates';
                u.ylimits = [];
                u.xticks = [];
                u.flag_star = 1;
                u.xticklabels = {};
                figure;u.use(sor);

                s = cat(2, s, o.save_n_close());

                u.valuesfieldname = 'times3';
                figure;u.use(sor);

                s = cat(2, s, o.save_n_close());
            end;
        end;

        %*****************************************************************************************************************************************
        
        %> Creates 2d image maps from sovalues object.
        function s = images_2d(o, sor)
            view_ratetimesubimages(sor);
            maximize_window();

            s = o.save_n_close();
        end;
    end;
end
