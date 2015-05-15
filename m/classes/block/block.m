%> @brief Base Block class
classdef block < irobj
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Potentially re-set when inheriting a block
    properties(SetAccess=protected)
        %> ='irdata'. (High-Level setting) Class or classes (can be string or cell of strings) that the block can deal with.
        %> Allows for @c objtool and @c datatool to know (when appropriate) which blocks are applicable to the selected object(s).
        inputclass = 'irdata';
        %> =0. (High-Level setting and internal function) Whether or not the block is bootable.
        flag_bootable = 0;
        %> =0. (High-Level + internal function). Whether or not the block can be trained, or completely non-data-based.
        flag_trainable = 0;

        %> =0. (internal function). Whether or not the block accepts incremental training. The meaning is:
        %> @arg If YES, it means that the block can adapt/evolve everytime its train() method is called
        %> @arg If NO, the block can be trained only once, and calling its train() method many times can lead to unpredictable results
        flag_incrtrain = 0;

        
        %> =1. (internal function) If true, dataset number of features will be checked upon training and using. Ignored if o.flag_trainable is 0.
        flag_fixednf = 1;
        %> =0. (internal function) If true, dataset number of observations will be checked upon training and using. Ignored if o.flag_trainable is 0.
        flag_fixedno = 0;
        
        %> =0. (High-Level setting (@ref gencode)) Whether block allows/expects multiple objects as input.
        flag_multiin = 0;
        %> =1. (High-Level setting (@ref gencode)) Whether the block generates any output at all (counterexample: @ref vis blocks)
        flag_out = 1;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% How to deal with the question of inliers/outliers!
        
        %> If true, train() will pass on to do_train() a dataset with inliers only.
        %> If this flag is true, @ref flag_train_require_inliers will be ignored, because @ref flag_train_inliers_only being true is one way to solve the "inliers requirement".
        flag_train_inliers_only = 0;
        
        %> =1. If true, train() will give an error if the dataset has outliers. This is true by default, because the developer should
        %> be aware of outliers being inputted into a training algorithm.
        flag_train_require_inliers = 1;
    end;

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Internal operation
    properties(SetAccess=protected)
        %> =-1. Number of features. Cleared at boot(), assigned or reinforced at train().
        nf = -1;
        %> =-1. Number of observations.
        no = -1;
        %> =0. Set to 1 by train() if training is successful; set back to 0 after booting.
        flag_trained = 0;
        %> =0. Set to 1 by boot() after booting the block
        flag_booted = 0;
        
        %> Trainings time
        time_train = 0;
        %> Use time
        time_use = 0;
    end;
                    
    methods(Access=private)
        
        %block_assert_trained: Makes sure that the block is trained [before used]
        function o = assert_trained(o)
            if o.flag_trainable > 0 && ~o.flag_trained
                irerror(sprintf('Tried to use block of class ´%s´ before training', class(o)));
            end;
        end;
        
        %block_assert_nf: Makes sure that the number of features is compatible with the block
        function o = assert_nonf(o, data)
            if o.flag_trainable > 0
                if o.flag_fixednf
                    for i = 1:length(data)
                        if o.nf ~= data(i).nf
                            irerror(sprintf('Incorrect number of features: %d (should be %d)', data(i).nf, o.nf));
                        end;
                    end;
                end;
                if o.flag_fixedno
                    for i = 1:length(data)
                        if o.no ~= data(i).no
                            irerror(sprintf('Incorrect number of observations: %d (should be %d)', data(i).no, o.no));
                        end;
                    end;
                end;
            end;
        end;
       
    end;
        
    
    methods(Access=protected)
        % "do" method is for pure implementation of the related functionality, opposed to its public counterpart 
        % which deals with bureaucracy
        function o = do_train(o, data) %#ok<INUSD>
        end;
        
        % "do" method is for pure implementation of the related functionality, opposed to its public counterpart 
        % which deals with bureaucracy
        function data = do_use(o, data)
        end;
        
        
        %> @brief Boots the block
        %>
        %> Abstract. Booting accounts for clearing any recordings; model structure; stored data etc from the object so that it can
        %> be re-used anew.
        function o = do_boot(o)
        end;
    end;

    
    
    methods
        function o = block()
            o.classtitle = 'Block';
        end;
    end;

    
    
    
    methods
        %> Abstract. Method to get the per-feature grades. BMTool stuff.
        function z = get_grades(o, params)
            irerror('Block does not calculate per-feature grades!');
        end;

        %> Abstract. Method to get block title based on passed parameters. BMTool stuff.
        function z = get_gradeslegend(o, params)
            if ~isstr(o.title)
                z = [o.classtitle];
            else
                z = o.title;
            end;
        end;

        %> @brief Applies block to data.
        function varargout = use(o, data)
            % BTW there is no point in the "o =" i.e. the assignment, because the block won't output itself anyway
            o.assert_trained();
            o.assert_nonf(data);

            t = tic();
            o.time_use = 0;
            out = o.do_use(data);
            if o.time_use == 0
                % Default time recording
                o.time_use = toc(t);
            end;
            if nargout == 1
                varargout = {out};
            else
                varargout = {o, out};
            end;
        end;
        
        
        %> @brief Trains block.
        function o = train(o, data, varargin)
            if o.flag_bootable && ~o.flag_booted
                irerror('Block needs to be booted first!');
            end;
            
            if o.flag_trainable > 0
                if o.flag_trained && o.flag_incrtrain
                    o.assert_nonf(data);
                end
                
                if (o.flag_train_inliers_only || o.flag_train_require_inliers) && any(data.classes < 0)
                    if o.flag_train_inliers_only
                        data = data_select_inliers(data);
                    else
                        irerror(sprintf('Dataset contains rows with class < 0, but block of class "%s" requires dataset with inliers only (select inliers first)!', class(o)));
                    end;
                end;
                    
                o.no = data(1).no; % Please note that if do_train() gives an error, this won't  have effect
                o.nf = data(1).nf;

                o.time_train = 0;
                t = tic();
                o = o.do_train(data, varargin{:});
                if o.time_train == 0
                    % Default time recording
                    o.time_train = toc(t);
                end;
            end;
            o.flag_trained = 1;
        end;
        
        %> @brief Configures the structure to deal with new type of data
        %>
        %> Booting accounts for clearing any recordings; model structure; stored data etc from the object so that it can
        %> be re-used anew.
        function o = boot(o)
            o.nf = -1;
            o.flag_trained = 0;

            o = o.do_boot();
            
            o.flag_booted = 1;
        end;
    end;

end