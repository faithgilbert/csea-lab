function varargout = wavelet_GUI(varargin)
% WAVELET_GUI M-file for wavelet_GUI.fig
%      WAVELET_GUI, by itself, creates a new WAVELET_GUI or raises the existing
%      singleton*.
%
%      H = WAVELET_GUI returns the handle to a new WAVELET_GUI or the handle to
%      the existing singleton*.
%
%      WAVELET_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WAVELET_GUI.M with the given input arguments.
%
%      WAVELET_GUI('Property','Value',...) creates a new WAVELET_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wavelet_GUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wavelet_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wavelet_GUI

% Last Modified by GUIDE v2.5 24-Jan-2012 16:39:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wavelet_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @wavelet_GUI_OutputFcn, ...
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


% --- Executes just before wavelet_GUI is made visible.
function wavelet_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to wavelet_GUI (see VARARGIN)

% Choose default command line output for wavelet_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes wavelet_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = wavelet_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function fStart_Callback(hObject, eventdata, handles)
% hObject    handle to fStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fStart as text
%        str2double(get(hObject,'String')) returns contents of fStart as a double


% --- Executes during object creation, after setting all properties.
function fStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function fEnd_Callback(hObject, eventdata, handles)
% hObject    handle to fEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hints: get(hObject,'String') returns contents of fEnd as text
%        str2double(get(hObject,'String')) returns contents of fEnd as a double


% --- Executes during object creation, after setting all properties.
function fEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fInt_Callback(hObject, eventdata, handles)
% hObject    handle to fInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fInt as text
%        str2double(get(hObject,'String')) returns contents of fInt as a double


% --- Executes during object creation, after setting all properties.
function fInt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fileName_Callback(hObject, eventdata, handles)
% hObject    handle to fileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fileName as text
%        str2double(get(hObject,'String')) returns contents of fileName as a double


% --- Executes during object creation, after setting all properties.
function fileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata   reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
stock = get(handles.stock, 'Value');
 
if stock == 0,  %appMP
    fStart = str2num(get(handles.fStart, 'string'));
    fEnd = str2num(get(handles.fEnd, 'string'));
    fInt = str2num(get(handles.fInt, 'string'));
    fileName = get(handles.fileName, 'string');
    wavelet_appMP(fileName, fStart, fEnd, fInt);

elseif stock == 1 %Stockwell
    xy = get(handles.fileName, 'string')
    [data,Version,LHeader,ScaleBins,NChan,NPointsold,NTrials,SampRate,ch_AvgRef]=ReadAppData(deblank(get(handles.fileName, 'string')));
    minfreq = str2num(get(handles.fStart, 'string'))
    maxfreq = str2num(get(handles.fEnd, 'string'))
    freqsamplingrate = str2num(get(handles.fInt, 'string'))
    samplingrate = SampRate;
    fSteps=(maxfreq-minfreq)/freqsamplingrate +1
    tSteps = NPointsold; %??
%  %stockwell(_____,minfreq,maxfreq,samplingrate,freqsamplingrate)
% 
% %  
%  
test = zeros(fSteps,tSteps,size(data,1)); 
for trial = 1:NTrials,
    if trial./10 == round(trial./10), fprintf('.'), end
   ReadAppData(deblank(get(handles.fileName, 'string')),trial); 
        for channel = 1:size(data,1), 
            test(:,:, channel) = st(data(channel,:),minfreq,maxfreq,samplingrate,freqsamplingrate); 
        end, 
        if trial==1, 
        tempwamat = test./abs(test); 
    else tempwamat = tempwamat+test./abs(test); 
    end
end
end
% 
% % for trial = 1: 1, a = readappdata('23emoc3A.E1.app3', trial), ...
% test = stock(a);
% end

% for trial = 1: 1, a = readappdata('23emoc3A.E1.app3', trial), ...
% for channel = 1:129, test = stock(a(channel));end
% end


% for trial = 1: 1, a = readappdata('23emoc3A.E1.app3', trial), ...
% for channel = 1:129, test = stock(a(channel,:));end
% end
 
% test = []; for trial = 1: 1, a = readappdata('23emoc3A.E1.app3', trial), ...
% for channel = 1:129, test = [test; stock(a(channel,:))];end
% end

% argh = stock(a(129,:)
% argh = stock(a(129,:));

% test = zeros(101,200,129); for trial = 1: 1, a = readappdata('23emoc3A.E1.app3', trial), ...
% for channel = 1:129, test(:,:, channel) = stock(a(channel,:)); end
% end

% edit readappdata
% [Data,Version,LHeader,ScaleBins,NChan,NPoints,NTrials] = readappdata('23emoc3A.E1.app3', 1)
% test = zeros(101,200,129); for trial = 1: 20, a = readappdata('23emoc3A.E1.app3', trial), ...
% for channel = 1:129, test(:,:, channel) = stock(a(channel,:)); end, if trial==1, tempwamat = test; else tempwamat = tempwamat+test; end
% end

% WaData
% StPower = permute(tempwamat, [3, 2, 1]);
 
% WaData
 
% contourf(0:4:800-.004,1:101,squeeze(StPower(68,:,:))');colorbar
% contourf(0:4:800-.004,1:101,squeeze(abs(StPower(68,:,:)))');colorbar

% test = zeros(101,200,129); for trial = 1: 10, a = readappdata('23emoc3A.E1.app3', trial), ...
% % for channel = 1:129, test(:,:, channel) = abs(stock(a(channel,:))); end, if trial==1, tempwamat = test; else tempwamat = tempwamat+test; end
% end

% test = zeros(101,200,129); for trial = 1: 10, a = readappdata('23emoc3A.E1.app3', trial), ...
% for channel = 1:129, test(:,:, channel) = abs(stock(a(channel,:))); end, if trial==1, tempwamat = test; else tempwamat = tempwamat+test; end
% end
 
% contourf(0:4:800-.004,1:101,squeeze(abs(StPower(68,:,:)))');colorbar
% contourf(0:4:800-.004,1:101,squeeze((StPower(68,:,:)))');colorbar

% StPower = permute(tempwamat, [3, 2, 1]);
% contourf(0:4:800-.004,1:101,squeeze((StPower(68,:,:)))');colorbar

% test = zeros(101,200,129); for trial = 1: 10, a = readappdata('23emoc3A.E1.app3', trial), ...
% for channel = 1:129, test(:,:, channel) = (stock(a(channel,:))); end, if trial==1, tempwamat = test./abs(test); else tempwamat = tempwamat+test./abs(test); end
% end

% StPhase = permute(tempwamat, [3, 2, 1]);
% contourf(0:4:800-.004,1:101,squeeze((StPhase(68,:,:)))');colorbar
% contourf(0:4:800-.004,1:101,squeeze(abs(StPhase(68,:,:)))');colorbar%
% %
% %


    %stockwell(_____,minfreq,maxfreq,samplingrate,freqsamplingrate)

% --- Executes during object deletion, before destroying properties.
function fStart_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to fStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 
% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over fStart.
function fStart_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to fStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function calculate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in stock.
function stock_Callback(hObject, eventdata, handles)
% hObject    handle to stock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stock

