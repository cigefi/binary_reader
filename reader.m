function [out] = reader(fileName)
    %map = memmapfile(fileName);
    map = memmapfile(fileName,'Format',{'int32', 1, 'partid';'single',1,'lon';'single',1,'lat';'single',1,'h';'single',1,'qvi';'single',1,'theta';'int32',1,'day'});
    out = map.Data;
    %out = reshape(memmapfile(fileName).Data,7,[])';
    %out = squeeze(out(1,:,:));
    
    %extra   
    path = java.lang.String(fileName);
    i = path.lastIndexOf('/');
    j = path.lastIndexOf('.');
    if(i<0)
        i = path.lastIndexOf('\');
    end
    newName = strcat(char(path.substring(0,j+1)),'nc');
    var2Read = char(path.substring(i+1,j));
    configure_netcdf(newName,var2Read)
end

function configure_netcdf(newFile,var2Read)
    nc_create_empty(newFile,'netcdf4');

    % Adding file dimensions
    nc_add_dimension(newFile,'lat',1);
    nc_add_dimension(newFile,'lon',1);
    nc_add_dimension(newFile,'h',1);
    nc_add_dimension(newFile,'qvi',1);
    nc_add_dimension(newFile,'theta',1);
    nc_add_dimension(newFile,'particle',0); % 0 means UNLIMITED dimension
    nc_add_dimension(newFile,'step',80);

    % Global params
    nc_attput(newFile,nc_global,'institution','CIGEFI - Universidad de Costa Rica');
    nc_attput(newFile,nc_global,'date',char(datetime('today')));
    nc_attput(newFile,nc_global,'contact','Roberto Villegas D: roberto.villegas@ucr.ac.cr');

    % Adding file variables
    stepData.Name = 'step';
    stepData.Dimension = {'lat','lon','h','qvi','theta'};
    nc_addvar(newFile,stepData);
    
    monthlyData.Name = var2Read;
    monthlyData.Datatype = 'single';
    monthlyData.Dimension = {'particle','step'};
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