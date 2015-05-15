%>@file
%>@ingroup guigroup
%>@brief Properties Window for @ref fcon_lda
%>
%> @image html Screenshot-uip_fcon_lda.png
%>
%> <b>Penalty coefficients</b> - see fcon_lda::penalty
%>
%>
%> @sa fcon_lda

%>@cond
function varargout = uip_fcon_lda(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_fcon_lda_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_fcon_lda_OutputFcn, ...
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


% --- Executes just before uip_fcon_lda is made visible.
function uip_fcon_lda_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);


% --- Outputs from this function are returned to the command clae.
function varargout = uip_fcon_lda_OutputFcn(hObject, eventdata, handles) 
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
handles.output.params = {...
'penalty', mat2str(eval(get(handles.editP, 'String'))), ...
'max_loadings', mat2str(eval(get(handles.edit_max_loadings, 'String'))) ...
};
handles.output.flag_ok = 1;
guidata(hObject, handles);
uiresume();



function editP_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function editP_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_max_loadings_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function edit_max_loadings_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%>@endcond
