%>@file
%>@ingroup guigroup
%>@brief Properties Window for @ref fcon_resample
%>
%>@image html Screenshot-uip_fcon_resample.png
%>
%> <b>Number of variables after resampling</b> - see fcon_resample::no_fea
%>
%> @sa fcon_resample

%>@cond
function varargout = uip_fcon_resample(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_fcon_resample_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_fcon_resample_OutputFcn, ...
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


% --- Executes just before uip_fcon_resample is made visible.
function uip_fcon_resample_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);


% --- Outputs from this function are returned to the command clae.
function varargout = uip_fcon_resample_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject);
    varargout{1} = handles.output;
    delete(gcf);
catch
    output.flag_ok = 0;
    varargout{1} = output;
end;


% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonOk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output.params = {...
'no_fea', mat2str(eval(get(handles.edit_no_fea, 'String'))) ...
};
handles.output.flag_ok = 1;
guidata(hObject, handles);
uiresume();


function edit_no_fea_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_no_fea_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%>@endcond
