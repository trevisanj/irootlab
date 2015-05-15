%> @ingroup guigroup
%> @file
%> @brief Properties Window for the "Classes from cluster" block
%> @sa blmisc_classes_from_clus

%> @cond
function varargout = uip_blmisc_classes_from_clus(varargin)
% Last Modified by GUIDE v2.5 26-Jun-2011 23:55:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_blmisc_classes_from_clus_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_blmisc_classes_from_clus_OutputFcn, ...
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


% --- Executes just before uip_blmisc_classes_from_clus is made visible.
function uip_blmisc_classes_from_clus_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_blmisc_classes_from_clus_OutputFcn(hObject, eventdata, handles) 
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
listbox_load_from_workspace('irdata_clus', handles.popupmenuData, 0);

%############################################
%############################################

% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles)
try
    sdata = listbox_get_selected_1stname(handles.popupmenuData);
    if isempty(sdata)
        error('Clusters dataset not specified!');
    end;

    handles.output.params = {...
    'idx_fea', int2str(eval(get(handles.edit_idx_fea, 'String'))), ...
    'classes_to_remove', mat2str(eval(get(handles.edit_classes_to_remove, 'String'))), ...
    'data_clus', sdata, ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;


% --- Executes on button press in pushbuttonRefreshData.
function pushbuttonRefreshData_Callback(hObject, eventdata, handles)
refresh(handles);

% --- Executes on selection change in popupmenuData.
function popupmenuData_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenuData_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_idx_fea_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_idx_fea_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_classes_to_remove_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_classes_to_remove_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
