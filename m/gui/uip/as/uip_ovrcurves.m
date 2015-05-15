%>@file
%>@ingroup guigroup
%>@brief Properties Window for @ref blmisc_split_ovr
%> @sa blmisc_split_ovr

%>@cond
function varargout = uip_ovrcurves(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_ovrcurves_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_ovrcurves_OutputFcn, ...
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


%############################################

%#########
function refresh(handles)
listbox_load_from_workspace('fsg', handles.popupmenu_fsg, 0);

%############################################


%#####
function uip_ovrcurves_OpeningFcn(hObject, eventdata, handles, varargin)
if nargin > 4
    % Dataset is expected as parameter
    ds = varargin{2};
    set(handles.text_caption, 'String', [get(handles.text_caption, 'String'), sprintf(' (number of levels in dataset: %d)', ds.get_no_levels)]);
end;
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);


%#####
function varargout = uip_ovrcurves_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject);
    varargout{1} = handles.output;
    delete(gcf);
catch %#ok<*CTCH>
    output.flag_ok = 0;
    varargout{1} = output;
end;


%#####
function pushbuttonOk_Callback(hObject, eventdata, handles) %#ok<*INUSL>


try
    idxs = eval(get(handles.edit_hierarchy, 'String'));
    if ~isnumeric(idxs)
        irerror('Please type in a numerical vector!');
    end;
    
    idx_ref = eval(get(handles.edit_idx_ref, 'String'));
    if ~isnumeric(idx_ref) || isempty(idx_ref) || idx_ref < 1
        irerror('Reference index is invalid! Please enter a number >= 1');
    end;

    sfsg = listbox_get_selected_1stname(handles.popupmenu_fsg);
    if isempty(sfsg)
        error('FSG not specified!');
    end;

    
    handles.output.params = {...
    'hierarchy', mat2str(idxs), ...
    'idx_ref', int2str(idx_ref), ...
    'fsg', sfsg, ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');   
end;

%--------------------------------------------------------------------------------------------------------------

function edit_hierarchy_Callback(hObject, eventdata, handles) %#ok<*INUSD,*DEFNU>
function edit_hierarchy_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_idx_ref_Callback(hObject, eventdata, handles)
function edit_idx_ref_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_fsg_Callback(hObject, eventdata, handles)
function popupmenu_fsg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%>@endcond
