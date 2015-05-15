%> @ingroup guigroup
%> @file
%> @brief Browses datasets present in workspace for GUI user to choose one.
%>
%> This is used in: uip_blbl_extract_cv.m
%>
%> @image html Screenshot-ask_dataset.png
%>
%> @c varargin inputs:
%> @arg internal Please pass first parameter as "[]" (empty vector)
%> @arg flag_empty=0 Whether can return empty or not
%> @arg caption='Dataset of input'
function varargout = ask_dataset(varargin)
% Last Modified by GUIDE v2.5 05-Mar-2011 16:14:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ask_dataset_OpeningFcn, ...
                   'gui_OutputFcn',  @ask_dataset_OutputFcn, ...
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

%> @cond
% --- Executes just before ask_dataset is made visible.
function ask_dataset_OpeningFcn(hObject, eventdata, handles, varargin)
if nargin > 4 && ~isempty(varargin{2})
    set(handles.text_caption, 'String', varargin{2});
end;

if nargin > 5
    handles.input.flag_empty = varargin{3};
else
    handles.input.flag_empty = 0;
end;

handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

% --- Outputs from this function are returned to the command clae.
function varargout = ask_dataset_OutputFcn(hObject, eventdata, handles) 
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
function refresh(handles)
listbox_load_from_workspace('irdata', handles.popupmenuData, handles.input.flag_empty);

%############################################

% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles)
try
    sdata = listbox_get_selected_1stname(handles.popupmenuData);
    if isempty(sdata)
        if handles.input.flag_empty
            sdata = '[]';
        else
            irerror('Input dataset not specified!');
        end;
    end;

    handles.output.params = {...
    'data', sdata ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;


% --- Executes on selection change in popupmenuData.
function popupmenuData_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenuData_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
