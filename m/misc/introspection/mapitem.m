%> @ingroup introspection
%> @brief Map item
classdef mapitem < handle
    properties
        %> (String) Item corresponding class name
        name;
        %> (3-element vector) Item's color
        color;
        %> (String) Class title (classtitle property of corresponding class)
        title;
        %> (String) Input class (inputclass property of correspondign class)
        input;
        %> Array of mapitem objects
        descendants = mapitem.empty;
        %> (String) Name of ancestor class
        ancestor;
        %> Parent object
        parent;
        
        %> Level of item in the class map tree it belongs to
        level;
        %> Whether the item is a leaf in the map tree it belongs to
        flag_final = 0;
        
        %> Used when item is converted to list
        index;
        %> Used when item is converted to list
        parentindex;
        
        
    end;
    
    
    methods(Static, Access=private)
        function [l, flag, index] = to_list_(item, inputobj, level, index, parentindex)
            flag = 0;
            no_desc = length(item.descendants);
            if no_desc == 0
                flag = isempty(inputobj);
                if ~flag
                    if ~iscell(item.input)
                        flag = isa(inputobj, item.input);                        
                    else
                        for i = 1:length(item.input)
                            if isa(inputobj, item.input{i});
                                flag = 1;
                                break;
                            end;
                        end;
                    end;
                end;

                if flag
                    temp = copy_obj(item);
                    temp.flag_final = 1;
                    temp.level = level;
                    temp.index = index;
                    temp.parentindex = parentindex;
                    index = index+1;
                    
                    l = temp;
                else
                    l = mapitem.empty;
                end;
            else
                l = mapitem.empty;
                for i = 1:no_desc
                    if ~flag
                        index_temp = index+1;  % Reserves 1 for current item
                        parentindex_temp = index;
                    else
                        index_temp = index;
                        parentindex_temp = indexpow;
                    end;
                        
                    [ltemp, flag_temp, index_] = mapitem.to_list_(item.descendants(i), inputobj, level+1, index_temp, parentindex_temp);
                    if flag_temp
                        if ~flag % first descendant
                            temp = copy_obj(item);
                            temp.flag_final = 0;
                            temp.level = level;
                            temp.index = index;
                            indexpow = index;
                            temp.parentindex = parentindex;
                            l = [l temp];
                            flag = 1;
                        end;
                        
                        index = index_;
                        l = [l, ltemp];
                    end;
                end;
                
                if flag
                end;
            end;
        end;
        
    end;
    
    methods
        %> @brief Builds an array containing only the items that accept the inputclass
        %> @return Array of mapitem objects
        function l = to_list(o, inputclass)
            if ~exist('inputclass', 'var') || isempty(inputclass)
                inputobj = [];
            else
                % Instantializes object of inputclass to have access to its superclasses
                inputobj = eval([inputclass, ';']);
            end;
            [l, flag] = mapitem.to_list_(o, inputobj, 1, 1, 0);
        end;
        
        
        %> @brief generates tree in HTML
        %>
        %> @param inputclass Same case as in @ref to_list()
        function s = to_html(o, inputclass)
            if ~exist('inputclass', 'var') || isempty(inputclass)
                inputobj = [];
            else
                % Instantializes object of inputclass to have access to its superclasses
                inputobj = eval([inputclass, ';']);
            end;
            [l, flag] = mapitem.to_list_(o, inputobj, 1, 1, 0);
            l = l(2:end);
            
            s = ['<table><tr>', 10, ...
                 '<td style="text-align: centre">Class Name</td>', 10, ...
                 '<td style="text-align: centre">Class Title</td>', 10, ...
                 '<td style="text-align: centre">Complete descent</td>', 10, ...
                 '</tr>', 10];
            
            
            function ss = close(n)
                ss = '';
                for j = 1:n
                    ss = cat(2, ss, '</ul>');
                end;
                ss = cat(2, ss, 10);
            end
            
            function ss = open(n)
                ss = '';
                for j = 1:n
                    ss = cat(2, ss, '<ul>');
                end;
                ss = cat(2, ss, 10);
            end
                
            
            i_level = 0;
            for i = 1:numel(l)
                if (l(i).level > i_level)
%                     s = cat(2, s, open(1));
                elseif (l(i).level < i_level)
%                     s = cat(2, s, close(i_level-l(i).level));
                end;
                indent = [repmat('&nbsp;', 1, (l(i).level-1)*3), '<span style="background-color: #', color2hex(l(i).color), '">&nbsp;&nbsp;&nbsp;</span>&nbsp;'];
                try
                    obj = eval([l(i).name, '();']);
                catch ME
                    irverbose(sprintf('Error creating instance of class "%s"', l(i).name));
                    rethrow(ME);
                end;
                s = cat(2, s, '<tr><td>', indent, l(i).name, '</td><td>', indent, l(i).title, '</td>', ...
                              '<td>', obj.get_ancestry(1), '</td>', '</tr>', 10);
                i_level = l(i).level;
            end;
            s = cat(2, s, '</table>');
%             s = cat(2, s, close(i_level));
        end;
    end;
end
