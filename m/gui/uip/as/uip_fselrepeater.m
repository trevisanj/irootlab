%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref fselrepeater
%> @sa fselrepeater

%> @cond
function varargout = uip_fselrepeater(varargin)
% Last Modified by GUIDE v2.5 07-Aug-2012 20:22:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_fselrepeater_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_fselrepeater_OutputFcn, ...
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


% --- Executes just before uip_fselrepeater is made visible.
function uip_fselrepeater_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_fselrepeater_OutputFcn(hObject, eventdata, handles) 
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
%############################################

%#########
function refresh(handles)
listbox_load_from_workspace({'as_fsel'}, handles.popupmenu_as_fsel, 0);
listbox_load_from_workspace({'fext', 'block_cascade_base'}, handles.popupmenu_fext, 1);
listbox_load_from_workspace('sgs', handles.popupmenu_sgs, 0);

%############################################
%############################################

% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
try
    sas_fsel = listbox_get_selected_1stname(handles.popupmenu_as_fsel);
    if isempty(sas_fsel)
        irerror('Feature Selection AS not specified!');
    end;
    sfext = listbox_get_selected_1stname(handles.popupmenu_fext);
    if isempty(sfext)
        sfext = '[]';
    end;
    ssgs = listbox_get_selected_1stname(handles.popupmenu_sgs);
    if isempty(ssgs)
        irerror('SGS not specified!');
    end;

%     other = uip_as_fsel_grades();
%     if other.flag_ok
        handles.output.params = {...
        'as_fsel', sas_fsel, ...
        'fext', sfext, ...
        'sgs', ssgs, ...
        'flag_parallel', int2str(get(handles.checkbox_flag_parallel, 'value')), ...
        };
        handles.output.flag_ok = 1;
        guidata(hObject, handles);
        uiresume();
%     end;
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

% --- Executes on selection change in popupmenu_sgs.
function popupmenu_sgs_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_sgs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_as_fsel.
function popupmenu_as_fsel_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_as_fsel_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_fext.
function popupmenu_fext_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_fext_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_data_Callback(hObject, eventdata, handles)
function popupmenu_data_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function checkbox_flag_parallel_Callback(hObject, eventdata, handles)
%> @endcond
