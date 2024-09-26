
function control()
    if game_paused then
        return
    end

    local grid_width = 8  -- Adjust if your grid size changes
    local grid_height = 8

    local col = ((selected_square - 1) % grid_width) + 1
    local row = flr((selected_square - 1) / grid_width) + 1

    if btnp(⬅️) and col > 1 then
        selected_square = selected_square - 1
        sfx(4)
    end
    if btnp(➡️) and col < grid_width then
        selected_square = selected_square + 1
        sfx(4)
    end
    if btnp(⬆️) and row > 1 then
        selected_square = selected_square - grid_width
        sfx(4)
    end
    if btnp(⬇️) and row < grid_height then
        selected_square = selected_square + grid_width
        sfx(4)
    end

    local sq=squares[selected_square]
    if sq then
        if btnp(❎) then
            if sq.marked then
                sq.marked = false
                sfx(2)
                -- Optional: Reset token_granted if you want tokens to be adjusted
                -- sq.token_granted = false
            else
                sq.marked = true
                sfx(1)
                -- After marking, check if we need to grant tokens
                grant_tokens()
            end
        end
    end
        end

-- Define the menu options

menu_options = {
    {
        text = "REVEAL 2 BOMBS",
        cost = 1,
        action = function()
            -- Find unrevealed bombs
            local unrevealed_bombs = {}
            for sq in all(squares) do
                if sq.bomb and not sq.revealed then
                    add(unrevealed_bombs, sq)
                end
            end

            -- Reveal up to two bombs
            local bombs_to_reveal = min(2, #unrevealed_bombs)
            for i = 1, bombs_to_reveal do
                local index = flr(rnd(#unrevealed_bombs)) + 1
                local bomb_square = unrevealed_bombs[index]
                bomb_square.revealed = true
                del(unrevealed_bombs, bomb_square)
            end

            sfx(1)  -- Play a sound effect
            message = "Revealed " .. bombs_to_reveal .. " bomb(s)!"
            message_timer = 120  -- Display message for 2 seconds
        end
    },
    {
        text = "REVEAL NO BOMB ROW",
        cost = 2,
        action = function()
            -- Find rows without bombs
            local grid_width = 8  -- Adjust based on your grid dimensions
            local grid_height = 8

            local rows_without_bombs = {}
            for row = 1, grid_height do
                local has_bomb = false
                for col = 1, grid_width do
                    local index = (row - 1) * grid_width + col
                    local sq = squares[index]
                    if sq.bomb then
                        has_bomb = true
                        break
                    end
                end
                if not has_bomb then
                    add(rows_without_bombs, row)
                end
            end

            if #rows_without_bombs > 0 then
                -- Reveal a random row without bombs
                local selected_row = rows_without_bombs[flr(rnd(#rows_without_bombs)) + 1]

                -- Reveal all squares in that row
                for col = 1, grid_width do
                    local index = (selected_row - 1) * grid_width + col
                    local sq = squares[index]
                    sq.revealed = true
                end

                sfx(2)  -- Play a sound effect
                message = "Revealed row " .. selected_row .. "!"
                message_timer = 120
            else
                sfx(6)  -- Error sound
                message = "No bomb-free row!"
                message_timer = 120
            end
        end
    },
    {
    text = "REVEAL GOAL DIFF",
    cost = 3,
    action = function()
        -- Calculate the sum and difference at the time of purchase
        sum_at_purchase = get_sum_of_marked_squares()
        goal_difference = abs(goal - sum_at_purchase)
        goal_diff_revealed = true  -- Set flag to true

        sfx(3)  -- Play a sound effect
        message = "Goal difference revealed!"
        message_timer = 120  -- Display message for 2 seconds
    end
    }



    }



function menu()


end