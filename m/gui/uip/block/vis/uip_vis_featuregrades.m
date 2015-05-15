%> @ingroup guigroup
%> @file
%> @brief Properties Dialog for @ref vis_featuregrades
%>
%> <b>FSG</b> - see vis_featuregrades::fsg
%>
%> @image html Screenshot-uip_vis_featuregrades.png
%>
%> @sa vis_featuregrades

%> @cond
function varargout = uip_vis_featuregrades(varargin)
% Last Modified by GUIDE v2.5 05-Sep-2011 14:52:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_vis_featuregrades_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_vis_featuregrades_OutputFcn, ...
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


% --- Executes just before uip_vis_featuregrades is made visible.
function uip_vis_featuregrades_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_vis_featuregrades_OutputFcn(hObject, eventdata, handles) 
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
listbox_load_from_workspace('fsg', handles.popupmenu_fsg, 0);
listbox_load_from_workspace('irdata', handles.popupmenu_data_hint, 1);

%############################################

% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles)
try
    sfsg = listbox_get_selected_1stname(handles.popupmenu_fsg);
    if isempty(sfsg)
        error('FSG not specified!');
    end;
    sdata_hint = listbox_get_selected_1stname(handles.popupmenu_data_hint);
    if isempty(sdata_hint)
        sdata_hint = '[]';
    end;

    handles.output.params = {...
    'fsg', sfsg, ...
    'data_hint', sdata_hint, ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;


% --- Executes on selection change in popupmenu_fsg.
function popupmenu_fsg_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_fsg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_data_hint.
function popupmenu_data_hint_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_data_hint_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
