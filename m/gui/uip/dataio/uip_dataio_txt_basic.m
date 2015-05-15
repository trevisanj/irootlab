%> @ingroup guigroup
%> @file
%> @brief Asks user whether to use x-axis range from file or a custom one.
%> @image html Screenshot-uip_dataio_txt_basic.png
%
%> @cond
function varargout = uip_dataio_txt_basic(varargin)
% Last Modified by GUIDE v2.5 11-Jul-2013 15:01:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_dataio_txt_basic_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_dataio_txt_basic_OutputFcn, ...
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


% --- Executes just before uip_dataio_txt_basic is made visible.
function uip_dataio_txt_basic_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);

% --- Outputs from this function are returned to the command line.
function varargout = uip_dataio_txt_basic_OutputFcn(hObject, eventdata, handles) 
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


%#########
function params = get_params(handles)
params = {...
'range', mat2str([eval(get(handles.editFrom, 'String')), eval(get(handles.editTo, 'String'))]), ...
};


% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles)
try
    handles.output.params = get_params(handles);
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
end;

function editTo_Callback(hObject, eventdata, handles)

function editFrom_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editFrom_Callback(hObject, eventdata, handles)

function editTo_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%>@endcond
