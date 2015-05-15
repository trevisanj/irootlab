%> @ingroup guigroup
%> @file
%> @brief Dialogbox for Distribution-based Outlier Removal
%> @image html Screenshot-uip_blmisc_rowsout_distr.png
%>
%> This window asks for properties common to all @ref blmisc_rowsout_distr descendants.
%>
%> <b>Mark outliers only</b> -
%> @arg If not checked, the dataset will be split in two: the first one will contain the inliers, whereas the second one will contain the outliers.
%> @arg If checked, only one new dataset will be generated, where the outliers will be marked (outliers' class will be
%> -2). See blmisc_rowsout::flag_mark_only
%>
%> <b>Threshold</b> - See blmisc_rowsout_distr::threshold
%>
%> <b>Range filter</b> - See blmisc_rowsout_distr::quantile
%>
%> <b>Tail trimming mode</b> - See blmisc_rowsout_distr::flag_trim_tail
%>
%> <b>Number of bins</b> - See blmisc_rowsout_distr::no_bins
%>
%> @sa blmisc_rowsout_distr

%> @cond
function varargout = uip_blmisc_rowsout_distr(varargin)
% Last Modified by GUIDE v2.5 07-Sep-2011 18:23:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_blmisc_rowsout_distr_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_blmisc_rowsout_distr_OutputFcn, ...
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


% --- Executes just before uip_blmisc_rowsout_distr is made visible.
function uip_blmisc_rowsout_distr_OpeningFcn(hObject, eventdata, handles, varargin)
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
function varargout = uip_blmisc_rowsout_distr_OutputFcn(hObject, eventdata, handles) 
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
%#########
function preview(handles)
data = handles.input.data;
if isempty(data)
    irerrordlg('Dataset not specified!', 'Cannot preview');
end;
blk = handles.input.block;
eval(['blk = blk.setbatch(', params2str(get_params(handles)), ');']);
blk = blk.train(data);
orhistgui_show(blk);


%#########
function params = get_params(handles)
types = {'threshold', 'ranges'};

params = {...
'flag_mark_only', int2str(get(handles.checkbox_flag_mark_only, 'Value')), ...
'idx_fea', int2str(eval(get(handles.edit_idx_fea, 'String'))), ...
'no_bins', int2str(eval(get(handles.edit_no_bins, 'String'))), ...
'threshold', get(handles.edit_threshold, 'String'), ...
'quantile', int2str(get(handles.popupmenu_quantile, 'Value')-1), ...
'flag_trim_tail', int2str(get(handles.checkbox_flag_trim_tail, 'value')), ...
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

% --- Executes on button press in pushbuttonPreview.
function pushbuttonPreview_Callback(hObject, eventdata, handles)
preview(handles);

function edit_idx_fea_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_idx_fea_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_quantile.
function popupmenu_quantile_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_quantile_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox_flag_trim_tail.
function checkbox_flag_trim_tail_Callback(hObject, eventdata, handles)


% --- Executes on button press in checkbox_flag_mark_only.
function checkbox_flag_mark_only_Callback(hObject, eventdata, handles)
%> @endcond
