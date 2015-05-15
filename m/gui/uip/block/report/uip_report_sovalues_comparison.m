%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref report_sovalues_comparison
%> @sa report_sovalues_comparison

%>@cond
function varargout = uip_report_sovalues_comparison(varargin)
% Last Modified by GUIDE v2.5 12-Nov-2012 18:27:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_report_sovalues_comparison_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_report_sovalues_comparison_OutputFcn, ...
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


% --- Executes just before uip_report_sovalues_comparison is made visible.
function uip_report_sovalues_comparison_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
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

listbox_load_from_workspace('vectorcomp', handles.popupmenu_vectorcomp, 1, 'Use default');




% --- Outputs from this function are returned to the command clae.
function varargout = uip_report_sovalues_comparison_OutputFcn(hObject, eventdata, handles) 
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
    
    svectorcomp = listbox_get_selected_1stname(handles.popupmenu_vectorcomp);
    if isempty(svectorcomp)
        svectorcomp = '[]';
    end;

    handles.output.params = {...
    'dimspec', aaa, ...
    'names', ['{''', svfn, '''}'], ...
    'maxrows', int2str(eval(get(handles.edit_maxrows, 'String'))), ...
    'flag_ptable' , int2str(get(handles.checkbox_flag_ptable, 'Value')), ...
    'vectorcomp', svectorcomp, ...
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

function edit_maxrows_Callback(hObject, eventdata, handles)

function edit_maxrows_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function checkbox_flag_ptable_Callback(hObject, eventdata, handles)


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


% --- Executes on selection change in popupmenu_vectorcomp.
function popupmenu_vectorcomp_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_vectorcomp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_vectorcomp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_vectorcomp


% --- Executes during object creation, after setting all properties.
function popupmenu_vectorcomp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_vectorcomp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
