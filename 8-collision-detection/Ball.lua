-- Ball class

-- Inisiasi Class Ball
Ball = Class {}

-- Fungsi membuat letak dan ukuran bola
function Ball:init(x, y, width, height)
    self.x = x           -- Menentukan nilai sumbu x
    self.y = y           -- Menentukan nilai sumbu y
    self.width = width   -- Menentukan nilai lebar bola
    self.height = height -- Menentukan nilai panjang bola

    -- memberikan kecepeatan bola di sumbu x dan y dengan random nilai

    -- variabel ini digunakan untuk memanggil randam number sesuai parameter yang diberikan dari kiri ke kanan
    -- Parameter 2 maksudnya memanggil random number antara 1 atau 2
    -- apabila keluar angka 1 maka munucl 100 apabila 2 muncul -100
    self.dy = math.random(2) == 1 and 100 or -100 -- parameter 2

    -- parameter langsung tetapkan akan muncul nilai antara parameter pertama dan kedua
    self.dx = math.random(-50, 50) -- (number 1, number 2)
end

-- Fungsi mereset bola saat game selesai
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2  -- Menempatakan bola ditengah sumbu x
    self.y = VIRTUAL_HEIGHT / 2 - 2 -- Menempatakan bola ditengah sumbu y

    -- Menentukan kecepeatan bola secara random
    self.dy = math.random(2) == 1 and -100 or 100 -- Menentukan gerak bola disumbu y
    self.dx = math.random(-50, 50)                -- Menentukan gerak bola di sumbu x
end

-- Fungsi mengupdate posisi dan kecepatan bola saat bermain
function Ball:update(dt)
    self.x = self.x + self.dx * dt -- Menentukan posisi bola di sumbu x saat bola bergerak
    self.y = self.y + self.dy * dt -- Menentukan posisi bola di sumbu y saat bola bergerak
end

-- Fungsi menampilankan bola
function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height) -- Isi warna bola, lokasi bola sumbu x, lokasi bola sumbu y, ukuran lebar bola, ukuran panjang bola
end

-- Fungsi Collision antara bola dan paddle
function Ball:collides(paddle)
    -- Sumbu x pada bola melebih sumbu x pada paddle
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    -- Sumbu y pada bola melebih sumbu x pada paddle
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end

    -- Tidak melebihi maka bola kembali
    return true
end
