push = require '3-kotak-player.push' --require the library

-- Ukuran layar
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Ukuran layar virtual
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Fungsi pertama yang jalan saat game mulai
function love.load()
    -- filtering on upscaling or downscaling
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Mengaplikasikan virtual resolusi dan tetap dalam ukuran layar semula
    -- Mengganti love.window.setMode
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    --     fullscreen = false,
    --     resizable = false,
    --     vsync = true
    -- })
end

--[[
    Fungsi keybord handling saat menekan keybord
]]
function love.keypressed(key)
    -- key dapat dijalankan dengan menggunakan string name
    if key == 'escape' then
        -- functions ini dapat memerikan perintah untuk menutup apliasi
        love.event.quit()
    end
end

-- Fungsi digunakan untuk meletakkan gambar
function love.draw()
    -- Mulai menampilankan virtual resolusi
    push:apply('start')

    -- Menggunakan 1 line untuk menggunakan virtual resolusi
    love.graphics.printf('Hello World', 0, VIRTUAL_HEIGHT / 2 - 6, VIRTUAL_WIDTH, 'center')

    -- Menghentikan menampilankan virtual resolusi
    push:apply('end')

    -- love.graphics.printf(
    --     'Hello Pong',          -- 'Text yang akan ditampilkan'
    --     0,                     -- 'Dimulai X (0)'
    --     WINDOW_HEIGHT / 2 - 6, -- 'Dimulai Y (Meletakkan ditengah layar)'
    --     WINDOW_WIDTH,          -- 'Jumlah pixel meletakkan lebar'
    --     'center'               -- 'align mode (center, right, left)'
    -- )
end
