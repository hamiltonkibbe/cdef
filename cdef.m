function  cdef( variable, varargin)
    %CDEF Print values of array as a C header constant definition
    %   CDEF(x) Generates a header file definition of variable x
    %   CDEF(x, 'precision', 'double')   Use double precision.
    %   CDEF(x, 'filename', 'headerfile.h') Write definition to headerfile.h
    %
    
    % Configure Arguments
    p = inputParser;
    addRequired(p, 'variable');
    addParameter(p, 'VarName', inputname(1), @isstr);
    addParameter(p, 'precision', 'single', ...
        @(x) any(validatestring(x, {'single', 'double'})));
    addParameter(p, 'ExportLength', false);
    addParameter(p, 'LengthName', '');
    addParameter(p, 'filename', '');
    addParameter(p, 'static', true);
    addParameter(p, 'pack', true);
    
    parse(p, variable, varargin{:});
    
    % Convenience handles
    precision = p.Results.precision;
    name = p.Results.VarName;
    export_length = p.Results.ExportLength;
    length_name = p.Results.LengthName;
    filename = p.Results.filename;
    write_file = ~strcmp(filename, '');
    
    if strcmp(precision, 'single')
        variable = single(variable);
        typestr = 'float';
        fmtstr = '%1.10gf';
    else
        typestr = 'double';
        fmtstr = '%1.19g';
    end
    
    
    %Get name for length variable
    if strcmp(length_name, '')
        length_name = strcat(name, 'Length');
    end
    
    %static declaration
    if p.Results.static
        prefix = 'static const';
    else
        prefix = 'const';
    end
    
    % Write data values
    values = '';
    line = '    ';
    extra = false;
    for i=1:length(variable)
        if ~p.Results.pack
            if i ~= length(variable)
                fmt = sprintf('    %s,\n', fmtstr);
            else
                fmt = sprintf('    %s\n', fmtstr);
            end
            values = [values sprintf(fmt, variable(i))];
        else
            if i ~= length(variable)
                fmt = sprintf('%s, ', fmtstr);
            else
                fmt = sprintf('%s', fmtstr);
            end
            
            valstr = sprintf(fmt, variable(i));
            if ((length(valstr) + length(line)) <= 79)
                line = [line valstr];
                extra = true;
            else
                values = sprintf('%s%s\n', values, line);
                line = ['    ' valstr];
                extra = false;
            end
        end
    end
    
    if extra
        values = sprintf('%s%s\n', values, line);
    end
    
    
    % Create the definition string
    def = '';
   
    % Write length declaration
    if export_length
        def = [def sprintf('%s unsigned %s = %d;\n\n',...
                prefix, length_name, length(variable))];
    end

    % Write variable declaration
    if export_length
        def = [def sprintf('%s %s %s[%s] =\n{\n%s};\n\n', ...
            prefix, typestr, name, length_name, values)];
    else 
        def = [def sprintf('%s %s %s[%d] =\n{\n%s};\n\n', ...
            prefix, typestr, name, length(variable), values)];
    end
    
    if write_file
        f = fopen(filename, 'w');
        ig_name = upper(strrep(filename, '.', '_'));
        
        fprintf(f, '/* %s\n * Generated by Matlab on %s\n */\n\n', ... 
            filename, datestr(now));
        
        fprintf(f, '#ifndef %s\n#define %s\n\n', ig_name, ig_name);
        fprintf(f, '#ifdef __cplusplus\nextern "C" {\n#endif\n\n');
        fprintf(f, '%s\n', def);
        fprintf(f, '#ifdef __cplusplus\n}\n#endif\n\n');
        fprintf(f, '#endif /* %s */\n\n', ig_name);
        fclose(f);
    else
        fprintf(def);
    end
end

