%> @brief Dataset loader/saver for mat files
%>
%> mat files are a bit tricky because the structure has evolved since the
%> beginning and backward compatibility is needed, but it is very stable now.
classdef dataio_mat < dataio
    methods
        %------------------------------------------------------------------
        %> Loader
        function data = load(o, range)

            if nargin == 1
                range = [];
            end;


            %> *1* checks for dataclass variable within file
            load(o.filename, '-mat', 'dataclass');
            if ~exist('dataclass', 'var')
%                irverbose('dataio_mat is creating default ''irdata'' object ...');
                data = irdata();
            else
%                irverbose(sprintf('new ''%s'' from file ''%s''...', dataclass, o.filename), 0);
                data = eval(dataclass);
            end;

            try
                load(o.filename, '-mat', 'DATA');
            catch ME
                irerror(['MATLAB couldn''t handle this file: ', ME.message]);
            end;

            if ~exist('DATA', 'var')
                irerror(sprintf('File ''%s'' does not contain a variable called ''DATA''', o.filename));
            end;

            data = data.import_from_struct(DATA);

            %> TODO This is a hack present until I do a proper wavenumber record
            %> while importing Pirouette files and make MATLAB import and record
            %> these information (and re-generate the .mat files).
            if ~isempty(range)
                data.fea_x = linspace(range(1), range(2), size(DATA.X, 2));
            else
                if isempty(data.fea_x)
                    irwarning('x vector was empty, default x wavenumber vector will be used');
                    data.fea_x = linspace(o.defaultrange(1), o.defaultrange(2), size(DATA.X, 2));
                end;
            end;
                

            data.assert_not_nan();
            data.filename = o.filename;
            data.filetype = 'mat';
            data = data.make_groupnumbers();
        end
        
        
        
        %------------------------------------------------------------------
        %> Saver
        function o = save(o, data)
            dataclass = class(data); %#ok<*NASGU>
            DATA = data;
            
            save(o.filename, 'DATA', 'dataclass');
            irverbose(sprintf('Just saved file "%s"', o.filename), 2);
        end;
    end
end