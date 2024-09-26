function make_grid()
    for c=2, 9 do
        for i=2, 9 do
            add(squares, square:new({x=square.width*i, y=square.height*c, fill=4}))
        end
    end
end
