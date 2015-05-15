%> @ingroup guigroup
%> @file
%> @brief Properties Window to create a Cascade Block
%> @image html Screenshot-uip_block_cascade.png
%> <p><b>Usage</b><br>
%> <ol><li>Create all blocks of the cascade sequence <b>before</b> calling this GUI</li>
%>     <li>The popupmenu shows all blocks present in the workspace. Select among blocks and click on `Add`.</li>
%>     <li>Click on `OK` when done</li>
%> </ol>
%>
%> @sa block_cascade

%> @cond
function varargout = uip_block_cascade(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_block_cascade_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_block_cascade_OutputFcn, ...
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

% --- Executes just before uip_block_cascade is made visible.
function uip_block_cascade_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
handles.blocknames = {};
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

% --- Outputs from this function are returned to the command line.
function varargout = uip_block_cascade_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject); % Handles is not a handle(!), so gotta retrieve it again to see changes in .output
    varargout{1} = handles.output;
    delete(gcf);
catch %#ok<*CTCH>
    output.flag_ok = 0;
    output.params = {};
    varargout{1} = output;
end;


%############################################
function refresh(handles)
listbox_load_from_workspace('block', handles.popupmenuBlocks, 0);
v = get(handles.listbox, 'Value');
if sum(v > length(handles.blocknames)) > 0 && ~isempty(handles.blocknames)
    set(handles.listbox, 'Value', 1);
end;
set(handles.listbox, 'String', handles.blocknames);
local_show_description(handles);

function local_show_description(handles)
show_description(handles.listbox, handles.editDescription);
%############################################
%############################################


% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles)
try
    handles.output.params = {...
    'blocks', params2str2(handles.blocknames) ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

% --- Executes on selection change in popupmenuBlocks.
function popupmenuBlocks_Callback(hObject, eventdata, handles) %#ok<*INUSD,*DEFNU>

% --- Executes during object creation, after setting all properties.
function popupmenuBlocks_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonAdd.
function pushbuttonAdd_Callback(hObject, eventdata, handles) %#ok<*INUSL>
blockname = listbox_get_selected_1stname(handles.popupmenuBlocks);
if ~isempty(blockname)
    handles.blocknames{end+1} = blockname;
    guidata(hObject, handles);
    refresh(handles);
end;

% --- Executes on selection change in listbox.
function listbox_Callback(hObject, eventdata, handles)
local_show_description(handles);

% --- Executes during object creation, after setting all properties.
function listbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbuttonRemove.
function pushbuttonRemove_Callback(hObject, eventdata, handles)
if ~isempty(get(handles.listbox, 'String'))
    idxs = get(handles.listbox, 'Value');
    if ~isempty(idxs)
        handles.blocknames(idxs) = [];
        guidata(hObject, handles);
        refresh(handles);
    end;
end;

function editDescription_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function editDescription_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
