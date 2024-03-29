function varargout = Thalweg(varargin)
% THALWEG MATLAB code for Thalweg.fig
%      THALWEG, by itself, creates a new THALWEG or raises the existing
%      singleton*.
%
%      H = THALWEG returns the handle to a new THALWEG or the handle to
%      the existing singleton*.
%
%      THALWEG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in THALWEG.M with the given input arguments.
%
%      THALWEG('Property','Value',...) creates a new THALWEG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Thalweg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Thalweg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Thalweg

% Last Modified by GUIDE v2.5 09-Dec-2015 21:57:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Thalweg_OpeningFcn, ...
                   'gui_OutputFcn',  @Thalweg_OutputFcn, ...
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


% --- Executes just before Thalweg is made visible.
function Thalweg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Thalweg (see VARARGIN)

%------------------------------my codes start---------------------
prompt = {'Row number for the input of npt'};      %npt is the number of sampling point at a cross-section
dlgtitle = 'Input';
dims = 1;
definput = {'3'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
row_npt=str2num(answer{1});

[dist,zbed]=extract_thalweg(row_npt);          
plot(handles.axes1,dist,zbed);             %set the current axes, important in multi window design!!!!!
%------------------------------my codes end----------------------

% Choose default command line output for Thalweg
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Thalweg wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Thalweg_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
