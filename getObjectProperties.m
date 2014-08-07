function cl_out = getObjectProperties(obj)
%the key to this solution - a metaclass describing the properties
mc = metaclass(obj);

% create a property struct with values to use in a table
ii = 0;
numb_props = length(mc.PropertyList);
cl_array = struct;

% For each property, check the value of the queried attribute
for  c = 1:numb_props
    
    % Get a meta.property object from the meta.class object
    mp = mc.PropertyList(c);
    
    %get the property value from the object
    attrValue = obj.(mp.Name);
    
    % If the attribute is set or has the specified value,
    % save its name in cell array
    if (~isempty(attrValue))
        %counter of cell array values
        ii = ii + 1;
        cl_array.(mp.Name) = 1;
        
        if(isa(attrValue,'TrialFrame'))
            cl_array.(mp.Name) = {attrValue.name};
        else
            cl_array.(mp.Name) = {attrValue};
        end
    end
end
% Return used portion of array
cl_out = cl_array
end