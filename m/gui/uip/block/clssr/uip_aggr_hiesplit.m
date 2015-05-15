%> @ingroup guigroup
%> @file
%> @brief Properties Window to create a Hie-Split Aggregation
%> @image html Screenshot-uip_aggr_hiesplit.png
%>
%> <b>Mold classifier</b> - see aggr_hiesplit::block_mold
%>
%> <b>Class levels to use for splitting</b> - see aggr_hiesplit::hie_split
%>
%> <b>Class levels to use for classification</b> - see aggr_hiesplit::hie_classify
%>
%> @sa aggr_hiesplit, aggr, uip_aggr.m

%> @cond
function varargout = uip_aggr_hiesplit(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_aggr_hiesplit_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_aggr_hiesplit_OutputFcn, ...
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

% --- Executes just before uip_aggr_hiesplit is made visible.
function uip_aggr_hiesplit_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
listbox_load_from_workspace({'clssr', 'block_cascade_base'}, handles.popupmenu_block_mold, 0);


% --- Outputs from this function are returned to the command line.
function varargout = uip_aggr_hiesplit_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject); % Handles is not a handle(!), so gotta retrieve it again to see changes in .output
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
    sblock_mold = listbox_get_selected_1stname(handles.popupmenu_block_mold);
    if isempty(sblock_mold)
        error('Test dataset not specified!');
    end;

    other = uip_aggr();
    if other.flag_ok
        handles.output.params = [other.params, {...
        'block_mold', sblock_mold, ...
        'hie_split', mat2str(eval(get(handles.edit_hie_split, 'String'))), ...
        'hie_classify', mat2str(eval(get(handles.edit_hie_classify, 'String'))) ...
        }];
        handles.output.flag_ok = 1;
        guidata(hObject, handles);
        uiresume();
    end;
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

% --- Executes on selection change in popupmenu_data_test.
function popupmenu_data_test_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_data_test_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_hie_split_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_hie_split_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_hie_classify_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_hie_classify_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_block_mold.
function popupmenu_block_mold_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu_block_mold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
