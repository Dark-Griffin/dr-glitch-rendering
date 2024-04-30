
def sprite_glitch(args, originalSpriteHash)
    # render glitched sprite using original sprite coordinates by rendering only chopped parts of the sprite in the square.
    divisions_for_x = 4
    divisions_for_y = 4
    #array of glitched sprite hashes to make chunks of sprite
    glitched_sprites = []
    divisions_for_x.times do |x|
        divisions_for_y.times do |y|
            #get an x and y for a chunked part of the original sprite unique to each chunk we will draw
            random_x_offset = x * (originalSpriteHash[:w] / divisions_for_x)
            random_y_offset = y * (originalSpriteHash[:h] / divisions_for_y)
            #now get a randomized chunk coordinate to draw inside that chunk
            random_x_chunk_mapped = rand(4) * (originalSpriteHash[:w] / divisions_for_x)
            random_y_chunk_mapped = rand(4) * (originalSpriteHash[:h] / divisions_for_y)
            #random_x_offset = rand(originalSpriteHash[:w])
            #random_y_offset = rand(originalSpriteHash[:h])
            width = originalSpriteHash[:w] / divisions_for_x
            height = originalSpriteHash[:h] / divisions_for_y
            #add a new sprite hash that is a glitched output
            glitched_sprites << {
                x: originalSpriteHash[:x] + (width * (divisions_for_x - x - 1)),
                y: originalSpriteHash[:y] + (height * (divisions_for_y - y - 1)),
                w: width,
                h: height,
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