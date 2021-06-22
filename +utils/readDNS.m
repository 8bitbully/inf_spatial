function [inverse, forward, params] = readDNS(dns_file)
    if ~strcmpi(dns_file(end-3:end), '.dns')
        warning('lütfen .dns uzantılı dosya giriniz.');
        return
    end
    
    content = zeros(100, 6);
    
    fileID = fopen(dns_file, 'r');
    counter = 1;
    while ~feof(fileID)
        tline = fgets(fileID);
        getVec = stringLineConverter(tline);
        if ~isnan(getVec)
            content(counter, 1:length(getVec)) = getVec;
            counter = counter + 1;
        end
    end

    fclose(fileID);
    
    params = content(1, :);
    
    content(1, :) = [];
    content(content == 0) = [];
    content = reshape(content, [], 4);

    inverse = content(:, 1:2);
    forward = content(:, 3:4);
end

function retVec = stringLineConverter(content)
    getMat = regexp(content, ' ', 'split');
    getMat = cellfun(@str2double, getMat);
    
    if any(~isnan(getMat))
        idx = isnan(getMat);
        getMat(idx) = [];
    end
    retVec = getMat;
end