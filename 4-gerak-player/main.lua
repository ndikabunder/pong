push = require '3-kotak-player.push' --require the library

-- Ukuran layar
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Ukuran layar virtual
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Membuat variabel kecepeatan player untuk bergerak
PADDLE_SPEED = 200

-- Fungsi pertama yang jalan saat game mulai
function love.load()
    -- filtering on upscaling or downscaling
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- membuat variabel font untuk dipakai menampilankan nama game didalam game (nama font dan ukuran font)
    smallFont = love.graphics.newFont('font.ttf', 8) -- nama font dan ukuran font

    -- membuat variabel font untuk menampilankan skor
    scoreFont = love.graphics.newFont('font.ttf', 32) -- nama font dan ukuran font

    -- Menjalankan font menjadikan smallfont object
    love.graphics.setFont(smallFont)

    -- Mengaplikasikan virtual resolusi dan tetap dalam ukuran layar semula
    -- Mengganti love.window.setMode
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- Variabel skor untuk ditampilkan dilayar
    player1Score = 0
    player2Score = 0

    -- Menentukan posisi player berdasarkan sumbu Y
    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50

    -- love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    --     fullscreen = false,
    --     resizable = false,
    --     vsync = true
    -- })
end

function love.update(dt)
    -- Gerakan player pertama
    if love.keyboard.isDown('w') then
        -- Menambahkan negative speed ke sumbu Y agar gerak ke atas
        player1Y = player1Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('s') then
        -- Menambahkan positif speed ke sumbu Y agar gerak ke bawah
        player1Y = player1Y + PADDLE_SPEED * dt
    end

    -- Gerakan player kedua
    if love.keyboard.isDown('up') then
        -- Menambahkan negative speed ke sumbu Y agar gerak ke atas
        player2Y = player2Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('down') then
        -- Menambahkan positif speed ke sumbu Y agar gerak ke bawah
        player2Y = player2Y + PADDLE_SPEED * dt
    end
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
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255) -- Warana rgb dan transparansi

    -- Menggunakan font yang sudah dipanggil untuk nama game
    love.graphics.setFont(smallFont)

    -- Menampilkan nama game, memposisikan nama game di layar dan menggunakan font yang sudah disiapkan (smallfont)
    love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center') -- (Menaampilkan text, letak sumbu x, letak sumbu y, lebar virtual, posisi align)

    -- Menggunakan font yang sudah dipanggil untuk skor player
    love.graphics.setFont(scoreFont)

    -- Menampikan skor player di layar, memposisikan skor font dan menggunakan font yang sudah disiapkan (scoreFont)
    -- skor palyer pertama
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3) -- (Menampilkan variabel skor, letak sumbu x, letak sumbu y)
    -- skor player kedua
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3) -- (Menampilkan variabel skor, letak sumbu x, letak sumbu y)

    -- Menampilkan kotak player pertama (Pemain Kiri)
    -- Fill = Berwarna
    -- 10 = posisi sumbu x + 10
    -- Player1Y = Posisi sumbu y
    -- 5 = lebar kotak
    -- 200 = panjang kotak
    love.graphics.rectangle('fill', 10, player1Y, 5, 20) -- (Isi, posisiX, posisiY , lebar, panjang)

    -- Menampilkan kotak player kedua (Pemain Kanan)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y - 50, 5, 20) -- (Isi, posisiX, posisiY , lebar, panjang)

    -- Menampilkan bola
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4) -- (Isi, posisiX, posisiY , lebar, panjang)

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
