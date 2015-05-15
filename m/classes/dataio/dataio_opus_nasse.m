%> @brief Dataset loader for OPUS "0" files
%>
%> Uses routine written by Michael Nasse during his time at Synchrotron Radiation Centre in Wisconsin, USA
%>
%> @sa load_opus_file2
classdef dataio_opus_nasse < dataio
    methods(Access=private)
        function clear_cubes(o)
            % Clear globals that start with "cube_"
            cc = who('cube_*', 'global');
            for i = 1:numel(cc)
                evalin('base', sprintf('clear(''global'', ''%s'');', cc{i}));
            end;
        end;
    end;
            
    methods
        %> Loader
        function data = load(o, range)

            flag_range = exist('range', 'var'); 
            
            if flag_range
                irwarning('range will be ignored');
            end;


            o.clear_cubes();
            
            data = irdata();

            % Clear globals that start with "cube_"
            cc = who('cube_*', 'global');
            for i = 1:numel(cc)
                evalin('base', sprintf('clear(''global'', ''%s'');', cc{i}));
            end;

            status = load_opus_file2(o.filename);

            if status ~= 0
                irerror(sprintf('OPUS file loading returned error status %d', status));
            end;

            cc = who('cube_*', 'global');

            if isempty(cc)
                irerror('Couldn''t find cube variable in the global space!');
            end;



            eval(['global ', cc{1}, '; cube = ', cc{1}, ';']);
            cube = double(cube); % Comes as single, originally
%             cube = permute(cube, [2, 1, 3]); % x-y are originally transposed
%             cube = cube(:, end:-1:1, :); % seems to be right-to-left
%            cube = cube(end:-1:1, :, :); % seems to be upside down
            
            data.X = reshape(cube, [size(cube, 1)*size(cube, 2), size(cube, 3), 1]);
            data.X = data.X(:, end:-1:1);
            data.height = size(cube, 1);
            temp = 0:data.no-1;
            data.obsnames = arrayfun(@(x, y) sprintf('x=%d, y=%d', x, y), floor(temp/data.height), mod(temp, data.height), 'UniformOutput', 0)';

            global spectral_axis;
            data.fea_x = spectral_axis(end:-1:1);

            data.classes = zeros(size(data.X, 1), 1);
            data.classlabels = {'Class 0'};




            % Assigns data.classes correcting numbers for eventual non-zero-based
            % classes
            m = min(data.classes);
            if m > 0
                irwarning(sprintf('Class numbers started in %d and thus were shifted down in order to start in zero.', m));
                data.classes = data.classes-m;
            end;

            % Produces class labels
            for i = 1:max(data.classes)+1
                data.classlabels{i} = sprintf('Class %d', i-1);
            end;


            data.assert_not_nan();
            data.filename = o.filename;
            data.filetype = '0';
            data = data.make_groupnumbers();

            
            o.clear_cubes();
        end
        
        
        %> Saver
        function o = save(o, data)
            irerror('Sorry, IRootLab does not save files in OPUS format');
        end;
    end
end