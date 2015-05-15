%> @ingroup guigroup sheware mainguis
%> @file
%> @brief datatool, see also @ref objtool.m
%> @image html Screenshot-datatool.png
%>
%> @sa objtool.m
%
%> @cond
function varargout = datatool(varargin)
% Last Modified by GUIDE v2.5 08-Nov-2012 12:32:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @datatool_OpeningFcn, ...
                   'gui_OutputFcn',  @datatool_OutputFcn, ...
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

% --- Executes just before datatool is made visible.
function datatool_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>

% Choose default command line output for datatool
handles.output = hObject;

handles.which_listbox = [handles.listboxDatasets, handles.listboxBlocks];


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes datatool wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global handles_datatool;
handles_datatool = handles;
handles_datatool.classname = 'irdata';
datatool_refresh(1);
colors_markers();

gui_set_position(hObject);
setup_load();

check_hsc();

% --- Outputs from this function are returned to the command line.
function varargout = datatool_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;




%##########################################################################
% AUXILIARY FUNCTIONS
%##########################################################################


%######################################


%#########
function datatool_refresh(which)
global handles_datatool;
datatool_load_from_workspace();
datatool_show_description(which);
nlog = length(get_varnames('irlog'));
data = eval([handles_datatool.classname, ';']);
set(handles_datatool.figure1, 'Color', data.color);


%#########   
function datatool_load_from_workspace()
global handles_datatool;
listbox_load_from_workspace(handles_datatool.classname, handles_datatool.listboxDatasets);
listbox_load_from_workspace('block', handles_datatool.listboxBlocks);

%#########   
function datatool_status(s)
global handles_datatool;
set(handles_datatool.text_status, 'String', s);


%#########   
function datatool_populate_block_more()
global handles_datatool;
blockname = get_selected_1stname(2);
a = {'More Actions>>'};
if ~isempty(blockname)
    block = evalin('base', [blockname, ';']);
    ma = block.moreactions;
    handles_datatool.block_moreactions = ma;
    guidata(handles_datatool.figure1, handles_datatool);
else
    ma = {};
end;
a = [a, ma];
if get(handles_datatool.popupmenuBlockMore, 'Value') > numel(a)
    set(handles_datatool.popupmenuBlockMore, 'Value', 1);
end;
set(handles_datatool.popupmenuBlockMore, 'String', a);



%#########   
function datatool_show_description(which)
global handles_datatool;
show_description(handles_datatool.which_listbox(which), handles_datatool.editDescription);
if which == 2
    datatool_populate_block_more();
end;

%#########
function a = get_selected_names(which)
global handles_datatool;
a = listbox_get_selected_names(handles_datatool.which_listbox(which));

%#########
function s = get_selected_1stname(which)
global handles_datatool;
s = listbox_get_selected_1stname(handles_datatool.which_listbox(which));


%######################################
% Applies block that still doesn't exist.
function do_block(which, classname)
dsnames = get_selected_names(which);
if ~isempty(dsnames)
    try
        r = do_blockmenu(classname, dsnames);
        if r.flag_ok
            og = r.og;
            og.flag_leave_block = which == 1; % Will leave the block in the workspace only if the button if from the left (data) panel
            og = og.start();
            og = og.m_create();
            og = og.m_boot();
            og = og.m_train();
            og = og.m_use();
            og = og.finish();
            datatool_refresh(1);
        end;
    catch ME
        datatool_refresh(1);
        send_error(ME);
    end;
else
    datatool_status('No object, can''t do anything!');
end;


%######################################
%> This if for the "boot", "train", and "use" block options
function do_block2(what)
% global handles_datatool;
blockname = get_selected_1stname(2);
if ~isempty(blockname)
    try
        dsnames = get_selected_names(1);

        og = gencode();
        og.blockname = blockname;
        og.dsnames = dsnames;
        og.flag_leave_block = 0;
        og = og.start();
        if ismember(what, {'boot', 'train', 'use'})
            og = og.(['m_', what])();
        else
            og = og.m_generic(what);
        end;
        og = og.finish();
        datatool_refresh(2);
    catch ME
        datatool_refresh(2);
        send_error(ME);
    end;
else
    datatool_status('Cannot do anything: there is no block!');
end;


%######################################
function change_class_from_edit()
global handles_datatool;
classname = get(handles_datatool.edit_class, 'String');
flag_ok = 0;
try
    data = eval([classname, ';']);
    test = data.color;
    flag_ok = 1;
catch ME
    s = sprintf('Class not accepted: "%s"', ME.message);
    datatool_status(s);
    irerror(s);
end;

if flag_ok
    handles_datatool.classname = classname;
    guidata(handles_datatool.figure1, handles_datatool);
    datatool_refresh(1);
end;    

%##########################################################################
%##########################################################################



% --- Executes during object creation, after setting all properties.
function listboxDatasets_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editDescription_CreateFcn(hObject, eventdata, handles)

function editDescription_Callback(hObject, eventdata, handles)
datatool_status('');


% --- Executes on button press in pushbuttonLoad.
function pushbuttonLoad_Callback(hObject, eventdata, handles) %#ok<*INUSD,*DEFNU>
datatool_status('');
path_assert();
global PATH;
global ATRTOOL_LOAD_OK ATRTOOL_LOAD_RANGE;
try
    types = {'mat', 'txt'};
    [name, path, filterindex] = uigetfile({'*.mat;*.txt', 'Supported file types (*.mat;*.txt)'; ...
                                           '*.*', 'All files (*.*)'; ...
                                           '*.mat', 'MAT-files (*.mat)'; ...
                                           '*.txt', 'TXT-files (*.txt)'; ...
                                           '*.0', 'OPUS-files (*.txt)'; ...
                                          }, 'Select file to open', PATH.data_load); %#ok<*NASGU>
    if name > 0
        name_full = fullfile(path, name);
        classname = detect_file_type(name_full);
        
        % Either way, will update the path
        PATH.data_load = path;
        setup_write();
        
        if isempty(classname)
            irerrordlg(sprintf('Could not detect type of file ''%s''', name), 'Sorry');
        else
            oio = eval(classname);
            s_range = '';
            flag_ok = 1;
            if ~oio.flag_xaxis
                datatool_fearange();
                if ~isempty(ATRTOOL_LOAD_OK)
                    s_range = '';
                    if ~isempty(ATRTOOL_LOAD_RANGE)
                        s_range = [mat2str(ATRTOOL_LOAD_RANGE)]; %#ok<NBRAK>
                    end;
                else
                    flag_ok = 0;
                end;

            end;

            if flag_ok

                name_new = find_varname('ds');
                code = sprintf('o = %s();\no.filename = ''%s'';\n%s = o.load(%s);', classname, name_full, name_new, s_range);

                ircode_eval(code, 'Dataset load');
                datatool_refresh(1);

            end;
        end;
    end;
        
catch ME
    datatool_refresh(1);
    send_error(ME);
end;

% --- Executes on button press in pushbuttonRename.
function pushbuttonRename_Callback(hObject, eventdata, handles)
datatool_status('');
s = get_selected_1stname(1);
if ~isempty(s)
    rename_object(s);
    datatool_refresh(1);
else
    datatool_status('No dataset to rename!');
end;

% --- Executes on selection change in listboxDatasets.
function listboxDatasets_Callback(hObject, eventdata, handles)
datatool_status('');
datatool_show_description(1);

% --- Executes on button press in pushbuttonClear.
function pushbuttonClear_Callback(hObject, eventdata, handles)
datatool_status('');
names = get_selected_names(1);
if ~isempty(names)
    code = sprintf('clear %s;', sprintf('%s ', names{:}));
    try
        ircode_eval(code, 'Dataset clearing');
        datatool_refresh(1);
    catch ME
        datatool_refresh(1);
        send_error(ME);
    end;
else
    datatool_status('No dataset to clear!');
end;    

% --- Executes on button press in pushbuttonRefresh.
function pushbuttonRefresh_Callback(hObject, eventdata, handles)
datatool_status('');
datatool_refresh(1);

% --- Executes on button press in pushbuttonVisualize.
function pushbuttonVisualize_Callback(hObject, eventdata, handles)
datatool_status('');
do_block(1, 'vis');


% --- Executes on button press in pushbuttonTransform.
function pushbuttonTransform_Callback(hObject, eventdata, handles)
datatool_status('');
do_block(1, 'fcon');

% --- Executes on button press in pushbuttonPre.
function pushbuttonPre_Callback(hObject, eventdata, handles)
datatool_status('');
do_block(1, 'pre');

% --- Executes on button press in pushbuttonMisc.
function pushbuttonMisc_Callback(hObject, eventdata, handles)
datatool_status('');
do_block(1, 'blmisc');

% --- Executes on button press in pushbutton_fsel.
function pushbutton_fsel_Callback(hObject, eventdata, handles)
datatool_status('');
do_block(1, 'fsel');

% --- Executes on button press in pushbuttonCascade.
function pushbuttonCascade_Callback(hObject, eventdata, handles)
datatool_status('');
do_block(1, 'block_cascade_base');


% --- Executes on button press in pushbuttonSaveas.
function pushbuttonSaveas_Callback(hObject, eventdata, handles)
datatool_status('');
path_assert();
global PATH;
dsname = get_selected_1stname(1);
if isempty(dsname)
    datatool_status('No dataset to save!');
    return;
end;
ds = evalin('base', [dsname ';']);

[pa, na, ex] = fileparts(ds.filename);

try
    classnames = {'dataio_mat', 'dataio_txt_irootlab', 'dataio_txt_pir', 'dataio_txt_basic'};
    [name, path, filterindex] = uiputfile({'*.mat', 'MAT file (*.mat)'; ...
                                           '*.txt', 'TXT file (IRootLab format) (*.txt)'; ...
                                           '*.txt', 'TXT file (pir format) (*.txt)'; ...
                                           '*.txt', 'TXT file (basic format) (*.txt)' ...
                                          }, 'Save as', fullfile(PATH.data_save, [na, ex]));
 
    if name > 0
%         ds.filename = fullfile(path, name)
%         evalin('base', [dsname '.filename = ''' ds.filename ''';']);
        filename = fullfile(path, name);
        o = eval(classnames{filterindex}); % creates instance of some dataio class
        o.filename = filename;
        o.save(ds);

        % If reached this point, will celebrate and write the path as default data path to the setup file
        PATH.data_save = path;
        setup_write();
    end;
        
catch ME
    send_error(ME);
end;

% --- Executes on button press in pushbuttonBlockRename.
function pushbuttonBlockRename_Callback(hObject, eventdata, handles)
datatool_status('');
s = get_selected_1stname(2);
if ~isempty(s)
    rename_object(s);
    datatool_refresh(2);
else
    datatool_status('There is no block to rename!');
end;

% --- Executes on selection change in listboxBlocks.
function listboxBlocks_Callback(hObject, eventdata, handles)
datatool_status('');
datatool_show_description(2);

% --- Executes during object creation, after setting all properties.
function listboxBlocks_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbuttonBlockClear.
function pushbuttonBlockClear_Callback(hObject, eventdata, handles)
datatool_status('');
names = get_selected_names(2);
if ~isempty(names)
    try
        code = sprintf('clear %s;', sprintf('%s ', names{:}));
        ircode_eval(code, 'Clearing blocks');
        datatool_refresh(2);
    catch ME
        datatool_refresh(2);
        send_error(ME);
    end
else
    datatool_status('There is no block to clear!');
end;    

% --- Executes on button press in pushbuttonBlockRefresh.
function pushbuttonBlockRefresh_Callback(hObject, eventdata, handles)
datatool_status('');
datatool_refresh(2);

% --- Executes on button press in pushbuttonBlockVisualize.
function pushbuttonBlockVisualize_Callback(hObject, eventdata, handles)
datatool_status('');
do_block(2, 'vis');

% --- Executes on button press in pushbuttonBlockUse.
function pushbuttonBlockUse_Callback(hObject, eventdata, handles)
datatool_status('');
do_block2('use');

% --- Executes on button press in pushbuttonBlockTrain.
function pushbuttonBlockTrain_Callback(hObject, eventdata, handles)
datatool_status('');
s = get_selected_1stname(2);
if ~isempty(s)
    o = evalin('base', [s, ';']); % gets object to see if it is trainable
    if o.flag_trainable < 1
        datatool_status('Cannot train: block not trainable!');
    else
        do_block2('train');
    end;
else
    datatool_status('Cannot train: there is no block!');
end;

% --- Executes on button press in pushbuttonBlockBoot.
function pushbuttonBlockBoot_Callback(hObject, eventdata, handles)
datatool_status('');
s = get_selected_1stname(2);
if ~isempty(s)
    o = evalin('base', [s, ';']); % gets object to see if it is bootable
    if ~o.flag_bootable
        datatool_status('Cannot boot: block not bootable!');
    else
        do_block2('boot');
    end;
else
    datatool_status('Cannot boot: there is no block!');
end;

% --- Executes on selection change in popupmenu_sheware.
function popupmenu_sheware_Callback(hObject, eventdata, handles)
datatool_status('');
idx = get(handles.popupmenu_sheware, 'Value');
if idx == 2
    % Load
    sheload();
    datatool_refresh(1);
end;

% --- Executes during object creation, after setting all properties.
function popupmenu_sheware_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuBlockMore.
function popupmenuBlockMore_Callback(hObject, eventdata, handles)
datatool_status('');
idx = get(handles.popupmenuBlockMore, 'Value');
if idx > 1
    aa = get(handles.popupmenuBlockMore, 'String');
    do_block2(aa{idx});
else
    datatool_status('There is no block!');
end;
    

% --- Executes during object creation, after setting all properties.
function popupmenuBlockMore_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonBlockOperate.
function pushbuttonBlockOperate_Callback(hObject, eventdata, handles)
datatool_status('');
do_block(2, ['blbl']);



function edit_class_Callback(hObject, eventdata, handles)
change_class_from_edit();

function edit_class_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton_all_Callback(hObject, eventdata, handles)
datatool_status('');
do_block(1, 'block');
%> @endcond
