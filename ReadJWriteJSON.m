%关于读写json文件的一些命令


%--------------------------------读取json--------------------------------------
[filename,path,FilterIndex]=uigetfile('*.*');
fpath=[path,filename];
jsonText = fileread(fpath);
data = jsondecode(jsonText);




%--------------------------------写json----------------------------------------
%将修改后的结构体编码为 JSON 字符串
jsonStr = jsonencode(data);

outputFileName = 'modified_data.json';  % 指定输出文件名
fileID = fopen(outputFileName, 'w');  % 以写模式打开文件
if fileID == -1
    error('无法打开文件');
end
fprintf(fileID, '%s', jsonStr);  % 写入 JSON 字符串
fclose(fileID);  % 关闭文件

disp(['数据已成功写入 ', outputFileName]);