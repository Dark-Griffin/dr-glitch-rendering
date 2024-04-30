
def sprite_glitch(args, originalSpriteHash)
    # render glitched sprite using original sprite coordinates by rendering only chopped parts of the sprite in the square.
    divisions_for_x = 4
    divisions_for_y = 4
    #array of glitched sprite hashes to make chunks of sprite
    glitched_sprites = []
    divisions_for_x.times do |x|
        divisions_for_y.times do |y|
            #get an x and y for a chunked part of the original sprite unique to each chunk we will draw, this is where the chunk should draw
            #random_x_offset = x * (originalSpriteHash[:w] / divisions_for_x)
            #random_y_offset = y * (originalSpriteHash[:h] / divisions_for_y)
            #get a randomized "chunk coordinate" to draw inside this real location chunk
            random_x_chunk_mapped = rand(4) * (originalSpriteHash[:w] / divisions_for_x)
            random_y_chunk_mapped = rand(4) * (originalSpriteHash[:h] / divisions_for_y)
            #calculate width and height of a chunk
            width = originalSpriteHash[:w] / divisions_for_x
            height = originalSpriteHash[:h] / divisions_for_y
            #add a new sprite hash that is a glitched output
            glitched_sprites << {
                #draw at real location of chunk, but inverted position along x and y axis of sprite (so top is bottom, left is right, to emphisize glitch effect)
                x: originalSpriteHash[:x] + (width * (divisions_for_x - x - 1)),
                y: originalSpriteHash[:y] + (height * (divisions_for_y - y - 1)),
                #use our calculated width and height for the chunk
                w: width,
                h: height,
                #use the random chunk coordinates as a tiled chunk from the original sprite image to fill the chunk
                tile_x: random_x_chunk_mapped,
                tile_y: random_y_chunk_mapped,
                tile_w: width,
                tile_h: height,
                path: originalSpriteHash[:path],
                angle: originalSpriteHash[:angle]
                #angle: 0
                #angle: originalSpriteHash[:angle] + 180
            }
        end
    end
    #render all the glitched sprites to the screen
    args.outputs.sprites << glitched_sprites
end