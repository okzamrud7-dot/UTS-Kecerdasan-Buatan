%% SISTEM FUZZY MAMDANI
% Menentukan Tingkat Risiko Kesulitan Belajar Siswa
% Dataset: 20 siswa

clc;
clear;
close all;

%% =========================================================
% 1. DATA SISWA
% Kolom:
% ID, Nilai Akademik, Kehadiran, Motivasi Belajar
% ==========================================================

data = {
    'S001', 90, 95, 90;
    'S002', 85, 92, 88;
    'S003', 80, 90, 75;
    'S004', 78, 85, 72;
    'S005', 75, 85, 70;
    'S006', 72, 80, 65;
    'S007', 70, 78, 60;
    'S008', 68, 75, 58;
    'S009', 65, 75, 55;
    'S010', 62, 72, 52;
    'S011', 60, 70, 50;
    'S012', 58, 68, 48;
    'S013', 55, 65, 45;
    'S014', 50, 65, 40;
    'S015', 48, 60, 35;
    'S016', 45, 58, 32;
    'S017', 40, 55, 30;
    'S018', 35, 50, 25;
    'S019', 30, 50, 25;
    'S020', 20, 35, 15;
};

%% =========================================================
% 2. RULE BASE
%
% Urutan:
% Nilai, Kehadiran, Motivasi
%
% 1 = Rendah
% 2 = Sedang
% 3 = Tinggi
%
% Output:
% 1 = Risiko Rendah
% 2 = Risiko Sedang
% 3 = Risiko Tinggi
% ==========================================================

rules = [
    1 1 1 3;
    1 1 2 3;
    1 1 3 3;
    1 2 1 3;
    1 2 2 3;
    1 2 3 2;
    1 3 1 3;
    1 3 2 2;
    1 3 3 2;

    2 1 1 3;
    2 1 2 3;
    2 1 3 2;
    2 2 1 2;
    2 2 2 2;
    2 2 3 1;
    2 3 1 2;
    2 3 2 1;
    2 3 3 1;

    3 1 1 2;
    3 1 2 2;
    3 1 3 1;
    3 2 1 2;
    3 2 2 1;
    3 2 3 1;
    3 3 1 2;
    3 3 2 1;
    3 3 3 1;
];

%% =========================================================
% 3. PROSES FUZZY UNTUK 20 SISWA
% ==========================================================

hasil = cell(size(data,1),5);

for i = 1:size(data,1)

    id = data{i,1};
    nilai = data{i,2};
    kehadiran = data{i,3};
    motivasi = data{i,4};

    % Hitung Fuzzy Mamdani
    risiko = hitungFuzzy(nilai, kehadiran, motivasi, rules);

    % Kategori risiko untuk pelaporan
    if risiko < 40
        kategori = 'Rendah';
    elseif risiko < 70
        kategori = 'Sedang';
    else
        kategori = 'Tinggi';
    end

    hasil{i,1} = id;
    hasil{i,2} = nilai;
    hasil{i,3} = kehadiran;
    hasil{i,4} = motivasi;
    hasil{i,5} = risiko;
    hasil{i,6} = kategori;
end

%% =========================================================
% 4. MENAMPILKAN HASIL
% ==========================================================

fprintf('\n===============================================================\n');
fprintf(' HASIL SISTEM FUZZY MAMDANI\n');
fprintf('===============================================================\n');

fprintf('%-6s %-8s %-12s %-10s %-12s %-10s\n', ...
    'ID','Nilai','Kehadiran','Motivasi','Risiko','Kategori');

fprintf('---------------------------------------------------------------\n');

for i = 1:size(hasil,1)

    fprintf('%-6s %-8.0f %-12.0f %-10.0f %-12.2f %-10s\n', ...
        hasil{i,1}, ...
        hasil{i,2}, ...
        hasil{i,3}, ...
        hasil{i,4}, ...
        hasil{i,5}, ...
        hasil{i,6});
end

fprintf('===============================================================\n');

%% =========================================================
% 5. MENYIMPAN HASIL KE CSV
% ==========================================================

T = cell2table(hasil, ...
    'VariableNames', ...
    {'ID','Nilai','Kehadiran','Motivasi','Risiko','Kategori'});

writetable(T,'dataset_siswa_simulasi_20.csv');

fprintf('\nHasil telah disimpan sebagai: dataset_siswa_simulasi_20.csv\n');

%% =========================================================
% 6. GRAFIK MEMBERSHIP FUNCTION
% ==========================================================

x = 0:1:100;

% ----------------------------------------------------------
% Membership Nilai Akademik
% ----------------------------------------------------------

figure;

plot(x, trapmf_manual(x, [0 0 40 60]), 'LineWidth', 2);
hold on;
plot(x, trimf_manual(x, [40 60 80]), 'LineWidth', 2);
plot(x, trapmf_manual(x, [60 80 100 100]), 'LineWidth', 2);

grid on;
xlabel('Nilai Akademik');
ylabel('Derajat Keanggotaan');
title('Membership Function Nilai Akademik');

legend('Rendah','Sedang','Tinggi');

% ----------------------------------------------------------
% Membership Kehadiran
% ----------------------------------------------------------

figure;

plot(x, trapmf_manual(x, [0 0 60 70]), 'LineWidth', 2);
hold on;
plot(x, trimf_manual(x, [60 75 90]), 'LineWidth', 2);
plot(x, trapmf_manual(x, [80 90 100 100]), 'LineWidth', 2);

grid on;
xlabel('Kehadiran (%)');
ylabel('Derajat Keanggotaan');
title('Membership Function Kehadiran');

legend('Rendah','Sedang','Tinggi');

% ----------------------------------------------------------
% Membership Motivasi
% ----------------------------------------------------------

figure;

plot(x, trapmf_manual(x, [0 0 30 50]), 'LineWidth', 2);
hold on;
plot(x, trimf_manual(x, [30 50 70]), 'LineWidth', 2);
plot(x, trapmf_manual(x, [50 70 100 100]), 'LineWidth', 2);

grid on;
xlabel('Motivasi Belajar');
ylabel('Derajat Keanggotaan');
title('Membership Function Motivasi');

legend('Rendah','Sedang','Tinggi');

% ----------------------------------------------------------
% Membership Output Risiko
% ----------------------------------------------------------

figure;

plot(x, trapmf_manual(x, [0 0 30 40]), 'LineWidth', 2);
hold on;
plot(x, trimf_manual(x, [30 50 70]), 'LineWidth', 2);
plot(x, trapmf_manual(x, [60 70 100 100]), 'LineWidth', 2);

grid on;
xlabel('Risiko Kesulitan Belajar');
ylabel('Derajat Keanggotaan');
title('Membership Function Risiko Kesulitan Belajar');

legend('Rendah','Sedang','Tinggi');


%% =========================================================
% 7. LIMA PENGUJIAN
% ==========================================================

uji = [
    90 95 90;
    75 85 70;
    65 75 55;
    50 65 40;
    20 35 15;
];

fprintf('\n===============================================================\n');
fprintf(' LIMA PENGUJIAN SISTEM\n');
fprintf('===============================================================\n');

fprintf('%-8s %-12s %-12s %-12s %-12s %-10s\n', ...
    'Uji','Nilai','Kehadiran','Motivasi','Risiko','Kategori');

fprintf('---------------------------------------------------------------\n');

for i = 1:size(uji,1)

    nilai = uji(i,1);
    kehadiran = uji(i,2);
    motivasi = uji(i,3);

    risiko = hitungFuzzy(nilai,kehadiran,motivasi,rules);

    if risiko < 40
        kategori = 'Rendah';
    elseif risiko < 70
        kategori = 'Sedang';
    else
        kategori = 'Tinggi';
    end

    fprintf('%-8d %-12.0f %-12.0f %-12.0f %-12.2f %-10s\n', ...
        i,nilai,kehadiran,motivasi,risiko,kategori);
end

fprintf('===============================================================\n');


%% =========================================================
% FUNGSI FUZZY MAMDANI
% ==========================================================

function output = hitungFuzzy(nilai, kehadiran, motivasi, rules)

    %% -----------------------------------------------------
    % 1. FUZZIFIKASI
    % ------------------------------------------------------

    % Nilai
    n_rendah = trapmf_manual(nilai,[0 0 40 60]);
    n_sedang = trimf_manual(nilai,[40 60 80]);
    n_tinggi = trapmf_manual(nilai,[60 80 100 100]);

    % Kehadiran
    k_rendah = trapmf_manual(kehadiran,[0 0 60 70]);
    k_sedang = trimf_manual(kehadiran,[60 75 90]);
    k_tinggi = trapmf_manual(kehadiran,[80 90 100 100]);

    % Motivasi
    m_rendah = trapmf_manual(motivasi,[0 0 30 50]);
    m_sedang = trimf_manual(motivasi,[30 50 70]);
    m_tinggi = trapmf_manual(motivasi,[50 70 100 100]);

    nilaiMF = [n_rendah n_sedang n_tinggi];
    hadirMF = [k_rendah k_sedang k_tinggi];
    motivasiMF = [m_rendah m_sedang m_tinggi];

    %% -----------------------------------------------------
    % 2. OUTPUT DOMAIN
    % ------------------------------------------------------

    z = 0:0.1:100;

    % Membership output
    output_rendah = trapmf_manual(z,[0 0 30 40]);
    output_sedang = trimf_manual(z,[30 50 70]);
    output_tinggi = trapmf_manual(z,[60 70 100 100]);

    outputMF = zeros(size(z));

    %% -----------------------------------------------------
    % 3. EVALUASI RULE
    % ------------------------------------------------------

    for r = 1:size(rules,1)

        input1 = rules(r,1);
        input2 = rules(r,2);
        input3 = rules(r,3);
        outputClass = rules(r,4);

        % AND menggunakan operator MIN
        alpha = min([
            nilaiMF(input1), ...
            hadirMF(input2), ...
            motivasiMF(input3)
        ]);

        % Implikasi menggunakan MIN
        if outputClass == 1

            clipped = min(alpha, output_rendah);

        elseif outputClass == 2

            clipped = min(alpha, output_sedang);

        else

            clipped = min(alpha, output_tinggi);

        end

        % Agregasi menggunakan MAX
        outputMF = max(outputMF,clipped);

    end

    %% -----------------------------------------------------
    % 4. DEFUZZIFIKASI CENTROID
    % ------------------------------------------------------

    pembilang = trapz(z,z .* outputMF);
    penyebut = trapz(z,outputMF);

    if penyebut == 0
        output = 0;
    else
        output = pembilang / penyebut;
    end

end


%% =========================================================
% FUNGSI TRIANGULAR MEMBERSHIP FUNCTION
% ==========================================================

function y = trimf_manual(x,p)

    a = p(1);
    b = p(2);
    c = p(3);

    y = zeros(size(x));

    % Naik
    idx = (x >= a) & (x <= b);

    if b ~= a
        y(idx) = (x(idx)-a)/(b-a);
    else
        y(idx) = 1;
    end

    % Turun
    idx = (x >= b) & (x <= c);

    if c ~= b
        y(idx) = max(y(idx),(c-x(idx))/(c-b));
    else
        y(idx) = 1;
    end

    % Titik puncak
    y(x == b) = 1;

end


%% =========================================================
% FUNGSI TRAPEZOIDAL MEMBERSHIP FUNCTION
% ==========================================================

function y = trapmf_manual(x,p)

    a = p(1);
    b = p(2);
    c = p(3);
    d = p(4);

    y = zeros(size(x));

    % Bagian naik
    idx = (x >= a) & (x <= b);

    if b ~= a
        y(idx) = (x(idx)-a)/(b-a);
    else
        y(idx) = 1;
    end

    % Bagian datar
    idx = (x >= b) & (x <= c);
    y(idx) = 1;

    % Bagian turun
    idx = (x >= c) & (x <= d);

    if d ~= c
        y(idx) = max(y(idx),(d-x(idx))/(d-c));
    else
        y(idx) = 1;
    end

end