%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref fsg_clssr
%>
%> <b>Classifier</b> - see fsg_clssr::clssr
%>
%> <b>Estimation Log</b> - see fsg_clssr::estlog
%>
%> <b>Estimation Post-processor</b> - see fsg_clssr::postpr_est
%>
%> <b>Test Post-processor</b> - see fsg_clssr::postpr_test
%>
%> <b>SGS</b> - see fsg_clssr::sgs
%>
%> @sa @ref fsg_clssr

%> @cond
function varargout = uip_fsg_clssr(varargin)
% Last Modified by GUIDE v2.5 06-Sep-2011 20:20:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_fsg_clssr_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_fsg_clssr_OutputFcn, ...
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


% --- Executes just before uip_fsg_clssr is made visible.
function uip_fsg_clssr_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_fsg_clssr_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject);
    varargout{1} = handles.output;
    delete(gcf);
catch
    output.flag_ok = 0;
    output.params = {};
    varargout{1} = output;
end;


%############################################

%#########
function refresh(handles)
listbox_load_from_workspace({'clssr', 'block_cascade_base'}, handles.popupmenu_clssr, 0);
listbox_load_from_workspace('estlog', handles.popupmenu_estlog, 1, 'Use default');
listbox_load_from_workspace({'decider', 'block_cascade_base'}, handles.popupmenu_postpr_est, 1, 'Use default');
listbox_load_from_workspace('block', handles.popupmenu_postpr_test, 1, 'Use default');
listbox_load_from_workspace('sgs', handles.popupmenu_sgs, 1);


%############################################
%############################################

% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles) %#ok<*INUSL,*DEFNU>
try
    sclssr = listbox_get_selected_1stname(handles.popupmenu_clssr);
    if isempty(sclssr)
        irerror('Classifier not specified!');
    end;
    sestlog = listbox_get_selected_1stname(handles.popupmenu_estlog);
    if isempty(sestlog)
        sestlog = '[]';
    end;
    spostpr_est = listbox_get_selected_1stname(handles.popupmenu_postpr_est);
    if isempty(spostpr_est)
        spostpr_est = '[]';
    end;
    spostpr_test = listbox_get_selected_1stname(handles.popupmenu_postpr_test);
    if isempty(spostpr_test)
        spostpr_test = '[]';
    end;
    ssgs = listbox_get_selected_1stname(handles.popupmenu_sgs);
    if isempty(ssgs)
         ssgs = '[]';
    end;
    
    handles.output.params = {...
    'clssr', sclssr, ...
    'estlog', sestlog, ...
    'postpr_est', spostpr_est, ...
    'postpr_test', spostpr_test, ...
    'sgs', ssgs ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;


% --- Executes on selection change in popupmenu_estlog.
function popupmenu_estlog_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_estlog_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_data.
function popupmenu_data_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_data_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_sgs.
function popupmenu_sgs_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_sgs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_decider.
function popupmenu_decider_Callback(hObject, eventdata, handles)

function popupmenu_decider_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu_clssr_Callback(hObject, eventdata, handles)

function popupmenu_clssr_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu_postpr_test_Callback(hObject, eventdata, handles)

function popupmenu_postpr_test_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu_postpr_est_Callback(hObject, eventdata, handles)

function popupmenu_postpr_est_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%> @endcond
