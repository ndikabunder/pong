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

    -- Membrika title pada window
    love.window.setTitle('Pong')

    -- Digunakan untuk memanggil random number
    -- Fungsi random number diambil dari waktu saat game berjalan
    math.randomseed(os.time())

    -- membuat variabel font untuk dipakai menampilankan nama game didalam game (nama font dan ukuran font)
    smallFont = love.graphics.newFont('font.ttf', 8) -- nama font dan ukuran font

    -- Memanggil font dan menjalankan smallFont
    love.graphics.setFont(smallFont)

    -- Membuat variabel untuk untuk menentukan font dan ukuran untuk score
    scoreFont = love.graphics.newFont('font.ttf', 32)

    -- Mengaplikasikan virtual resolusi dan tetap dalam ukuran layar semula
    -- Mengganti love.window.setMode
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- Membuat variabel untuk skor player
    -- Untuk menentukan pemenang
    player1Score = 0
    player2Score = 0

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
        -- Cek kondisi bila bola menyetuh player kanan
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        -- Cek kondisi bila bola menyetuh player kanan
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        -- Deteksi bola menyentuh layar bagian atas dan bawah
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
        end

        -- Memantulkan bola dari layar bagian atas dan bawah
        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
        end

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

    -- Menjalakan font untuk skor
    love.graphics.setFont(scoreFont)
    -- Menampilkan skore player 1
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50,
        VIRTUAL_HEIGHT / 3) -- Memanggil variabel skore dan dijadikan string, letak sumbu x, letak sumbu y
    -- Menampilkan skore player 2
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3) -- Memanggil variabel skore dan dijadikan string, letak sumbu x, letak sumbu y

    -- Menampilkan paddel menggunakan Class paddle
    player1:render()
    player2:render()

    -- Menampilkan bola menggunakan Class ball
    ball:render()

    -- Menampikan FPS dilayar
    displayFPS()

    -- Menghentikan menampilankan virtual resolusi
    push:apply('end')
end

-- Fungsi untuk menampilankan FPS
function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
