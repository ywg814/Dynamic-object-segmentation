%% ѡȡͼ������

frame_number = 50;    %����frame_number֡
switch(imagetitle)
    case 'egtest01'
        imagepath = 'E:\����ͼ�����ݼ�\PETS2005\egtest01\';
        numzeros = 5;
        fext = '.jpg';
        imagename =  dir([imagepath '*' fext]);
        begin = 1;
        frame_number = size(imagename, 1);
          
    case 'egtest02'
        imagepath = 'E:\����ͼ�����ݼ�\PETS2005\egtest02\';
        numzeros = 5;
        fext = '.jpg';
        imagename =  dir([imagepath '*' fext]);
        begin = 1;
        frame_number = size(imagename, 1);
         
    case 'egtest03'
        imagepath = 'E:\����ͼ�����ݼ�\PETS2005\egtest03\';
        numzeros = 5;
        fext = '.jpg';
        imagename =  dir([imagepath '*' fext]);
        begin = 1;
        frame_number = size(imagename, 1);
           
    case 'egtest04'
        imagepath = 'E:\����ͼ�����ݼ�\PETS2005\egtest04\';
        numzeros = 5;
        fext = '.jpg';
        imagename =  dir([imagepath '*' fext]);
        begin = 1;
        frame_number = size(imagename, 1);
           
    case 'egtest0'
        imagepath = 'E:\����ͼ�����ݼ�\PETS2005\egtest05\';
        numzeros = 5;
        fext = '.jpg';
        imagename =  dir([imagepath '*' fext]);
        begin = 1;
        frame_number = size(imagename, 1);
            
    case 'redteam'
        imagepath = 'E:\����ͼ�����ݼ�\PETS2005\redteam\';
        numzeros = 5;
        fext = '.jpg';
        imagename =  dir([imagepath '*' fext]);
        begin = 1;
        frame_number = size(imagename, 1);
    
        
end
