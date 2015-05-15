%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref vis_log_as_fsel
%> @sa vis_log_as_fsel

%> @cond
function varargout = uip_vis_log_as_fsel(varargin)
% Last Modified by GUIDE v2.5 30-Jun-2012 14:44:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_vis_log_as_fsel_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_vis_log_as_fsel_OutputFcn, ...
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


% --- Executes just before uip_vis_log_as_fsel is made visible.
function uip_vis_log_as_fsel_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_vis_log_as_fsel_OutputFcn(hObject, eventdata, handles) 
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
listbox_load_from_workspace('irdata', handles.popupmenuData, 1);

%############################################

% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles)
try
    sdata = listbox_get_selected_1stname(handles.popupmenuData);
    if isempty(sdata)
        sdata = '[]';
    end;

    handles.output.params = {...
    'data_hint', sdata, ...
    'flag_mark', int2str(get(handles.checkbox_flag_mark, 'Value')), ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

function popupmenuData_Callback(hObject, eventdata, handles)

function popupmenuData_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function checkbox_flag_mark_Callback(hObject, eventdata, handles)
%> @endcond
