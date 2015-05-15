%> @brief Classifiers base class
%>
%> A classifier is a block that outputs class probabilities for each observation. Output is given as an @c
%> estimato dataset.

classdef clssr < block
    properties(SetAccess=protected)
        classlabels = {};
    end;
    
    properties(SetAccess=protected)
        no_outputs;
    end;
        


    properties
        flag_datay = 0; % means data.classes are to be ignored and data.Y to be used as target. Basically defineas a regression problem.
    end;

    
    
    methods
        function o = clssr(o)
            o.classtitle = 'Classifier';
            o.flag_trainable = 1;
            o.flag_bootable = 1;
            o.color = [157, 0, 0]/255;
        end;
        
        %> @brief Resets @ref classlabels and calls @ref clssr::boot()
        function o = boot(o)
            o.classlabels = {};
            
            o = boot@block(o);
        end;

        
        function z = get.no_outputs(o)
            z = o.get_no_outputs();
        end;
        
        % Renumbers data classes to match o.classlabels order
        function classes  = get_classes(o, data)
            classes = renumber_classes(data.classes, data.classlabels, o.classlabels);
        end;
        

        
        
        function o = draw_domain(o, parameters)
            if o.nf ~= 2
                irerror('Domain needs to be 2-dimensional!');
            end;

            o.do_draw_domain(parameters);
            make_box();
        end;

    end;
    
    
    methods(Access=protected)
        function z = get_no_outputs(o)
            z = length(o.classlabels);
        end;
    
        % Fields expected in params:
        %     .x_range
        %     .y_range
        %     .x_no
        %     .y_no
        %     .ds_train
        
        % TODO needs see what to do with estimation
        function o = do_draw_domain(o, params)
            
            de = decider();


            % classification regions
            flag_regions = ~o.flag_datay && isfield(params, 'flag_regions') && params.flag_regions;
            if flag_regions
                [Q1, Q2] = meshgrid(linspace(params.x_range(1), params.x_range(2), params.x_no), ...
                                    linspace(params.y_range(1), params.y_range(2), params.y_no));
                X_map = [Q1(:) Q2(:)];

                ds = irdata();
                ds.X = X_map;


                est = o.use(ds);
                est = de.use(est);

                classes_map_block = zeros(params.y_no, params.x_no);
                for i = 1:params.x_no
                    classes_map_block(:, i) = est.classes((i-1)*params.y_no+1:i*params.y_no);
                end;

                h = pcolor(Q1, Q2, classes_map_block);

                vtemp = unique(est.classes);
                for i = 1:numel(vtemp)
                    color_matrix(i, :) = rgb(find_color(vtemp(i)+1));
                end;

                colormap(color_matrix);
                shading flat;
                alpha(h, 0.4);
                hold on;
            end;



            % training points
            flag_ds_train = isfield(params, 'ds_train') && ~isempty(params.ds_train);
            if flag_ds_train
                if ~o.flag_datay
                    pieces = data_split_classes(params.ds_train);
                else
                    pieces = params.ds_train;
                end;

                ihandle = 1;
                for i = 1:length(pieces)
                    if ~o.flag_datay
                        i_class = renumber_classes(pieces(i).classes(1), pieces(i).classlabels, o.classlabels);
                    else
                        i_class = 0;
                    end;

                    no = size(pieces(i).X, 1);

                    hh = plot3(pieces(i).X(:, 1), pieces(i).X(:, 2), ones(no, 1)*1, 'Color', find_color(i_class+1), ...
                              'Marker', find_marker(i_class+1), 'MarkerFaceColor', find_color(i_class+1), 'LineStyle', 'none', ...
                              'MarkerSize', find_marker_size(i_class+1));
                    if ~isempty(hh)
                        handles(ihandle) = hh(1);
                        ihandle = ihandle+1;
                    end;
                    hold on;
                end

            end;

            flag_ds_test = isfield(params, 'ds_test') && ~isempty(params.ds_test);
            if flag_ds_test
                if ~o.flag_datay
                    pieces = data_split_classes(params.ds_test);
                else
                    pieces = params.ds_test;
                end;

                ihandle = 1;
                for i = 1:length(pieces)
                    if ~o.flag_datay
                        i_class = renumber_classes(pieces(i).classes(1), pieces(i).classlabels, o.classlabels);
                    else
                        i_class = 0;
                    end;

                    no = size(pieces(i).X, 1);

                    hh = plot3(pieces(i).X(:, 1), pieces(i).X(:, 2), ones(no, 1)*1, 'LineWidth', 2, 'Color', 'k', ...
                               'Marker', find_marker(i_class+1), 'MarkerFaceColor', find_color(i_class+1), 'LineStyle', 'none', ...
                               'MarkerSize', find_marker_size(i_class+1)*1.5);
                    if ~isempty(hh)
                        handles(ihandle) = hh(1);
                        ihandle = ihandle+1;
                    end;
                    hold on;
                end

            end;


            if flag_ds_train || flag_ds_test
                % Ok, this is gonna give an error if only the test data exists, but... this is life
                feanames = params.ds_train.get_fea_names([1, 2]);
                xlabel(feanames{1});
                ylabel(feanames{2});
            end;


            % plot_piece(pieces_train(1).X, find_color(1));
            % alpha(gco, 1);
            % hold on;
            % plot_piece(pieces_train(2).X, find_color(2));
            % alpha(gco, 1);
            % 
            % plot_piece(pieces_test(1).X, find_color(1), 1);
            % alpha(gco, 0.5);
            % hold on;
            % plot_piece(pieces_test(2).X, find_color(2), 1);
            % alpha(gco, 0.5);
            % 

            % gscatter(X_map(:, 1), X_map(:, 2), classes_map, COLORS);
            axis([params.x_range(1), params.x_range(2), params.y_range(1), params.y_range(2)]);
            % legend off;

            format_frank(gcf);


        end;
    end;
end    