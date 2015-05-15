%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref as_grades_fsg
%> @sa as_grades_fsg

%> @cond
function varargout = uip_as_grades_fsg(varargin)
% Last Modified by GUIDE v2.5 26-Aug-2012 00:54:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_as_grades_fsg_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_as_grades_fsg_OutputFcn, ...
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

% --- Executes just before uip_as_grades_fsg is made visible.
function uip_as_grades_fsg_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
if numel(varargin) < 3
    handles.input.flag_needs_fsg = 0;
else
    handles.input.flag_needs_fsg = varargin{3};
end;
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_as_grades_fsg_OutputFcn(hObject, eventdata, handles) 
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
listbox_load_from_workspace('fsg', handles.popupmenu_fsg, 0);

%############################################
%############################################


% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
try
    sfsg = listbox_get_selected_1stname(handles.popupmenu_fsg);
    if isempty(sfsg)
        irerror('FSG not specified!');
    end;

    handles.output.params = {...
    'fsg', sfsg, ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

function editVariables_Callback(hObject, eventdata, handles) %#ok<*INUSD>

% --- Executes during object creation, after setting all properties.
function editVariables_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenuType.
function popupmenuType_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenuType_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editNf_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function editNf_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editThreshold_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function editThreshold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenuFsg_Callback(hObject, eventdata, handles)

function popupmenuFsg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenu_fsg_Callback(hObject, eventdata, handles)

function popupmenu_fsg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function checkbox_flag_optimize_Callback(hObject, eventdata, handles)
function popupmenu_data_Callback(hObject, eventdata, handles)
function popupmenu_data_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
