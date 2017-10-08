function varargout = iot_demo(varargin)
% IOT_DEMO MATLAB code for iot_demo.fig
%      IOT_DEMO, by itself, creates a new IOT_DEMO or raises the existing
%      singleton*.
%
%      H = IOT_DEMO returns the handle to a new IOT_DEMO or the handle to
%      the existing singleton*.
%
%      IOT_DEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IOT_DEMO.M with the given input arguments.
%
%      IOT_DEMO('Property','Value',...) creates a new IOT_DEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before iot_demo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to iot_demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help iot_demo

% Last Modified by GUIDE v2.5 28-Jun-2017 17:05:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @iot_demo_OpeningFcn, ...
                   'gui_OutputFcn',  @iot_demo_OutputFcn, ...
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


% --- Executes just before iot_demo is made visible.
function iot_demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to iot_demo (see VARARGIN)

% Choose default command line output for iot_demo
handles.output = hObject;

handles.data.history_x = [0];
handles.data.history_y = [0];
handles.data.limit_t = 30.0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes iot_demo wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = iot_demo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function limit_txt_Callback(hObject, eventdata, handles)
% hObject    handle to limit_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of limit_txt as text
%        str2double(get(hObject,'String')) returns contents of limit_txt as a double


% --- Executes during object creation, after setting all properties.
function limit_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to limit_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in set_btn.
function set_btn_Callback(hObject, eventdata, handles)
% hObject    handle to set_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = get(handles.limit_txt, 'String');
tmp = str2double(tmp);
handles.data.limit_t = tmp;
guidata(hObject, handles);


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
javaaddpath('mongo-java-driver-2.13.1.jar')
import com.mongodb.*
while 1
    %connect mongo
    m = Mongo('127.0.0.1',27017);
    db = m.getDB('iot');
    clients = db.getCollection('temperature');
    sort_querry = BasicDBObject("datetime",-1);
    fcstPrices = clients.find().sort(sort_querry);
    if fcstPrices.hasNext()
        fcstPrices.next();
        ans = jsondecode(char(fcstPrices.curr().toString()));
        %save the temperature
        handles.data.history_x = [handles.data.history_x ans.temperature];
        handles.data.history_y = [handles.data.history_y handles.data.history_y(1,end)+1];
        guidata(hObject, handles);
        %max x length is 1000
        now_l = length(handles.data.history_x);
        if now_l > 1000
            handles.data.history_x = handles.data.history_x(1,now_l-999:end);
            handles.data.history_y = handles.data.history_y(1,now_l-999:end);
            guidata(hObject, handles);
        end
    end
    %close db
    db.cleanCursors(1);
    %plot 
    hold off;
    plot( handles.axes1,handles.data.history_y, handles.data.history_x)
    %get alert temperature
    tmp = get(handles.limit_txt, 'String');
    tmp = str2double(tmp);
    handles.data.limit_t = tmp;
    guidata(hObject, handles);
    %change the alert light
    if handles.data.history_x(1,end) >= handles.data.limit_t
        set(handles.t_light,'backgroundcolor','r');
    else
        set(handles.t_light,'backgroundcolor','c');
    end
    %wait 1 sec
    pause(1)
end


% --- Executes during object creation, after setting all properties.
function t_light_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t_light (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
