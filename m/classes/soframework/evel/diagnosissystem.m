%> @brief Diagnosis System class
%>
%> Has blocks for Pre-processing, Feature Extraction, and Classification as separate properties
%>
%> Has some funcitonalities, sucha as being able to mount a block_cascade
%>
%>
classdef diagnosissystem < irobj
    properties
        % These have precedence
        sostage_pp;
        sostage_fe;
        sostage_cl;
        
        
        %> Pre-processing block
        blk_pp;
        %> Feature Extraction block
        blk_fe;
        %> Classificaton block
        blk_cl;
        
        %> =1. Whether to auto-insert a standardization block after the FE block when assembling the overall block
        flag_std = 1;
    end;

    methods
        function o = diagnosissystem()
            o.classtitle = 'Diagnosis System';
        end;
    end;

    % Tools
    methods
        %> Returns pre-processsed dataset
        function ds = preprocess(o, ds)
            if ~isempty(o.sostage_pp)
                pp = o.sostage_pp.get_block();
            elseif ~isempty(o.blk_pp)
                pp = o.blk_pp;
            else
                irerror('Neither sostage_pp nor blk_pp are set');
            end;
            
            pp = pp.boot();
            pp = pp.train(ds);
            ds = pp.use(ds);
        end;
        
        
        %> Puts everything together in a single block
        function blk = get_block(o)
            blk = make_one(o.get_sequence());
            blk.title = o.get_s_sequence([], 0);
        end;
        
        %> Returns sequence without the pre-processing block
        function blk = get_fecl(o)
            cc = o.get_sequence();
            cc2 = o.get_sequence(0);
            blk = make_one(cc(2:end));
            blk.title = o.get_s_sequence(cc2(2:end), 0);
        end;
        
        %> Returns the sequence description
        %>
        %> Note that it uses get_methodname() from the blocks, rather than classtitles
        %>
        %> @param cc (Optional) Cell of blocks. Defaults to o.get_sequence(0)
        %> @flag_short=0 Passes on to irobj.get_methodname()
        function s = get_s_sequence(o, cc, flag_short)
            if nargin < 2 || isempty(cc)
                cc = o.get_sequence(0);
            end;
            if nargin < 3 || isempty(flag_short)
                flag_short = 0;
            end;
            
            s = '';
            for i = 1:numel(cc)
                s = cat(2, s, iif(i == 1, '', '->'), cc{i}.get_methodname(flag_short));
            end;
        end;
    end;
    
    
    methods(Access=protected)
        %> Returns the (trainable) standardization block
        function blk = get_std(o)
            blk = pre_std();
            blk.title = 'Std';
        end;
        
        %> Returns the complete sequence in a cell
        %>
        %> Internally checks @c flag_std and whether each stage is empty or not
        %>
        %>
        %> It won't care if anything is empty or not. In the worst case, an empty cell will be returned
        %>
        %> @param flag_std_ If passed, overrides @ref diagnosissystem::flag_std
        function cc = get_sequence(o, flag_std_)
            if nargin < 2
                flag_std_ = o.flag_std;
            end;
            
            cc = {};
            
            if ~isempty(o.sostage_pp)
                cc{end+1} = o.sostage_pp.get_block();
            elseif ~isempty(o.blk_pp)
                cc{end+1} = o.blk_pp;
            end;
            
            if ~isempty(o.sostage_fe)
                cc{end+1} = o.sostage_fe.get_block();
            elseif ~isempty(o.blk_fe)
                cc{end+1} = o.blk_fe;
            end;
            
            if flag_std_
                cc{end+1} = o.get_std();
            end;
            
            if ~isempty(o.sostage_cl)
                cc{end+1} = o.sostage_cl.get_block();
            elseif ~isempty(o.blk_cl)
                cc{end+1} = o.blk_cl;
            end;
        end;
    end;
end
