%> @ingroup guigroup
%> @file
%> @brief Class Selection Dialog
%>
%> @image html Screenshot-blockmenu.png
%>
%> <h3>Input parameters (varargin)</h3>
%> @arg rootclassname
%> @arg dsnames
%> <h3>Output</h3>
%> Structure containing the following fields: flag_ok, params, classname
function varargout = blockmenu(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @blockmenu_OpeningFcn, ...
                   'gui_OutputFcn',  @blockmenu_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
               
% This was the default what-to-do with in arguments; this is the first time I am using them, so won't just delete the
% shit.
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT




%> @cond
% --- Executes just before blockmenu is made visible.
function blockmenu_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
% 

if length(varargin) < 1
    varargin{1} = 'block';
end;
if length(varargin) < 2
    varargin{2} = [];
end;

[rootclassname, dsnames] = varargin{[1, 2]};


handles.input.rootclassname = rootclassname;
handles.input.dsnames = dsnames;
% handles.input.prefix_behaviour = prefix_behaviour;
handles.output.flag_ok = 0;


%%% Population


% Resolves datasets.
flag_ds = ~isempty(dsnames);
if flag_ds
    for i = 1:length(dsnames)
        datasets(i) = evalin('base', [dsnames{i} ';']);
    end;
    inputclass = class(datasets(1));
else
    inputclass = '';
    datasets = [];
end;

handles.input.datasets = datasets;
list = classmap_get_list(rootclassname, inputclass); % descendants of classname that have class(data) as inputclass
handles.list = list;
handles.idx_in = 1:numel(list); % Indexes of list elements to show
handles.al = lower(itemlist2cell(list));
handles.a = itemlist2cell(list);

uicontrol(handles.edit_filter); % Sets focus

guidata(hObject, handles);

% The popupmenu ...
populate_listbox(handles);

gui_set_position(hObject);
o = eval([rootclassname ';']);
set(hObject, 'Color', o.color);
set(handles.textChoose, 'BackgroundColor', o.color); % I don't know how to make staticText transparent so far, or inherit parent's color
set(handles.text_filter, 'BackgroundColor', o.color); % I don't know how to make staticText transparent so far, or inherit parent's color

% if numel(list) == 1
%     % If there is only one option, does an automatic OK button
%     do_ok(handles);
% end;






%################################################################
%################################################################

%#################################
function do_ok(handles)

if length(get(handles.listboxType, 'String')) > 0 %#ok<*ISMT>
    which = handles.idx_in(get(handles.listboxType, 'Value'));
    item = handles.list(which);
    if ~item.flag_final
        msgbox('Please select a deepest-level option!');
    else
        classname = handles.list(which).name;
        try
            obj = eval([classname, ';']);
            result = obj.get_params(handles.input.datasets);

            if result.flag_ok
                handles.output.flag_ok = 1;
                handles.output.classname = classname;
                handles.output.params = result.params;
                guidata(handles.figure1, handles);
                uiresume;
            end;

        catch ME
            send_error(ME);
        end;
            
    end;
end;


%#################################
function populate_listbox(handles)
filter = fel(get(handles.edit_filter, 'String'));
if ~isempty(filter)
    filter = lower(filter);
    idxs = find(cellfun(@(x) (~isempty(x)), cellfun(@(x) (findstr(filter, x)), handles.al, 'UniformOutput', 0)));
    b = zeros(1, numel(handles.a));
    for i = 1:numel(idxs)
        if handles.list(idxs(i)).flag_final
            b(idxs(i)) = 1;
            ob = handles.list(idxs(i));
            while 1
                if ob.level == 1
                    break;
                end;
                ob = handles.list(ob.parentindex);
                b(ob.index) = 1;
            end;
        end;
    end;
    handles.idx_in = find(b);
else
    handles.idx_in = 1:numel(handles.a);
end;

set(handles.listboxType, 'Value', 1);
set(handles.listboxType, 'String', handles.a(handles.idx_in));
guidata(handles.figure1, handles);

%################################################################
%################################################################





% --- Outputs from this function are returned to the command line.
function varargout = blockmenu_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject); % Handles is not a handle(!), so gotta retrieve it again to see changes in .output
    varargout{1} = handles.output;
    delete(gcf);
catch %#ok<*CTCH>
    output.flag_ok = 0;
    output.params = {};
    varargout{1} = output;
end;

% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
do_ok(handles);

% --- Executes on selection change in listboxType.
function listboxType_Callback(hObject, eventdata, handles)
if strcmp(get(handles.figure1, 'SelectionType'), 'open') % This is how you detect a double-click in MATLAB
    do_ok(handles);
end;
    

% --- Executes during object creation, after setting all properties.
function listboxType_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD>
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_cancel.
function pushbutton_cancel_Callback(hObject, eventdata, handles)
close();



function edit_filter_Callback(hObject, eventdata, handles)
populate_listbox(handles);

% --- Executes during object creation, after setting all properties.
function edit_filter_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_filter_KeyPressFcn(hObject, eventdata, handles)
%> @endcond
