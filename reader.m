% Function reader
%
% Prototype: reader(fileName)
%
% dirName = Path of the directory that contents the files
function [out] = reader(fileName)
    if nargin < 1
        error('dataProcessingEOF: dirName is a required input')
    end
    d = dir(fileName);
    if(d.bytes>0)
        map = memmapfile(fileName,'Format',{'int32', 1, 'partid';'single',1,'lon';'single',1,'lat';'single',1,'h';'single',1,'qvi';'single',1,'theta';'int32',1,'day'});
        out = map.Data;
        %ids = unique(extractfield(out,'partid'));
    else
        disp('No hay datos');
    end
end