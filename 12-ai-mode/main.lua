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
    smallFont = love.graphics.newFont('font.ttf', 8)  -- nama font dan ukuran font

    largeFont = love.graphics.newFont('font.ttf', 16) -- nama font dan ukuran font

    -- Memanggil font dan menjalankan smallFont
    love.graphics.setFont(smallFont)

    -- Membuat variabel untuk untuk menentukan font dan ukuran untuk score
    scoreFont = love.graphics.newFont('font.ttf', 32)

    -- Menyiapkan sounds
    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
    }

    -- Mengaplikasikan virtual resolusi dan tetap dalam ukuran layar semula
    -- Mengganti love.window.setMode
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
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

-- Fungsi resize window
function love.resize(w, h)
    push:resize(w, h)
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

    -- -- Gerakan player kedua
    -- -- Ketika keyboard Up dipencet
    -- if love.keyboard.isDown('up') then
    --     -- Nilai dy akan ditambahkan
    --     player2.dy = -PADDLE_SPEED
    --     -- Ketika keyboard DOWN dipencet
    -- elseif love.keyboard.isDo wn('down') then
    --     -- Nilai dy akan ditambahkan
    --     player2.dy = PADDLE_SPEED
    -- else
    --     -- Nilai dy akan ditambahkan
    --     player2.dy = 0
    -- end

    if player2.y > ball.y then
        player2.dy = -PADDLE_SPEED
    else
        player2.dy = PADDLE_SPEED
    end


    -- Membuat uratan permainan
    if gameState == 'serve' then
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end

        -- Memperbarui posisi bolda saat memulai game sesuai DX dan DY
        -- skala kecepatan berdasakan DT sehingga gerakan tidak bergantung pada framerate
    elseif gameState == 'play' then -- play memuali permainan
        -- Cek kondisi bila bola menyetuh player kanan
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds['paddle_hit']:play()
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

            sounds['paddle_hit']:play()
        end

        -- Deteksi bola menyentuh layar bagian atas dan bawah
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy

            sounds['paddle_hit']:play()
        end

        -- Memantulkan bola dari layar bagian atas dan bawah
        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy

            sounds['wall_hit']:play()
        end
    end

    -- Mengecek bola sudah kurang dari 0
    -- Menambahkan skor ke player 2
    if ball.x < 0 then
        servingPlayer = 1 -- Variable untuk player yang memulai dulu
        player2Score = player2Score + 1

        sounds['score']:play()
        if player2Score == 10 then
            winningPlayer = 2 -- Membuat variable untuk agar dapat mengetahui pemeneang
            gameState = 'done'
        else
            ball:reset()
            gameState = 'start'
        end
    end

    -- Mengecek bola sudah lebih dari virtual width
    -- Menambahkan skor ke player 1
    if ball.x > VIRTUAL_WIDTH then
        servingPlayer = 2 -- Variable untuk player yang memulai dulu
        player1Score = player1Score + 1

        sounds['score']:play()
        if player1Score == 10 then
            winningPlayer = 1 -- Membuat variable untuk agar dapat mengetahui pemeneang
            gameState = 'done'
        else
            ball:reset()
            gameState = 'start'
        end
    end

    -- Fungsi untuk menentukan posisi bola saat game dimulai
    if gameState == 'play' then
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

            -- Reset skore ke 0
            player1Score = 0
            player2Score = 0

            -- Memutuskan siapa yang mulai dahulu
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
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

    displayScore()

    -- Menampilkan nama game, memposisikan nama game di layar dan menggunakan font yang sudah disiapkan (smallfont)
    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')     -- (Menaampilkan text, letak sumbu x, letak sumbu y, lebar virtual, posisi align)
        love.graphics.printf('Press Enter to Begin', 0, 20, VIRTUAL_WIDTH, 'center') -- (Menaampilkan text, letak sumbu x, letak sumbu y, lebar virtual, posisi align)
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!",
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center') -- (Menaampilkan text, letak sumbu x, letak sumbu y, lebar virtual, posisi align)
    elseif gameState == 'play' then
        -- tidak ada display
    elseif gameState == 'done' then
        -- UI Pesan  menang
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!',
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
    end

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

-- Fungsi menampilankan skor
function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50,
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
end
