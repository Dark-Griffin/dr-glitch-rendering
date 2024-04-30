
def sprite_glitch(args, originalSpriteHash)
    # render glitched sprite using original sprite coordinates by rendering only chopped parts of the sprite in the square.
    divisions_for_x = 2
    divisions_for_y = 2
    #array of glitched sprite hashes to make chunks of sprite
    glitched_sprites = []
    divisions_for_x.times do |x|
        divisions_for_y.times do |y|
            #randomize the x and y of the part of the image we will use for this glitch chunk.
            random_x_offset = rand(originalSpriteHash[:w])
            random_y_offset = rand(originalSpriteHash[:h])
            width = originalSpriteHash[:w] / divisions_for_x
            height = originalSpriteHash[:h] / divisions_for_y
            random_x_addition = rand(width - divisions_for_x)
            random_y_addition = rand(height - divisions_for_y)
            #add a new sprite hash that is a glitched output
            glitched_sprites << {
                x: originalSpriteHash[:x] + random_x_offset,
                y: originalSpriteHash[:y] + random_y_offset,
                w: width,
                h: height,
                tile_x: x * width + random_x_addition,
                tile_y: y * height + random_y_addition,
                path: originalSpriteHash[:path],
                angle: originalSpriteHash[:angle]
            }
        end
    end
    #render all the glitched sprites to the screen
    args.outputs.sprites << glitched_sprites
end