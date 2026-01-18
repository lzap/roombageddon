---@meta
--- TIC-80 API definitions - generated using AI

--- Main game loop callback, called 60 times per second.
function TIC() end

--- Called once when the cartridge starts.
function BOOT() end

--- Called before drawing each scanline for border effects.
---@param row number Scanline number.
function BDR(row) end

--- Called after frame draw for overlay effects.
function OVR() end

--- Handles game menu interactions.
---@param index number Menu item index.
function MENU(index) end

--- Prints text to the screen using the system font.
---@param text string The string to print.
---@param x number X coordinate.
---@param y number Y coordinate.
---@param color? number Color index (0-15). Default is 15.
---@param fixed? boolean Use fixed width characters.
---@param scale? number Text scaling factor.
---@param alt? boolean Use alternative system font.
---@return number width Returns the width of the printed text in pixels.
function print(text, x, y, color, fixed, scale, alt) end

--- Clears the screen with a specific color.
---@param color? number Color index (0-15). Default is 0.
function cls(color) end

--- Draws a sprite from the sprite bank.
---@param id number Sprite index (0-511).
---@param x number X coordinate.
---@param y number Y coordinate.
---@param colorkey? number|table Color index (or table of indices) to be treated as transparent. Use -1 for no transparency.
---@param scale? number Sprite scaling factor.
---@param flip? number Flip mode: 0:none, 1:horiz, 2:vert, 3:both.
---@param rotate? number Rotation mode: 0:none, 1:90°, 2:180°, 3:270°.
---@param w? number Width in number of sprites (default 1).
---@param h? number Height in number of sprites (default 1).
function spr(id, x, y, colorkey, scale, flip, rotate, w, h) end

--- Draws a map or a portion of it.
---@param x? number Map X coordinate (in tiles, default 0).
---@param y? number Map Y coordinate (in tiles, default 0).
---@param w? number Width of the map portion (in tiles, default 30).
---@param h? number Height of the map portion (in tiles, default 17).
---@param sx? number Screen X coordinate (in pixels, default 0).
---@param sy? number Screen Y coordinate (in pixels, default 0).
---@param colorkey? number|table Transparent color index.
---@param scale? number Scaling factor (default 1).
---@param remap? function Callback function for dynamic tile remapping.
function map(x, y, w, h, sx, sy, colorkey, scale, remap) end

--- Checks if a gamepad button is currently pressed.
---@param id number Button ID (0:Up, 1:Down, 2:Left, 3:Right, 4:A, 5:B, 6:X, 7:Y).
---@return boolean pressed True if the button is down.
function btn(id) end

--- Checks if a gamepad button was just pressed in the current frame.
---@param id number Button ID (0-7).
---@param hold? number Frames to wait before starting repeats.
---@param period? number Frames between repeats.
---@return boolean pressed
function btnp(id, hold, period) end

--- Checks if a keyboard key is currently pressed.
---@param code number Key code.
---@return boolean pressed
function key(code) end

--- Checks if a keyboard key was just pressed.
---@param code number Key code.
---@param hold? number Frames to wait before starting repeats.
---@param period? number Frames between repeats.
---@return boolean pressed
function keyp(code, hold, period) end

--- Draws a filled rectangle.
---@param x number X coordinate.
---@param y number Y coordinate.
---@param w number Width.
---@param h number Height.
---@param color number Color index (0-15).
function rect(x, y, w, h, color) end

--- Draws a rectangle border.
---@param x number
---@param y number
---@param w number
---@param h number
---@param color number
function rectb(x, y, w, h, color) end

--- Draws a line between two points.
---@param x0 number
---@param y0 number
---@param x1 number
---@param y1 number
---@param color number
function line(x0, y0, x1, y1, color) end

--- Draws a filled circle.
---@param x number Center X.
---@param y number Center Y.
---@param r number Radius.
---@param color number Color index.
function circ(x, y, r, color) end

--- Draws a circle border.
---@param x number Center X.
---@param y number Center Y.
---@param r number Radius.
---@param color number Color index.
function circb(x, y, r, color) end

--- Draws a filled ellipse.
---@param x number Center X.
---@param y number Center Y.
---@param a number Horizontal radius.
---@param b number Vertical radius.
---@param color number Color index.
function elli(x, y, a, b, color) end

--- Draws an ellipse border.
---@param x number Center X.
---@param y number Center Y.
---@param a number Horizontal radius.
---@param b number Vertical radius.
---@param color number Color index.
function ellib(x, y, a, b, color) end

--- Gets or sets a pixel color.
---@param x number X coordinate.
---@param y number Y coordinate.
---@param color? number Color index to set. If omitted, returns current color.
---@return number color Current pixel color if reading.
function pix(x, y, color) end

--- Draws text using custom font.
---@param text string Text to print.
---@param x number X coordinate.
---@param y number Y coordinate.
---@param chromakey? number Transparent color index.
---@param char_width? number Character width.
---@param char_height? number Character height.
---@param fixed? boolean Fixed width characters.
---@param scale? number Scaling factor.
---@param alt? boolean Use alternative font.
---@return number width Text width in pixels.
function font(text, x, y, chromakey, char_width, char_height, fixed, scale, alt) end

--- Sets the clipping rectangle.
---@param x? number X coordinate (default 0).
---@param y? number Y coordinate (default 0).
---@param w? number Width (default screen width).
---@param h? number Height (default screen height).
function clip(x, y, w, h) end

--- Reads from RAM.
---@param address number RAM address (0x0000 - 0x17FFF).
---@param bits? number Bit size: 1, 2, 4, or 8 (default 8).
---@return number value The value at the address.
function peek(address, bits) end

--- Writes to RAM.
---@param address number RAM address.
---@param value number The value to write.
---@param bits? number Bit size: 1, 2, 4, or 8 (default 8).
function poke(address, value, bits) end

--- Reads 1 bit from RAM.
---@param address number RAM address.
---@return number value Bit value (0 or 1).
function peek1(address) end

--- Writes 1 bit to RAM.
---@param address number RAM address.
---@param value number Bit value (0 or 1).
function poke1(address, value) end

--- Reads 2 bits from RAM.
---@param address number RAM address.
---@return number value Value (0-3).
function peek2(address) end

--- Writes 2 bits to RAM.
---@param address number RAM address.
---@param value number Value (0-3).
function poke2(address, value) end

--- Reads 4 bits from RAM.
---@param address number RAM address.
---@return number value Value (0-15).
function peek4(address) end

--- Writes 4 bits to RAM.
---@param address number RAM address.
---@param value number Value (0-15).
function poke4(address, value) end

--- Gets the tile ID at a specific map location.
---@param x number Map X tile coordinate (0-239).
---@param y number Map Y tile coordinate (0-135).
---@return number tile_id The ID of the tile.
function mget(x, y) end

--- Sets the tile ID at a specific map location.
---@param x number
---@param y number
---@param tile_id number
function mset(x, y, tile_id) end

--- Gets sprite flag value.
---@param sprite_id number Sprite index (0-511).
---@param flag number Flag index (0-7).
---@return boolean value Flag state.
function fget(sprite_id, flag) end

--- Sets sprite flag value.
---@param sprite_id number Sprite index (0-511).
---@param flag number Flag index (0-7).
---@param value boolean Flag state.
function fset(sprite_id, flag, value) end

--- Returns the current mouse status.
---@return number x, number y, boolean left, boolean middle, boolean right, number scrollx, number scrolly
function mouse() end

--- Plays a sound effect.
---@param id number SFX index (0-63).
---@param note? number Note (0-95) or frequency.
---@param duration? number Duration in ticks (-1 for infinite).
---@param channel? number Channel (0-3).
---@param volume? number Volume (0-15).
---@param speed? number Playback speed.
function sfx(id, note, duration, channel, volume, speed) end

--- Prints a debug message to the TIC-80 console.
---@param message any The message to log.
---@param color? number Console text color.
function trace(message, color) end

--- Returns the number of milliseconds passed since the game started.
---@return number time
function time() end

--- Returns UNIX timestamp.
---@return number timestamp Unix timestamp in seconds.
function tstamp() end

--- Reads or writes persistent memory (32-bit values).
---@param index number Slot index (0-255).
---@param value? number Value to write. If omitted, returns current value.
---@return number value Current value if reading.
function pmem(index, value) end

--- Copies a block of memory.
---@param dest number Destination RAM address.
---@param source number Source RAM address.
---@param size number Number of bytes to copy.
function memcpy(dest, source, size) end

--- Sets a block of memory to a specific value.
---@param dest number Destination RAM address.
---@param value number The byte value to set.
---@param size number Number of bytes to fill.
function memset(dest, value, size) end

--- Saves or restores memory banks.
---@param mask number Bank mask (0-7).
---@param bank? number Bank number (0-3).
---@param tocart? boolean If true, save to cart; if false, load from cart.
---@return number result Operation result.
function sync(mask, bank, tocart) end

--- Exits the cartridge and returns to console.
function exit() end

--- Resets the cartridge to boot state.
function reset() end

--- Plays music track.
---@param track number Track index (-1 to stop, 0-63 to play).
---@param frame? number Starting frame.
---@param row? number Starting row.
---@param loop? boolean Loop playback.
---@param sustain? boolean Sustain notes.
---@param tempo? number Tempo override.
---@param speed? number Speed override.
function music(track, frame, row, loop, sustain, tempo, speed) end