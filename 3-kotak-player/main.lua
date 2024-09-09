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

    -- Memanggil font untuk dipakai didalam game (nama font dan ukuran font)
    smallfont = love.graphics.newFont('font.ttf', 8)

    -- Menjalankan font menjadikan smallfont object
    love.graphics.setFont(smallfont)

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

    -- Membersihkan tampilan dengan menampilankan warna sesuai keinginan
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    -- Menggunakan 1 line untuk menggunakan virtual resolusi
    love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

    -- Menampilkan kotak player pertama (Pemain Kiri)
    love.graphics.rectangle('fill', 10, 30, 5, 20)

    -- Menampilkan kotak player kedua (Pemain Kanan)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, 5, 20)

    -- Menampilkan bola
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

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
