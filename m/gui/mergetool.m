%> @ingroup guigroup mainguis codegen
%> @file
%> @brief Tool to merge several single-spectrum files into a dataset.
%> @image html Screenshot-mergetool.png
%>
%> <b>Directory containing multiple files</b> - directory containing multiple single-spectrum files.
%> @note make sure that this directory contains <b>only</b> the files of interest. View files, sort by <b>size</b> and checks extremities to detect unusual
%> file sizes. These may be invalid spectra.
%> @attention Never use directory names nor file names containing single quotes (" ' "). They are not handled properly by mergetool, and will cause the operation to fail.
%>
%> <b>File type</b> - Currently supported types are:
%> @arg "Pirouette .DAT" text format
%> @arg OPUS binary format
%> @arg Wire TXT format
%>
%> <b>File filter</b> - wildcard filter. Examples: <code>*.*</code>; <code>*.dat</code>; <code>*.DAT</code>
%>
%> <b>Group code trimming dot (right-to-left)</b> - allows you control over trimming off part of the filename for the <b>group code</b> of each spectrum.
%> For example, you may have several files like:
%> @verbatim
%> sample1.000.dat
%> sample1.001.dat
%> sample1.002.dat
%>        ^   ^ 
%>        |   |
%>        |   1 first dot (left-to-right)
%>        |
%>        2 second dot
%> @endverbatim
%> All these are spectra from the same group (named "sample1"). Specifying "2" for the trimming dot will get rid of
%> everything after the 2nd last dot counting from right to left. Thus, all spectra will have group code "sample1".
%>
%> <h3>Image building options</h3>
%> If <b>Build image is checked</b>, the image <b>height</b> needs to be informed. The width is automatically calculated as the number of files in the directory divided by the informed <b>height</b>.
%> @note To build an image, the files need to have a sequential numbering between dots, as above. 

%> @cond
function varargout = mergetool(varargin)
% Last Modified by GUIDE v2.5 24-Nov-2012 11:42:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mergetool_OpeningFcn, ...
                   'gui_OutputFcn',  @mergetool_OutputFcn, ...
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


% --- Executes just before mergetool is made visible.
function mergetool_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>

% Choose default command line output for mergetool
handles.output = hObject;

setup_load();
path_assert();
global PATH;
set(handles.editPath, 'String', PATH.data_spectra);
guidata(hObject, handles); % Update handles structure
gui_set_position(hObject);
check_hsc();


% --- Outputs from this function are returned to the command line.
function varargout = mergetool_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


%=======================================================================================================================


%==============================
function handles = find_handles()
H = findall(0, 'Name', 'mergetool');
if isempty(H)
    irerror('mergetool not open');
end;
handles = guidata(H);

%==============================
function add_log(s)
handles = find_handles();
a = get(handles.editStatus2, 'String');
s = {s};
set(handles.editStatus2, 'String', [a; s]);

%==============================
function morasse_lah(handles, filename, idx1, idx2, msg)
add_log(filename);
% SLASH = '/';
add_log([repmat(' ', 1, idx1-1), repmat('-', 1, idx2-idx1+1)]);
add_log([repmat(' ', 1, idx2-1), '|']);
add_log([repmat(' ', 1, idx2-1), msg]);



%==============================
% Reads parameters from mergetool window edit boxes; performs minor checks
%
% Returns a stru with .filetype, .wild, .trimdot, .flag_image, .height
function stru = get_window_settings()
handles = find_handles();
stypes = {'pir', 'opus', 'wire'};
try
    stru.filetype = stypes{get(handles.popupmenu_type, 'value')};
    stru.wild = get_wild();
    stru.trimdot = eval(get(handles.editTrimdot, 'String'));
    stru.flag_image = get(handles.checkbox_flag_image, 'Value');
    stru.height = eval(get(handles.edit_height, 'String'));

    if isempty(stru.height)
        stru.height = 0;
    end;
    
    if stru.flag_image
        if stru.height <= 0
            irerror('Please specify height');
        end;
        
        if stru.trimdot < 1
            irerror('For image building, "Group code trimming dot" needs be at least 1!');
        end;
    end;
catch ME
    irerror(sprintf('Error in window settings:\n%s', ME.message));
end;

%==============================
function do_checks(handles)
set(handles.editStatus2, 'String', '');
add_log('==> Checking... ==>');
try 
    stru = get_window_settings();

    [filenames, groupcodes] = resolve_dir(stru.wild, stru.trimdot, stru.flag_image);
    no_files = numel(filenames);
    
    add_log(sprintf('Number of files: %d', no_files));
    add_log(sprintf('Number of groups: %d', numel(unique(groupcodes))));
    
    if no_files > 0
        filename = filenames{1};
        idxs = find([filename, '.'] == '.');
        if numel(idxs) < stru.trimdot+1
            irerror(sprintf('File name such as "%s" has only %d dot%s, whereas "Group code trimming dot" is %d!', filename, numel(idxs)-1, iif(numel(idxs)-1 > 1, 's', ''), stru.trimdot));
        end;
        idx1 = 1;
        idx2 = idxs(end-stru.trimdot)-1;
        code = filename(1:idx2);
        morasse_lah(handles, filename, idx1, idx2, ['Group code ("', code, '")']);

        if stru.flag_image
            idx1 = idxs(end-stru.trimdot)+1;
            idx2 = idxs(end-stru.trimdot+1)-1;
            sorderref = filename(idx1:idx2);
            morasse_lah(handles, filename, idx1, idx2, ['Sequence number for image pixels ("', sorderref, '")']);
            orderref = str2double(sorderref);
            if isnan(orderref)
                irerror(sprintf('File part "%s" should be a number!', sorderref));
            end;
            
            if stru.flag_image
                if stru.height <= 0
                    irerror('Please specify image height!');
                end;

                if no_files/stru.height ~= floor(no_files/stru.height)
                    irerror(sprintf('Invalid image height: %d not divisible by %d!', no_files, stru.height));
                end;
                
                add_log(sprintf('Image width: %d', no_files/stru.height));
            end;
        end;
    else
        irerror('No files!');
    end;        

    [filenames, groupcodes] = resolve_dir(stru.wild, stru.trimdot, stru.flag_image); %#ok<NASGU>
    
    add_log('===> ...Passed!');
catch ME
    add_log(['===> ...Checking error: ', ME.message]);
    send_error(ME);
end;


function path_ = get_wild()
handles = find_handles();
% handles    structure with handles and user data (see GUIDATA)

path_ = get(handles.editPath, 'String');
filter = get(handles.editFilter, 'String');
if isempty(path_)
    path_ = '.';
end;
if path_(end) ~= '/'
    path_ = [path_ '/'];
end;

path_ = [path_ filter];


%=======================================================================================================================






%####
function editPath_Callback(hObject, eventdata, handles)
set(handles.textStatus, 'String', '?');
set(handles.editStatus2, 'String', '?');

%#####
function pushbuttonGo_Callback(hObject, eventdata, handles)
set(handles.editStatus2, 'String', '');
do_checks(handles);

% Pre-check with get_wild() only
path_ = get_wild();
a = dir(path_);
if length(a) == 0 %#ok<ISMT>
    msgbox('No files found in specified directory!');
else
    try
        % Check-n-load vars from GUI
        stru = get_window_settings();

        [filenames, groupcodes] = resolve_dir(stru.wild, stru.trimdot, stru.flag_image); %#ok<NASGU>
        no_files = numel(filenames);
    
        % Creates dataset in workspace
        name_new = find_varname('ds');
        
        s_code = sprintf('[%s, flag_error] = %s2data(''%s'', %d, %d, %d);', ...
            name_new, stru.filetype, path_, stru.trimdot, stru.flag_image, stru.height); % Line of MATLAB code
        
        evalin('base', s_code);
        
        ds = evalin('base', [name_new ';']);
        flag_error = evalin('base', 'flag_error;');
        
        add_log(sprintf('Imported: %d', no_files-flag_error));
        add_log(sprintf('Failed: %d', flag_error));
        add_log(sprintf('Total: %d', no_files));
        if flag_error
            ss = 'Finished with errors. Check MATLAB command window output.';
            if flag_error > 7 && flag_error/no_files > 0.51
                add_log(sprintf('A large amount of files failed to import. Maybe the files are of a different type?'));
            end;
        else
            ss = 'Success!';
        end;
        add_log(sprintf('%s! Variable name in workspace: %s; Number of rows: %d', ss, name_new, ds.no));
        
        path_assert();
        global PATH; %#ok<TLEV>
        PATH.data_spectra = get(handles.editPath, 'String');
        setup_write();
    catch ME
        send_error(ME);
    end;
end;


%#####
function pushbuttonOpen_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
o = uigetdir(get(handles.editPath, 'String'));

if ~(isnumeric(o) && o == 0)
    set(handles.editPath, 'String', o);
end;

%#####
function pushbuttonLaunch_Callback(hObject, eventdata, handles)
datatool();

%#####
function pushbutton_check_Callback(hObject, eventdata, handles)
do_checks(handles);

%#####
function pushbuttonLaunchObjtool_Callback(hObject, eventdata, handles)
objtool();

%#####
function pushbutton_detect_Callback(hObject, eventdata, handles)
s = detect_spectrum_type(get_wild());
if ~isempty(s)
    handles = find_handles();
    i_type = find(strcmp(s, {'pir', 'opus', 'wire'}));
    set(handles.popupmenu_type, 'Value', i_type);
    add_log(sprintf('Detected file type: "%s"', s));
else
    msgbox('Could not detect file type in specified directory.');
end;

%------------------------------------------------------------------------------------------------------------------------------------------

function editFilter_Callback(hObject, eventdata, handles) %#ok<*INUSD>
function editFilter_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editTrimdot_Callback(hObject, eventdata, handles)
function editTrimdot_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editStatus2_Callback(hObject, eventdata, handles)
function editStatus2_CreateFcn(hObject, eventdata, handles)
function checkbox_flag_image_Callback(hObject, eventdata, handles)
function edit_height_Callback(hObject, eventdata, handles)
function edit_height_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_type_Callback(hObject, eventdata, handles)
function popupmenu_type_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editPath_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function editTarget_Callback(hObject, eventdata, handles)
function editTarget_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%> @endcond
