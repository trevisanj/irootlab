%> @ingroup guigroup
%> @file
%> @brief Properties Window used by @ref uip_vis_loadings.m and @ref uip_vis_cv.m
%> @image html Screenshot-uip_vis_loadings.png
%>
%> @attention Although it does not have a corresponding block, this file is used by uip_vis_cv.m and uip_vis_loadings.m
%>
%> <b>Dataset for hint</b> - see vis_loadings::data_hint
%>
%> <b>Flip negative values</b> - see vis_loadings::flag_abs
%>
%> <b>Peak Detector</b> - see vis_loadings::peakdetector
%>
%> <b>Trace "minimum altitude" line from peak detector</b> - see vis_loadings::flag_trace_minalt
%>
%> <b>Plot as Peak Location Plots</b> - see vis_loadings::flag_trace_minalt
%>
%> @sa vis_loadings

%>@cond
function varargout = uip_vis_grades(varargin)
% Last Modified by GUIDE v2.5 18-Feb-2012 18:03:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_vis_grades_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_vis_grades_OutputFcn, ...
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


% --- Executes just before uip_vis_grades is made visible.
function uip_vis_grades_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_vis_grades_OutputFcn(hObject, eventdata, handles) 
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
listbox_load_from_workspace('peakdetector', handles.popupmenuPeakdetector, 1);


%############################################
%############################################

% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles)
try
    sdata2 = listbox_get_selected_1stname(handles.popupmenuDataHint);
    if isempty(sdata2)
        sdata2 = '[]';
    end;
    spd = listbox_get_selected_1stname(handles.popupmenuPeakdetector);
    flag_pd = 1;
    if isempty(spd)
        flag_pd = 0;
        spd = '[]';
    end;

    flag_bmtable = get(handles.radiobutton_pl, 'Value') > 0;
    
    if flag_bmtable && ~flag_pd
        irerror('Peak detector must be provided in order to plot "Peak Location Plots"!');
    end;
    
    handles.output.params = {...
    'flag_abs', int2str(get(handles.checkbox_flag_abs, 'Value')), ...
    'flag_trace_minalt', int2str(get(handles.checkbox_flag_trace_minalt, 'Value')), ...
    'flag_envelope', int2str(get(handles.checkbox_flag_envelope, 'Value')), ...
    'data_hint', sdata2, ...
    'peakdetector', spd, ...
    'flag_bmtable', int2str(flag_bmtable), ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

function checkbox_flag_abs_Callback(hObject, eventdata, handles)

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

function checkbox_flag_envelope_Callback(hObject, eventdata, handles)

function radiobutton_curves_Callback(hObject, eventdata, handles)
if get(hObject, 'Value') > 0
    set(handles.radiobutton_pl, 'Value', 0);
end;

function radiobutton_pl_Callback(hObject, eventdata, handles)
if get(hObject, 'Value') > 0
    set(handles.radiobutton_curves, 'Value', 0);
end;

function checkbox_flag_trace_minalt_Callback(hObject, eventdata, handles)

%> @endcond
