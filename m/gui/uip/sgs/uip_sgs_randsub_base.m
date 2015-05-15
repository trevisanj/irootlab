%> @ingroup guigroup
%> @file
%> @brief Properties Window for Random sub-sampling (@ref sgs_randsub_base)
%>
%> <b>Type</b> - see sgs_randsub_base::type
%>
%> <b>Bites (fractions)</b> - see sgs_randsub_base::bites
%>
%> <b>Bites (number of units)</b> - see sgs_randsub_base::bites_fixed
%>
%> <b>Number of repetitions</b> - see sgs_randsub_base::no_reps
%>
%> @sa sgs_randsub_base, sgs_randsub, sgs
%
%> @cond
function varargout = uip_sgs_randsub_base(varargin)
% Last Modified by GUIDE v2.5 23-Feb-2012 18:55:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_sgs_randsub_base_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_sgs_randsub_base_OutputFcn, ...
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


% --- Executes just before uip_sgs_randsub_base is made visible.
function uip_sgs_randsub_base_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_sgs_randsub_base_OutputFcn(hObject, eventdata, handles) 
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

% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles)
try
    other = uip_sgs();
    if other.flag_ok
        types = get(handles.popupmenu_type, 'String');
        handles.output.params = [other.params, {...
        'type', ['''', types{get(handles.popupmenu_type, 'Value')}, ''''], ...
        'bites', mat2str(eval(get(handles.edit_bites, 'String'))), ...
        'bites_fixed', mat2str(eval(get(handles.edit_bites_fixed, 'String'))), ...
        'no_reps', num2str(eval(get(handles.edit_no_reps, 'String'))) ...
        }];
        handles.output.flag_ok = 1;
        guidata(hObject, handles);
        uiresume();
    end;
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

% --- Executes on button press in checkbox_flag_loo.
function checkbox_flag_loo_Callback(hObject, eventdata, handles)

function edit_bites_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_bites_CreateFcn(hObject, eventdata, handles)
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

function edit_bites_fixed_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_bites_fixed_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_no_reps_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_no_reps_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
