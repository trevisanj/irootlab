%> @ingroup guigroup
%> @file uip_as_fsel_grades.m
%> @brief Properties Window for @ref as_fsel_grades
%> @sa as_fsel_grades

%> @cond
function varargout = uip_as_fsel_grades(varargin)
% Last Modified by GUIDE v2.5 26-Aug-2012 13:53:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_as_fsel_grades_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_as_fsel_grades_OutputFcn, ...
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

% --- Executes just before uip_as_fsel_grades is made visible.
function uip_as_fsel_grades_OpeningFcn(hObject, eventdata, handles, varargin)
if nargin >= 5
    handles.inputobj = varargin{2};
else
    handles.inputobj = [];
end;

if numel(varargin) < 3
    handles.input.flag_needs_fsg = 0;
else
    handles.input.flag_needs_fsg = varargin{3};
end;
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_as_fsel_grades_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject);
    varargout{1} = handles.output;
    delete(gcf);
catch %#ok<*CTCH>
    output.flag_ok = 0;
    output.params = {};
    varargout{1} = output;
end;

%############################################

%#########
function refresh(handles)
listbox_load_from_workspace('peakdetector', handles.popupmenuPeakdetector, 1);


%#########
function view1(handles)
cla(handles.axes1, 'reset');
axes(handles.axes1); %#ok<MAXES>
hold off;

input = handles.inputobj;

if isempty(input)
    msgbox('Cannot draw, input not specified!', 'Information');
else
    evalin('base', ['global TEMP; TEMP = as_fsel_grades(); TEMP = TEMP.setbatch(', params2str(get_params(handles)), ');']);
    global TEMP; %#ok<*TLEV>
    log = TEMP.use(input);
    log.draw([], 1);
    clear TEMP;
end;


%#########
function params = get_params(handles)

types = {'none', 'nf', 'threshold'};
sortmodes = {'grade', 'index'};

spd = listbox_get_selected_1stname(handles.popupmenuPeakdetector);
if isempty(spd)
    spd = '[]';
end;
    
params = {...
'type', ['''' types{get(handles.popupmenuType, 'Value')} ''''], ...
'nf_select', int2str(eval(get(handles.editNf, 'String'))), ...
'threshold', get(handles.editThreshold, 'String'), ...
'peakdetector', spd, ...
'sortmode', ['''' sortmodes{get(handles.popupmenu_sortmode, 'Value')} ''''], ...
};




%############################################
function pushbuttonOk_Callback(hObject, eventdata, handles)
try
    handles.output.params = get_params(handles);
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
end;


function pushbutton_preview_Callback(hObject, eventdata, handles) %#ok<*INUSL>
view1(handles);

%############################################
%############################################




function editVariables_CreateFcn(hObject, eventdata, handles) %#ok<*DEFNU,*INUSD>
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenuType_Callback(hObject, eventdata, handles)
function popupmenuType_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editNf_Callback(hObject, eventdata, handles)
function editNf_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editThreshold_Callback(hObject, eventdata, handles)
function editThreshold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenuFsg_Callback(hObject, eventdata, handles)
function popupmenuFsg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenuPeakdetector_Callback(hObject, eventdata, handles)
function popupmenuPeakdetector_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_fsg_Callback(hObject, eventdata, handles)
function popupmenu_fsg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function checkbox_flag_optimize_Callback(hObject, eventdata, handles)
function popupmenu_sortmode_Callback(hObject, eventdata, handles)
function popupmenu_sortmode_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_input_Callback(hObject, eventdata, handles)
function popupmenu_input_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
