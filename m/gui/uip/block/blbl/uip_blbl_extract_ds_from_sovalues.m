%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref blbl_extract_ds_from_sovalues
%>
%> @sa blbl_extract_ds_from_sovalues.m

%>@cond
function varargout = uip_blbl_extract_ds_from_sovalues(varargin)
% Last Modified by GUIDE v2.5 12-Nov-2012 17:04:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_blbl_extract_ds_from_sovalues_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_blbl_extract_ds_from_sovalues_OutputFcn, ...
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


% --- Executes just before uip_blbl_extract_ds_from_sovalues is made visible.
function uip_blbl_extract_ds_from_sovalues_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
if nargin > 4
    handles.input.sovalues = varargin{2};
else
    handles.input.sovalues = [];
end;
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);

if ~isempty(handles.input.sovalues)
    sov = handles.input.sovalues;
    a = sov.get_numericfieldnames();
    set(handles.popupmenu_valuesfieldname, 'string', a);
    set(handles.edit_valuesfieldname, 'string', a{1});
else
    set(handles.popupmenu_valuesfieldname, 'string', {'?'});
end;



% --- Outputs from this function are returned to the command clae.
function varargout = uip_blbl_extract_ds_from_sovalues_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles)
try
    aaa = eval(get(handles.edit_dimspec, 'String'));
    if iscell(aaa)
        aaa = cell2str(aaa);
    else
        aaa = mat2str(aaa);
    end;
    
    svfn = fel(get(handles.edit_valuesfieldname, 'String'));
    if ~isempty(handles.input.sovalues)
        sov = handles.input.sovalues;
        if ~any(strcmp(svfn, sov.get_numericfieldnames()));
            irerror(sprintf('Invalid values field name: "%s"', svfn));
        end;
    end;
    
    handles.output.params = {...
    'dimspec', aaa, ...
    'valuesfieldname', ['''', svfn, ''''], ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;


function edit_dimspec_Callback(hObject, eventdata, handles) %#ok<*INUSD,*DEFNU>

% --- Executes during object creation, after setting all properties.
function edit_dimspec_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_valuesfieldname_Callback(hObject, eventdata, handles)

function edit_valuesfieldname_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%#####
function popupmenu_valuesfieldname_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
s = contents{get(hObject,'Value')};
if ~strcmp(s, '?')
    set(handles.edit_valuesfieldname, 'String', s);
end;

function popupmenu_valuesfieldname_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
