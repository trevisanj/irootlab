%> @ingroup guigroup
%> @file
%> @brief Calls Properties GUIs for all component blocks
%
%> @param blk instance of block to be created
%> @param input (optional) Input to block
function varargout = uip_block_cascade_base(varargin)
global blk;
blk = varargin{1};
input = []; flag_input = 0;
if nargin >= 1 && ~isempty(varargin{2})
    input = varargin{2};
    flag_input = 1;
end;
output.flag_ok = 0;
output.params = {};

no_blocks = numel(blk.blocks);
params = {};
for i = 1:no_blocks
    z = blk.blocks{i}.get_params(input);
    
    if ~z.flag_ok
        break;
    end;

    if i < no_blocks
        % Transforms input
        blk.blocks{i} = blk.blocks{i}.boot();
    end;
        
    if isfield(z, 'params') % bit of tolerance
        for j = 1:2:numel(z.params)
            z.params{j} = ['blocks{', int2str(i), '}.', z.params{j}];
        end;
        params = [params, z.params]; % Goes collecting params
        
        if i < no_blocks
            for j = 1:2:numel(z.params)-1
                s_code = sprintf('global blk; blk.%s = %s;', z.params{j}, z.params{j+1});
                evalin('base', s_code);
            end;
        end;
    end;
    
    if i < no_blocks && flag_input
        blknow = blk.blocks{i}.train(input);
        input = blknow.use(input);
    end;
    
    if i == no_blocks
        output.flag_ok = 1;
        output.params = params;
    end;
end;


















varargout{1} = output;
