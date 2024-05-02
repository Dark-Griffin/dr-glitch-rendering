
def sprite_glitch(args, originalSpriteHash, delay=10, divisions_for_x=4, divisions_for_y=4)
    # render glitched sprite using original sprite coordinates by rendering only chopped parts of the sprite in the square.
    divisions_for_x = 4
    divisions_for_y = 4
    #delay of reshuffle
    #delay = 10 # in frames to display each shuffle before redoing it.
    #array of glitched sprite hashes to make chunks of sprite
    glitched_sprites = []

    #if there is no glitched_sprites lookup hash, create one
    if args.state.glitched_sprites.nil?
        args.state.glitched_sprites = {}
    end

    #if we do not have a glitched sprite for this sprite yet, or if the timer value is 0, we need to create a new glitched sprite lookup table
    if args.state.glitched_sprites[originalSpriteHash[:path]].nil? || args.state.glitched_sprites[originalSpriteHash[:path]][:timer] <= 0
        #create a new glitched sprite lookup table
        args.state.glitched_sprites[originalSpriteHash[:path]] = {
            coordinates: create_division_array_coordinates(args, divisions_for_x, divisions_for_y, originalSpriteHash),
            timer: delay
        }
    end

    args.state.glitched_sprites[originalSpriteHash[:path]].coordinates.each do |coordinate|
        #iterate and draw all chunks to screen
        glitched_sprites << {
            x: coordinate[:x] + originalSpriteHash[:x],
            y: coordinate[:y] + originalSpriteHash[:y],
            w: coordinate[:w],
            h: coordinate[:h],
            tile_x: coordinate[:mapped_x],
            tile_y: coordinate[:mapped_y],
            tile_w: coordinate[:w],
            tile_h: coordinate[:h],
            path: originalSpriteHash[:path],
            angle: originalSpriteHash[:angle]
        }
    end


    #decrement the timer for the glitched sprite hash
    args.state.glitched_sprites[originalSpriteHash[:path]][:timer] -= 1

    #render all the glitched sprites to the screen
    args.outputs.sprites << glitched_sprites
end

def create_division_array_coordinates(args, divisions_for_x, divisions_for_y, originalSpriteHash)
    coordinates = []
    #calculate width and height of a chunk
    width = originalSpriteHash[:w] / divisions_for_x
    height = originalSpriteHash[:h] / divisions_for_y

    divisions_for_x.times do |x|
        divisions_for_y.times do |y|
            #build a regular array of chunk locations to be scrambled
            coordinates << { 
                x: (originalSpriteHash[:w] / divisions_for_x) * x, 
                y: (originalSpriteHash[:h] / divisions_for_y) * y,
                w: width,
                h: height,
                #note to self: this needs to be replaced so that each chunk always has a unique x and y from another chunk in the list.
                # most likely I need a second pass that builds a new array with the mapped_x and mapped_y values chosen off a deck list of available values, so that as it goes each value is consumed off the deck list.
                mapped_x: x * (originalSpriteHash[:w] / divisions_for_x),
                mapped_y: y * (originalSpriteHash[:h] / divisions_for_y)
            }
        end
    end

    #create a deck to pull mapped_x and y values from in order to avoid duplicate randoms
    deck = []
    #add all coordinate mapped_x and mapped_y value pairs to the deck
    coordinates.each do |coordinate|
        deck << { x: coordinate[:mapped_x], y: coordinate[:mapped_y] }
    end
    #now for each coordinate, pick one from the deck at random and overwrite the mapped_x and mapped_y values
    coordinates.each do |coordinate|
        #pick a random value from the deck
        random_deck_index = rand(deck.length)
        #overwrite the mapped_x and mapped_y values with the random value from the deck
        coordinate[:mapped_x] = deck[random_deck_index][:x]
        coordinate[:mapped_y] = deck[random_deck_index][:y]
        #remove the value from the deck so it cannot be picked again
        deck.delete_at(random_deck_index)
    end

    #now we can return the scrambled coordinates
    return coordinates
end