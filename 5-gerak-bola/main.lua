-- Memanggil library push untuk virtual resolusi
-- https://github.com/Ulydev/push
push = require '3-kotak-player.push'

-- Memanggil library class
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

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

    -- variable untuk menentukan kecepeatan dan posisi bola saat game dimulai
    ballX = VIRTUAL_WIDTH / 2 - 2  -- Sumbu X
    ballY = VIRTUAL_HEIGHT / 2 - 2 -- sumbu Y

    -- variabel ini digunakan untuk memanggil randam number sesuai parameter yang diberikan dari kiri ke kanan
    -- Parameter 2 maksudnya memanggil random number antara 1 atau 2
    -- apabila keluar angka 1 maka munucl 100 apabila 2 muncul -100
    ballDX = math.random(2) == 1 and 100 or -100 -- parameter 2
    -- let ballDX = Math.random() < 0.5 ? 100 : -100; -- Bentuk javascript

    -- parameter langsung tetapkan akan muncul nilai antara parameter pertama dan kedua
    ballDY = math.random(-50, 50) -- (number 1, number 2)

    -- Game state variable digunakan untuk transisi antara part atau adegan
    -- Biasanya digunakan untuk main menu, main game, high score, dll
    -- Digunakan untuk memulai merender atau menupdate game
    gameState = 'start'
end

function love.update(dt)
    -- Gerakan player pertama
    if love.keyboard.isDown('w') then
        -- Cara kedua (unutk peddel atau player naik ketas)
        -- memberikan nilai negative pada sumbu Y dengan mengalikan dengan delta time untuk player pertama
        -- dan kita memberikan batas sehingga tidak keluar dilayar diatas layar
        -- math.max() mengembalikan nilai terbesar anara 2 parameter
        player1Y = math.max(0, player1Y + -PADDLE_SPEED * dt) -- (2 parameter antra 0 dan player1Y)
    elseif love.keyboard.isDown('s') then
        -- Cara kedua (unutk peddel atau player menurunkan kebawah)
        -- memberikan nilai positif pada sumbu Y
        -- math.max() mengembalikan nilai terkecil antara 2 parameter yang diberikan
        -- dan kita memberikan batas agar pedal tidak keluar dibawah layar
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt) -- (2 parameter antara virtual height dan palyer1Y)
    end

    -- Gerakan player kedua
    if love.keyboard.isDown('up') then
        -- Cara kedua (unutk peddel atau player naik ketas)
        -- memberikan nilai negative pada sumbu Y dengan mengalikan dengan delta time untuk player pertama
        -- dan kita memberikan batas sehingga tidak keluar dilayar diatas layar
        -- math.max() mengembalikan nilai terbesar anara 2 parameter
        player2Y = math.max(0, player2Y + -PADDLE_SPEED * dt) -- (2 parameter antra 0 dan player1Y)
    elseif love.keyboard.isDown('down') then
        -- Cara kedua (unutk peddel atau player menurunkan kebawah)
        -- memberikan nilai positif pada sumbu Y
        -- math.min() mengembalikan nilai terkecil antara 2 parameter yang diberikan
        -- dan kita memberikan batas agar pedal tidak keluar dibawah layar
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt) -- (2 parameter antara virtual height dan palyer1Y)
    end

    -- Memperbarui posisi bolda saat memulai game sesuai DX dan DY
    -- skala kecepatan berdasakan DT sehingga gerakan tidak bergantung pada framerate
    if gameState == 'play' then -- play memuali permainan
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end
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

            -- Menempatakn posisi bola di tengah layar
            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2

            -- memberikan kecepeatan bola di sumbu x dan y dengan random nilai

            -- variabel ini digunakan untuk memanggil randam number sesuai parameter yang diberikan dari kiri ke kanan
            -- Parameter 2 maksudnya memanggil random number antara 1 atau 2
            -- apabila keluar angka 1 maka munucl 100 apabila 2 muncul -100
            ballDX = math.random(2) == 1 and 100 or -100 -- parameter 2

            -- let ballDX = Math.random() < 0.5 ? 100 : -100; -- Bentuk javascript
            -- parameter langsung tetapkan akan muncul nilai antara parameter pertama dan kedua
            ballDY = math.random(-50, 50) -- (number 1, number 2)
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

    -- Menggunakan font yang sudah dipanggil untuk skor player
    love.graphics.setFont(scoreFont)

    -- Menampikan skor player di layar, memposisikan skor font dan menggunakan font yang sudah disiapkan (scoreFont)
    -- skor palyer pertama
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3) -- (Menampilkan variabel skor, letak sumbu x, letak sumbu y)
    -- skor player kedua
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3) -- (Menampilkan variabel skor, letak sumbu x, letak sumbu y)

    -- menampilankan player 1 di kiri
    love.graphics.rectangle('fill', 10, player1Y, 5, 20) -- isi kotak, sumbu x, sumbu y, ukuran lebar, ukuran tinggi

    -- Menampilkan palyer 2 di kanan
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20) -- isi kotak, sumbu x, sumbu y, ukuran lebar, ukuran tinggi

    -- Menampilkan bola (Ditengah layar)
    love.graphics.rectangle('fill', ballX, ballY, 4, 4) -- Fill Color, posisi X, posisi Y, ukuran Panjang, ukuran lebar

    -- Menghentikan menampilankan virtual resolusi
    push:apply('end')
end
