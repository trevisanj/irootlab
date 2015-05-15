%> @brief system optimizer stage doer - Pre-processing generic
%>
%> Initial sequence: Cut (1800-900) -> Resample (nf_resample) -> Spline representation (spline_nf).
%> Then does something specific to the descendant class, specified by the get_blocks() method.
%>
%> 2nd and 3rd steps are optional.
%>
classdef sostage_pp < sostage
    properties
        %> Spline representation
        flag_spline = 0;
        %> Number of splines for spline representation
        spline_nf;
        
        %> Resampling number of features. If <= 0, there will be no resampling
        nf_resample = 0;
    end;
    
    methods(Access=protected)
        function out = do_get_block(o)
            out = block_cascade();

            cutter1 = fsel();
            cutter1 = cutter1.setbatch({'v_type', 'rx', ...
            'flag_complement', 0, ...
            'v', [1800, 900]});
            out.blocks = {cutter1};
            
            if o.nf_resample > 0
                b = fcon_resample();
                b.no_fea = o.nf_resample;
                out.blocks{end+1} = b;
            end;
            
            if o.flag_spline
                osp = fcon_spline();
                osp.no_basis = o.spline_nf;
                out.blocks{end+1} = osp;
            end;


            % Adds sequence of blocks from descendant class            
            blocks = o.get_blocks();
            for i = 1:numel(blocks)
                out.blocks{end+1} = blocks{i};
            end;
        end;
        
        %> Override this. Must return a cell of blocks
        function a = get_blocks(o)
            a = {};
        end;
    end;
end
