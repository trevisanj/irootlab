%> This is designed to group several soitem_merger_fhg together
%>
%> This is used to merge several datasets together. The merge_fhg outputs for each dataset
%> must be put together in a directory and go_merger_merger_fhg must be used. This is to be
%> done manually, for it is out of reach of task management system.
classdef merger_merger_fhg < sodesigner
% % %     methods
% % %         %> Constructor
% % %         function o = merger_merger_fhg()
% % %             o.flag_requires_sosetup_scene = 0;
% % %         end;
% % %     end;
    
    methods(Access=protected)
        function out = do_design(o)
            out = soitem_merger_merger_fhg();
            items = o.input;
            ni = numel(items);
            for i = 1:ni
                out.items(i) = items{i}; % Converts cell to object array
            end;
            out.title = ['Merge of ', int2str(ni), ' MERGE_FHG', iif(ni > 1, '''s', '')];
            out.dstitle = 'varies';
        end;
    end;
end
