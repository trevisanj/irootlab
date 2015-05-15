%> @file
%>@ingroup introspection
%>
%> @sa classmap_assert.m, classmap_compile.m

%> @brief Scans IRootLab directories and build hierarchical class maps
classdef classmap < handle
    properties
        timestamp;
        root;
    end;
    
    methods(Static, Access=private)
        %===============================================================================
        % Copyright (C) 2003 Guillaume Flandin <Guillaume@artefact.tk>
        % (extracted from m2html.m)
        %
        % changed to get files with "new." in the name
        function mfiles = getmfiles(mdirs,mfiles,recursive)
            %- Extract M-files from a list of directories and/or M-files

            for i=1:length(mdirs)
                if exist(mdirs{i}) == 2 % M-file
                    mfiles{end+1} = mdirs{i};
                elseif exist(mdirs{i}) == 7 % Directory
                    w = what(mdirs{i});
                    w = w(1); %- Sometimes an array is returned...
                    names = sort(w.m);
                    for j=1:length(names)
        %                 if findstr('new.', w.m{j})
        %                    mfiles{end+1} = fullfile(mdirs{i},w.m{j});
                             mfiles{end+1} = names{j};
        %                 end;
                    end
                    if recursive
                        d = dir(mdirs{i});
                        d = {d([d.isdir]).name};
                        d = {d{~ismember(d,{'.' '..'})}};
%                         [vals, idxs] = sort(d);
                        d = sort(d);
                        for j=1:length(d)
                            mfiles = classmap.getmfiles(cellstr(fullfile(mdirs{i},d{j})),...
                                               mfiles,recursive);
                        end
                    end
                else
                    fprintf('Warning: Unprocessed file %s.\n',mdirs{i});
                end
            end;
        end;
        
        
        function res = find_item_by_name_(item, name)
            res = [];
            if strcmp(item.name, name)
                res = item;
            else
                for i = 1:length(item.descendants)
                    res = classmap.find_item_by_name_(item.descendants(i), name);
                    if ~isempty(res)
                        break;
                    end;
                end;
            end;
        end;
            
    end;
    
    methods
        function o = classmap(o)
            o.root = mapitem();
            o.root.name = '?';
            o.root.title = '?';
        end;
        
        
        % Classname needs be a subdirectory of the IRootLab root folder
        function o = build(o, classname)

            
            o.timestamp = now();
            list = mapitem.empty;


            files = classmap.getmfiles({fullfile(get_rootdir(), 'classes', classname)}, {}, 1);


            cnt = 0;
            for i = 1:length(files)
                try
                    ss = textread(files{i}, '%s');
                catch ME
                    disp('wtfwtfwtfwtfwtfwtfwtfwtfwtfwtfwtfwtfwtfwtfwtfwtfwtfwtfwtf');
                end;
                if ismember('classdef', ss)
                    disp([files{i} '...']);
                    try
                        obj = eval(files{i}(1:end-2));
            %         disp(obj);


                        if obj.flag_ui && isa(obj, classname)
                            temp = superclasses(obj);
                            name = class(obj);
                            oo = mapitem();
                            oo.name = name;
                            oo.color = obj.color;
                            oo.title = obj.classtitle;
                            oo.ancestor = temp{1};

                             if isa(obj, 'block')
                                oo.input = obj.inputclass;
                             end;



                            cnt = cnt+1;
                            list(cnt) = oo; % to organize later
                            names{cnt} = name; % to help find the classes

                            if strcmp(list(cnt).name, classname)
                                o.root.descendants(end+1) = list(cnt);
                            end;
                        end;     
                    catch ME
                        irverbose(['Failed mapping file ', files{i}(1:end-2), '!!!!!!!!!!!!!!!!!!!!!!'], 3);
                        rethrow(ME);
                    end;
                end;
            end;


            for i = 1:length(list)
                if ~strcmp(list(i).name, classname)
                    [val, idx] = find(strcmp(names, list(i).ancestor));
                    if (isempty(idx))
                        irerror(sprintf('Ancestor ''%s'' for class ''%s'' not found!', list(i).ancestor, list(i).name));
                    end;
            %         fprintf('********%s %d\n', list(i).ancestor, idx);
                    list(idx).descendants(end+1) = list(i);
                    list(i).parent = list(idx);
                end;
            end;
        end;
        
        
        function item = find_item_by_name(o, name)
            item = classmap.find_item_by_name_(o.root, name);
        end;
    end;
end
