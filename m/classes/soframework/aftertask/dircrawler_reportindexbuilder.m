%> Report index builder
classdef dircrawler_reportindexbuilder < dircrawler
    properties(SetAccess=protected)
        map = {};
    end;
        
    methods
        function o = dircrawler_reportindexbuilder()
            o.patt_exclude = 'report';
        end;

        function o = process_dir(o, d)
            dd = getdirs([], [], 'report'); % list of reports subdirectories
            
            if ~isempty(dd)
                d0 = d;
                if d(1) == '.'
                    d = d(3:end); % subpath to split in five
                end;
                
                a = regexp(d, filesep(), 'split');
                
                switch length(a)
                    case 4
                        a{5} = '-';

                        % #sameblock ---begin---
                        
                        for j = 1:numel(dd)
                            dm(j) = length(dir(fullfile(dd{j}, '*.html')))-2;
                        end;

                        i = size(o.map, 1)+1;
                        o.map(i, 1:8) = {a{:}, dd, d0, dm}; %#ok<CCAT>
                        
                        % #sameblock ---end---
                        
                    case 5

                        % #sameblock ---begin---
                        
                        for j = 1:numel(dd)
                            dm(j) = length(dir(fullfile(dd{j}, '*.html')))-2;
                        end;

                        i = size(o.map, 1)+1;
                        o.map(i, 1:8) = {a{:}, dd, d0, dm}; %#ok<CCAT>
                        
                        % #sameblock ---end---
                    otherwise
                        irerror('I have been prepared to handle 4th or 5th-level reports only');
                end;
            end;
        end;
        
        function o = finish(o)
            n = size(o.map, 1);
            
            if n == 0
                irverbose('Nothing was generated!');
                return;
            end;
            

            s = stylesheet();
            s = cat(2, s, '<h1>Main Reports Page</h1><center>', 10);
            
            aa = {'Dataset', 'Observation meaning', 'Portion of dataset used', 'Dataset split', 'Pre-processing spec'};
            for k = 1:5
                ma = o.map;
                slice = ma(:, k);
                [vv, ii] = sort(slice);
                ma = ma(ii, :);
               

                s = cat(2, s, '<h2>Sorted by ', aa{k}, '</h2>');
                s = cat(2, s, '<table class="bo">');

                for i = 1:n
                    s = cat(2, s, '<tr>', 10);
                    
                    % five first columns
                    for m = 1:5
                        s = cat(2, s, '<td class="bo" valign=top>', iif(m == k, '<b>', ''), ma{i, m}, iif(m == k, '<b>', ''), '</td>', 10);
                    end;
                    
                    % links-to-files column
                    s = cat(2, s, '<td class="bo">', 10);
                    rr = ma{i, 6};
                    sdir = ma{i, 7};
                    sdir(sdir == '\') = '/';
                    if sdir(1) == '.'
                        sdir = sdir(3:end);
                    end;
                    nj = length(rr);
                    for j = 1:nj
                        sreport = rr{j};
                        sreport(sreport == filesep()) = [];
                        sreport(sreport == '.') = [];
                        s = cat(2, s, iif(j > 1, '<br/>', ''), '<a href="', sdir, '/', sreport, '/', 'index.html">', sreport, ' (groups: ', int2str(ma{i, 8}(j)), ')</a>', 10);
                    end;
                    s = cat(2, s, '</td></tr>', 10);
                end;
                s = cat(2, s, '</table>', 10);
            end;
            
            s = cat(2, s, '</center>', 10);
            
            h = fopen('index.html', 'w');
            fwrite(h, s);
            fclose(h);
        end;
    end;
end