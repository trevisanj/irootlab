%>@file
%>@ingroup guigroup
%>@brief Properties Window for @ref pre_sigwindow
%>
%>@image html Screenshot-uip_pre_sigwindow.png
%>
%> <b>x-axis range</b> - see pre_sigwindow::range
%>
%> <b>x-axis width</b> - see pre_sigwindow::width
%>
%> @sa pre_sigwindow

%>@cond
function varargout = uip_pre_sigwindow(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_pre_sigwindow_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_pre_sigwindow_OutputFcn, ...
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


% --- Executes just before uip_pre_sigwindow is made visible.
function uip_pre_sigwindow_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);


% --- Outputs from this function are returned to the command clae.
function varargout = uip_pre_sigwindow_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject);
    varargout{1} = handles.output;
    delete(gcf);
catch
    output.flag_ok = 0;
    varargout{1} = output;
end;

% --- Executes during object creation, after setting all properties.
function editReg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles)
handles.output.params = {...
'range', mat2str(eval(get(handles.edit_range, 'String'))), ...
'width', num2str(eval(get(handles.edit_width, 'String'))) ...
};
handles.output.flag_ok = 1;
guidata(hObject, handles);
uiresume();

function edit_range_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_range_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_width_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_width_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%>@endcond
