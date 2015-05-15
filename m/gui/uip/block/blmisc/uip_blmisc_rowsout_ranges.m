%> @ingroup guigroup
%> @file uip_blmisc_rowsout_ranges.m
%> @brief Properties Window for Range-based Outlier Removal
%> @image html Screenshot-uip_blmisc_rowsout_ranges.png
%>
%> <b>Mark outliers only</b> -
%> @arg If not checked, the dataset will be split in two: the first one will contain the inliers, whereas the second one will contain the outliers.
%> @arg If checked, only one new dataset will be generated, where the outliers will be marked (outliers' class will be
%> -2). See blmisc_rowsout::flag_mark_only
%>
%> <b>Index of feature</b> - see blmisc_rowsout_uni::idx_fea
%>
%> <b>Ranges</b> - see blmisc_rowsout_uni::ranges
%>
%> <b>Number of bins</b> - see blmisc_rowsout_uni::no_bins. For range-based outlier removal, this has no effect in the calculation, only if the user wants to draw a histogram (blmisc_rowsout_uni::draw_histogram())
%>
%> @sa blmisc_rowsout_ranges, blmisc_rowsout_uni

%> @cond
function varargout = uip_blmisc_rowsout_ranges(varargin)
% Last Modified by GUIDE v2.5 07-Sep-2011 18:20:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_blmisc_rowsout_ranges_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_blmisc_rowsout_ranges_OutputFcn, ...
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


% --- Executes just before uip_blmisc_rowsout_ranges is made visible.
function uip_blmisc_rowsout_ranges_OpeningFcn(hObject, eventdata, handles, varargin)
handles.input.block = varargin{1};
if nargin > 4
    handles.input.data = varargin{2};
else
    handles.input.data = [];
end;
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);



% --- Outputs from this function are returned to the command clae.
function varargout = uip_blmisc_rowsout_ranges_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject);
    varargout{1} = handles.output;
    delete(gcf);
catch %#ok<*CTCH>
    output.flag_ok = 0;
    output.params = {};
    varargout{1} = output;
end;

%############################################

%#########
function preview(handles)
data = handles.input.data;
if isempty(data)
    irerrordlg('Dataset not specified!', 'Cannot preview');
end;
try
    blk = handles.input.block;
    eval(['blk = blk.setbatch(', params2str(get_params(handles)), ');']);
    blk = blk.train(data);
    orhistgui_show(blk);
catch ME
    irerrordlg(sprintf('Couldn''t preview: "%s"', ME.message), 'Sorry, mate');
    send_error(ME);
end;

%#########
function params = get_params(handles)
temp = fel(get(handles.edit_ranges, 'String'));
s = sprintf('%s', temp');
s_ranges = mat2str(eval(s));

params = {...
'idx_fea', int2str(eval(get(handles.edit_idx_fea, 'String'))), ...
'no_bins', int2str(eval(get(handles.edit_no_bins, 'String'))), ...
'ranges', s_ranges, ...
'flag_mark_only', int2str(get(handles.checkbox_flag_mark_only, 'Value')) ...
};


%############################################
%############################################


% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles)
try
    handles.output.params = get_params(handles);
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

function editVariables_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function editVariables_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuType.
function popupmenuType_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenuType_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_no_bins_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_no_bins_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_threshold_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_threshold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenuFsg.
function popupmenuFsg_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenuFsg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_ranges_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_ranges_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonPreview.
function pushbuttonPreview_Callback(hObject, eventdata, handles)
preview(handles);

function edit_idx_fea_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_idx_fea_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_flag_mark_only.
function checkbox_flag_mark_only_Callback(hObject, eventdata, handles)

%> @endcond
