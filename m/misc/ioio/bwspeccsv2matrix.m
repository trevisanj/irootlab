%
% JT 20170721 -- Opens BWSpec's CSV file format returns a matrix [nf]x[2]
%
% Below is an example provided by Frank Martin (30_50_t.csv):
%
% ===BEGIN SAMPLE===
% File Version;BWSpec4.04_00
%
% Date,2017-03-17 07:52:28
%
% [...]
%
% Pixel,Wavelength,Wavenumber,Raman Shift,Dark,Reference,Raw data #1,Dark Subtracted #1,%TR #1,Absorbance #1,Irradiance (lumen) #1,
%
% 0,   ,   ,   ,1873.0000,65535.0000,1519.0000,-354.0000,0.0000,0.0000,0.0000,
%
% [...]
%
% 313,   ,   ,   ,1806.0000,65535.0000,31757.0000,29951.0000,0.0000,0.0000,0.0000,
%
% 314,816.78,12243.25,498.36,1656.0000,65535.0000,31546.0000,29890.0000,0.0000,0.0000,0.0000,
%
% [...]
%
% 2046,   ,   ,   ,792.0000,65535.0000,744.0000,-48.0000,0.0000,0.0000,0.0000,
%
% 2047,   ,   ,   ,792.0000,65535.0000,744.0000,-48.0000,0.0000,0.0000,0.0000,
%
% ===END SAMPLE===
%
%
% Args:
%     filename: string
%     nf (optional): if one already knows the expected number of features,
%                    this function can avoid its on-the-fly matrix
%                    allocation strategy. Not passed is equivalent to passed as ZERO
%                    
%
function M = bwspeccsv2matrix(filename, nf)

X_COLUMN = 4;  % Raman Shift
Y_COLUMN = 8;  % Dark Subtracted
REQUIRED_COMMAS = max(X_COLUMN, Y_COLUMN)-1;

h = fopen(filename, 'r');

knows = 0;  % Knows the spectral length
if nargin < 2 || nf < 1
    M = zeros(1, 2);
    nm = 1;
else
    M = zeros(nf, 2);
    knows = 1;
end;

i = 0;
while 1
    s = fgets(h);
    if isnumeric(s)  % -1 meaning EOF
        break;
    end;
    
%     len_s = length(s);
%     if len_s <= 1
%         if cnt_empty > 1
%             break;
%         end;
%         cnt_empty = cnt_empty+1;
%         continue;
%     end;
    
    % Parser online lines with more than a certain number of delimiters
    n_commas = sum(s == ',');
    if n_commas >= REQUIRED_COMMAS
        row_values = strsplit(s, ',');
        number_test = str2double(row_values{X_COLUMN});
        if ~isnan(number_test)
            i = i+1;
            if ~knows && i > nm
                nm = nm*2;
                M(nm, 1) = 0;
            end;
            M(i, 1) = number_test;
            M(i, 2) = str2double(row_values{Y_COLUMN});
        end;
    end;
end;

% This is important as a file type check for automatic file type detection
if i == 0
    irerror('This does not appear to be a BWSpec CSV file');
end;

if ~knows && nm > i
    M = M(1:i, :);
else
    % This is a sanity check
    if i ~= nf
        irerror(sprintf('bwspeccsv2matrix: number of data points found: i=%d; should be nf=%d', i, nf));
    end;
end;
    
fclose(h);
