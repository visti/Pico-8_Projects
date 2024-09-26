function update_square_by_number(number)
    for i, sq in ipairs(squares) do
        if sq.number == number then
            -- Update the square's properties
            --sq.color = new_color
            --sq.text_color = new_textcolor
            sq.show_number = true
            sq.selected = true
            return
        end
    end

end

function draw_tokens()
    local x = 1
    local start_y = 114
    local spacing = 10
    
    for i = 0, spending_tokens -1 do
        local y = start_y - i * spacing
        spr(1, x, y)
    end
end

function get_number_of_marked_squares()
    local count = 0
    for sq in all(squares) do
        if sq.marked then
            count += 1
        end
    end
    return count  -- Return nil if not found
end


function get_square_by_number(number)
    for _, sq in ipairs(squares) do
        if sq.number == number then
            return sq
        end
    end
    return nil  -- Return nil if not found
end

function get_sum_of_marked_squares()
    local sum = 0
    for sq in all(squares) do
        if sq.marked then
            sum = sum + sq.number  -- or any other property you'd like to sum
        end
    end
    return sum
end

function draw_menu()
    local x = 21
    local y = 70  -- Adjusted to display the menu higher
    local w = x + 101
    local h = y + #menu_options * 8  -- Height based on the number of options

    -- Draw menu background
    rectfill(x - 1, y - 1, w + 1, h + 1, 6)
    rectfill(x, y, w, h, 3)

    -- Loop over menu options
    for i, option in ipairs(menu_options) do
        local option_y = y + (i - 1) * 8  -- Adjust spacing between options
        local color = 7  -- Default text color

        -- Highlight the selected option
        if i == menu_selected_option then
            rectfill(x + 1, option_y, w - 1, option_y + 7, 5)  -- Highlight background
            color = 0  -- Black text on highlight
        end

        -- Draw option text
        print(option.text, x + 1, option_y + 1, color)

        -- Draw cost in tokens
        for t = 1, option.cost do
            local token_x = w - 8 - (t - 1) * 6
            spr(1, token_x, option_y)
        end
    end
end

function update_menu()
    -- Navigate menu options
    if btnp(⬆️) then
        menu_selected_option -= 1
        if menu_selected_option < 1 then
            menu_selected_option = #menu_options  -- Wrap around to last option
        end
    elseif btnp(⬇️) then
        menu_selected_option += 1
        if menu_selected_option > #menu_options then
            menu_selected_option = 1  -- Wrap around to first option
        end
    end

    -- Confirm selection
    if btnp(❎) then  -- ❎ is the confirm button (Z key)
        local selected_option = menu_options[menu_selected_option]
        if spending_tokens >= selected_option.cost then
            -- Deduct tokens
            spending_tokens -= selected_option.cost
            -- Execute the option's action
            selected_option.action()
            -- Close the menu
            game_paused = false
        else
            -- Not enough tokens
            sfx(0)  -- Play a sound to indicate failure
            message = "Not enough tokens!"
            message_timer = 60
        end
    end

end


function grant_tokens()
    local new_marked_squares = 0
    for sq in all(squares) do
        if sq.marked and not sq.token_granted then
            new_marked_squares += 1
        end
    end

    -- Calculate how many tokens to grant
    local tokens_to_grant = flr(new_marked_squares / 4)

    if tokens_to_grant > 0 then
        spending_tokens += tokens_to_grant

        -- Mark squares as having contributed to tokens
        local tokens_contributed = 0
        for sq in all(squares) do
            if sq.marked and not sq.token_granted then
                sq.token_granted = true
                tokens_contributed += 1
                if tokens_contributed >= tokens_to_grant * 4 then
                    break
                end
            end
        end

    -- Optional: Play a sound or show a message when tokens are granted
        sfx(7)  -- Assuming sfx(7) is a token grant sound
        message = "you gained " .. tokens_to_grant .. " token(s)!"
        message_timer = 60  -- Display message for 1 second
    end
    
end