%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref peakdetector
%> @image html Screenshot-uip_peakdetector.png
%> <p>Options:</p>
%> <p><b>Minimum  peak altitude</b> - Minimum distance between the zero line and the peak top. See peakdetector::minaltitude</p>
%> <p><b>Minimum  peak height</b> - Minimum distance between the highest mountain foot (left or right) and the peak top. See peakdetector::minheight</p>
%> <p><b>Altitude and height are given as fractions</b> - if checked, the two above options will be used to multiply the
%> maximum value of the curve to get the actual minima expressed in the same units as the curve; if not checked, it will
%> be assumed that the two parameters above are already expressed in the same units as the curve. See peakdetector::flag_perc</p>
%> <p><b>Minimum horizontal distance between two adjacent peaks (in points)</b>. Prevents detecting peaks that are too close to each other. See peakdetector::mindist</p>
%> <p><b>Maximum number of peaks</b> - if specified (i.e., if > 0), peaks will be sorted in descending order of altitude
%> and the highest peaks will be returned. See peakdetector::no_max</p>
%> <p><b>Use absolute value of curve</b> - if checked, the absolute value of the curve will be taken before peak
%> detection. If not checked, negative parts of the signal are made into "lakes", i.e., replaced by zeroes. See peakdetector::flag_abs</p>
%>
%> @sa peakdetector
%
%> @cond
function varargout = uip_peakdetector(varargin)
% Last Modified by GUIDE v2.5 12-Jul-2012 19:31:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_peakdetector_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_peakdetector_OutputFcn, ...
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


% --- Executes just before uip_peakdetector is made visible.
function uip_peakdetector_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_peakdetector_OutputFcn(hObject, eventdata, handles) 
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

function editReg_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function editReg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles) %#ok<*INUSL>
try
    handles.output.params = {...
    'flag_perc', int2str(get(handles.checkbox_flag_perc, 'Value')), ...
    'flag_abs', int2str(get(handles.checkbox_flag_abs, 'Value')), ...
    'minaltitude', num2str(eval(get(handles.edit_minaltitude, 'String'))), ...
    'minheight', num2str(eval(get(handles.edit_minheight, 'String'))), ...
    'mindist_units', num2str(eval(get(handles.edit_mindist_units, 'String'))), ...
    'no_max', num2str(eval(get(handles.edit_no_max, 'String'))) ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

% --- Executes on button press in checkbox_flag_group.
function checkbox_flag_group_Callback(hObject, eventdata, handles) %#ok<*INUSD,*DEFNU>

% --- Executes on button press in checkbox_flag_perclass.
function checkbox_flag_perclass_Callback(hObject, eventdata, handles)

function edit_randomseed_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_randomseed_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox_flag_perc.
function checkbox_flag_perc_Callback(hObject, eventdata, handles)

function edit_no_reps_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_no_reps_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_minaltitude_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_minaltitude_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_minheight_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_minheight_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_flag_abs.
function checkbox_flag_abs_Callback(hObject, eventdata, handles)


function edit_mindist_units_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_mindist_units_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_no_max_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_no_max_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
