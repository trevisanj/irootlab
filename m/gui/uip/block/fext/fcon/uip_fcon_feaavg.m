%>@file
%>@ingroup guigroup
%>@brief Properties Window for @ref fcon_feaavg
%> @sa fcon_feaavg

%>@cond
function varargout = uip_fcon_feaavg(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @blockuip_fsel_fixed_OpeningFcn, ...
                   'gui_OutputFcn',  @blockuip_fsel_fixed_OutputFcn, ...
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


% --- Executes just before blockuip_fsel_fixed is made visible.
function blockuip_fsel_fixed_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);


% --- Outputs from this function are returned to the command clae.
function varargout = blockuip_fsel_fixed_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject);
    varargout{1} = handles.output;
    delete(gcf);
catch %#ok<*CTCH>
    output.flag_ok = 0;
    varargout{1} = output;
end;

function pushbuttonOk_Callback(hObject, eventdata, handles) %#ok<*INUSL>
handles.output.params = {...
'factor', int2str(eval(get(handles.edit_factor, 'String'))) ...
};
handles.output.flag_ok = 1;
guidata(hObject, handles);
uiresume();

function edit_factor_Callback(hObject, eventdata, handles)
function edit_factor_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD,*DEFNU>
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%>@endcond
