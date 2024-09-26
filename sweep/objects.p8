sq_no = 0

square = {
    x = 15,
    y = 15,
    width = 12,
    height = 12,
    color = 8,
    selected = false,
    show_number = true,  -- Renamed for clarity
    fill = 3,
    text_color=10,
    bombs=false,
    exploded=false,
    marked=false,
    number = sq_no,  -- Default value, though it will be updated in the constructor

    new = function(self, tbl)
        tbl = tbl or {}
        setmetatable(tbl, { __index = self })
        
        -- Increment the global sq_no and assign it to the new square
        sq_no = sq_no + 1
        tbl.number = sq_no

        tbl.revealed = false
        
        return tbl
    end,

    update = function(self)
        -- If the ❎ button is pressed, mark the square as selected
        if btn(❎) then 
            self.selected = true 
        else 
            self.selected = false 
        end

    end,

    draw = function(self)
        -- Display the number if it's a revealed safe square
        if self.revealed and not self.bomb then
            rectfill(self.x+0, self.y+1, self.x + self.width-1, self.y + self.height-1, 5)  -- Different color for revealed squares
            print(self.number, self.x + 1, self.y + 2, 7)
        end 

        if self.marked then 
            rectfill(self.x+1, self.y+1, self.x + self.width-1, self.y + self.height-1, 2)
            print(self.number, self.x + 2, self.y + 2, self.text_color+1) 
        end

        if self.number == selected_square then
            -- Highlight the selected square (e.g., with a different fill color)
            rectfill(self.x+1, self.y+1, self.x + self.width-1, self.y + self.height-1, self.fill)
            print(self.number, self.x + 2, self.y + 2, self.text_color)
            rect(self.x, self.y, self.x + self.width, self.y + self.height, self.color)
        else
            -- Draw non-selected squares
            rect(self.x, self.y, self.x + self.width, self.y + self.height, self.color)
        end

        -- For debugging: print "X" if the square is a bomb
        if self.bomb then
            -- print("X", self.x + 3, self.y + 3, 8)  -- Adjust position as needed
        end
        if self.exploded then
            print("O", self.x + 3, self.y + 3, 9)  -- Adjust position as needed
        end
        
        -- Display the bomb if it's revealed
        if self.bomb and self.revealed then
            print("X", self.x + 3, self.y + 3, 8)  -- Adjust position and color as needed
        end

               

        
    end
}
