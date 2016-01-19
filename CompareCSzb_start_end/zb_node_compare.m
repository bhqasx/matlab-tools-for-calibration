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

% Last Modified by GUIDE v2.5 15-Jan-2016 21:32:13

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
