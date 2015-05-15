%> @ingroup guigroup
%> @file
%> @brief Repeated Train-Test (@ref reptt) Properties Window
%>
%> This window asks for properties common to all @ref reptt classes
%>
%> @image html Screenshot-uip_reptt.png
%>
%> <b>Test post-processor</b> (optional) - see reptt::postpr_test
%>
%> <b>Estimation post-processor</b> - see reptt::postpr_est
%>
%> <b>Mold Classifiers</b> - see reptt::block_mold
%>
%> <b>Mold Train-Test Logs</b> - see reptt::log_mold
%>
%> @sa reptt

%> @cond
function varargout = uip_reptt(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_reptt_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_reptt_OutputFcn, ...
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

% --- Executes just before uip_reptt is made visible.
function uip_reptt_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
handles.names_block_mold = {};
handles.names_log_mold = {};
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

% --- Outputs from this function are returned to the command line.
function varargout = uip_reptt_OutputFcn(hObject, eventdata, handles) 
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
listbox_load_from_workspace('ttlog', handles.listbox_log_mold, 0);
v = get(handles.listbox_log_mold, 'Value');
if sum(v > length(handles.names_log_mold)) > 0 && ~isempty(handles.names_log_mold)
    set(handles.listbox_log_mold, 'Value', 1);
end;
set(handles.edit_log_mold, 'String', handles.names_log_mold);

listbox_load_from_workspace({'clssr', 'block_cascade_base'}, handles.listbox_block_mold, 0);
v = get(handles.listbox_block_mold, 'Value');
if sum(v > length(handles.names_block_mold)) > 0 && ~isempty(handles.names_block_mold)
    set(handles.listbox_block_mold, 'Value', 1);
end;
set(handles.edit_block_mold, 'String', handles.names_block_mold);


% others
listbox_load_from_workspace('block', handles.popupmenu_postpr_est, 0);
listbox_load_from_workspace('block', handles.popupmenu_postpr_test, 1);


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
    spostpr_test = listbox_get_selected_1stname(handles.popupmenu_postpr_test);
    if isempty(spostpr_test)
        spostpr_test = '[]';
    end;
    spostpr_est = listbox_get_selected_1stname(handles.popupmenu_postpr_est);
    if isempty(spostpr_est)
        irerror('Estimation Post-Processor not specified!');
    end;

    if isempty(handles.names_block_mold)
        irerror('No mold Classifiers specified!');
    end;

    if isempty(handles.names_log_mold)
        irerror('No mold Train-Test Logs specified!');
    end;


    handles.output.params = {...
    'postpr_test', spostpr_test, ...
    'postpr_est', spostpr_est, ...
    'log_mold', params2str2(handles.names_log_mold) ...
    'block_mold', [params2str2(handles.names_block_mold), ''''], ... % Transposes the list of blocks to have a column instead of a row
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
end;

% --- Executes on selection change in listbox_block_mold.
function listbox_block_mold_Callback(hObject, eventdata, handles) %#ok<*INUSL,*DEFNU>
local_show_description(handles, handles.listbox_block_mold);

% --- Executes on selection change in listbox_log_mold.
function listbox_log_mold_Callback(hObject, eventdata, handles)
local_show_description(handles, handles.listbox_log_mold);


% --- Executes on button press in pushbutton_block_mold_add.
function pushbutton_block_mold_add_Callback(hObject, eventdata, handles)
nn = listbox_get_selected_1stname(handles.listbox_block_mold);
if ~isempty(nn)
    handles.names_block_mold{end+1} = nn;
    guidata(hObject, handles);
    refresh(handles);
end;

% --- Executes on button press in pushbutton_block_mold_restart.
function pushbutton_block_mold_restart_Callback(hObject, eventdata, handles)
set(handles.edit_block_mold, 'String', {});
handles.names_block_mold = [];
guidata(hObject, handles);
refresh(handles);

% --- Executes on button press in pushbutton_log_mold_add.
function pushbutton_log_mold_add_Callback(hObject, eventdata, handles)
nn = listbox_get_selected_1stname(handles.listbox_log_mold);
if ~isempty(nn)
    handles.names_log_mold{end+1} = nn;
    guidata(hObject, handles);
    refresh(handles);
end;

% --- Executes on button press in pushbutton_log_mold_restart.
function pushbutton_log_mold_restart_Callback(hObject, eventdata, handles)
set(handles.edit_log_mold, 'String', {});
handles.names_log_mold = [];
guidata(hObject, handles);
refresh(handles);

function edit_description_Callback(hObject, eventdata, handles) %#ok<*INUSD>

% --- Executes during object creation, after setting all properties.
function edit_description_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_postpr_test.
function popupmenu_postpr_test_Callback(hObject, eventdata, handles)
local_show_description(handles, handles.popupmenu_postpr_test);

% --- Executes during object creation, after setting all properties.
function popupmenu_postpr_test_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in popupmenu_postpr_est.
function popupmenu_postpr_est_Callback(hObject, eventdata, handles)
local_show_description(handles, handles.popupmenu_postpr_est);


% --- Executes during object creation, after setting all properties.
function popupmenu_postpr_est_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_block_mold_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_block_mold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function listbox_log_mold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_log_mold_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_log_mold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function listbox_block_mold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_data.
function popupmenu_data_Callback(hObject, eventdata, handles)
local_show_description(handles, handles.popupmenu_data);


% --- Executes during object creation, after setting all properties.
function popupmenu_data_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
