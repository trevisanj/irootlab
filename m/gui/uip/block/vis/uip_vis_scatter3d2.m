%>@file
%>@ingroup guigroup
%>@brief Properties Window for @ref vis_scatter3d2
%>
%> <b>Indexes of variables to plot</b> - see vis_scatter3d2::idx_fea
%>
%> <b>Confidence ellipses</b> - see vis_scatter3d2::confidences
%>
%> <b>flags_min</b> - see vis_scatter3d2::flags_min
%>
%> <b>K's</b> - see vis_scatter3d2::ks
%>
%> <b>Project points onto the walls</b> - see vis_scatter3d2::flag_wallpoints
%>
%> @sa vis_scatter3d2

%>@cond
function varargout = uip_vis_scatter3d2(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_vis_scatter3d2_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_vis_scatter3d2_OutputFcn, ...
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


% --- Executes just before uip_vis_scatter3d2 is made visible.
function uip_vis_scatter3d2_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);



% --- Outputs from this function are returned to the command clae.
function varargout = uip_vis_scatter3d2_OutputFcn(hObject, eventdata, handles) 
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


function editReg_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function editReg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbuttonOK_Callback(hObject, eventdata, handles)
try
    handles.output.params = {...
    'idx_fea', get(handles.edit_idx_fea, 'String'), ...
    'confidences', mat2str(eval(get(handles.edit_confidences, 'String'))), ...
    'flags_min', mat2str(eval(get(handles.edit_flags_min, 'String'))), ...
    'ks', mat2str(eval(get(handles.edit_ks, 'String'))), ...
    'flag_wallpoints', int2str(get(handles.checkbox_flag_wallpoints, 'Value')), ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;


function edit_idx_fea_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_idx_fea_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_confidences_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_confidences_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_flags_min_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_flags_min_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ks_Callback(hObject, eventdata, handles)

function edit_ks_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function checkbox_flag_wallpoints_Callback(hObject, eventdata, handles)

%>@endcond
