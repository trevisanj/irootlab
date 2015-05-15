%> @ingroup guigroup
%> @file uip_subsetsprocessor.m
%> @brief Properties Window for @ref subsetsprocessor
%> @sa subsetsprocessor

%> @cond
function varargout = uip_subsetsprocessor(varargin)
% Last Modified by GUIDE v2.5 07-Aug-2012 23:08:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_subsetsprocessor_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_subsetsprocessor_OutputFcn, ...
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

% --- Executes just before uip_subsetsprocessor is made visible.
function uip_subsetsprocessor_OpeningFcn(hObject, eventdata, handles, varargin)
if nargin >= 5
    handles.inputlog = varargin{2};
else
    handles.inputlog = [];
end;
if numel(varargin) < 3
    handles.input.flag_needs_fsg = 0;
else
    handles.input.flag_needs_fsg = varargin{3};
end;
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_subsetsprocessor_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject);
    varargout{1} = handles.output;
    delete(gcf);
catch ME %#ok<NASGU>
    output.flag_ok = 0;
    output.params = {};
    varargout{1} = output;
end;

%############################################


%#########
function view1(handles)
cla(handles.axes1, 'reset');
axes(handles.axes1); %#ok<MAXES>
hold off;

input = handles.inputlog;

if isempty(input)
    msgbox('Cannot draw, input not specified!', 'Information');
else
    try
        set(handles.text_wait, 'String', 'Wait...', 'ForegroundColor', [0, 0, .8]);
        o = subsetsprocessor();
        eval(['o = o.setbatch(', params2str(get_params(handles)), ');']);
        set(handles.text_wait, 'String', 'Ok', 'ForegroundColor', [0, 0.7, 0]);
        log_hist = o.use(input);
        log_hist.draw_stackedhists([], {[], .80*[1, 1, 1]}, def_peakdetector(), 0);
    catch ME
        set(handles.text_wait, 'String', '');
        send_error(ME); % irerrordlg(ME.message, 'Error');
    end;
end;


%#########
function params = get_params(handles)
nf4gradesmodes = {'fixed', 'stability'};
snf4gradesmode = nf4gradesmodes{get(handles.popupmenu_nf4gradesmode, 'Value')};
stabilitytypes = {'kun'};
sstabilitytype = stabilitytypes{get(handles.popupmenu_stabilitytype, 'Value')};
params = {...
        'nf4gradesmode', ['''' snf4gradesmode ''''], ...
        'stabilitytype', ['''' sstabilitytype ''''], ...
        'nf4grades', int2str(eval(get(handles.edit_nf4grades, 'String'))), ...
        'minhits_perc', num2str(eval(get(handles.edit_minhits_perc, 'String'))), ...
        'stabilitythreshold', num2str(eval(get(handles.edit_stabilitythreshold, 'String'))), ...
        };


%############################################
%############################################


% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles) %#ok<*INUSL,*DEFNU>
try
    handles.output.params = get_params(handles);
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
end;

function pushbutton_preview_Callback(hObject, eventdata, handles)
view1(handles);

%############################################
%############################################

function editVariables_Callback(hObject, eventdata, handles) %#ok<*INUSD>

% --- Executes during object creation, after setting all properties.
function editVariables_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_nf4gradesmode.
function popupmenu_nf4gradesmode_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_nf4gradesmode_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_nf4grades_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_nf4grades_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_minhits_perc_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_minhits_perc_CreateFcn(hObject, eventdata, handles)
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
function popupmenu_stabilitytype_Callback(hObject, eventdata, handles)
function popupmenu_stabilitytype_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_stabilitythreshold_Callback(hObject, eventdata, handles)
function edit_stabilitythreshold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
