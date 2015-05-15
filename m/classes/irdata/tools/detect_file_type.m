%>@ingroup datasettools
%> @file
%> @brief does a series of tests on the dataset file to try to guess its format
function classname = detect_file_type(filename)

if ~exist(filename, 'file')
    irerror(sprintf('File "%s" does not exist!', filename));
end;

classname = '';
id = fopen(filename, 'r');

if id <= 0
    irerror(sprintf('Could not open file "%s"', filename));
end;

try

    while 1
        % checks MAT
        s = fread(id, 6);
        if strcmp(char(s)', 'MATLAB')
            classname = 'dataio_mat';
            break;
        end;

        fseek(id, 0, 'bof');
        s = fread(id, 8);
        s = strip_quotes(char(s)');
        if length(s) >= 7
            if strcmp(lower(s(1:7)), 'irtools') || strcmp(lower(s(1:5)), 'iroot')
                classname = 'dataio_txt_irootlab';
                break;
            end;
        end;

        fseek(id, 0, 'bof');
        s = fread(id, 1);
        if s >= 48 && s <= 57 || s == '-'
            % If contents starts with a number, the file type is likely "basic"
            classname = 'dataio_txt_basic';
            break;
        end;

        if sum(s == sprintf('\t,; ')) > 0 % Tests CSV common separators
            % If file starts with a separator, file type is likely to be the Pirouette table
            classname = 'dataio_txt_pir';
            break;
        end;

        fseek(id, 0, 'bof');
        s = fread(id, 4);
        if sum(s == [10, 10, 254, 254]') == 4
            classname = 'dataio_opus_nasse';
            break;
        end;

        break;
    end;

    if isempty(classname)
    %     irerror('Could not detect type of file ''%s''', filename);
        irwarning(sprintf('Could not detect type of file ''%s''', filename));
    else
        irverbose(sprintf('File type detected for file ''%s'': ''%s''', filename, classname), 1);
    end;
    fclose(id);
catch ME
    fclose(id);
    rethrow(ME);
end;




