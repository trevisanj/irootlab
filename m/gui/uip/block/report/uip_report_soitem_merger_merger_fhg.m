%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref report_soitem_merger_merger_fhg
%> @sa report_soitem_merger_merger_fhg

%>@cond
function varargout = uip_report_soitem_merger_merger_fhg(varargin)
% Last Modified by GUIDE v2.5 26-Jul-2012 14:54:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_report_soitem_merger_merger_fhg_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_report_soitem_merger_merger_fhg_OutputFcn, ...
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


% --- Executes just before uip_report_soitem_merger_merger_fhg is made visible.
function uip_report_soitem_merger_merger_fhg_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_report_soitem_merger_merger_fhg_OutputFcn(hObject, eventdata, handles) 
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
listbox_load_from_workspace('biocomparer', handles.popupmenu_biocomparer, 1);
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
    sbiocomparer = listbox_get_selected_1stname(handles.popupmenu_biocomparer);
    if isempty(sbiocomparer)
        sbiocomparer = '[]';
    end;
    ssubsetsprocessor = listbox_get_selected_1stname(handles.popupmenu_subsetsprocessor);
    if isempty(ssubsetsprocessor)
        ssubsetsprocessor = '[]';
    end;
    
    handles.output.params = {...
    'flag_draw_stability', int2str(get(handles.checkbox_flag_draw_stability, 'Value')) ...
    'flag_biocomp_per_clssr', int2str(get(handles.checkbox_flag_biocomp_per_clssr, 'Value')), ...
    'flag_biocomp_per_stab', int2str(get(handles.checkbox_flag_biocomp_per_stab, 'Value')), ...
    'flag_biocomp_all', int2str(get(handles.checkbox_flag_biocomp_all, 'Value')), ...
    'flag_nf4grades', int2str(get(handles.checkbox_flag_nf4grades, 'Value')), ...
    'flag_biocomp_nf4grades', int2str(get(handles.checkbox_flag_biocomp_nf4grades, 'Value')), ...
    'flag_biocomp_per_ssp', int2str(get(handles.checkbox_flag_biocomp_per_ssp, 'Value')), ...
    'stab4all', int2str(eval(get(handles.edit_stab4all, 'String'))), ...
    'peakdetector', speakdetector, ...
    'biocomparer', sbiocomparer, ...
    'subsetsprocessor', ssubsetsprocessor, ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

function checkbox_flag_biocomp_per_clssr_Callback(hObject, eventdata, handles) %#ok<*INUSD>

% --- Executes on selection change in popupmenuDataHint.
function popupmenuDataHint_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenuDataHint_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenuPeakdetector.
function popupmenuPeakdetector_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenuPeakdetector_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function checkbox_flag_biocomp_all_Callback(hObject, eventdata, handles)

function radiobutton_curves_Callback(hObject, eventdata, handles)
if get(hObject, 'Value') > 0
    set(handles.radiobutton_pl, 'Value', 0);
end;
function radiobutton_pl_Callback(hObject, eventdata, handles)
if get(hObject, 'Value') > 0
    set(handles.radiobutton_curves, 'Value', 0);
end;
function checkbox_flag_biocomp_per_stab_Callback(hObject, eventdata, handles)
function edit_stab4all_Callback(hObject, eventdata, handles)
function edit_stab4all_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_subsetsprocessor_Callback(hObject, eventdata, handles)
function popupmenu_subsetsprocessor_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_biocomparer_Callback(hObject, eventdata, handles)
function popupmenu_biocomparer_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_peakdetector_Callback(hObject, eventdata, handles)
function popupmenu_peakdetector_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function checkbox_flag_nf4grades_Callback(hObject, eventdata, handles)
function checkbox_flag_biocomp_nf4grades_Callback(hObject, eventdata, handles)
function checkbox_flag_biocomp_per_ssp_Callback(hObject, eventdata, handles)
function checkbox_flag_draw_stability_Callback(hObject, eventdata, handles)
%> @endcond


