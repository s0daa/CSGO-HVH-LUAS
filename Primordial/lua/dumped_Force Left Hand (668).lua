local lefthand = cvars.cl_righthand
function setleft()
    lefthand:set_int(0)
end
callbacks.add(e_callbacks.NET_UPDATE, setleft)