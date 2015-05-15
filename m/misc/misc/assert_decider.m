%>@ingroup misc assert
%>@file
%>@brief Makes sure that the object is able to decide upon classes
%
%> @param obj
function assert_decider(obj)

flag_ok = 0;
if isa(obj, 'decider')
    flag_ok = 1;
else
    if isa(obj, 'block_cascade_base')
        for i = 1:numel(obj.blocks)
            if strcmp(class(obj.blocks{i}), 'decider')
                flag_ok = 1;
            end;
        end;
    end;
end;

if ~flag_ok
    irerror('postpr_est must be able to decide (either be a decider or a block_cascade_base with a decider as last block)!');
end;
