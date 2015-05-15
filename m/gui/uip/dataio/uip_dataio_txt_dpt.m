%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref vis_image
%> @image html Screenshot-uip_dataio_txt_dpt.png
%>
%> <b>Mode</b> - see vis_image::mode
%>
%> <b>Index of feature</b> - see vis_image::idx_fea
%>
%> @sa vis_image

%> @cond
function varargout = uip_dataio_txt_dpt(varargin)
% Last Modified by GUIDE v2.5 08-Jul-2013 09:00:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_dataio_txt_dpt_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_dataio_txt_dpt_OutputFcn, ...
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


% --- Executes just before uip_dataio_txt_dpt is made visible.
%
% varargin{1} is expected to be a dataio object, with filename already set
function uip_dataio_txt_dpt_OpeningFcn(hObject, eventdata, handles, varargin)
% Ignores what is usually a block that is passed to the GUI handles.input.block = varargin{1};
if nargin > 4

% % % %     % Tries to load spectra only (not image map)
% % % % %     oio = dataio_txt_dpt();


    handles.ds = varargin{1}.load();
else
    handles.ds = [];
end;
set(handles.uipanel_transpose, 'SelectionChangeFcn', ...
    @(hObject, eventdata) uip_dataio_txt_dpt('uipanel_transpose_SelectionChangeFcn',hObject,eventdata,guidata(hObject))); % Have to set this by hand because GUIDE does not do that automatically
handles.output.flag_ok = 0;
guidata(hObject, handles);
update_direction(handles);
handles = guidata(hObject);
update_dimensions(handles);
gui_set_position(hObject);

%#################################################################################################

%#########
function preview(handles)
ds = handles.ds;
if isempty(ds)
    irerrordlg('Dataset not specified!', 'Cannot preview');
    return;
end;
height = handles.heights(get(handles.popupmenu_dim, 'Value'));
ds.height = height;
ds.direction = handles.direction;
% if handles.flag_transpose
%     ds.height = ds.no/height;
%     ds = ds.transpose2();
% else
%     ds.height = height;
% end;
ot = fcon_mea_area();
%disp('Calculating area...')
ds2 = ot.use(ds);

u = vis_image();
u.mode = 0;
u.idx_fea = 1;
u.flag_set_position = 0;
vis_image01 = u;
cla(handles.axes1, 'reset');
axes(handles.axes1);
vis_image01.use(ds2);
title('');


%#########
function params = get_params(handles)
if isempty(handles.heights)
    s_height = '[]';
else
    s_height = int2str(handles.heights(get(handles.popupmenu_dim, 'Value')));
end;
params = {...
'height', s_height, ...
'direction', ['''', handles.direction, ''''], ...
};


%#########
% Called whenever the checkbox is checked/unchecked
function update_dimensions(handles)
heights = [];
if isempty(handles.ds)
    strs = {'(dataset not provided)'};
else
    ds = handles.ds;
    heights = [];
    strs = {};
    for i = 1:ds.no
        if ds.no/i == floor(ds.no/i)
            heights(end+1) = i; %#ok<*AGROW>
            strs{end+1} = sprintf('%3d x %3d', ds.no/i, i);
        end;
    end;
end;
handles.heights = heights;
set(handles.popupmenu_dim, 'Value', 1);
set(handles.popupmenu_dim, 'String', strs);
guidata(handles.figure1, handles);

%#########
% Updates intrnal flag_transpose
function update_direction(handles)
handles.direction = iif(get(handles.radiobutton_hor, 'Value'), 'hor', 'ver');
guidata(handles.figure1, handles);



%#################################################################################################


% --- Outputs from this function are returned to the command clae.
function varargout = uip_dataio_txt_dpt_OutputFcn(hObject, eventdata, handles) 
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

% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles)
try
    handles.output.params = get_params(handles);
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

function uipanel_transpose_SelectionChangeFcn(hObject, eventdata, handles)
update_direction(handles);

% --- Executes on selection change in popupmenu_dim.
function popupmenu_dim_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_dim_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_idx_fea_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_idx_fea_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_preview.
function pushbutton_preview_Callback(hObject, eventdata, handles)
preview(handles);
function uipanel_transpose_ButtonDownFcn(hObject, eventdata, handles)
%> @endcond
