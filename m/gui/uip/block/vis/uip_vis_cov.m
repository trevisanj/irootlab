%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref vis_cov
%> @image html Screenshot-uip_vis_cov.png
%>
%> <b>Type</b> - see vis_cov::type
%>
%> <b>Dataset for hint</b> - see vis_cov::data_hint
%>
%> @sa vis_cov

%>@cond
function varargout = uip_vis_cov(varargin)
% Last Modified by GUIDE v2.5 22-Aug-2011 16:21:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_vis_cov_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_vis_cov_OutputFcn, ...
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


% --- Executes just before uip_vis_cov is made visible.
function uip_vis_cov_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_vis_cov_OutputFcn(hObject, eventdata, handles) 
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
listbox_load_from_workspace('irdata', handles.popupmenuDataHint, 1);

%############################################
%############################################

% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles)
try
    types = 'cwb';
    type = types(get(handles.popupmenu_type, 'Value'));
    
    sdata2 = listbox_get_selected_1stname(handles.popupmenuDataHint);
    if isempty(sdata2)
        sdata2 = '[]';
    end;

    handles.output.params = {...
    'data_hint', sdata2, ...
    'type', ['''', type, ''''] ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;


% --- Executes on selection change in popupmenuDataHint.
function popupmenuDataHint_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenuDataHint_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_type.
function popupmenu_type_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_type_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
