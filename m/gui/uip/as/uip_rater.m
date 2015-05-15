%> @ingroup guigroup
%> @file
%> @brief Rater (@ref rater) Properties Window
%> @sa @ref rater


%> @cond
function varargout = uip_rater(varargin)
% Last Modified by GUIDE v2.5 09-Nov-2012 16:54:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_rater_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_rater_OutputFcn, ...
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


% --- Executes just before uip_rater is made visible.
function uip_rater_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_rater_OutputFcn(hObject, eventdata, handles)  %#ok<*INUSL>
try
    uiwait(handles.figure1);
    handles = guidata(hObject);
    varargout{1} = handles.output;
    delete(gcf);
catch %#ok<*CTCH>
    output.flag_ok = 0;
    output.params = {};
    varargout{1} = output;
end;


%############################################

%#########
function refresh(handles)
listbox_load_from_workspace('block', handles.popupmenu_postpr_test, 1);
listbox_load_from_workspace('sgs', handles.popupmenu_sgs, 1);
listbox_load_from_workspace('ttlog', handles.popupmenu_estlog, 1);
listbox_load_from_workspace('block', handles.popupmenu_postpr_est, 1);
listbox_load_from_workspace({'clssr', 'block_cascade_base'}, handles.popupmenu_clssr, 1);


%############################################
%############################################

% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles)
try
    sclssr = listbox_get_selected_1stname(handles.popupmenu_clssr);
    if isempty(sclssr)
        sclssr = '[]';
    end;
    ssgs = listbox_get_selected_1stname(handles.popupmenu_sgs);
    if isempty(ssgs)
         ssgs = '[]';
    end;
    sestlog = listbox_get_selected_1stname(handles.popupmenu_estlog);
    if isempty(sestlog)
        sestlog = '[]';
    end;
    spostpr_test = listbox_get_selected_1stname(handles.popupmenu_postpr_test);
    if isempty(spostpr_test)
        spostpr_test = '[]';
    end;
    spostpr_est = listbox_get_selected_1stname(handles.popupmenu_postpr_est);
    if isempty(spostpr_est)
        spostpr_est = '[]';
    end;
    
    handles.output.params = {...
    'clssr', sclssr, ...
    'sgs', ssgs, ...
    'ttlog', sestlog, ...
    'postpr_est', spostpr_est, ...
    'postpr_test', spostpr_test ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;


function popupmenu_estlog_Callback(hObject, eventdata, handles)
function popupmenu_estlog_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_postpr_test_Callback(hObject, eventdata, handles)
function popupmenu_postpr_test_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_sgs_Callback(hObject, eventdata, handles)
function popupmenu_sgs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_postpr_est_Callback(hObject, eventdata, handles)
function popupmenu_postpr_est_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_clssr_Callback(hObject, eventdata, handles)
function popupmenu_clssr_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD,*DEFNU>
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
