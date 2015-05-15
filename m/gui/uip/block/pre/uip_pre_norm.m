%> @ingroup guigroup
%> @file uip_pre_norm.m
%> @brief Properties Window for @ref pre_norm
%> @image html Screenshot-uip_pre_norm.png
%>
%> <b>Normalization type</b> - see normaliz.m, pre_norm::types
%>
%> <b>Feature indexes - see pre_norm::idxs_fea
%>
%> @sa pre_norm, normaliz.m

%>@cond
function varargout = uip_pre_norm(varargin)
% Last Modified by GUIDE v2.5 04-Feb-2011 14:30:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_pre_norm_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_pre_norm_OutputFcn, ...
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

% --- Executes just before uip_pre_norm is made visible.
function uip_pre_norm_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_pre_norm_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles)
try
    types = 'vcna12sr';
    
    handles.output.params = {...
    'types', ['''' types(get(handles.popupmenuType, 'Value')) ''''], ...
    'idxs_fea', get(handles.editIdxs_fea, 'String') ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

% --- Executes on selection change in popupmenuType.
function popupmenuType_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenuType_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editIdxs_fea_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function editIdxs_fea_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%> @endcond
