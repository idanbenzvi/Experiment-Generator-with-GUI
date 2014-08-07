% in_shape.m
%
% a function which takes the x & y coordinates of the mouse and the
% rectangle of shape and checks if the mouse is inside the shape

function is_in = in_shape(rect, mouse_x, mouse_y)
    if (mouse_x > rect(1) && mouse_y > rect(2) && ...
         mouse_x < rect(3) && mouse_y < rect(4))
        is_in = 1;
    else
        is_in = 0;
    end
end