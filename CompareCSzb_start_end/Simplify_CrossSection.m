function varargout = Simplify_CrossSection(varargin)
% SIMPLIFY_CROSSSECTION MATLAB code for Simplify_CrossSection.fig
%      SIMPLIFY_CROSSSECTION, by itself, creates a new SIMPLIFY_CROSSSECTION or raises the existing
%      singleton*.
%
%      H = SIMPLIFY_CROSSSECTION returns the handle to a new SIMPLIFY_CROSSSECTION or the handle to
%      the existing singleton*.
%
%      SIMPLIFY_CROSSSECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMPLIFY_CROSSSECTION.M with the given input arguments.
%
%      SIMPLIFY_CROSSSECTION('Property','Value',...) creates a new SIMPLIFY_CROSSSECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Simplify_CrossSection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Simplify_CrossSection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Simplify_CrossSection

% Last Modified by GUIDE v2.5 13-Apr-2016 18:03:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Simplify_CrossSection_OpeningFcn, ...
                   'gui_OutputFcn',  @Simplify_CrossSection_OutputFcn, ...
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


% --- Executes just before Simplify_CrossSection is made visible.
function Simplify_CrossSection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Simplify_CrossSection (see VARARGIN)

%------------------------------my codes start---------------------
global CS_original;
global CS_simplified;
button=questdlg('��ѡ������ļ����ļ���ʽӦ��һάģ������ļ�һ��','Guide','Yes');
if ~strcmp(button,'Yes')
    return;
end
[filename,path,FilterIndex]=uigetfile('*.*');
[ncs,CS_original]=readCS([path,filename]);
CS_simplified=CS_original;
    
set(handles.slider1,'Min',1);          %set slider initial starte
set(handles.slider1,'Max',ncs);
set(handles.slider1,'Value',1);
set(handles.slider1,'SliderStep',[1/(ncs-1),1/(ncs-1)]);

handles.ics=round(get(handles.slider1,'Value'));        %set the current CS as 1
plot(CS_original(handles.ics).x,CS_original(handles.ics).zb,'bo-');
grid on;
set(handles.text1,'String',['CS', num2str(handles.ics)]);
%------------------------------my codes end----------------------

% Choose default command line output for Simplify_CrossSection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Simplify_CrossSection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Simplify_CrossSection_OutputFcn(hObject, eventdata, handles) 
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
global CS_original;

handles.ics=round(get(hObject,'Value'));
plot(CS_original(handles.ics).x,CS_original(handles.ics).zb,'bo-');
grid on;
set(handles.text1,'String',['CS', num2str(handles.ics)]);
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
fprintf(fid,'%d     �ܶ�����\n', ncs);
for i=1:1:ncs
    fprintf(fid,'CS%2d(HH%2d)\n',i,1+ncs-i);
    fprintf(fid,'xxxxxx\n');
    fprintf(fid,'%d        xxx\n',CS_af(i).npt);
    fprintf(fid,'���       ����       �߳�\n');
    for j=1:1:CS_af(i).npt
        fprintf(fid,'%d     %.3f      %.3f      %d\n', j, CS_af(i).x(j), CS_af(i).zb(j), CS_af(i).chfp(j));                
    end
end

fclose(fid);


% --------------------------------------------------------------------
function Options_Callback(hObject, eventdata, handles)
% hObject    handle to Options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Shape_Callback(hObject, eventdata, handles)
% hObject    handle to Shape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Rectangle_Callback(hObject, eventdata, handles)
% hObject    handle to Rectangle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Triangle,'Checked','off');
set(hObject,'Checked','on');
handles.cs_shape='Rectangle';
guidata(hObject, handles);        %update user data in handles


% --------------------------------------------------------------------
function Triangle_Callback(hObject, eventdata, handles)
% hObject    handle to Triangle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Rectangle,'Checked','off');
set(hObject,'Checked','on');
handles.cs_shape='Triangle';
guidata(hObject, handles); 



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
handles.zw_design=str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CS_original;
global CS_simplified;
[area,width]=get_area(CS_original(handles.ics),handles.zw_design);
if strcmp(handles.cs_shape,'Rectangle')
    
elseif strcmp(handles.cs_shape,'Triangle')
    
end
    