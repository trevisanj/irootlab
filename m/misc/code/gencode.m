%> @file
%> @ingroup codegen

%> @ingroup codegen
%> @brief MATLAB code generation to create, boot, train and use blocks.
%>
%> @sa objtool.m, datatool.m, do_blockmenu.m
%>
classdef gencode < handle
    properties
        refblock;
        classname;
        dsnames = [];
        params;
        blockname;
        flag_leave_block = 1;
    end;
    
    properties(SetAccess=protected)
        soutname1;
        soutname2;
        flag_started;
        flag_data;
        flag_handle; % whether the data is a handle class, just in case
        
        %> Whether the "u" object is in the workspace
        flag_u = 0;
        %> generated code
        code = {};
        %> Also generated code, but does not get emptied by @c execute()
        allcode = {};
        %> Name of the variable that the block has in the base workspace.
        varname;
    end;
        
    methods
        function set.classname(o, z)
            o.classname = z;
            o.flag_started = 0;
        end;

        function set.dsnames(o, z)
            o.dsnames = z;
            o.flag_started = 0;
        end;
        
        function set.params(o, z)
            o.params = z;
            o.flag_started = 0;
        end;

        function z = get.varname(o)
            if o.flag_u
                z = 'u';
            else
                z = o.blockname;
            end;
        end;
    end;
    
    methods (Access=protected)
        function o = assert_started(o)
            if ~o.flag_started
                o.start();
                o.flag_started = 1;
            end;
        end;


        %> Makes a string to represent the input data.
        function sds = get_sds(o)
            if o.refblock.flag_multiin
                sds = '['; 
                for i = 1:length(o.dsnames); 
                    if i > 1; sds = cat(2, sds, ', '); end; 
                    sds = cat(2, sds, o.dsnames{i}); 
                end; 
                sds = strcat(sds, ']');
            else
                sds = o.dsnames{1};
            end;
        end;
        
        %> Adds code
        function o = add_code(o, code)
            o.code{end+1} = code;
            o.allcode{end+1} = code;
        end;
            
        
        %> Executes accumulated code
        %> @param flag_finish Whether the execution is the last of a series (will add an extra LineFeed if so)
        function o = execute(o, flag_finish)
            if nargin < 2
                flag_finish = 0;
            end;
            if numel(o.code) > 0
%                 temp = char(o.code);
                ircode_eval(sprintf('%s', o.code{:}));
                o.code = {};
            end;
            
            if flag_finish
                ircode_add(char(10));
            end;
        end;
    end;    

    
    methods
        function o = start(o)
            if ~isempty(o.classname)
                o.refblock = eval(o.classname); % instantializes the class in order to find out a few things
            elseif ~isempty(o.blockname)
                o.refblock = evalin('base', [o.blockname, ';']);
            else
                irerror('Cannot start: neither classname nor blockname set');
            end;

            o.flag_data = ~isempty(o.dsnames);


            o.code = {}; % Clears generated code
            o.allcode = {};
            o.flag_u = 0;
            
            o.add_code('');
%             o.add_code(['% -- @ ', datestr(now), 10]);
        end;
        

        %> Generates code that creates new block
        function o = m_create(o)
            o.assert_started();
            
            o.add_code(sprintf('u = %s();\n', o.classname)); % C O D E - creates o.refblock
            o.flag_u = 1;
            if ~isempty(o.params)
                o.add_code(params2str(o.params, 1)); % C O D E - sets parameters
            end;
            
            o = o.execute();

            if o.flag_leave_block && o.flag_u
                o.blockname = find_varname([o.classname]); % Name for the block
                o = o.add_code(sprintf('%s = u;\n', o.blockname));
                o.flag_u = 0;
                o = o.execute();
            end;
        end;

        %> Generates code that boots the block
        function o = m_boot(o)
            o.assert_started();
            if o.refblock.flag_bootable
                o = o.add_code(sprintf('%s = %s.boot();\n', o.varname, o.varname));
            end;
        end;
        
      
        %> Generates code that trains the block
        function o = m_train(o)
            o.assert_started();
            
            if ~o.flag_data
                irerror('Cannot apply block: dataset names not provided!');
            end;

            if o.refblock.flag_trainable > 0
                o = o.add_code(sprintf('%s = %s.train(%s);\n', o.varname, o.varname, o.get_sds()));
            end;
        end;
        
        %> Generate code that uses the block
        function o = m_use(o)
            o.assert_started();
            
            if ~o.flag_data
                irerror('Cannot apply block: dataset names not provided!');
            end;
            
            sds = o.get_sds();

            if isa(o.refblock, 'vis') && o.refblock.flag_graphics
                o = o.add_code(sprintf('figure;\n'));
            end;


            if o.refblock.flag_out
                o = o.add_code(sprintf('out = %s.use(%s);\n', o.varname, sds));
                o = extract_output(o);
                
                if isa(o.refblock, 'irreport')
                    o = o.open_in_browser();
                end;
            else
                o = o.add_code(sprintf('%s.use(%s);\n', o.varname, sds));
            end;
        end;

        
        %> Executes "generic" method from the block. Does not not pass any parameter to the block, i.e., it is assumed
        %> that the block can execute the method using its own properties previously assigned.
        function o = m_generic(o, what)
            o.assert_started();
            
%             if ~o.flag_data
%                 irerror('Cannot apply block: dataset names not provided!');
%             end;
            
%             sds = o.get_sds();

%             o = o.add_code(sprintf('out = %s.%s(%s);', o.varname, what, sds));

            o = o.add_code(sprintf('out = %s.%s();\n', o.varname, what));
            
            o = extract_output(o);
        end;

        function o = extract_output(o)
            o = o.assert_started();
            o = o.execute(); %
           
            out = evalin('base', 'out;');
            flag_cell = iscell(out);

            if o.flag_data
                data = evalin('base', [o.dsnames{1}, ';']);
%                 o.flag_handle = isa(data, 'handle');
            end;

            
            if flag_cell
                [ni, nj] = size(out);
            else
                ni = 1; nj = 1;
            end;
            for i = 1:ni
                for j = 1:nj
                    if flag_cell
                        outij = out{i, j};
                        sij = sprintf('{%d, %d}', i, j);
                    else
                        outij = out;
                        sij = '';
                    end;

                    if isa(outij, 'irdata')
                        suffix = get_suffix(class(o.refblock));
                        if o.flag_data
                            if o.refblock.flag_multiin
                                outname = find_varname([class(data) '_' suffix]);
                            else
                                outname = find_varname([o.dsnames{1} '_' suffix]);
                            end;
                        else
                            outname = find_varname([class(outij), '_', suffix]);
                        end;

                        if numel(outij) > 1
                            for k = 1:numel(outij)
                                o = o.add_code(sprintf('%s_%02d = out%s(%d);\n', outname, k, sij, k));
                            end;
                        else
                            o = o.add_code(sprintf('%s = out%s;\n', outname, sij));
                        end;

                    else
                        % Anything else than datasets will be made into a decent name, but not extracted if it is an array.

                        suffix = get_suffix(class(o.refblock));
                        outname = find_varname([class(outij), '_', suffix]);
                        o = o.add_code(sprintf('%s = out%s;\n', outname, sij));
                        
                    end;
                    
                    o = o.execute();
                end;
            end;
        end;
            
        
        function o = open_in_browser(o)
            o = o.add_code(sprintf('out.open_in_browser();\n'));
        end;
     
        function o = finish(o)
            o = o.execute(1);
        end;
    end;
end
