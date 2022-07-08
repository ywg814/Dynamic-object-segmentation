%% 选取图像序列

frame_number = 50;    %运行frame_number帧
switch(imagetitle)
    case 'egtest01'
        imagepath = 'E:\跟踪图像数据集\PETS2005\egtest01\';
        numzeros = 5;
        fext = '.jpg';
        imagename =  dir([imagepath '*' fext]);
        begin = 1;
        frame_number = size(imagename, 1);
          
    case 'egtest02'
        imagepath = 'E:\跟踪图像数据集\PETS2005\egtest02\';
        numzeros = 5;
        fext = '.jpg';
        imagename =  dir([imagepath '*' fext]);
        begin = 1;
        frame_number = size(imagename, 1);
         
    case 'egtest03'
        imagepath = 'E:\跟踪图像数据集\PETS2005\egtest03\';
        numzeros = 5;
        fext = '.jpg';
        imagename =  dir([imagepath '*' fext]);
        begin = 1;
        frame_number = size(imagename, 1);
           
    case 'egtest04'
        imagepath = 'E:\跟踪图像数据集\PETS2005\egtest04\';
        numzeros = 5;
        fext = '.jpg';
        imagename =  dir([imagepath '*' fext]);
        begin = 1;
        frame_number = size(imagename, 1);
           
    case 'egtest05'
        imagepath = 'E:\跟踪图像数据集\PETS2005\egtest05\';
        numzeros = 5;
        fext = '.jpg';
        imagename =  dir([imagepath '*' fext]);
        begin = 1;
        frame_number = size(imagename, 1);
            
    case 'redteam'
        imagepath = 'E:\跟踪图像数据集\PETS2005\redteam\';
        numzeros = 5;
        fext = '.jpg';
        imagename =  dir([imagepath '*' fext]);
        begin = 1;
        frame_number = size(imagename, 1);
    
        
end
