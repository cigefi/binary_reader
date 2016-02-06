% Function binary_reader
%
% Prototype: binary_reader({[dirName]})
%
% dirName = Path of the directory that contents the files
function [out] = binary_reader(dirName)
    if nargin < 1
        error('binary_reader: dirName is a required input')
    end
    
    dirData = dir(char(dirName(1)));
    path = java.lang.String(dirName(1));
    if(path.charAt(path.length-1) ~= '/')
        path = path.concat('/');
    end
    if(length(dirName)>1)
        newName = dirName(2);
    else
        newName = strcat(char(path),'[CIGEFI] Data.nc');
    end
    var2Read = 'meteoro';
    if(exist(char(newName),'file')==0)
        configure_netcdf(char(newName),var2Read);
        out = [];
    else
        out = nc_varget(char(newName),var2Read);
    end
    for f = 3:length(dirData)
        fileT = path.concat(dirData(f).name);
        if(fileT.substring(fileT.lastIndexOf('.')+1).equalsIgnoreCase('dat'))
            try
                d = dir(char(fileT));
                if(d.bytes>0)
                    % Subrutine to read the data of .dat files
                    out = readFile(char(fileT),out);
                    %out = cat(2,out,readFile(char(fileT),out));
                end
            catch
                continue;
            end
        else
            if isequal(dirData(f).isdir,1)
                  newPath = char(path.concat(dirData(f).name));
                if nargin < 2 % Validates if the var2Read param is received
                    out = cat(1,out,reader({[char(newPath)],[char(newName)]}));
                end
            end
        end
    end
    
    if(length(dirName)==1 && ~isempty(out))
        nc_data = [];
        save(strcat(var2Read,'-raw.mat'), 'out');
        for i=1:1:length(out)
            if(mod(i,50000)==0)
                fprintf('Data saved %d of %d\n',i,length(out));
            end
            parti = cat(1,out(i).lon,out(i).lat,out(i).h,out(i).qvi,out(i).theta)';
            days = out(i).day';
            hours = out(i).hour';
            % Rearranging data in order to save as .nc file
            nc_data = cat(3,nc_data,rearrangeData(parti,days,hours)); %R
        end
        save(strcat(var2Read,'.mat'), 'out');
        nc_varput(char(newFile),var2Read,nc_data);
        fprint('%d particles sucessfully saved',length(out));
    end
end

function configure_netcdf(newFile,var2Read)
    nc_create_empty(newFile,'netcdf4');

    % Adding file dimensions
    nc_add_dimension(newFile,'lat',0);
    nc_add_dimension(newFile,'lon',0);
    nc_add_dimension(newFile,'h',0);
    nc_add_dimension(newFile,'qvi',0);
    nc_add_dimension(newFile,'theta',0);
    nc_add_dimension(newFile,'particle',0); % 0 means UNLIMITED dimension
    nc_add_dimension(newFile,'time',0);
    nc_add_dimension(newFile,'data',0);

    % Global params
    nc_attput(newFile,nc_global,'institution','CIGEFI - Universidad de Costa Rica');
    nc_attput(newFile,nc_global,'date',char(datetime('today')));
    nc_attput(newFile,nc_global,'contact','Roberto Villegas D: roberto.villegas@ucr.ac.cr');

    % Adding file variables
    data.Name = 'data';
    data.Dimension = {'lat','lon','h','qvi','theta'};
    nc_addvar(newFile,data);
    
    time.Name = 'time';
    time.Dimension = {'time'};
    nc_addvar(newFile,time);
    
    monthlyData.Name = var2Read;
    monthlyData.Datatype = 'single';
    monthlyData.Dimension = {'time','data','particle'};
    nc_addvar(newFile,monthlyData);

    particleData.Name = 'particle';
    particleData.Dimension = {'particle'};
    nc_addvar(newFile,particleData);

    latData.Name = 'lat';
    latData.Dimension = {'lat'};
    nc_addvar(newFile,latData);

    lonData.Name = 'lon';
    lonData.Dimension = {'lon'};
    nc_addvar(newFile,lonData);
    
    hData.Name = 'h';
    hData.Dimension = {'h'};
    nc_addvar(newFile,hData);
    
    qviData.Name = 'qvi';
    qviData.Dimension = {'qvi'};
    nc_addvar(newFile,qviData);
    
    thetaData.Name = 'theta';
    thetaData.Dimension = {'theta'};
    nc_addvar(newFile,thetaData);
end

function [out] = readFile(fileName,current_data)
    hour = java.lang.String(fileName);
    h = char(hour.substring(hour.lastIndexOf('-')+1,hour.lastIndexOf('.')));
    map = memmapfile(fileName,'Format',{'int32', 1, 'partid';'single',1,'lon';'single',1,'lat';'single',1,'h';'single',1,'qvi';'single',1,'theta';'int32',1,'day'});
    data = map.Data;
    if(isempty(current_data))
        ids = extractfield(data,'partid');
        out = [];
    else
        c = extractfield(current_data,'partid');
        d = extractfield(data,'partid');
        ids = cat(2,c,d);
        out = current_data;
    end
    for i=1:1:length(data)
        if(mod(i,50000)==0)
            fprintf('Steps %d of %d\n',i,length(data));
            %disp(strcat('Steps ',num2str(length(data)-i),' of ',));
        end
        if(isempty(out))
            out(i).partid = data(i).partid;%#ok<AGROW>
            %out(i).partid(1) = data(i).partid;
            out(i).lon(1) = data(i).lon;%#ok<AGROW>
            out(i).lat(1) = data(i).lat;%#ok<AGROW>
            out(i).h(1) = data(i).h;%#ok<AGROW>
            out(i).qvi(1) = data(i).qvi;%#ok<AGROW>
            out(i).theta(1) = data(i).theta;%#ok<AGROW>
            out(i).day(1) = data(i).day;%#ok<AGROW>
            out(i).hour(1) = str2num(h);%#ok<AGROW>
        else
            k = find(ids==data(i).partid);
            if(length(k)>1&&k(1)<length(out))%~isEmpty(k)
                k = k(1);
                %out(k).partid(end+1) = data(i).partid;
                out(k).lon(end+1) = data(i).lon;%#ok<AGROW>
                out(k).lat(end+1) = data(i).lat;%#ok<AGROW>
                out(k).h(end+1) = data(i).h;%#ok<AGROW>
                out(k).qvi(end+1) = data(i).qvi;%#ok<AGROW>
                out(k).theta(end+1) = data(i).theta;%#ok<AGROW>
                out(k).day(end+1) = data(i).day;%#ok<AGROW>
                out(k).hour(end+1) = str2num(h);%#ok<AGROW>
            else
                r = length(out) + 1;
                out(r).partid = data(i).partid;%#ok<AGROW>
                %out(r).partid(1) = data(i).partid;
                out(r).lon(1) = data(i).lon;%#ok<AGROW>
                out(r).lat(1) = data(i).lat;%#ok<AGROW>
                out(r).h(1) = data(i).h;%#ok<AGROW>
                out(r).qvi(1) = data(i).qvi;%#ok<AGROW>
                out(r).theta(1) = data(i).theta;%#ok<AGROW>
                out(r).day(1) = data(i).day;%#ok<AGROW>
                out(r).hour(1) = str2num(h);%#ok<AGROW>
            end
        end
    end
    disp(strcat('File saved:  ',fileName));
end

function [out] = rearrangeData(parti,days,hours)
    out = NaN(248,5);
    keys =   {0,3,6,9,12,15,18,21};
    vals = [0,1,2,3,4,5,6,7];
    map = containers.Map(keys,vals);
    for k=1:1:length(parti(:,1))
        pos = (days(k)-1)*8 + map(hours(k)) + 1;
        out(pos,:) = parti(k,:)';
    end
end