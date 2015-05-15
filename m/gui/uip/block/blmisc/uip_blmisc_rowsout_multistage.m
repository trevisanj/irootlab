%> @ingroup guigroup
%> @file
%> @brief Properties Window for a Multi-stage Outlier Removal block
%> @sa blmisc_rowsout_multistage

%> @cond
function varargout = uip_blmisc_rowsout_multistage(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_blmisc_rowsout_multistage_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_blmisc_rowsout_multistage_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before uip_blmisc_rowsout_multistage is made visible.
function uip_blmisc_rowsout_multistage_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
handles.processors = {};
handles.removers = {};
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

% --- Outputs from this function are returned to the command line.
function varargout = uip_blmisc_rowsout_multistage_OutputFcn(hObject, eventdata, handles) 
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


%############################################
%############################################

%############
function refresh(handles)

% logs and classifiers
listbox_load_from_workspace('blmisc_rowsout', handles.listbox_removers, 0);
% set(handles.edit_log_mold, 'String', handles.names_log_mold);
listbox_load_from_workspace('block', handles.listbox_processors, 0);
local_show_description(handles, []);

%############
function local_show_description(handles, listbox)
if isempty(listbox)
    set(handles.edit_description, 'String', {});
end;
show_description(listbox, handles.edit_description);

%############################################
%############################################


% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles)
try
    if isempty(handles.processors)
        irerror('At least one (processor, remover) pair is needed!');
    end;

    handles.output.params = {...
    'flag_mark_only', int2str(get(handles.checkbox_flag_mark_only, 'Value')), ...
    'mode', int2str(get(handles.popupmenu_mode, 'value')-1), ...
    'processors', params2str2(handles.processors) ...
    'removers', params2str2(handles.removers), ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
end;

%#####
function listbox_processors_Callback(hObject, eventdata, handles) %#ok<*INUSL,*DEFNU>
local_show_description(handles, handles.listbox_processors);

%#####
function listbox_removers_Callback(hObject, eventdata, handles)
local_show_description(handles, handles.listbox_removers);

%#####
function pushbutton_add_Callback(hObject, eventdata, handles)
name_pr = listbox_get_selected_1stname(handles.listbox_processors);
name_re = listbox_get_selected_1stname(handles.listbox_removers);

flag_error = 0;
s = '';
if isempty(name_re)
    flag_error = 1;
    s = 'I need an outlier remover block to form the pair!';
end;
if isempty(name_pr)
    name_pr = '[]';
end;

if flag_error
    irerrordlg(s, 'Cannot add');
else
    handles.processors{end+1} = name_pr;
    handles.removers{end+1} = name_re;
    a = cellstr(get(handles.edit_pairs, 'string'));
    if numel(a) == 1 && isempty(a{1})
        a = {};
    end;
    a{end+1} = sprintf('(%s, %s)', name_pr, name_re);
    set(handles.edit_pairs, 'string', a);
    guidata(hObject, handles);
    refresh(handles);
end;

%#####
function pushbutton_restart_Callback(hObject, eventdata, handles)
set(handles.edit_pairs, 'String', {});
handles.processors = {};
handles.removers = {};
guidata(hObject, handles);
refresh(handles);

%--------------------------------------------------------------------------------------------

function popupmenu_mode_Callback(hObject, eventdata, handles)
function edit_description_Callback(hObject, eventdata, handles) %#ok<*INUSD>
function edit_description_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_mode_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_pairs_Callback(hObject, eventdata, handles)
function edit_pairs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function listbox_removers_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_log_mold_Callback(hObject, eventdata, handles)
function edit_log_mold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function listbox_processors_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_data_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function checkbox_flag_mark_only_Callback(hObject, eventdata, handles)
%> @endcond
