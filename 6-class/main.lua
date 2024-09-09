-- Memanggil library push untuk virtual resolusi
-- https://github.com/Ulydev/push
push = require '3-kotak-player.push'

-- Memanggil library class
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

-- Memanggil class Paddle
require 'Paddle'

-- Memanggil class Ball
require 'Ball'

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

    -- Digunakan untuk memanggil random number
    -- Fungsi random number diambil dari waktu saat game berjalan
    math.randomseed(os.time())

    -- membuat variabel font untuk dipakai menampilankan nama game didalam game (nama font dan ukuran font)
    smallFont = love.graphics.newFont('font.ttf', 8) -- nama font dan ukuran font

    -- Menjalankan font menjadikan smallfont object
    love.graphics.setFont(smallFont)

    -- Mengaplikasikan virtual resolusi dan tetap dalam ukuran layar semula
    -- Mengganti love.window.setMode
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- Inisiasi class Paddle
    -- Menggunkan class Paddle:init untuk menentukan letak paddle dan ukuran paddle
    player1 = Paddle(10, 30, 5, 20)                                  -- Sumbu x, sumbu y, lebar paddle, panjang paddle
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20) -- Sumbu x, sumbu y, lebar paddle, panjang paddle

    -- Inisiasi class Ball
    -- Menentukan letak bola dan ukuran bola
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4) -- Sumbu x, sumbu y, lebar paddle, panjang paddle

    -- Game state variable digunakan untuk transisi antara part atau adegan
    -- Biasanya digunakan untuk main menu, main game, high score, dll
    -- Digunakan untuk memulai merender atau menupdate game
    gameState = 'start'
end

function love.update(dt)
    -- Gerakan player pertama
    -- Ketika keyboard W dipencet
    if love.keyboard.isDown('w') then
        -- Nilai dy akan ditambahkan
        player1.dy = -PADDLE_SPEED
        -- Ketika keyboard S dipencet
    elseif love.keyboard.isDown('s') then
        -- Nilai dy akan ditambahkan
        player1.dy = PADDLE_SPEED
    else
        -- Nilai dy akan ditambahkan
        player1.dy = 0
    end

    -- Gerakan player kedua
    -- Ketika keyboard Up dipencet
    if love.keyboard.isDown('up') then
        -- Nilai dy akan ditambahkan
        player2.dy = -PADDLE_SPEED
        -- Ketika keyboard DOWN dipencet
    elseif love.keyboard.isDown('down') then
        -- Nilai dy akan ditambahkan
        player2.dy = PADDLE_SPEED
    else
        -- Nilai dy akan ditambahkan
        player2.dy = 0
    end

    -- Memperbarui posisi bolda saat memulai game sesuai DX dan DY
    -- skala kecepatan berdasakan DT sehingga gerakan tidak bergantung pada framerate
    if gameState == 'play' then -- play memuali permainan
        -- Fungsi untuk menentukan posisi bola saat game dimulai
        ball:update(dt)
    end

    -- Fungsi untuk menentukan posisi paddle saat game dimulai
    player1:update(dt)
    player2:update(dt)
end

--[[
    Fungsi keybord handling saat menekan keybord
]]
function love.keypressed(key)
    -- key dapat dijalankan dengan menggunakan string name
    -- Saat keyboard di tekan esc
    if key == 'escape' then
        -- functions ini dapat memerikan perintah untuk menutup apliasi
        -- game akan langsung terttutup
        love.event.quit()

        --  saat keyboard ditekan enter
    elseif key == 'enter' or key == 'return' then
        -- Apalibla game game state sama dengan start
        if gameState == 'start' then
            -- game akan dimulai
            gameState = 'play'
        else
            -- Game sebelum mulai
            gameState = 'start'

            -- Mereset bola saat game akan dimulai lagi
            ball:reset()
        end
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
    if gameState == 'start' then
        love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center') -- (Menaampilkan text, letak sumbu x, letak sumbu y, lebar virtual, posisi align)
    else
        love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center') -- (Menaampilkan text, letak sumbu x, letak sumbu y, lebar virtual, posisi align)
    end

    -- Menampilkan paddel menggunakan Class paddle
    player1:render()
    player2:render()

    -- Menampilkan bola menggunakan Class ball
    ball:render()

    -- Menghentikan menampilankan virtual resolusi
    push:apply('end')
end
