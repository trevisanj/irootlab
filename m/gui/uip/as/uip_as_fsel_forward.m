%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref as_fsel_forward (Forward Feature Selection)
%> <b>Number of features</b> - see as_fsel_forward::nf_select
%>
%> <b>Feature Subset Grader</b> - see as_fsel_forward::fsg
%>
%> @sa as_fsel_forward

%>@cond
function varargout = uip_as_fsel_forward(varargin)

% Last Modified by GUIDE v2.5 07-Aug-2012 19:27:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_as_fsel_forward_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_as_fsel_forward_OutputFcn, ...
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


% --- Executes just before uip_as_fsel_forward is made visible.
function uip_as_fsel_forward_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);

refresh(handles);


% --- Outputs from this function are returned to the command clae.
function varargout = uip_as_fsel_forward_OutputFcn(hObject, eventdata, handles)  %#ok<*INUSL>
try
    uiwait(handles.figure1);
    handles = guidata(hObject);
    varargout{1} = handles.output;
    delete(gcf);
catch
    output.flag_ok = 0;
    varargout{1} = output;
end;




%############################################

%#########
function refresh(handles)
listbox_load_from_workspace('fsg', handles.popupmenuFsg);


%############################################
%############################################

% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
sfsg = listbox_get_selected_1stname(handles.popupmenuFsg);
if isempty(sfsg)
    irerrordlg('Please specify FSG object!', 'Cannot continue');
else
    handles.output.params = {...
    'nf_select', int2str(eval(get(handles.editNf, 'String'))), ...
    'fsg', sfsg ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
end;

function editVariables_Callback(hObject, eventdata, handles) %#ok<*INUSD>

% --- Executes during object creation, after setting all properties.
function editVariables_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editNf_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function editNf_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuFsg.
function popupmenuFsg_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenuFsg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%> @endcond
