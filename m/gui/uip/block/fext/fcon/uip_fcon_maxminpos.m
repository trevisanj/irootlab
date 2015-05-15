%>@file
%>@ingroup guigroup
%>@brief Properties Window for @ref fcon_maxminpos
%>
%> <b>Map</b> - see fcon_maxminpos::map
%>
%> @sa fcon_maxminpos, peak_landmarks.m

%>@cond
function varargout = uip_fcon_maxminpos(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @blockuip_fsel_rmiesc_OpeningFcn, ...
                   'gui_OutputFcn',  @blockuip_fsel_rmiesc_OutputFcn, ...
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


% --- Executes just before blockuip_fsel_rmiesc is made visible.
function blockuip_fsel_rmiesc_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);


% --- Outputs from this function are returned to the command clae.
function varargout = blockuip_fsel_rmiesc_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject);
    varargout{1} = handles.output;
    delete(gcf);
catch %#ok<*CTCH>
    output.flag_ok = 0;
    varargout{1} = output;
end;

function pushbuttonOk_Callback(hObject, eventdata, handles) %#ok<*DEFNU>

temp = get(handles.edit_options, 'String');
s = sprintf('%s\n', temp{:});

handles.output.params = {...
'map', mat2str(eval(s)) ...
};
handles.output.flag_ok = 1;
guidata(hObject, handles);
uiresume();


function edit_options_Callback(hObject, eventdata, handles) %#ok<*INUSD>

function edit_options_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%>@endcond
