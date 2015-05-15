%> @ingroup gruigroup
%> @file
%> @brief Report Dialog Box
%> @image html Screenshot-reportdlg.png
%> Visualization of object report. Called when the user chooses <em>Visualize->Report</em>

%> @cond
function varargout = reportdlg(varargin)

% Edit the above text to modify the response to help reportdlg

% Last Modified by GUIDE v2.5 09-Feb-2011 17:03:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @reportdlg_OpeningFcn, ...
                   'gui_OutputFcn',  @reportdlg_OutputFcn, ...
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


% --- Executes just before reportdlg is made visible.
function reportdlg_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for reportdlg
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

if numel(varargin) > 0
    set(handles.editText, 'String', varargin{1});
else
    set(handles.editText, 'String', '?');
end;
gui_set_position(hObject);



% --- Outputs from this function are returned to the command line.
function varargout = reportdlg_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
try
    [name, path, filterindex] = uiputfile({'*.txt', 'MATLAB source file(*.m)'; '*.*', 'All files'}, 'Save as', 'log.txt');
    if name > 0
        filename = fullfile(path, name);
        h = fopen(filename, 'w');
        fwrite(h, get(handles.editText, 'string'));
        fclose(h);
        irverbose(['File ''' filename ''' saved successfully!'], 1);
    end;
catch ME
    irerrordlg(ME.message, 'Error saving file!');
end;

function editText_Callback(hObject, eventdata, handles)
% hObject    handle to editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editText as text
%        str2double(get(hObject,'String')) returns contents of editText as a double


% --- Executes during object creation, after setting all properties.
function editText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond

