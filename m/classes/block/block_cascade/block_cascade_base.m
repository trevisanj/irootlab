%> @brief Cascade block: sequence of blocks represented by a block
%>
%> Cascade blocks can mimic the behaviour of linear transformation blocks (fcon_linear; such as PCA) if it contains one or more such blocks.
%> It has all the properties that a fcon_linear block has, however its valid functioning will depend on the component blocks.
%> The loadings matrix is calculated by multiplying the loadings matrix of successive component blocks.
%>
%> 
%>
%> @arg boot: all component blocks booted
%> @arg train: after training first block, training data is inputted into it to get the training data to the second block etc
%> @arg use: output of (k-1)-th block is inputted into k-th block
%>
%>@sa uip_block_cascade_base.m, blsp_crossc
classdef block_cascade_base < block
    properties
        %> Cell of @c block objects
        blocks = {};
        %> =1. Whether to cross-calculate outputs when it is the case. The case is: in training; and the component block is level 1
        %> (trainable); and the component block is not the last block. If @c flag_crossc is false, the same dataset will be used
        %> to train and to calculate the block output.
        flag_crossc = 0;
        %> SGS to do the cross-calculations when necessary. If needed and empty, a default one will be used
        sgs_crossc;
    end;
    
    
    % These properties have their getters and are read-only
    properties
        %> Loadings matrix. @ref fcon_linear mimicking. Calculates loadings matrix by multiplying
        %> (<code>L = block1.L*block2.L*...</code>). 
        L;
%         %> Feature names. @ref fcon_linear / fsel mimicking.
%         fea_names;
        %> Loadings feature names. @ref fcon_linear mimicking.
        L_fea_names;
        %> Feature x-axis. @ref fcon_linear mimicking. Retrieves the @c L_fea_x from the first block.
        L_fea_x;
        %> x-axis name. @ref fcon_linear mimicking. Retrieves the @c xname from the first block.
        xname;
        xunit;
        yname;
        yunit;
        %> Class labels. @ref clssr mimicking. Retrieves the @c classlabels property from the last block.
        classlabels;
        %> Feature indexes. @ref fsel mimicking. Retrieves the @c v property from the last block.
        v;
        %> Decision threshold. @ref decider mimicking. Retriever the @c decisionthreshold property from some decider it finds along the
        %> blocks
        decisionthreshold;
    end;    
    properties(SetAccess=protected)
        %> Number of blocks.
        no_blocks;
        %> Whether the block is able to mimic a @ref fcon_linear. This is calculated at boot time.
        flag_fcon_linear = 0;
        %> Whether the block is able to mimic a @ref decider. This is calculated at boot time.
        flag_decider = 0;
        %> Index of first linear block. This is calculated at boot time.
        idx_linear1;
        %> Index of decider. This is calculated at boot time.
        idx_decider;
        
        flag_checked = 0;
    end;
    
    properties(Access=private)
        %> Whether an error should be thrown if an invalid property is accessed. Because block_cascade_base can mimic several other classes,
        %> but this is dependand on its component blocks, many properties can be invalid. However, giving errors all the time can be annoying
        %> if the purpose is just to display properties, such as when one types the variable name at MATLAB command window.
        %> If flag_give_error is false, all numeric properties will return a NaN when they are invalid
        flag_give_error = 0;
    end;
    
    methods
        function o = block_cascade_base()
            o.classtitle = 'Block Cascade';
            o.short = 'Cascade';
            o.flag_trainable = 1;
            o.flag_bootable = 1;
        end;
        
        function  z = get.no_blocks(o)
            z = length(o.blocks);
        end;
        
        function L = get.L(o)
            L = o.get_loadings();
        end;
        
%         function z = get.fea_names(o)
%             z = o.get_fea_names();
%         end;

        function z = get.L_fea_x(o)
            z = o.get_L_fea_x();
        end;

        function z = get.xname(o)
            z = o.get_xname();
        end;
        
        function z = get.xunit(o)
            z = o.get_xunit();
        end;
        
        function z = get.yname(o)
            z = o.get_yname();
        end;
        
        function z = get.yunit(o)
            z = o.get_yunit();
        end;
        
        %> Other getters call yet another function, I don't know exactly why. I won't do this here because this may be
        %> called many times.
        function z = get.classlabels(o)
            z = o.blocks{end}.classlabels;
        end;
        
        %> Retrieves @c v from last block.
        function z = get.v(o)
            z = o.blocks{end}.v;
        end;
        
        %> Retrieves @c decisionthreshold from the decider that if finds
        function z = get.decisionthreshold(o)
            if ~o.flag_decider
                if o.flag_give_error
                    irerror('Cascade block cannot mimic a decider!');
                else
                    z = NaN;
                end;
            else
                z = o.blocks{o.idx_decider}.decisionthreshold;
            end;
        end;        
    end;
    
    methods
        %> Extracts @ref fcon_linear_fixed with same Loadings Matrix
        function blk = extract_fcon_linear_fixed(o)
            blk = fcon_linear_fixed();
            blk.L = o.L;
            blk.copy_axes_from(o);
        end;
    end;
    
    


    
    %---------------------------------------------------------------------------------------------------------
    
    % GET EVERYTHING
    
    methods
        function z = get_L_fea_x(o)
            if numel(o.blocks) == 0
                if o.flag_give_error
                    irerror('Cascade block is empty!');
                else
                    z = NaN;
                end;
            else
                if ~o.flag_fcon_linear
                    if o.flag_give_error
                        irerror('Cascade block cannot mimic a linear block!');
                    else
                        z = NaN;
                    end;
                else
                    b = o.get_linear1();
                    z = b.L_fea_x;
                end;
            end;
        end;

        function z = get_xname(o)
            if numel(o.blocks) == 0
                if o.flag_give_error
                    irerror('Cascade block is empty!');
                else
                    z = '';
                end;
            else
                if ~o.flag_fcon_linear
                    if o.flag_give_error
                        irerror('Cascade block cannot mimic a linear block!');
                    else
                        z = '';
                    end;
                else
                    b = o.get_linear1();
                    z = b.xname;
                end;
            end;
        end;

    
        %> Feature names: takes the xname property from the first linear block
        function z = get_xunit(o)
            if numel(o.blocks) == 0
                if o.flag_give_error
                    irerror('Cascade block is empty!');
                else
                    z = '';
                end;
            else
                if ~o.flag_fcon_linear
                    if o.flag_give_error
                        irerror('Cascade block cannot mimic a linear block!');
                    else
                        z = '';
                    end;
                else
                    b = o.get_linear1();
                    z = b.xunit;
                end;
            end;
        end;

        %> y-name: takes the yname property from the last block that has it
        %>
        %> @return yname. Defaults to an empty string.
        function z = get_yname(o)
            z = '';
            for i = numel(o.blocks):-1:1
                if isprop(o.blocks{i}, 'yname')
                    z = o.blocks{i}.yname;
                    break;
                end;
            end;
        end;

        %> y-unit: takes the yunit property from the last block that has it
        %>
        %> @return yunit. Defaults to an empty string.
        function z = get_yunit(o)
            z = '';
            for i = numel(o.blocks):-1:1
                if isprop(o.blocks{i}, 'yunit')
                    z = o.blocks{i}.yunit;
                    break;
                end;
            end;
        end;

% 
%         %> Feature names: takes the fea_names property from the first linear block
%         function z = get_fea_names(o)
%             if numel(o.blocks) == 0
%                 if o.flag_give_error
%                     irerror('Cascade block is empty!');
%                 else
%                     z = {};
%                 end;
%             else
%                 b = o.get_linear1();
%                 z = b.fea_names;
%             end;
%         end;

        %> @brief Calls get_methodname() for all blocks
        %> @param flag_short=0
        function s = get_methodname(o, flag_short)
            if nargin < 2 || isempty(flag_short)
                flag_short = 0;
            end;
            s = '';
            for i = 1:length(o.blocks)
                if i > 1
                    s = [s '->'];
                end;
                b = o.blocks{i};
                s = [s b.get_methodname(flag_short)];
            end;
        end;

        
        %> Mimicking a fcon_linear::get_L_fea_names()
        %>
        %> Calls the get_L_fea_names from the first block that has this method (SEARCHING BACKWARDS)
        function a = get_L_fea_names(o, idxs)
            a = {};
            nb = numel(o.blocks);
            if nb == 0
                if o.flag_give_error
                    irerror('Cascade block is empty!');
                else
                end;
            else
                for i = nb:-1:1
                    b = o.blocks{i};
                    if ismethod(b, 'get_L_fea_names')
                        a = b.get_L_fea_names(idxs);
                        break;
                    end;
                end;
            end;
        end;

        
        %> Cascades blocks' loadings matrices. Works only if one or all blocks provide one loadings matrix of course, i.e., they
        %> all represent linear transforms.
        function L = get_loadings(o)
            if ~o.flag_fcon_linear
                if o.flag_give_error
                    irerror('Cascade block cannot mimic a linear block!');
                else
                    L = NaN;
                end;
            else
                if ~o.flag_trained
                    L = [];
                else
                    for i = o.idx_linear1:length(o.blocks)
                        if ~ismember(properties(o.blocks{i}), 'L')
                            irerror(sprintf('Block ''%s'' does not have property ''L''!', o.blocks{i}.classtitle));
                        end;

                        if i == o.idx_linear1
                            L = o.blocks{i}.L;
                        else
                            L = L*o.blocks{i}.L;
                        end;
                    end;
                end;
            end;
        end;
    end;
    
    
    
    
    
    
    
    
    %---------------------------------------------------------------------------------------------------------
    
    
    methods(Access=protected)
        %> BLock needs to keep up-to-date with contents
        function o = assert_checked(o)
            if ~o.flag_checked
                o = o.do_check();
            end;
        end;
        
        function o = do_check(o)
            idx1temp = 0; % Index of first linear block
            flag_cannot = 0; % Cannot be a linear block
            o.flag_decider = 0;
            level = 0;
            for i = 1:length(o.blocks)
                if isa(o.blocks{i}, 'block_cascade_base')
                    o.blocks{i} = o.blocks{i}.do_check();
                end;
                
                if isa(o.blocks{i}, 'fcon_linear') || isa(o.blocks{i}, 'block_cascade_base') && o.blocks{i}.flag_fcon_linear
                    if idx1temp == 0
                        idx1temp = i;
                    end;
                elseif idx1temp
                    flag_cannot = 1;
                end;
                
                if ~o.flag_decider && isa(o.blocks{i}, 'decider')
                    o.flag_decider = 1;
                    o.idx_decider = i;
                end;
                
                level = max(level, o.blocks{i}.flag_trainable);
            end;
            
            o.flag_fcon_linear = ~flag_cannot && idx1temp > 0;
            if o.flag_fcon_linear
                o.idx_linear1 = idx1temp;
            end;
            
            o.flag_trainable = level;
            
            o.flag_checked = 1;
        end;
        
        %> Boots every encapsulated block
        function o = do_boot(o)
            o = o.do_check();

            for i = 1:length(o.blocks)
                o.blocks{i} = o.blocks{i}.boot();
            end;
        end;

        %> Trains every encapsulated block
        %> @todo think about stacked generalization
        function o = do_train(o, data)
            o = o.assert_checked();
            
            flag_crossc_first = 1;
            
            for i = 1:o.no_blocks
                % Sequence here is cross-calculate; train; use.
                %
                % Cross-calculate and use are mutually exclusive.
                %
                % Note that cross-calculation could go after but I put it before to make it more robust to blocks that don't boot propertly
                
                % Cross-calculate
                if i < o.no_blocks && o.flag_crossc && o.blocks{i}.flag_trainable > 0
                    % Creates block blsp_crossc if it is the first time the cross-calculated will be performed in this training function
                    if flag_crossc_first
                        block_crossc = blsp_crossc();
                        if ~isempty(o.sgs_crossc)
                            block_crossc.sgs = o.sgs_crossc;
                        end;
                        flag_crossc_first = 0;
                    end;
                        
                    block_crossc.mold = o.blocks{i};
                    data_next = block_crossc.use(data);
                end;
                
                % Train
                if o.blocks{i}.flag_trainable > 0
                    o.blocks{i} = o.blocks{i}.train(data);
                end;
                
                % Use
                if i < o.no_blocks && (~o.flag_crossc || o.blocks{i}.flag_trainable == 0)
                    data_next = o.blocks{i}.use(data);
                end;

                if i < o.no_blocks
                    data = data_next;
                end;
            end;
        end;
        
        %> output of (k-1)-th block is inputted into k-th block. Final output is the output of the end-th block.
        %>
        %> Skips any blmisc_rowsout block (outlier remover)
        function data = do_use(o, data)
            o = o.assert_checked();
            
            for i = 1:length(o.blocks)
                blk = o.blocks{i};
                if isa(blk, 'blmisc_rowsout')
                    % Skips outlier removers in use stage
                else
                    data = o.blocks{i}.use(data);
                end;
            end;
        end;
        
        %> Makes sure that the block can mimic a linear block
        function o = assert_fcon_linear(o)
            if ~o.flag_fcon_linear
                irerror('Cascade block cannot mimic a linear block!');
            end;
        end;
        
        
% % % % % % %         %> Makes sure that the block can mimic a linear block
% % % % % % %         function o = assert_decider_(o)
% % % % % % %             if ~o.flag_decider
% % % % % % %                 irerror('Cascade block cannot mimic a decider!');
% % % % % % %             end;
% % % % % % %         end;
        
        %> Retrieves the first linear block
        function b = get_linear1(o)
            o = o.assert_checked();
            
            o.assert_fcon_linear();
            b = o.blocks{o.idx_linear1};
        end;

        %>
        function s = do_get_report(o)
            s = do_get_report@block(o);
            
            len = length(o.blocks);
            for i = 1:len
                stemp = sprintf('Component Block %d/%d', i, len);
                stemp2 = repmat('-', 1, length(stemp));
                s = cat(2, s, sprintf('\n\n /%s\\\n| %s |\n \\%s/\n', stemp2, stemp, stemp2), o.blocks{i}.get_report());
            end;
        end;
    end;
end

    
