%> @ingroup guigroup
%> @file
%> @brief Rater (@ref rater) Properties Window
%> @sa @ref factoscurve


%> @cond
function varargout = uip_factorscurve(varargin)
% Last Modified by GUIDE v2.5 13-Nov-2012 11:19:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_factorscurve_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_factorscurve_OutputFcn, ...
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


% --- Executes just before uip_factorscurve is made visible.
function uip_factorscurve_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_factorscurve_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject);
    varargout{1} = handles.output;
    delete(gcf);
catch %#ok<CTCH>
    output.flag_ok = 0;
    output.params = {};
    varargout{1} = output;
end;


%############################################

%#########
function refresh(handles)
listbox_load_from_workspace('sgs', handles.popupmenu_sgs, 1, 'Use default');
listbox_load_from_workspace({'fcon_linear', 'block_cascade_base'}, handles.popupmenu_fcon_mold, 0);
listbox_load_from_workspace({'clssr', 'block_cascade_base'}, handles.popupmenu_clssr, 1, 'Use default');


%############################################
%############################################

% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles) %#ok<*INUSL>
try
    sclssr = listbox_get_selected_1stname(handles.popupmenu_clssr);
    if isempty(sclssr)
       sclssr = '[]';
    end;
    sfcon_mold = listbox_get_selected_1stname(handles.popupmenu_fcon_mold);
    if isempty(sfcon_mold)
        irerror('Linear transformation block not specified!');
    end;
    ssgs = listbox_get_selected_1stname(handles.popupmenu_sgs);
    if isempty(ssgs)
         ssgs = '[]';
    end;
    
    handles.output.params = {...
    'clssr', sclssr, ...
    'fcon_mold', sfcon_mold, ...
    'sgs', ssgs, ...
    'no_factorss', mat2str(round((eval(get(handles.edit_no_factorss, 'String'))))), ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
end;

%################################################


function popupmenu_clssr_Callback(hObject, eventdata, handles) %#ok<*INUSD,*DEFNU>
function popupmenu_clssr_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_data_Callback(hObject, eventdata, handles)
function popupmenu_data_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_sgs_Callback(hObject, eventdata, handles)
function popupmenu_sgs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_fcon_mold_Callback(hObject, eventdata, handles)
function popupmenu_fcon_mold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_no_factorss_Callback(hObject, eventdata, handles)
function edit_no_factorss_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
