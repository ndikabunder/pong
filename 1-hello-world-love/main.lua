-- Ukuran layar
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Fungsi pertama yang jalan saat game mulai
function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

-- Fungsi digunakan untuk meletakkan gambar
function love.draw()
    love.graphics.printf(
        'Hello Pong',          -- 'Text yang akan ditampilkan'
        0,                     -- 'Dimulai X (0)'
        WINDOW_HEIGHT / 2 - 6, -- 'Dimulai Y (Meletakkan ditengah layar)'
        WINDOW_WIDTH,          -- 'Jumlah pixel meletakkan lebar'
        'center'               -- 'align mode (center, right, left)'
    )
end
