database_files = dir('./ltstdb/*.mat');

for i=1:length(database_files)
    base_file_name = database_files(i).name;
    %disp(base_file_name);
    split_by_dot = strsplit(base_file_name, '.');
    file_name = split_by_dot{1};
    disp(file_name);
    Detector(file_name);
end