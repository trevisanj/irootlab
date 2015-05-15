%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref clssr_tree
%> @image html Screenshot-uip_clssr_tree.png
%>
%> <b>FSGT object (optional)</b> - see clssr_tree::fsgt
%>
%> <b>Pruning type</b> - see clssr_tree::pruningtype
%>
%> <b>Maximum number of levels</b> - see clssr_tree::no_levels_max
%>
%> <b>Chi-squared test threshold</b> - see clssr_tree::chi2threshold
%>
%> @sa @ref clssr_tree

%> @cond
function varargout = uip_clssr_tree(varargin)
% Last Modified by GUIDE v2.5 03-Sep-2011 16:21:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_clssr_tree_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_clssr_tree_OutputFcn, ...
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


% --- Executes just before uip_clssr_tree is made visible.
function uip_clssr_tree_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_clssr_tree_OutputFcn(hObject, eventdata, handles) 
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
listbox_load_from_workspace('fsgt', handles.popupmenu_fsgt, 0);


%############################################
%############################################

% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles)
try
    sfsgt = listbox_get_selected_1stname(handles.popupmenu_fsgt);
    if isempty(sfsgt)
        sfsgt = '[]';
    end;

    ss = get(handles.popupmenu_pruningtype, 'String');
    stype = ss{get(handles.popupmenu_pruningtype, 'Value')};
    spruningtype = stype(1); % 
    
    handles.output.params = {...
    'fsgt', sfsgt ...
    'pruningtype', spruningtype, ...
    'no_levels_max', int2str(eval(get(handles.edit_no_levels_max, 'String'))), ...
    'chi2threshold', int2str(eval(get(handles.edit_chi2threshold, 'String'))) ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

function popupmenu_fsgt_Callback(hObject, eventdata, handles)

function popupmenu_fsgt_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_no_levels_max_Callback(hObject, eventdata, handles)

function edit_no_levels_max_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_chi2threshold_Callback(hObject, eventdata, handles)

function edit_chi2threshold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu_pruningtype_Callback(hObject, eventdata, handles)

function popupmenu_pruningtype_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
