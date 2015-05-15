%> @ingroup guigroup sheware mainguis
%> @file
%> @brief GUI for loading datasets from the SHEware database.
%>
%> The parameters names <b>Experiment</b>, <b>Domain</b>, <b>Deactivation Scheme</b>, <b>Tray</b>, and <b>Classifier</b> match SHEware terminology (e.g. "classifier" in IRootLab has another meaning).
%>
%> Each <b>Classifier</b> selected will generate one class level in the dataset.
%>
%> After clicking on <b>Generate dataset</b>: 
%> @arg data will be retrieved from the SHEware database
%> @arg the Window will close
%> @arg a new dataset will appear in @c datatool (and in MATLAB workspace).
%>
%> @image html Screenshot-sheload.png

%> @cond
function varargout = sheload(varargin)
% Last Modified by GUIDE v2.5 22-Nov-2012 16:15:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sheload_OpeningFcn, ...
                   'gui_OutputFcn',  @sheload_OutputFcn, ...
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


% --- Executes just before sheload is made visible.
function sheload_OpeningFcn(hObject, eventdata, handles, varargin)
try
    connect_to_cells();
    handles.output.flag_ok = 0;
    handles.ids_experiment = [];
    handles.ids_domain = [];
    handles.ids_deact = [];
    handles.ids_judge = [];
    handles.ids_tray = [];
    handles.idxs_judge = []; % will be synchronized with which is shown in edit_judge
    guidata(hObject, handles);
    gui_set_position(hObject);
    populate_experiment(handles);
catch ME
    send_error(ME);
end;



% --- Outputs from this function are returned to the command clae.
function varargout = sheload_OutputFcn(hObject, eventdata, handles) 
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
varargout{1} = handles.output;

%############################################

%#########
function z = get_idexperiment(hh)
idx = get(hh.popupmenu_experiment, 'Value');
if idx == 1
    z = [];
else
    z = hh.ids_experiment(idx-1);
end;
    
%#########
function z = get_iddomain(hh)
idx = get(hh.popupmenu_domain, 'Value');
if idx == 1
    z = [];
else
    z = hh.ids_domain(idx-1);
end;
    
%#########
function z = get_iddeact(hh)
idx = get(hh.popupmenu_deact, 'Value');
if idx == 1
    z = [];
else
    z = hh.ids_deact(idx-1);
end;
    
%#########
function z = get_idtray(hh)
idx = get(hh.popupmenu_tray, 'Value');
if idx == 1
    z = [];
else
    z = hh.ids_tray(idx-1);
end;

%#########
function z = get_idjudge(hh)
z = [];
if numel(hh.idxs_judge) > 0
    z = hh.ids_judge(hh.idxs_judge);
end;


%#########
function populate_experiment(hh)
a = {'(Select)'};
b = irquery(sprintf('select id, name from experiment order by name'));
ids = b.id;
names = b.name;
for i = 1:numel(ids)
    a = [a sprintf('%s (id %d)', names{i}, ids(i))];
end;
set(hh.popupmenu_experiment, 'Value', 1);
set(hh.popupmenu_experiment, 'String', a);
switch_experiment(hh);
hh.ids_experiment = ids;
guidata(hh.figure1, hh);


%#########
function populate_domain(hh)
a = {'(Select)'};
idexperiment = get_idexperiment(hh);
if idexperiment > 0
    b = irquery(sprintf('select domain.id, domain.name, count(*) as ccc from series left join domain on domain.id = series.iddomain where series.idexperiment = %d group by series.iddomain order by domain.name', idexperiment));
    ids = b.id;
    names = b.name;
    counts = b.ccc;
    for i = 1:numel(ids)
        a = [a sprintf('%s (id %d) - %d series', names{i}, ids(i), counts(i))];
    end;
    hh.ids_domain = ids;
    guidata(hh.figure1, hh);
end;
set(hh.popupmenu_domain, 'Value', 1);
set(hh.popupmenu_domain, 'String', a);
switch_domain(hh);


%#########
function populate_deact(hh)
a = {'(Leave blank)'};
idexperiment = get_idexperiment(hh);
b = irquery(sprintf('select id, name from deact order by name'));
ids = b.id;
names = b.name;
if idexperiment > 0
    for i = 1:length(ids)
        b = irquery(sprintf('select count(*) as ccc from deact_spectrum left join spectrum on deact_spectrum.idspectrum = spectrum.id where iddeact = %d and spectrum.idexperiment = %d', ids(i), idexperiment));
        count = b.ccc;
        a = [a sprintf('%s (id %d) - %d outliers', names{i}, ids(i), count)];
    end;
else
    for i = 1:numel(ids)
        a = [a sprintf('%s (id %d)', names{i}, ids(i))];
    end;
end;
set(hh.popupmenu_deact, 'String', a);
hh.ids_deact = ids;
guidata(hh.figure1, hh);

%#########
function populate_tray(hh)
a = {'(Leave blank)'};
idexperiment = get_idexperiment(hh);
if idexperiment > 0
    b = irquery(sprintf(['select tray.id, tray.code, count(*) as ccc from spectrum ' ... 
        'left join colony on spectrum.idcolony = colony.id ' ...
        'left join slide on colony.idslide = slide.id ' ...
        'left join tray on slide.idtray = tray.id ' ...
        'where spectrum.idexperiment = %d group by tray.id order by tray.code'], idexperiment));
    ids = b.id;
    names = b.code;
    counts = b.ccc;
    for i = 1:numel(ids)
        a = [a sprintf('%s (id %d) - %d scans', names{i}, ids(i), counts(i))];
    end;
    hh.ids_tray = ids;
    guidata(hh.figure1, hh);
end;
set(hh.popupmenu_tray, 'Value', 1);
set(hh.popupmenu_tray, 'String', a);
switch_tray(hh);

%#########
function populate_judge(hh)
a = {};
idexperiment = get_idexperiment(hh);
if idexperiment > 0
    b = irquery(sprintf(['select judge.id, judge.name, count(*) as ccc from spectrum_judge ' ...
        'left join spectrum on spectrum_judge.idspectrum = spectrum.id ' ...
        'left join judge on spectrum_judge.idjudge = judge.id ' ...
        'where spectrum.idexperiment = %d and judge.class_name = "judge_score_human" group by judge.id order by judge.name'], idexperiment));
    ids = b.id;
    names = b.name;
    counts = b.ccc;
    for i = 1:numel(ids)
        a = [a sprintf('%s (id %d)', names{i}, ids(i))];
    end;
    hh.ids_judge = ids;
end;
hh.idxs_judge = [];
set(hh.listbox_judge, 'Value', 1);
set(hh.listbox_judge, 'String', a);
guidata(hh.figure1, hh);
sync_judge(hh);


%#########
function sync_judge(hh)
if isempty(hh.idxs_judge)
    a = '';
else
    aa = get(hh.listbox_judge, 'String');
    a = aa(hh.idxs_judge);
end;
set(hh.edit_judge, 'String', a);




%#########
function switch_experiment(hh)
populate_domain(hh);
populate_deact(guidata(hh.figure1));
populate_tray(guidata(hh.figure1));
populate_judge(guidata(hh.figure1));

%#########
function switch_domain(hh)

%#########
function switch_deact(hh)

%#########
function switch_tray(hh)

%#########
function switch_judge(hh)




%############################################
%############################################


% --- Executes on button press in pushbutton_ok.
function pushbutton_ok_Callback(hObject, eventdata, handles)
try
    idexperiment = get_idexperiment(handles);
    iddomain = get_iddomain(handles);
    idjudge = get_idjudge(handles);
    iddeact = get_iddeact(handles);
    idtray = get_idtray(handles);

    if isempty(idexperiment)
        irerror('Please select an experiment!');
    end;
    if isempty(iddomain)
        irerror('Please select a domain!');
    end;

    name = find_varname('ds_she');
    scode = [...
'o = dataio_db();', 10, ...
sprintf('o.idexperiment = %s;\n', mat2str(idexperiment)), ...
sprintf('o.idjudge = %s;\n', mat2str(idjudge)), ...
sprintf('o.iddomain = %s;\n', mat2str(iddomain)), ...
sprintf('o.iddeact = %s\n', mat2str(iddeact)), ...
sprintf('o.idtray = %s;\n', mat2str(idtray)), ...
sprintf('%s = o.load();\n', name) ...
];
    ircode_eval(scode, 'Loads dataset from SHEware database');
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

% --- Executes on selection change in popupmenu_experiment.
function popupmenu_experiment_Callback(hObject, eventdata, handles)
switch_experiment(handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_experiment_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_domain.
function popupmenu_domain_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu_domain_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_deact.
function popupmenu_deact_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu_deact_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_tray.
function popupmenu_tray_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu_tray_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_judge.
function listbox_judge_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function listbox_judge_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_add.
function pushbutton_add_Callback(hObject, eventdata, handles)
if numel(handles.ids_judge) > 0
    handles.idxs_judge(end+1) = get(handles.listbox_judge, 'Value');
    guidata(handles.figure1, handles);
    sync_judge(handles);
end;

% --- Executes on button press in pushbutton_restart.
function pushbutton_restart_Callback(hObject, eventdata, handles)
handles.idxs_judge = [];
guidata(handles.figure1, handles);
sync_judge(handles);


function edit_judge_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit_judge_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%#####
function pushbutton_launch_objtool_Callback(hObject, eventdata, handles)
objtool;

%#####
function pushbutton_launch_datatool_Callback(hObject, eventdata, handles)
datatool();
%> @endcond
