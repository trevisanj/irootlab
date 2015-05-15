%> @ingroup guigroup
%> @file
%> @brief Draws datasets in orhistgui
%
%> @param flag_msg=1 Whether to alarm about incompatible dataset
function orhistgui_view2(flag_msg)
handles = orhistgui_find_handles();
global FONTSIZE;
temp = FONTSIZE;

if nargin < 1 || isempty(flag_msg)
    flag_msg = 1;
end;

try
    flag_continue = 1;
    sdata = listbox_get_selected_1stname(handles.popupmenu_data);
    if isempty(sdata)
        if flag_msg
            irerror('Dataset not specified!');
        else
            flag_continue = 0;
        end;
    end;
    
    if flag_continue
        data = evalin('base', [sdata, ';']);

        % Makes a dataset with the removed rows
        blk = handles.remover;

        if data.no ~= blk.no
            if flag_msg
                irerror(sprintf('Selected dataset has an incompatible number of rows: actual: %d; expected: %d', data.no, blk.no));
            else
                flag_continue = 0;
            end;
        end;
        
        if flag_continue
            map_out = 1:data.no;
            map_out(blk.map) = [];
            dsin = data.map_rows(blk.map);
            dsout = data.map_rows(map_out);

            FONTSIZE = 15; %#ok<*NASGU>
            ov = vis_alldata();

            axes(handles.axes2); %#ok<*MAXES>
            hold off;
            ov.use(dsin);
            title('Rows remaining');

            axes(handles.axes3);
            hold off;
            ov.use(dsout);
            title('Rows removed');

            FONTSIZE = temp;
        end;
    end;
catch ME
    FONTSIZE = temp;
    send_error(ME);
end;
