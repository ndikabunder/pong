-- Paddle Class

-- Inisiasi class paddle
Paddle = Class {}

-- Fungsi membuat variabel lokasi paddle dan ukuran paddle
function Paddle:init(x, y, width, height)
    self.x = x           -- Lokasi sumbu x
    self.y = y           -- Lokasi sumbu y
    self.width = width   -- Lebar paddle
    self.height = height -- Panjang paddle
    self.dy = 0          -- Kecepatan di sumbu y
end

-- Fungsi gerakan paddle saat bergereak
function Paddle:update(dt)
    if self.dy < 0 then
        -- Menentukan sumbu y
        -- Fungsi math.max menetukan 2 angka terbesar antra 2 parameter yang diberikan
        -- dan memberikan kecepatan dengan delta time
        -- Memberikan fungsi agar paddle tidak keluar dari screen atas
        self.y = math.max(0, self.y + self.dy * dt)
    else
        -- Menentukan sumbu y
        -- Fungsi math.min menetukan 2 angka terkecil antra 2 parameter yang diberikan
        -- dan memberikan kecepatan dengan delta time
        -- Memberikan fungsi agar paddle tidak keluar dari screen bawah
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

-- Fungsi menampilankan paddles
function Paddle:render()
    -- Memberikan isi, posisi sumbu x, posisi sumbu y, lebar paddle, panjang paddle
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
