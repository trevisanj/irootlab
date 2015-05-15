%> @ingroup paper_cross
%> @file
%> @brief Abstract class to return datasets
%>
%> By convention, the "type" code is:
%> @arg @c 1 - training/design dataset
%> @arg @c 2 - test dataset
%> @arg @c 3 - who knows the future
classdef dataloader
    properties
        %> Class label of the reference class
        reflabel = [];
        
        %> Title for showing in reports
        title = '';
        
        %> =0. one-versus-reference index. 0-multi-class dataset
        ovrindex = 0;
        %> =0. cross-validation split index. 0-whole dataset
        cvsplitindex = 0;
        %> = 1. Train-test split indexes. 1-train; 2-test; [1,2] - both (2 datasets will be given by get_dataset())
        ttindex = 1;
        
        
        % Cross-validation properties
        
        %> =2938123. For cross-validation splits
        randomseed = 2938123;
        
        %> =10, of course. Cross-validation "k"
        k = 10;
        
        flag_group = 1;
        
        basefilename = []; 
    end;
    
    
    methods
        %> Returns a string to identify "where from" we are running (which computer).
        function s = get_where(o) %#ok<MANU>
            s = get_computer_name();
        end;

        
% % % % % %         %> Returns the smallest possible dataset, used for determining the number of classes a priory
% % % % % %         function ds = load_smallest(o)
% % % % % %             try
% % % % % %                 ds = o.do_load_smallest();
% % % % % %             catch ME %#ok<*NASGU>
% % % % % %                 irverbose('Info (dataloader): do_load_smallest() failed, using default get_raw()');
% % % % % %                 ds = o.get_raw(1);
% % % % % %             end;
% % % % % %         end;
    end;
    
% % % % % % %     methods(Access=protected)
% % % % % % %         %> Defaults to get_raw()
% % % % % % %         function ds = do_load_smallest(o)
% % % % % % %             ds = o.get_raw(o, 1);
% % % % % % %         end;
% % % % % % %     end;
        
    
    methods(Sealed)
% % % % % % % %         %> OVR - "One-Versus-Reference"
% % % % % % % %         %>
% % % % % % % %         %> This method is here pretty much because this is the class who knows which data class the reference class is
% % % % % % % %         function dss = get_ovr(o, ds)
% % % % % % % %             refindex = find(strcmp(ds.classlabels, o.reflabel));
% % % % % % % %             if isempty(refindex)
% % % % % % % %                 irerror(sprintf('Dataset does not have the reference class "%s"!', o.reflabel));
% % % % % % % %             end;
% % % % % % % %             
% % % % % % % %         
        %> Loads the smallest possible dataset to get its number of classes
        function nc = get_nc(o)
            ds = o.get_basedataset();
            nc = ds.nc;
        end;
    end;

    methods(Access=protected)
        function s = get_filename_internal(o, ovrindex_, cvsplitindex_, ttindex_)
            [route, name, ext] = fileparts(o.basefilename); %#ok<NASGU>
            s = fullfile(route, sprintf('subds_%s_ovr%02d_cv%02d_tt%1d.mat', name, ovrindex_, cvsplitindex_, ttindex_));
        end;

    end;
    
    methods(Static)
        function ds = load_dataset(fn)
            classname = detect_file_type(fn);
            if isempty(classname)
                irerror(sprintf('Could not detect type of file ''%s''', fn));
            else
                oio = eval([classname, '();']);
                oio.filename = fn;
                ds = oio.load();
            end;
        end;
    end;

    methods(Sealed)
        function pieces = split_dataset(o, ds)
            osgs = sgs_crossval();
            osgs.no_reps = o.k;
            osgs.flag_perclass = 1; % I have made this obligatory to ensure that all classes are present in every training and test dataset
            osgs.flag_group = o.flag_group && ~isempty(ds.groupcodes); % splits per group if there are groups in dataset
            osgs.flag_perclass = 1;
            osgs.randomseed = o.randomseed;
            
            obsidx = osgs.get_obsidxs(ds);
            pieces = ds.split_map(obsidx);
        end;

        
        function s = get_filename(o)
            s = o.get_filename_internal(o.ovrindex, o.cvsplitindex, o.ttindex);
        end;
        
        function ds = get_dataset(o)
            fn = o.get_filename();
            ds = o.load_dataset(fn);
        end;
        
        function ds = get_basedataset(o)
            fn = o.basefilename;
            ds = o.load_dataset(fn);
        end;
        
        
        %> Writes several dataset to file!
        function o = create_splits(o)
            fn = o.basefilename;
            ds = o.load_dataset(fn);
            basetitle = ds.title;
            ds.title = [ds.title, iif(isempty(ds.title), '', ' - '), sprintf('All %d classes', ds.nc)];
            
            
            
            oio = dataio_mat();
            
            
            % First the single (non-OVR) datasets
            pieces = o.split_dataset(ds);
            for i = 1:size(pieces, 1)
                for j = 1:2
                    oio.filename = o.get_filename_internal(0, i, j);
                    oio.save(pieces(i, j));
                end;
            end;
                    
            

            if ds.nc > 2
                % Now the OVR cases

                refindex = find(strcmp(ds.classlabels, o.reflabel));
                if isempty(refindex)
                    irerror(sprintf('Dataset does not have the reference class "%s"!', o.reflabel));
                end;

                pieces0 = data_split_classes(ds);

                p = 0;
                for m = 1:ds.nc
                    if m ~= refindex
                        p = p+1;
                        ds2 = data_merge_rows(pieces0([m, refindex]));
                        ds2.title = [basetitle, iif(isempty(basetitle), '', ' - '), sprintf('%s vs. %s', pieces0(m).classlabels{1}, pieces0(refindex).classlabels{1})];
                        
                        
                        pieces = o.split_dataset(ds2);
                        for i = 1:size(pieces, 1)
                            for j = 1:2
                                oio.filename = o.get_filename_internal(p, i, j);
                                oio.save(pieces(i, j));
                            end;
                        end;
                    end;
                end;
            end;
        end;
        
    end;

end
