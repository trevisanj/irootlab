%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref report_log_fselrepeater_hist
%>
%> <b>Dataset for hint</b> - see report_log_fselrepeater_hist::data_hint
%>
%> <b>Peak Detector</b> - see report_log_fselrepeater_hist::peakdetector
%>
%> @sa report_log_fselrepeater_hist

%>@cond
function varargout = uip_report_log_fselrepeater_hist(varargin)
% Last Modified by GUIDE v2.5 06-Jul-2013 20:30:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_report_log_fselrepeater_hist_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_report_log_fselrepeater_hist_OutputFcn, ...
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


% --- Executes just before uip_report_log_fselrepeater_hist is made visible.
function uip_report_log_fselrepeater_hist_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_report_log_fselrepeater_hist_OutputFcn(hObject, eventdata, handles) 
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
listbox_load_from_workspace('peakdetector', handles.popupmenu_peakdetector, 1);
listbox_load_from_workspace('irdata', handles.popupmenu_data_hint, 1);
listbox_load_from_workspace('subsetsprocessor', handles.popupmenu_subsetsprocessor, 1);


%############################################
%############################################

% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles) %#ok<*DEFNU,*INUSL>
try
    speakdetector = listbox_get_selected_1stname(handles.popupmenu_peakdetector);
    if isempty(speakdetector)
        speakdetector = '[]';
    end;
    sdata_hint = listbox_get_selected_1stname(handles.popupmenu_data_hint);
    if isempty(sdata_hint)
        sdata_hint = '[]';
    end;
    ssubsetsprocessor = listbox_get_selected_1stname(handles.popupmenu_subsetsprocessor);
    if isempty(ssubsetsprocessor)
        ssubsetsprocessor = '[]';
    end;
    
    handles.output.params = {...
    'peakdetector', speakdetector, ...
    'data_hint', sdata_hint, ...
    'subsetsprocessor', ssubsetsprocessor, ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

function popupmenu_subsetsprocessor_Callback(hObject, eventdata, handles)
function popupmenu_subsetsprocessor_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_data_hint_Callback(hObject, eventdata, handles)
function popupmenu_data_hint_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_peakdetector_Callback(hObject, eventdata, handles)
function popupmenu_peakdetector_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
