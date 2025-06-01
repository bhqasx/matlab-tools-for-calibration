function varargout = zb_node_compare(varargin)
% ZB_NODE_COMPARE MATLAB code for zb_node_compare.fig
%      ZB_NODE_COMPARE, by itself, creates a new ZB_NODE_COMPARE or raises the existing
%      singleton*.
%
%      H = ZB_NODE_COMPARE returns the handle to a new ZB_NODE_COMPARE or the handle to
%      the existing singleton*.
%
%      ZB_NODE_COMPARE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ZB_NODE_COMPARE.M with the given input arguments.
%
%      ZB_NODE_COMPARE('Property','Value',...) creates a new ZB_NODE_COMPARE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before zb_node_compare_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to zb_node_compare_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help zb_node_compare

% Last Modified by GUIDE v2.5 23-Apr-2019 11:38:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @zb_node_compare_OpeningFcn, ...
                   'gui_OutputFcn',  @zb_node_compare_OutputFcn, ...
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


% --- Executes just before zb_node_compare is made visible.
function zb_node_compare_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to zb_node_compare (see VARARGIN)

%------------------------------my codes start---------------------
handles=CsCompare_initiate(handles);
global CS;
global CS_af;         %cross-sections after flood
handles.ics=round(get(handles.slider1,'Value'));        %set the current CS as 1
handles.draw_wl=0;
plotCS(CS(handles.ics));
set(handles.text1,'String',['CS', num2str(handles.ics)]);

%------------------------------my codes end----------------------

% Choose default command line output for zb_node_compare
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes zb_node_compare wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = zb_node_compare_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global CS;
global CS_af;         %cross-sections after flood
handles.ics=round(get(hObject,'Value'));
if get(handles.checkbox_AfterFlood,'Value')
    plotCS(CS(handles.ics),CS_af(handles.ics));
    grid on;
else
    plotCS(CS(handles.ics));
    grid on;
end

if handles.draw_wl==1
    hold on;
    plot([CS(handles.ics).x(1), CS(handles.ics).x(end)], [handles.wl(handles.ics), handles.wl(handles.ics)]);
    hold off;
end

if isfield(CS(handles.ics),'name')
    set(handles.text1,'String',['CS', num2str(handles.ics),'(',char(CS(handles.ics).name),')']);
else
    set(handles.text1,'String',['CS', num2str(handles.ics)]);
end
guidata(hObject, handles);    %the ics field is added to handles, so this line is needed


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in checkbox_AfterFlood.
function checkbox_AfterFlood_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_AfterFlood (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_AfterFlood
global CS;
global CS_af;
if get(hObject,'Value')
    plotCS(CS(handles.ics),CS_af(handles.ics));
    grid on;
else
    plotCS(CS(handles.ics));
    grid on;
end
guidata(hObject, handles);

% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ExpToTxt_Callback(hObject, eventdata, handles)
% hObject    handle to ExpToTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%export cs data to txt file
global CS_af;

ncs=size(CS_af,2);
fid = fopen('ExportedCS.txt', 'w');
fprintf(fid,'xxxxxx\n');
fprintf(fid,'%d     总断面数\n', ncs);
for i=1:1:ncs
    fprintf(fid,'CS%2d(HH%2d)\n',i,1+ncs-i);
    fprintf(fid,'xxxxxx\n');
    fprintf(fid,'%d        xxx\n',CS_af(i).npt);
    fprintf(fid,'序号       起点距       高程\n');
    for j=1:1:CS_af(i).npt
        fprintf(fid,'%d     %.3f      %.3f      %d\n', j, CS_af(i).x(j), CS_af(i).zb(j), CS_af(i).chfp(j));                
    end
end

fclose(fid);


% --------------------------------------------------------------------
function EditCS_Callback(hObject, eventdata, handles)
% hObject    handle to EditCS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Move_LNode_Callback(hObject, eventdata, handles)
% hObject    handle to Move_LNode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Edit Cross Section->Move Left Node
handles.node_modi=1;
set(handles.figure1,'KeyPressFcn',{@MyKeyPressF,handles});
guidata(hObject, handles);
% --------------------------------------------------------------------
function Move_RNode_Callback(hObject, eventdata, handles)
% hObject    handle to Move_RNode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Edit Cross Section->Move Right Node
handles.node_modi=2;
set(handles.figure1,'KeyPressFcn',{@MyKeyPressF,handles});
guidata(hObject, handles);

function MyKeyPressF(hObject,eventdata,handles)

global CS;
global CS_af;

if isfield(handles,'node_modi')&&handles.checkbox_AfterFlood.Value
    if handles.node_modi==1
        if strcmp(eventdata.Key,'leftarrow')           
            CS_af(handles.ics).x(1)=CS_af(handles.ics).x(1)-1;
        elseif strcmp(eventdata.Key,'rightarrow')
            CS_af(handles.ics).x(1)=CS_af(handles.ics).x(1)+1;
        end
    else
        if strcmp(eventdata.Key,'leftarrow')
            CS_af(handles.ics).x(end)=CS_af(handles.ics).x(end)-1;
        elseif strcmp(eventdata.Key,'rightarrow')
            CS_af(handles.ics).x(end)=CS_af(handles.ics).x(end)+1;
        end
    end
    
    if strcmp(CS_af(handles.ics).modi_info,'None')
        CS_af(handles.ics).modi_info='NarrowFp';
    elseif strcmp(CS_af(handles.ics).modi_info,'NarrowCh')
        CS_af(handles.ics).modi_info='NarrowChFp';
    end
    plotCS(CS(handles.ics),CS_af(handles.ics));
end


% --------------------------------------------------------------------
function Complet_CS_Callback(hObject, eventdata, handles)
% hObject    handle to Complet_CS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global CS;
global CS_af;

npt=size(CS(handles.ics).x,1);

%----------------------------补完左侧---------------------------------------
xl=CS_af(handles.ics).x(1);
for i=1:1:npt-1
   if (CS(handles.ics).x(i)<xl)&&(CS(handles.ics).x(i+1)>=xl)
       xleft=CS(handles.ics).x(1:i);
       zbleft=CS(handles.ics).zb0(1:i);
       break;
   end
end
for i=1:1:size(xleft)-1
   if (zbleft(i)>=CS_af(handles.ics).zb(1))&&(zbleft(i+1)<CS_af(handles.ics).zb(1))
       zbleft(i+1:end)=CS_af(handles.ics).zb(1);
       break;
   end
end
CS_af(handles.ics).x=[xleft;CS_af(handles.ics).x];
CS_af(handles.ics).zb=[zbleft;CS_af(handles.ics).zb];

%----------------------------补完右侧---------------------------------------
xr=CS_af(handles.ics).x(end);
for i=npt:-1:2
   if (CS(handles.ics).x(i)>xr)&&(CS(handles.ics).x(i-1)<=xr)
       xright=CS(handles.ics).x(i:end);
       zbright=CS(handles.ics).zb0(i:end);
       break;
   end
end
for i=size(xright):-1:2
   if (zbright(i)>=CS_af(handles.ics).zb(end))&&(zbright(i-1)<CS_af(handles.ics).zb(end))
       zbright(1:i-1)=CS_af(handles.ics).zb(end);
       break;
   end
end
CS_af(handles.ics).x=[CS_af(handles.ics).x;xright];
CS_af(handles.ics).zb=[CS_af(handles.ics).zb;zbright];

CS_af(handles.ics).done=1;
plotCS(CS(handles.ics),CS_af(handles.ics));


% --------------------------------------------------------------------
function Volume_Callback(hObject, eventdata, handles)
% hObject    handle to Volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function Vol_Level_Curve_Callback(hObject, eventdata, handles)
% hObject    handle to Vol_Level_Curve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global CS;
level=0;
button=questdlg('请输入一组水位','Guide','Yes');
if ~strcmp(button,'Yes')
    return;
end
openvar('level');     %在窗口中输入
Vol=getVolAtZ(level,CS);


% --------------------------------------------------------------------
function Water_Level_Callback(hObject, eventdata, handles)
% hObject    handle to Water_Level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Add_Water_Level_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Water_Level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.draw_wl=1;
[filename,path,FilterIndex]=uigetfile('*.*');
[pathstr,name,ext] = fileparts(filename);
if strcmp(ext,'.mat')
    load([path,filename],'MaxWL');
end
handles.wl=MaxWL;
guidata(hObject, handles); 